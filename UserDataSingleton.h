//
//  UserDataSingleton.h
//  TOIAPP
//
//  Created by Subodh Dharmwan on 25/11/15.
//  Copyright (c) 2015 CYNOTECK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDataSingleton : NSObject{
@private
    NSArray *globalArray;
}
@property(nonatomic,strong) NSMutableArray *myFinalArray;
+(UserDataSingleton *) getInstance;
-(void)saveInUserDatasingletonWithArray:(NSArray *)array;
-(NSDictionary *)getGlobalArray;

@end
