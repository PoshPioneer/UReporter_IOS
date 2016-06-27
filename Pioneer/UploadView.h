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
    UIAlertView *successful_AlertShow ;
    
    BOOL homeFeedServiceCallComplete;
    BOOL loadCategoryServiceCallComplete;
    BOOL loadWeatherServiceCallComplete;
    BOOL getCategoryServiceCallComplete;
    BOOL checkUserAlreadyAvailableServiceCallComplete;


    
    
}

@property(nonatomic,assign)int checkServiceType;




- (IBAction)loginButton:(id)sender;

@property(nonatomic,strong)UIImage *mainImagePhoto;
//Image picker property
@property(nonatomic,strong)UIImage *mainImage;

//Image picker property end


- (IBAction)Slider_Tapped:(id)sender;

- (IBAction)Video_Tapped:(id)sender;
- (IBAction)Photo_Tapped:(id)sender;
- (IBAction)Audio_Tapped:(id)sender;
- (IBAction)Text_Tapped:(id)sender;

- (IBAction)setting_Tapped:(id)sender;
//- (IBAction)i_ForContent_Tapped:(id)sender;


@property (weak, nonatomic) IBOutlet UIButton *iOutlet;
@property (nonatomic,strong) NSMutableDictionary *getData;
@property (nonatomic,strong) NSString *getOTP;
@property (nonatomic) float getTime;


@property (weak, nonatomic) IBOutlet UITabBar *tabBarController;
@property (weak, nonatomic) IBOutlet UITabBarItem *photoTabBar;
@property (weak, nonatomic) IBOutlet UITabBarItem *videoTabBar;
@property (weak, nonatomic) IBOutlet UITabBarItem *audioTabBar;
@property (weak, nonatomic) IBOutlet UITabBarItem *textTabBar;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)btn_temperature_Tapped:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *show_temperature;


@end
