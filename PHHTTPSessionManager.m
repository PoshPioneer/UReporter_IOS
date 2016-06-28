//
//  PHHTTPSessionManager.m
//  Pioneer
//
//  Created by Jerry Horton on 6/22/16.
//  Copyright © 2016 CYNOTECK. All rights reserved.
//

#import "PHHTTPSessionManager.h"
#import "PHCachingURLProtocol.h"

@implementation PHHTTPSessionManager

+ (instancetype)manager {
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSMutableArray * protocolsArray = [sessionConfiguration.protocolClasses mutableCopy];
    [protocolsArray insertObject:[PHCachingURLProtocol class] atIndex:0];
    sessionConfiguration.protocolClasses = protocolsArray;
    PHHTTPSessionManager * phManager = [[PHHTTPSessionManager alloc] initWithSessionConfiguration:sessionConfiguration];
    
    
    return phManager;
}


@end
