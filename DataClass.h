//
//  DataClass.h
//  ACSG_App
//
//  Created by Deepankar Parashar on 12/10/15.
//  Copyright (c) 2015 Cynoteck. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataClass : NSObject
{
    
    
}


+(DataClass*)getInstance;


#pragma mark -- Methods


@property (strong,nonatomic) NSString * globalTemperature;

@property NSUInteger globalIndexSelection;


@property(strong,nonatomic) NSString * globalUserAgent;
@property (strong,nonatomic) NSDictionary * globaltextDict;

@property(strong,nonatomic)NSMutableArray * globalSubmitArray;


@property float temperature;

@property(assign) NSUInteger globalIndex;
@property int globalCheckValue;
@property(nonatomic,strong)NSString * globalSharedLink;
@property(strong,nonatomic)NSMutableArray *globalcompleteCategory;
@property(assign) BOOL flag;
@property(assign) BOOL isFromOtherView;

@property(assign) NSUInteger rowIndex;
@property(assign) NSUInteger sectionIndex;



@property(strong,nonatomic)NSString * globalFeedID;
@property(strong,nonatomic)NSString * globalFeedType;
@property(strong,nonatomic)NSString * globalstaticLink;
@property(strong,nonatomic)NSString * globalSubCategory;

@property BOOL globalStaticCheck; // only for static view.

@property(assign) NSUInteger globalCounter;

@property(strong,nonatomic) NSDictionary *jsonDict;


@property(strong,nonatomic)NSString * globalCategory;


@property(nonatomic,strong)NSMutableArray *audioDetailsMutableArray;
@property BOOL checkForAudioCurrentCaptureOrNot;


@property (nonatomic,strong)NSMutableArray *feedsArrayDC;



@end
