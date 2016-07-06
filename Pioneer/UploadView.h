//
//  UploadView.h
//  pioneer
//
//  Created by CYNOTECK on 7/25/14.
//  Copyright (c) 2014 CYNOTECK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpinnerView.h"
#import <CoreLocation/CoreLocation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "CCKFNavDrawer.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface UploadView : UIViewController<CCKFNavDrawerDelegate,UIAlertViewDelegate,CLLocationManagerDelegate,UITabBarControllerDelegate,UITabBarDelegate,NSXMLParserDelegate,UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,SDWebImageManagerDelegate>{
    
    BOOL isCameraClicked;
    BOOL isPickerTapped;
    
    UIImageView *m_SplashView;
    SpinnerView *spinner;

    CLLocationManager *locationManager;
  
    BOOL homeFeedServiceCallComplete;
    BOOL loadCategoryServiceCallComplete;
    BOOL loadWeatherServiceCallComplete;
    BOOL getCategoryServiceCallComplete;
    BOOL checkUserAlreadyAvailableServiceCallComplete;

    
}

@property(nonatomic,assign)int checkServiceType;
@property(nonatomic,strong)UIImage *mainImagePhoto;
@property(nonatomic,strong)UIImage *mainImage;
@property (weak, nonatomic) IBOutlet UIButton *iOutlet;
@property (nonatomic,strong) NSMutableDictionary *getData;
@property (nonatomic,strong) NSString *getOTP;
@property (nonatomic) float getTime;
@property (weak, nonatomic) IBOutlet UITabBar *tabBarController;
@property (weak, nonatomic) IBOutlet UITabBarItem *photoTabBar;
@property (weak, nonatomic) IBOutlet UITabBarItem *videoTabBar;
@property (weak, nonatomic) IBOutlet UITabBarItem *audioTabBar;
@property (weak, nonatomic) IBOutlet UITabBarItem *textTabBar;
@property (weak, nonatomic) IBOutlet UITableView *uploadTableView;
@property (weak, nonatomic) IBOutlet UILabel *show_temperature;
@property (weak, nonatomic) IBOutlet UIImageView *wetherIconImage;


- (IBAction)Slider_Tapped:(id)sender;
- (IBAction)btn_temperature_Tapped:(id)sender;
- (IBAction)setting_Tapped:(id)sender;
@property (nonatomic,strong)NSString *tempStringFeedType;


@end
