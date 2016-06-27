//
//  DataClass.m
//  ACSG_App
//
//  Created by Deepankar Parashar on 12/10/15.
//  Copyright (c) 2015 Cynoteck. All rights reserved.
//

#import "DataClass.h"
#import <UIKit/UIKit.h>


@implementation DataClass

@synthesize globalTemperature,globalIndex;
@synthesize  globalUserAgent,temperature,globaltextDict,globalSubmitArray,globalcompleteCategory,flag,sectionIndex,rowIndex;
@synthesize globalCounter,jsonDict,isFromOtherView;



static DataClass *instance =nil;
+(DataClass *)getInstance
{
    @synchronized(self)
    {
        if(instance==nil)
        {
            
            instance= [DataClass new];
            
        }
    }
    return instance;
}


@end
