//
//  UserDataSingleton.m
//  TOIAPP
//
//  Created by Subodh Dharmwan on 25/11/15.
//  Copyright (c) 2015 CYNOTECK. All rights reserved.
//

#import "UserDataSingleton.h"

@implementation UserDataSingleton
@synthesize myFinalArray;
static UserDataSingleton *userDataSingletonInstance;
+(UserDataSingleton *) getInstance
{
    
    if (userDataSingletonInstance == nil)   {
        userDataSingletonInstance = [[UserDataSingleton alloc] init];
    }
    return userDataSingletonInstance;
}

-(void)saveInUserDatasingletonWithArray:(NSArray *)array
{
    globalArray = array;
}
-(NSDictionary *)getGlobalDictionary
{
    return globalArray;
}

@end
