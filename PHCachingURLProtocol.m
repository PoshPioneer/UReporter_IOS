//
//  PHURLProtocol.m
//  Pioneer
//
//  Created by Jerry Horton on 6/22/16.
//  Copyright © 2016 CYNOTECK. All rights reserved.
//

#import "PHCachingURLProtocol.h"

#define WORKAROUND_MUTABLE_COPY_LEAK 0

#if WORKAROUND_MUTABLE_COPY_LEAK
// required to workaround http://openradar.appspot.com/11596316
@interface NSURLRequest(MutableCopyWorkaround)

- (id) mutableCopyWorkaround;

@end
#endif

@interface PHCachedData : NSObject <NSCoding>
@property (nonatomic, readwrite, strong) NSData *data;
@property (nonatomic, readwrite, strong) NSURLResponse *response;
@property (nonatomic, readwrite, strong) NSURLRequest *redirectRequest;
@end

static NSString *PHCachingURLHeader = @"X-PHCache";

@interface PHCachingURLProtocol () // <NSURLConnectionDelegate, NSURLConnectionDataDelegate> iOS5-only
@property (nonatomic, readwrite, strong) NSURLConnection *connection;
@property (nonatomic, readwrite, strong) NSMutableData *data;
@property (nonatomic, readwrite, strong) NSURLResponse *response;
- (void)appendData:(NSData *)newData;
@end

@implementation NSString (Sha1)

- (NSString *)sha1
{
    // see http://www.makebetterthings.com/iphone/how-to-get-md5-and-sha1-in-objective-c-ios-sdk/
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
}


@end


static NSObject *PHCachingSupportedSchemesMonitor;
static NSSet *PHCachingSupportedSchemes;

@implementation PHCachingURLProtocol
@synthesize connection = connection_;
@synthesize data = data_;
@synthesize response = response_;

+ (void)initialize
{
    if (self == [PHCachingURLProtocol class])
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            PHCachingSupportedSchemesMonitor = [NSObject new];
        });
        
        [self setSupportedSchemes:[NSSet setWithObjects:@"http",@"https", nil]];
    }
}

+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
    // only handle http requests we haven't marked with our header.
    if ([[self supportedSchemes] containsObject:[[request URL] scheme]] &&
        ([request valueForHTTPHeaderField:PHCachingURLHeader] == nil))
    {
        return YES;
    }
    return NO;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request
{
    return request;
}

- (NSString *)cachePathForRequest:(NSURLRequest *)aRequest
{
    // This stores in the Caches directory, which can be deleted when space is low, but we only use it for offline access
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName = [[[aRequest URL] absoluteString] sha1];
    
    return [cachesPath stringByAppendingPathComponent:fileName];
}

- (void)startLoading
{
    if (![self useCache]) {
        NSMutableURLRequest *connectionRequest =
#if WORKAROUND_MUTABLE_COPY_LEAK
        [[self request] mutableCopyWorkaround];
#else
        [[self request] mutableCopy];
#endif
        // we need to mark this request with our header so we know not to handle it in +[NSURLProtocol canInitWithRequest:].
        [connectionRequest setValue:@"" forHTTPHeaderField:PHCachingURLHeader];
        NSURLConnection *connection = [NSURLConnection connectionWithRequest:connectionRequest
                                                                    delegate:self];
        [self setConnection:connection];
    }
    else {
        PHCachedData *cache = [NSKeyedUnarchiver unarchiveObjectWithFile:[self cachePathForRequest:[self request]]];
        if (cache) {
            NSData *data = [cache data];
            NSURLResponse *response = [cache response];
            NSURLRequest *redirectRequest = [cache redirectRequest];
            if (redirectRequest) {
                [[self client] URLProtocol:self wasRedirectedToRequest:redirectRequest redirectResponse:response];
            } else {
                
                [[self client] URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed]; // we handle caching ourselves.
                
                NSString* dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                
                DLog(@"data: %@", dataString);
                
                [[self client] URLProtocol:self didLoadData:data];
                [[self client] URLProtocolDidFinishLoading:self];
            }
        }
        else {
            [[self client] URLProtocol:self didFailWithError:[NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorCannotConnectToHost userInfo:nil]];
        }
    }
}

- (void)stopLoading
{
    [[self connection] cancel];
}

// NSURLConnection delegates (generally we pass these on to our client)

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response
{
    // Thanks to Nick Dowell https://gist.github.com/1885821
    if (response != nil) {
        NSMutableURLRequest *redirectableRequest =
#if WORKAROUND_MUTABLE_COPY_LEAK
        [request mutableCopyWorkaround];
#else
        [request mutableCopy];
#endif
        // We need to remove our header so we know to handle this request and cache it.
        // There are 3 requests in flight: the outside request, which we handled, the internal request,
        // which we marked with our header, and the redirectableRequest, which we're modifying here.
        // The redirectable request will cause a new outside request from the NSURLProtocolClient, which
        // must not be marked with our header.
        [redirectableRequest setValue:nil forHTTPHeaderField:PHCachingURLHeader];
        
        NSString *cachePath = [self cachePathForRequest:[self request]];
        PHCachedData *cache = [PHCachedData new];
        [cache setResponse:response];
        [cache setData:[self data]];
        [cache setRedirectRequest:redirectableRequest];
        [NSKeyedArchiver archiveRootObject:cache toFile:cachePath];
        [[self client] URLProtocol:self wasRedirectedToRequest:redirectableRequest redirectResponse:response];
        return redirectableRequest;
    } else {
        return request;
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [[self client] URLProtocol:self didLoadData:data];
    [self appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [[self client] URLProtocol:self didFailWithError:error];
    [self setConnection:nil];
    [self setData:nil];
    [self setResponse:nil];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [self setResponse:response];
    [[self client] URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageAllowed];  // We cache ourselves.
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [[self client] URLProtocolDidFinishLoading:self];
    
    NSString *cachePath = [self cachePathForRequest:[self request]];
    PHCachedData *cache = [PHCachedData new];
    [cache setResponse:[self response]];
    [cache setData:[self data]];
    [NSKeyedArchiver archiveRootObject:cache toFile:cachePath];
    
    [self setConnection:nil];
    [self setData:nil];
    [self setResponse:nil];
}

- (BOOL) useCache
{
    BOOL reachable = [Utility connected];
    return !reachable;
}

- (void)appendData:(NSData *)newData
{
    if ([self data] == nil) {
        [self setData:[newData mutableCopy]];
    }
    else {
        [[self data] appendData:newData];
    }
}

+ (NSSet *)supportedSchemes {
    NSSet *supportedSchemes;
    @synchronized(PHCachingSupportedSchemesMonitor)
    {
        supportedSchemes = PHCachingSupportedSchemes;
    }
    return supportedSchemes;
}

+ (void)setSupportedSchemes:(NSSet *)supportedSchemes
{
    @synchronized(PHCachingSupportedSchemesMonitor)
    {
        PHCachingSupportedSchemes = supportedSchemes;
    }
}

@end

static NSString *const kDataKey = @"data";
static NSString *const kResponseKey = @"response";
static NSString *const kRedirectRequestKey = @"redirectRequest";

@implementation PHCachedData
@synthesize data = data_;
@synthesize response = response_;
@synthesize redirectRequest = redirectRequest_;

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:[self data] forKey:kDataKey];
    [aCoder encodeObject:[self response] forKey:kResponseKey];
    [aCoder encodeObject:[self redirectRequest] forKey:kRedirectRequestKey];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self != nil) {
        [self setData:[aDecoder decodeObjectForKey:kDataKey]];
        [self setResponse:[aDecoder decodeObjectForKey:kResponseKey]];
        [self setRedirectRequest:[aDecoder decodeObjectForKey:kRedirectRequestKey]];
    }
    
    return self;
}

@end

#if WORKAROUND_MUTABLE_COPY_LEAK
@implementation NSURLRequest(MutableCopyWorkaround)

- (id) mutableCopyWorkaround {
    NSMutableURLRequest *mutableURLRequest = [[NSMutableURLRequest alloc] initWithURL:[self URL]
                                                                          cachePolicy:[self cachePolicy]
                                                                      timeoutInterval:[self timeoutInterval]];
    [mutableURLRequest setAllHTTPHeaderFields:[self allHTTPHeaderFields]];
    if ([self HTTPBodyStream]) {
        [mutableURLRequest setHTTPBodyStream:[self HTTPBodyStream]];
    } else {
        [mutableURLRequest setHTTPBody:[self HTTPBody]];
    }
    [mutableURLRequest setHTTPMethod:[self HTTPMethod]];
    
    return mutableURLRequest;
}

@end
#endif
