//
//  AppDelegate.h
//  pioneer
//
//  Created by CYNOTECK on 7/25/14.
//  Copyright (c) 2014 CYNOTECK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate,SyncDelegate>
{
    UIImageView *m_SplashView;
    NSMutableArray *myFinalArray;
    NSString *lettersString;
    CLLocationManager *locationManager;
    SyncManager *sync;
    NSString *timestamp;
}

@property NSInteger indexpath;
@property NSInteger ReviewIndexPath;
@property (strong,nonatomic)NSString *Title,*Description;
@property(strong,nonatomic)NSDictionary * submitDict;
@property(strong,nonatomic)NSDictionary * textDictionarySubmit;
@property(strong,nonatomic)NSMutableArray * FinalSubmitForReview;
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,strong)NSString *putValueToKeyChain;
@property(nonatomic,strong)NSMutableArray *id_CategoryArray;
@property(nonatomic,strong)NSMutableArray *categoryNameArray;
@property(nonatomic,strong)NSData *recordedData ;
@property(strong,nonatomic)NSMutableString *soundFilePathData;
@property(nonatomic,strong)NSString *uniqueNameForLableAudio;
@property(nonatomic,strong)NSMutableData *responseData;
@property(strong,nonatomic)NSMutableArray *myFinalArray;      //New Changes
@property(strong,nonatomic)NSString *device_Token ;
@property(nonatomic,strong)NSURL *yourFileURL;
@property(nonatomic,strong)NSString * randomNumber;
@property(nonatomic,strong) NSMutableArray * genderArr ;
@property (nonatomic,strong)NSString *FinalKeyChainValue;
@property(nonatomic,strong) NSString *userAddress;
@property(nonatomic,strong)UINavigationController *navigationController;

-(void)registerPushNotification_Method;
-(void)getCategory;

-(void)showIt ;
-(void)hideIt;

@end
