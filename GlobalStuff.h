//
//  GlobalStuff.h
//  Petofy
//
//  Created by Mohit Bisht on 11/01/16.
//  Copyright © 2016 Cynoteck. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalStuff : NSObject{
    
    NSString* UserAgent;

}

+ (NSString *)getDeviceId;
+(NSString *)generateToken;

@end
