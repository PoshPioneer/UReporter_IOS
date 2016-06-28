//
//  PHURLProtocol.h
//  Pioneer
//
//  Created by Jerry Horton on 6/22/16.
//  Copyright © 2016 CYNOTECK. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>


@interface PHCachingURLProtocol : NSURLProtocol

+ (NSSet *)supportedSchemes;
+ (void)setSupportedSchemes:(NSSet *)supportedSchemes;

- (NSString *)cachePathForRequest:(NSURLRequest *)aRequest;
- (BOOL) useCache;

@end

/**
 * This extension contains several a helper
 * for creating a sha1 hash from instances of NSString
 */
@interface NSString (Sha1)

/**
 * Creates a SHA1 (hash) representation of NSString.
 *
 * @return NSString
 */
- (NSString *)sha1;


@end