//
//  GlobalStuff.m
//  Petofy
//
//  Created by Mohit Bisht on 11/01/16.
//  Copyright © 2016 Cynoteck. All rights reserved.
//

#import "GlobalStuff.h"
#import "SSKeychain.h"
#import <CommonCrypto/CommonHMAC.h>
#import "Base64.h"
#import <CommonCrypto/CommonDigest.h>
#include <ifaddrs.h>
#include <arpa/inet.h>

@implementation GlobalStuff


+ (NSString *)getDeviceId {
    NSString *appName=[[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleNameKey];
    NSString *strApplicationUUID = [SSKeychain passwordForService:appName account:@"DeviceId"];
    if (strApplicationUUID == nil) {
        strApplicationUUID  = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        [SSKeychain setPassword:strApplicationUUID forService:appName account:@"DeviceId"];
    }
    return strApplicationUUID;
}

#pragma mark generating the token-----

+(NSString *)generateToken {
    
    __block NSString* userAgentBlock=nil;
    
    
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UIWebView* webView = [[UIWebView alloc] initWithFrame:CGRectZero];
            NSString* userAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
            
            userAgentBlock=userAgent;
        });
    
    NSDate * now = [NSDate date];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    // [outputFormatter setDateFormat:@"HH:mm:ss"];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [outputFormatter setTimeZone:timeZone];
    [outputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    DLog(@"newDateString %f", [now timeIntervalSince1970 ]);
    
    
    double  Finaldate = [now timeIntervalSince1970] ;
    
    double milliseconds = Finaldate *1000;
    
    DLog(@"final date---%f",milliseconds);
    
    NSString * deviceID = [self getDeviceId];
    DLog(@"device id--%@",deviceID);
    NSString * salt =  [NSString stringWithFormat:@"%@:rz8LuOtFBXphj9WQfvFh",[[NSUserDefaults standardUserDefaults]valueForKey:@"userID_Default"]];
    
    DLog(@"key is view controller --%@",salt);//  @":rz8LuOtFBXphj9WQfvFh";
    NSString * IPAddress = [self getIPAddress];
    NSString * sourceParam = @"SkagitTimes";
    //  NSString * userAgent = @"iOS";
    double ticks =  ((milliseconds  * 10000) + 621355968000000000);
    DLog(@"ticks--%0.00000f",ticks);
    
    NSString *hashLeft = [NSString stringWithFormat:@"%@:%@:%@:%0.00000f:%@", deviceID,IPAddress ,userAgentBlock,ticks,sourceParam];
    DLog(@"final string--%@",hashLeft);
    
    // DLog(@"ip address--%@",IPAddress);
    NSData *saltData = [salt dataUsingEncoding:NSUTF8StringEncoding];
    NSData *paramData = [hashLeft dataUsingEncoding:NSUTF8StringEncoding];//deviceID
    
    NSMutableData* hash = [NSMutableData dataWithLength:CC_SHA256_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA256, saltData.bytes, saltData.length, paramData.bytes, paramData.length, hash.mutableBytes);
    NSString *base64LeftHash = [Base64 base64forData:hash];
    DLog(@"left hash  base 64--%@",base64LeftHash);
    
    
    // rightHash...
    
    NSString *hashRight =[NSString stringWithFormat:@"%@:%0.00000f:%@",deviceID,ticks,sourceParam];
    DLog(@"right Hash --%@",hashRight);
    
    NSString *token = [NSString stringWithFormat:@"%@:%@",base64LeftHash,hashRight];
    DLog(@"concated hash --%@",token);
    NSData *tokenData = [token dataUsingEncoding:NSUTF8StringEncoding];//deviceID
    return [Base64 base64forData:tokenData];
    
}

- (NSNumber *)dateToSecondConvert:(NSString *)string {
    
    NSArray *components = [string componentsSeparatedByString:@":"];
    
    NSInteger hours   = [[components objectAtIndex:0] integerValue];
    NSInteger minutes = [[components objectAtIndex:1] integerValue];
    NSInteger seconds = [[components objectAtIndex:2] integerValue];
    
    return [NSNumber numberWithInteger:(hours * 60 * 60) + (minutes * 60) + seconds];
    
    
}



#pragma mark-- getIPAddress...

+ (NSString *)getIPAddress {
    
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                    
                }
                
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    
    DLog(@"IP Address--%@",address);
    return address;
    
}



+ (NSString*)base64forData:(NSData*)theData {
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];
    
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    NSInteger i;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {  value |= (0xFF & input[j]);  }  }  NSInteger theIndex = (i / 3) * 4;  output[theIndex + 0] = table[(value >> 18) & 0x3F];
        output[theIndex + 1] = table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6) & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0) & 0x3F] : '=';
    }
     return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];

}

@end
