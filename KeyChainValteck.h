//
//  KeyChainValteck.h
//  pioneer
//
//  Created by Valeteck on 08/08/14.
//  Copyright (c) 2014 CYNOTECK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeyChainValteck : NSObject



+ (void)keyChainSaveKey:(NSString *)key data:(id)data;
+ (id)keyChainLoadKey:(NSString *)key;
+ (void)keyChainDeleteKey:(NSString *)service;
+ (NSMutableDictionary *)getKeychainQuery:(NSString *)key;


@end
