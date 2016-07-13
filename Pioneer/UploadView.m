//
//  UploadView.m
//  pioneer
//
//  Created by CYNOTECK on 7/25/14.
//  Copyright (c) 2014 CYNOTECK. All rights reserved.
//

#import "UploadView.h"
#import "UploadVideoView.h"
#import "UploadPhoto.h"
#import "UploadTextView.h"
#import "Setting_Screen.h"
#import "UploadAudioView.h"
#import "AppDelegate.h"
#import "KeyChainValteck.h"
#import "Info.h"
#import "Setting_Screen.h"
#import <UIImageView+WebCache.h>
#import "CustomCell.h"
#import "NSDate+TimeAgo.h"
#import "DetailsViewController.h"
#import "About.h"
#import "PrivacyPolicy.h"
#import "Submission.h"
#import "EditProfile.h"
#import "temperatureViewController.h"
#import "SubmitForReview.h"
#import "StaticLinkView.h"
#import "RecordAudioView.h"
#import "PhotoGallery.h"
#import "VideoPlayer.h"
#import "TermsAndConditions.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "loginView.h"
#import "UIAlertController+Window.h"
#import "AFNetworking.h"





NSString *letter = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface UploadView ()<SyncDelegate> {
    
    NSMutableData *responseData;
    NSXMLParser *parser;
    NSArray *feeds;
    NSMutableDictionary *items;
    NSMutableString *title;
    NSMutableString *link;
    NSString *element;
    NSMutableString *description;
    NSMutableString *author;
    NSMutableString *pubDate;
    NSMutableString * imageUrl;
    NSMutableDictionary * attributeDictionary;
    NSMutableString * media;
    NSMutableArray *test_url;
    NSMutableArray *temp_imageURL_Array;
    NSMutableDictionary *temp_imageURL_Dict;
    NSMutableString *str_imageURLs;

    NSURL *url;
    NSURLRequest *urlRequest;
    NSMutableData *WeatherResponseData;
    //int i;
    DataClass * objectDataClass;

    NSMutableArray * categoryArray;
    id collectingData;

    NSArray * tempFeed;
    NSMutableDictionary * completeData;
    //NSMutableArray * homejsonFeed;
    NSString *fileName;
    NSString* localUrl;
    NSArray * firstFeedID;

    NSMutableArray* videoURl;
    NSData *data ;
    NSString*finalUnique;
    NSString* captureduniqueName;
    BOOL Nav_valueToPhoto;


    NSString* firstFeedItemId;

    BOOL VideoIsTapped; // for checking video is tapped.

    // new variable for video
    UIImage *imageThumbnail;
    NSData* videoData;
    NSString *tempPath ;
    BOOL isBrowserTapped;
    NSString*finalUniqueVideo;

    SyncManager *sync;
    CGSize screenSize;
    
    NSString * wetherIcon;
    
    NSMutableArray * PhotoUrl;

}

@property(assign) NSInteger previousRSSSectionIndex;
@property (strong, nonatomic) CCKFNavDrawer *rootNav;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation UploadView

@synthesize iOutlet,mainImagePhoto;
@synthesize tabBarController,photoTabBar,videoTabBar,audioTabBar,textTabBar;
@synthesize show_temperature,mainImage ,uploadTableView,wetherIconImage;
@synthesize tempStringFeedType;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)callServicesInQueue
{
    [self checkUserAlreadyAvailableService];
    [self loadHomeFeed];
}

- (void)beginRefreshingTableView {
    
   [self.refreshControl beginRefreshing];
    
    if (self.uploadTableView.contentOffset.y == 0) {
        
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^(void){
            
            self.uploadTableView.contentOffset = CGPointMake(0, -self.refreshControl.frame.size.height);
            
        } completion:^(BOOL finished){
            
        }];
        
    }
}

-(void) handleServiceCallCompletion
{
    
    if(checkUserAlreadyAvailableServiceCallComplete && homeFeedServiceCallComplete )
    {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.view setUserInteractionEnabled:YES];
            
        });
        
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    sync = [[SyncManager alloc] init];
    sync.delegate = self;
    
    
    screenSize = [[UIScreen mainScreen] bounds].size;
    
    
    
    objectDataClass =[DataClass getInstance];
    [self.uploadTableView setBackgroundView:nil];
    [self.uploadTableView setBackgroundColor:[UIColor clearColor]];
    //[self.show_temperature setHidden:YES];
    [self setNeedsStatusBarAppearanceUpdate];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.uploadTableView addSubview:self.refreshControl];
    
    
    tabBarController.delegate = self;
    
    
    videoTabBar.tag = 0;
    photoTabBar.tag = 1;
    audioTabBar.tag = 2;
    textTabBar.tag  = 3;
    
    //CCFnavDrawer
    DLog(@"global feed id--%@ and type--%@",objectDataClass.globalFeedID,objectDataClass.globalFeedType);
    
    self.rootNav = (CCKFNavDrawer *)self.navigationController;
    [self.rootNav setCCKFNavDrawerDelegate:self];

    [self loadApiAndCheckInternet];
    
    //self.previousRSSSectionIndex = 0;
    //objectDataClass.sectionIndex = self.previousRSSSectionIndex;

}

- (void)refresh:(UIRefreshControl *)refreshControl {
 
    [self loadCategoryAPI];
    
}

-(void)loadApiAndCheckInternet{
    
    [self loadCategoryAPI];
    
}

-(void)loadWeather:(NSString*)cityNameFromLatandLong {
    
        PHHTTPSessionManager *manager = [PHHTTPSessionManager manager];
    
        cityNameFromLatandLong = [cityNameFromLatandLong stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        NSString *urlString = [NSString stringWithFormat:@"http://prngapi.cloudapp.net/api/weather?cityname=%@",cityNameFromLatandLong];
    
        [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
        {
            NSLog(@"JSON weather: %@", responseObject);
            NSDictionary *json = [Utility cleanJsonToObject:responseObject];
            
            if (json!=NULL || [json isKindOfClass:[NSNull class]]) {
                
                NSString * temperature  = [NSString stringWithFormat:@"%@",[json valueForKey:@"Temp"]];
                
                if ([temperature isEqualToString:@"0"]) {
                    
                    
                    
                    
                }else{
                
                
                //setting temperature to label.....
                show_temperature.text = [[[NSString stringWithFormat:@"%d",[temperature intValue]] stringByAppendingString:@"\u00B0"] stringByAppendingString:@"C"];
                NSLog(@"temperature is --%0.0f",[show_temperature.text floatValue]);
                wetherIcon = [json valueForKey:@"Icon"];
                NSLog(@"wether icon is:%@",wetherIcon);
                
                
                NSString *ImageURL = [NSString stringWithFormat:@"http://openweathermap.org/img/w/%@.png",wetherIcon];
                //NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:ImageURL]];
                //wetherIconImage.image = [UIImage imageWithData:imageData];
                
                [wetherIconImage  sd_setImageWithURL:[NSURL URLWithString:ImageURL] placeholderImage:[UIImage imageNamed:@""]];
                
                //setting temp to global variable......
                objectDataClass.temperature = [temperature floatValue];
                NSLog(@"global temp --%0.0f",objectDataClass.temperature);
                
                
                }
                
                
            } else {
               
                
                
                
            }
            
            
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            DLog(@"Error: %@", error);
            [self handleServiceCallCompletion];
        }];
    
 

}




-(void)gobackToHomeScreen
{

    DLog(@"goBackToHomeScreen");
    [self.navigationController popViewControllerAnimated:YES];

}
- (void) receiveNotification:(NSNotification *) notification
{
    
    if ([[notification name] isEqualToString:@"RefreshUploadeView"]){

          [self loadCategoryAPI];
    }
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];

  //  feeds=[[NSUserDefaults standardUserDefaults]valueForKey:@"feesArray"];
    

    PhotoUrl = [NSMutableArray new];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager requestAlwaysAuthorization];
    if ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        
        [locationManager requestAlwaysAuthorization];
    }
    [locationManager startUpdatingLocation];

    
    objectDataClass.audioDetailsMutableArray=nil; // removing object....
    
    // pending ......
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveNotification:) name:@"RefreshUploadeView" object:nil];
    
    

    [tabBarController setSelectedItem:nil]; // set tab bar unselected
    [tabBarController setTintColor:[UIColor blackColor]]; // set tab bar selection color white
    
    
    NSLog(objectDataClass.globalStaticCheck ? @"Yes" : @"No");
        
    if (objectDataClass.globalStaticCheck == YES) {
        
            
            
    }
    else
    {

        videoTabBar.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
        audioTabBar.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
        textTabBar.imageInsets  = UIEdgeInsetsMake(6, 0, -6, 0);
        photoTabBar.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    

    }
    
}

-(void)checkUserAlreadyAvailableService
{

    checkUserAlreadyAvailableServiceCallComplete = YES;
    [self beginRefreshingTableView];
    
    
    NSString* urlString = [NSString stringWithFormat:@"%@%@/%@?deviceId=&source=&token=%@",kBaseURL,kAPI,kUserDetails,[GlobalStuff generateToken]];
    NSLog(@"URL===%@",urlString);
    
    PHHTTPSessionManager *manager = [PHHTTPSessionManager manager];
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *json = [Utility cleanJsonToObject:responseObject];
        
        if (json)
        {
           
           [self handleServiceCallCompletion];
            
            if ([[NSString stringWithFormat:@"%@",[[json valueForKey:@"data"]valueForKey:@"IsLocationEnabled"]] isEqualToString:@"0"])
            {
                
                // no location details are there ...
                
                [[NSUserDefaults standardUserDefaults] setValue:@"LocationOff" forKey:@"LocationCheck"];
                [[NSUserDefaults standardUserDefaults]synchronize];

                
            }
            else
            {
                [[NSUserDefaults standardUserDefaults] setValue:@"LocationOn" forKey:@"LocationCheck"];
                [[NSUserDefaults standardUserDefaults]synchronize];
            }
            
            NSString *userID_Default = [NSString stringWithFormat:@"%@",[[json valueForKey:@"header"] valueForKey:@"UserId"]];
            [[NSUserDefaults standardUserDefaults]setValue:userID_Default forKeyPath:@"userID_Default"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            AppDelegate *app =(AppDelegate *)[UIApplication sharedApplication].delegate;
            [app getCategory];

            
            
            if ([[NSString stringWithFormat:@"%@",[[json valueForKey:@"data"]valueForKey:@"RegisteredwithSyncronex"]] isEqualToString:@"1"])
            {
                
                if ([[NSUserDefaults standardUserDefaults] valueForKey:@"userName"] == nil) {
                    
                    [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"subscribeStatus"];
                    LoginView *loginView=[[LoginView alloc]initWithNibName:@"LoginView" bundle:nil];
                    [self presentViewController:loginView animated:YES completion:nil];
                }
            }
        }
        
        [self.refreshControl endRefreshing];
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [self.refreshControl endRefreshing];
        [self handleServiceCallCompletion];
    }];


    
}

#pragma mark --
#pragma mark -- TabBar delegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if(item.tag == 0)
    {
                DLog(@"Video Tab bar tapped");
        [self checkforNavigationInternetconnection:1];
        
    }else if (item.tag ==1) {
        
        DLog(@"Image tab bar tapped");
        [self checkforNavigationInternetconnection:2];
        
    }else if (item.tag ==2){
        
      
        DLog(@"Audio Tab bar tapped");

    [self checkforNavigationInternetconnection:3];
        
    }else if (item.tag ==3) {
        
               DLog(@"Text Tab bar tapped");
        
        [self checkforNavigationInternetconnection:4];
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --
#pragma mark -- IBAction

- (IBAction)Slider_Tapped:(id)sender {
    
    [self.rootNav drawerToggle:1];
    
    
}



- (IBAction)Video_Tapped:(id)sender {
    
   // [self checkforNavigationInternetconnection:1];

}

- (IBAction)Photo_Tapped:(id)sender {
    
    //[self checkforNavigationInternetconnection:2];
    
}

- (IBAction)Audio_Tapped:(id)sender {
    
   // [self checkforNavigationInternetconnection:3];

    
}

- (IBAction)Text_Tapped:(id)sender {
    
    //[self checkforNavigationInternetconnection:4];

}

- (IBAction)setting_Tapped:(id)sender {
    
    [self checkforNavigationInternetconnection:5];

}

/*- (IBAction)i_ForContent_Tapped:(id)sender {
    

    CGSize size = [[UIScreen mainScreen]bounds].size;
    
    if (size.height==480) {
        
        Info *uploadV = [[Info alloc]initWithNibName:@"info3.5" bundle:nil];
        [self.navigationController pushViewController:uploadV animated:YES];
        
    }else{
        
        Info *uploadV = [[Info alloc]initWithNibName:@"Info" bundle:nil];
        [self.navigationController pushViewController:uploadV animated:YES];
        
    }
    
    
}*/



-(void)checkforNavigationInternetconnection:(int)type{
    
    
    if (type==1) {
        
        UIAlertController *alrController=[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *takeVideo=[UIAlertAction actionWithTitle:@"Capture" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            VideoIsTapped = YES;
            [self loadVideoRecorder];
        }];
        
        UIAlertAction *gallery=[UIAlertAction actionWithTitle:@"Choose From Gallery" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            isBrowserTapped =YES;
            VideoIsTapped = YES;
            [self startMediaBrowserFromViewController: self usingDelegate: self];
            
        }];
        
        UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [tabBarController setSelectedItem:nil]; // set tab bar unselected
            [tabBarController setTintColor:[UIColor blackColor]]; // set tab bar selection color white
            
            
        }];
        
        
        [alrController addAction:takeVideo];
        [alrController addAction:gallery];
        [alrController addAction:cancel];
        
        
        [self presentViewController:alrController animated:YES completion:nil];
        
        
    }
    
    else if (type==2)
        
    {
        
        VideoIsTapped= NO;
        
        UIAlertController *alrController=[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *takeVideo=[UIAlertAction actionWithTitle:@"Capture" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            
            isCameraClicked=YES;
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:picker animated:YES completion:NULL];
            
        }];
        
        UIAlertAction *gallery=[UIAlertAction actionWithTitle:@"Choose From Gallery" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            isCameraClicked=NO;
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = NO;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:picker animated:YES completion:NULL];
            
            
            
        }];
        
        UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            [tabBarController setSelectedItem:nil]; // set tab bar unselected
            [tabBarController setTintColor:[UIColor blackColor]]; // set tab bar selection color white
            
        }];
        
        
        [alrController addAction:takeVideo];
        [alrController addAction:gallery];
        [alrController addAction:cancel];
        
        
        [self presentViewController:alrController animated:YES completion:nil];
        
        //
        //                [self.view endEditing:YES];
        //                NSLog(@"capture photo tapped");
        //
        //                isCameraClicked=YES;
        //                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        //                picker.delegate = self;
        //                picker.allowsEditing = YES;
        //                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        //                [self presentViewController:picker animated:YES completion:NULL];
        //            }else {
        //
        //                //   if ([sender selectedSegmentIndex]==0) {
        //
        //                NSLog(@"capture photo tapped");
        //
        //                isCameraClicked=YES;
        //                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        //                picker.delegate = self;
        //                picker.allowsEditing = YES;
        //                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        //
        //                [self presentViewController:picker animated:YES completion:NULL];
        //            }
        
        
    }
    
    
    else if (type ==3)
        
    {
        
        RecordAudioView *recordview=[[RecordAudioView alloc]initWithNibName:@"RecordAudioView" bundle:Nil];
        [self.navigationController pushViewController:recordview  animated:YES];
        
    }else if (type==4)
        
    {
        
        
        UploadTextView *text=[[UploadTextView alloc]initWithNibName:@"UploadTextView" bundle:nil];
        [self.navigationController pushViewController:text animated:NO];
        
        
        
        
        
        
        
    }else if (type ==5){
        
        Setting_Screen *setting=[[Setting_Screen alloc]initWithNibName:@"Setting_Screen" bundle:nil];
        [self.navigationController pushViewController:setting animated:YES];
        
    }
    
    
}


/*
-(void)checkforNavigationInternetconnection:(int)type{
 
 
          if (type==1) {
 
               VideoIsTapped = YES;
              [self loadVideoRecorder];
 
        }
          else if (type==2) {

              VideoIsTapped= NO;

            if (IS_OS_8_OR_LATER) {
                // code for ios 8 or above !!!!!!!!!
                
                ////////
                
                
                // if ([sender selectedSegmentIndex]==0) {
                [self.view endEditing:YES];
                DLog(@"capture photo tapped");
                
                isCameraClicked=YES;
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.delegate = self;
                picker.allowsEditing = YES;
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                
                //            [self addChildViewController:picker];
                //            [picker didMoveToParentViewController:self];
                //            [self.view addSubview:picker.view];
                [self presentViewController:picker animated:YES completion:NULL];
                
                
            }else {
                
                //   if ([sender selectedSegmentIndex]==0) {
                
                DLog(@"capture photo tapped");
                
                isCameraClicked=YES;
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.delegate = self;
                picker.allowsEditing = YES;
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                
                [self presentViewController:picker animated:YES completion:NULL];
                
                
                
            }

            
        }else if (type ==3){
            
            
            RecordAudioView *recordview=[[RecordAudioView alloc]initWithNibName:@"RecordAudioView" bundle:Nil];
            [self.navigationController pushViewController:recordview  animated:YES];
            
        }else if (type==4){
            
            
                UploadTextView *text=[[UploadTextView alloc]initWithNibName:@"UploadTextView" bundle:nil];
            [self.navigationController pushViewController:text animated:YES];
            
        } else if (type ==5){
            
            Setting_Screen *setting=[[Setting_Screen alloc]initWithNibName:@"Setting_Screen" bundle:nil];
            [self.navigationController pushViewController:setting animated:YES];
            
        }


}

*/

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
   
    [self.view setUserInteractionEnabled:YES];
    [spinner removeSpinner];

}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    
 
    DLog(@"didUpdateToLocation: %@", newLocation);
   
    
    //CLLocation *currentLocation = newLocation;
    
    CLGeocoder *reverseGeocoder = [[CLGeocoder alloc] init];
    
    [reverseGeocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        // NSLog(@"Received placemarks: %@", placemarks);
        
        CLPlacemark *myPlacemark = [placemarks objectAtIndex:0];
       
        NSString *cityName = myPlacemark.subAdministrativeArea;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            DLog(@"inside main thread!");
            [self loadWeather:cityName];
        });
        
        locationManager = nil;
        [locationManager stopUpdatingLocation];

    }];
}


-(void)getAdrressFromLatLong : (CGFloat)lat lon:(CGFloat)lon{
    // coding to send data to server .......start
    ///// we need to fetch location.....
//    [self.view setUserInteractionEnabled:NO];
//    spinner=[SpinnerView loadSpinnerIntoView:self.view];

    NSString *urlString = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f&amp;sensor=false",lat,lon];
    NSURL *url1 = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url1];
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc]init]
                           completionHandler:^(NSURLResponse *response, NSData *data1, NSError *error) {
                               NSError *jsonError;
                               NSArray *array = [NSJSONSerialization JSONObjectWithData:data1
                                                                                options:kNilOptions
                                                                                  error:&jsonError];
                               if (array) {
                                   
                                  // for (NSDictionary * dict in array) {
                                       
                                       NSLog(@"op address is ===%@",[[[array valueForKey:@"results"] valueForKey:@"formatted_address"]objectAtIndex:0]);
                                       [[NSUserDefaults standardUserDefaults]setValue:[NSString stringWithFormat:@"%@",[[[array valueForKey:@"results"] valueForKey:@"formatted_address"]objectAtIndex:0]] forKey:@"address_Default"];
                                       [[NSUserDefaults standardUserDefaults]synchronize];
                                       
                                  // }
                                   //return to main thread
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       
                                       [self.view setUserInteractionEnabled:YES];
                                       [spinner removeSpinner];
                                       
                                       
                                       NSString *address = [[NSUserDefaults standardUserDefaults]stringForKey:@"address_Default"];
                                       [[NSUserDefaults standardUserDefaults]synchronize];
                                       
                                       if (!address) {
                                           
//                                           UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"There was an error while getting the location." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//                                           [alert show];
                                           
                                       }else{
                                           // do nothing!!!!!
                                       }
                                       NSLog(@"inside main thread!");
                                   });
                               }
                               else{
                                   [self.view setUserInteractionEnabled:YES];
                                   [spinner removeSpinner];
                                   
                                   //error while getting location so we need to set bool no here !!!!!!
                                   DLog(@"An error occuredasdfadsfadsf: %@", jsonError);
                                   
                               }
                           }];

    // coding to send data to server .......end..
    
}


#pragma mark-- For Static Menu items.

- (void)StaticMenuItems:(NSInteger)indexValue{
    
    DLog(@"index value--%lu",(unsigned long)indexValue);
    
    DataClass *obj = [DataClass getInstance];
    
    if ( [obj.globalcompleteCategory count] ==indexValue) {
        DLog(   @"this is edit profile");
       
            EditProfile *edit = [[EditProfile alloc]initWithNibName:@"EditProfile" bundle:nil];
            [self.navigationController pushViewController:edit animated:YES];
       

        
    }else if ( [obj.globalcompleteCategory count]+1 == indexValue) {
        DLog(@"terms and conditions!!!");
        
        
            
            
            TermsAndConditions *termsandconditions = [[TermsAndConditions alloc]initWithNibName:@"TermsAndConditions" bundle:nil];
            [self.navigationController pushViewController:termsandconditions animated:YES];
            
            
        
        
    }else if ( [obj.globalcompleteCategory count]+2 == indexValue) {
        
       
        DLog(@" privacy policy");
       
            
            
            PrivacyPolicy *termsOfUse = [[PrivacyPolicy alloc]initWithNibName:@"PrivacyPolicy" bundle:nil];
            [self.navigationController pushViewController:termsOfUse animated:YES];
            
        
        
    }else if ([obj.globalcompleteCategory count]+3 == indexValue) {
        
        DLog(@"About us!!!!");

        
       
            
            About *abt = [[About alloc]initWithNibName:@"About" bundle:nil];
            [self.navigationController pushViewController:abt animated:YES];
            
            
        

        
    }else if ([obj.globalcompleteCategory count]+4 == indexValue){
         DLog(@"my submission");
        
        
            
            
            Submission *submission=[[Submission alloc]initWithNibName:@"Submission" bundle:nil];
            
            [self.navigationController pushViewController:submission animated:YES];
            
            
        

       
        
       
        
       
        
    }else if ( [obj.globalcompleteCategory count]+5 == indexValue) {
        DLog(@"save for later");
        CGSize size = [[UIScreen mainScreen]bounds].size;
        if (480 == size.height) {
            // for iPhone 4.
            SubmitForReview * submitForReviewObj = [[SubmitForReview alloc] initWithNibName:@"SubmitForReview3.5" bundle:nil];
            [self.navigationController pushViewController:submitForReviewObj animated:NO];
            
            
        } else {
            // for iPhone 5 or Above
            
            SubmitForReview * submitForReviewObj = [[SubmitForReview alloc]initWithNibName:@"SubmitForReview" bundle:nil];
            
            [self.navigationController pushViewController:submitForReviewObj animated:NO];
            
        }
        
    }
    
    
}


-(void)CCKFNavDrawerSelection:(NSInteger)selectionIndex{
    
     DLog(@"CCKFNavDrawerSelection =================== %li", (long)selectionIndex);
    //[self.view setUserInteractionEnabled:NO];
    //spinner=[SpinnerView loadSpinnerIntoView:self.view];
    
   // [self.view setUserInteractionEnabled:NO];
   // spinner=[SpinnerView loadSpinnerIntoView:self.view];
    
    
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone){
        
        if ([objectDataClass.globalFeedType isEqualToString:@"Static Link"]) {
            // For this open link in webview..
            
            NSLog(@"link is static");
            StaticLinkView * staticObj = [[StaticLinkView alloc] initWithNibName:@"StaticLinkView" bundle:nil];
            staticObj.staticlink = objectDataClass.globalstaticLink;
            objectDataClass.globalFeedType=tempStringFeedType;
            staticObj.previousMenuIndex = self.previousRSSSectionIndex;

            [self.navigationController pushViewController:staticObj animated:YES];
            
            
            
        }else if ([objectDataClass.globalFeedType isEqualToString:@"Live Streaming"]) {
            //For opening link in external browser.
            
            objectDataClass.globalFeedType=tempStringFeedType;

            UIApplication *mySafari = [UIApplication sharedApplication];
            NSURL *myURL = [[NSURL alloc]initWithString:objectDataClass.globalstaticLink];
            
                            [mySafari openURL:myURL];
            if (![mySafari openURL:myURL])
            {
            
                //  opening didn&#039;t work
            
            }
            
        }
        else{
            
            self.previousRSSSectionIndex = (NSUInteger)selectionIndex;
            DataClass *obj = [DataClass getInstance];
            
                tempStringFeedType=objectDataClass.globalFeedType;
                [self beginRefreshingTableView];
                
                if ([[NSUserDefaults standardUserDefaults] valueForKey:@"subscribeStatus"] == nil)
                {
                // serive for global counter.....
                [sync serviceCall:@"https://syncaccess-demo-posh.stage.syncronex.com/demo/posh/api/svcs/meter/standard?format=JSON" withParams:obj.jsonDict];
                }
                
                NSString* urlString;
                
                if ([objectDataClass.globalCategory isEqualToString:@"Breaking News"]) {
                    //ht tp://prngapi.cloudapp.net/api/BreakingNews?feedid=23&&source=SkagitTimes

                    urlString = [NSString stringWithFormat:@"%@%@/BreakingNews?feedid=%@&source=%@",kBaseURL,kAPI,objectDataClass.globalFeedID,@"SkagitTimes" ];
                    
                    NSLog(@"url with feed id %@",urlString);
                    
                }
                else
                {
                
                    if (objectDataClass.globalFeedID)
                    {
                        
                        
                        urlString = [NSString stringWithFormat:@"%@%@/%@/%@?feedid=%@&source=%@" ,kBaseURL,kAPI,kRssFeed,kGetRssFeed,objectDataClass.globalFeedID,@"SkagitTimes"];
                        
                        NSLog(@"url with feed id %@",urlString);
                        
                    }
                    else
                    {
                       
                        
                        
                        urlString = [NSString stringWithFormat:@"%@%@/%@/%@?feedid=%@&source=%@",kBaseURL,kAPI,kRssFeed,kGetRssFeed,firstFeedItemId,@"SkagitTimes" ];
                                     
                                     
                        
                        
                        
                        NSLog(@"url string home--%@",urlString);
                        
                    }
                }
                PHHTTPSessionManager *manager = [PHHTTPSessionManager manager];
                manager.requestSerializer = [AFJSONRequestSerializer serializer];
                manager.responseSerializer = [AFJSONResponseSerializer serializer];
                
                [manager.requestSerializer setValue:@"PoshMobile" forHTTPHeaderField:@"User-Agent"];


                [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
                    
                    NSLog(@"JSON: %@", responseObject);
                    NSDictionary *json = [Utility cleanJsonToObject:responseObject];
                    [self.view setUserInteractionEnabled:YES];
                    [self.refreshControl endRefreshing];
                    if (json)
                    {
                        
                            NSLog(@"storing it first time");
                        
                        if ([[json valueForKey:@"items"] isKindOfClass:[NSArray class]] && [[json valueForKey:@"items"] count]>0)
                        {
                            
                            
                        
                            
                            feeds= [json valueForKey:@"items"];
                            
//                            [[NSUserDefaults standardUserDefaults]setValue:feeds forKey:@"feesArray"];
//                            [[NSUserDefaults standardUserDefaults]synchronize];
                            [self.uploadTableView reloadData];

                            NSLog(@"new feed are --%@",feeds);
                            
                        }
                        
                        else
                        {
                            UIAlertController * errorAlert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"No data received from the server" preferredStyle:UIAlertControllerStyleAlert];
                            UIAlertAction * errorAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * alert){
                                
                                
                            }];
                            
                            [errorAlert addAction:errorAction];
                            [self presentViewController:errorAlert animated:YES completion:nil];
                            

                        }
                    }
                    
                } failure:^(NSURLSessionTask *operation, NSError *error) {
                    NSLog(@"Error: %@", error);
                    
                    UIAlertController * errorAlert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"No data received from the server" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction * errorAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * alert){
                        
                        
                    }];
                    
                    [errorAlert addAction:errorAction];
                    [self presentViewController:errorAlert animated:YES completion:nil];

                    [self.view setUserInteractionEnabled:YES];
                    [self.refreshControl endRefreshing];
                    
                }];
                
        }
    }
}


#pragma mark -- UITableView Delegate and DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return  1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return  feeds.count;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (0 == indexPath.row ) {
        
        
        return 250.0;
    }
    if ([objectDataClass.globalFeedType isEqualToString:@"Photo Gallery"] || [objectDataClass.globalFeedType isEqualToString:@"Video Gallery"])
    {
         return 117.0;
    }
    
    return 134.0;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    static NSString *MyIdentifier = @"MyReuseIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
   
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:MyIdentifier];
    }
    else
    {
        for (UIView *view in cell.subviews) {
            
            [view removeFromSuperview];
        }
        
        [cell prepareForReuse];
    }
    
    UILabel * firstIndexlabel;
    UILabel * newsPostTime_lbl;
    UILabel * lblCategory;
    UIView * firstIndexView;
    UIView *secondView;
    UILabel *newsTitleNew;
    UILabel * lblDiscription;

  
    cell.backgroundColor = [UIColor whiteColor];
    cell.backgroundView = [UIView new] ;
    cell.selectedBackgroundView = [UIView new];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSArray *mediaArray =[[feeds objectAtIndex:indexPath.row] objectForKey:@"Mediaitems"] ;
    NSString * mediaURL;
    if ([mediaArray  count]>0) {
        
        NSString* imageURltemp = [mediaArray[0] valueForKey:@"url"];
        mediaURL = imageURltemp;
        
    }
    if (0 == indexPath.row) {
        
        firstIndexView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, screenSize.width, 250.0)];
        [firstIndexView setBackgroundColor:[UIColor whiteColor]];
        [cell addSubview:firstIndexView];
        
        
        
                NSString * imgURl = [NSString stringWithFormat:@"%@",mediaURL];
                
                UIImageView * firstImageView =[[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, screenSize.width, 250.0)]; //2,6,301,170
                firstImageView.contentMode = UIViewContentModeScaleAspectFill;
                firstImageView.layer.masksToBounds = YES;
                firstImageView.clipsToBounds= YES;
                
                if ([objectDataClass.globalFeedType isEqualToString:@"Video Gallery"]) {
                    
                    if (mediaURL)
                    {

                    [firstImageView setImage:[UIImage imageNamed:@"VideoPlaceHolder@2x.png"]];
                    }
                    
                }else {
                    
                    if (mediaURL)
                    {

                    [firstImageView sd_setImageWithURL:[NSURL URLWithString:imgURl] placeholderImage:[UIImage imageNamed:@"PlaceHolder@2x.png"]];
                    }
                    else
                    {
                        [firstImageView setImage:[UIImage imageNamed:@"PlaceHolder@2x.png"]];
                    }
                }
        
                [firstIndexView addSubview:firstImageView];
            
        
        UIImageView * gradientImage = [[UIImageView alloc] init];
        gradientImage.frame = firstIndexView.bounds;
        [gradientImage setImage:[UIImage imageNamed:@"Gradient-02@2x.png"]];
        gradientImage.contentMode = UIViewContentModeScaleToFill;
        [firstIndexView addSubview:gradientImage];
        
        
        UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:firstIndexView.bounds];
        firstIndexView.layer.masksToBounds = NO;
        firstIndexView.layer.shadowColor = [UIColor whiteColor].CGColor;
        firstIndexView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
        firstIndexView.layer.shadowOpacity = 0.5f;
        firstIndexView.layer.shadowRadius = 2.0;
        firstIndexView.layer.shadowPath = shadowPath.CGPath;

        newsPostTime_lbl = [[UILabel alloc] initWithFrame:CGRectMake(17.0,120.0, 150.0, 15.0)];//14.0, 108.0, 260.0, 30.0)
        newsPostTime_lbl.textColor = [UIColor colorWithRed:183.0/255.0  green:183.0/255.0 blue:183.0/255.0 alpha:1.0f];
        newsPostTime_lbl.lineBreakMode =NSLineBreakByWordWrapping;
        [newsPostTime_lbl setFont:[UIFont fontWithName:@"ProximaNovaACond-Light" size:12.0]];
        newsPostTime_lbl.text =[[[feeds objectAtIndex:indexPath.row] objectForKey:@"pubDate"] uppercaseString];
        [firstIndexView addSubview:newsPostTime_lbl];
        [firstIndexView bringSubviewToFront:newsPostTime_lbl];

        
        lblCategory = [[UILabel alloc] initWithFrame:CGRectMake(screenSize.width - 167,120.0, 150.0, 15.0)];//14.0, 108.0, 260.0, 30.0)
        lblCategory.textColor = [UIColor colorWithRed:183.0/255.0  green:183.0/255.0 blue:183.0/255.0 alpha:1.0f];
        [lblCategory setFont:[UIFont fontWithName:@"ProximaNovaACond-Light" size:12.0]];
        lblCategory.textAlignment = NSTextAlignmentRight;
        lblCategory.text = [[[feeds objectAtIndex:indexPath.row] objectForKey:@"category"] uppercaseString];
        [firstIndexView addSubview:lblCategory];
        
        
        
        /*
      
        for (NSString* family in [UIFont familyNames])
        {
            NSLog(@"%@", family);
            
            for (NSString* name in [UIFont fontNamesForFamilyName: family])
            {
                NSLog(@"  %@", name);
            }
        }
        
         */
        
        
        firstIndexlabel  = [[UILabel alloc] initWithFrame:CGRectMake(17.0, 149.0, 280.0, 40.0)];//14.0, 128.0, 280.0, 40.0
        firstIndexlabel.numberOfLines = 2;
        firstIndexlabel.textColor = [UIColor whiteColor];
        firstIndexlabel.lineBreakMode = NSLineBreakByWordWrapping;
        [firstIndexlabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:17.0]];
        firstIndexlabel.text =[[feeds objectAtIndex:indexPath.row] objectForKey:@"Title"];
        [firstIndexView addSubview:firstIndexlabel];
        
        
        lblDiscription = [[UILabel alloc] initWithFrame:CGRectMake(17,198.0, screenSize.width-34, 35.0)];//14.0, 108.0, 260.0, 30.0)
        lblDiscription.numberOfLines = 2;

        lblDiscription.textColor = [UIColor colorWithRed:160.0/255.0  green:160.0/255.0 blue:160.0/255.0 alpha:1.0f];
        [lblDiscription setFont:[UIFont fontWithName:@"PTSerif-Regular" size:12.0]];
        
        NSAttributedString *htmlString = [[NSAttributedString alloc] initWithData:[[[feeds objectAtIndex:indexPath.row] objectForKey:@"Description"] dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: [NSNumber numberWithInt:NSUTF8StringEncoding]} documentAttributes:nil error:nil];

        lblDiscription.text = [htmlString string];
        [firstIndexView addSubview:lblDiscription];
        

       
    }
    else
    {
        //ads
        secondView = [[UIView alloc] initWithFrame:CGRectMake(17.0, 17.0, screenSize.width-34, 100.0)];
        [cell addSubview:secondView];
        [secondView setBackgroundColor:[UIColor clearColor]];
        UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:secondView.bounds];
        secondView.layer.masksToBounds = NO;
        secondView.layer.shadowColor = [UIColor whiteColor].CGColor;
        secondView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
        secondView.layer.shadowOpacity = 0.5f;
        secondView.layer.shadowRadius = 2.0;
        secondView.layer.shadowPath = shadowPath.CGPath;
        
        
        
        newsTitleNew = [[UILabel alloc] init];
        [secondView addSubview:newsTitleNew];
        newsTitleNew.numberOfLines = 2;
        newsTitleNew.lineBreakMode = NSLineBreakByWordWrapping;
        [newsTitleNew setFont: [UIFont fontWithName:@"Roboto-Regular" size:15.0]];
        
        NSString *trimmedTitle =  [[[feeds objectAtIndex:indexPath.row] objectForKey:@"Title"] stringByTrimmingCharactersInSet:
                                         [NSCharacterSet whitespaceCharacterSet]];

        newsTitleNew .text  = trimmedTitle ;

        
        UILabel * newsPostTimeNew = [[UILabel alloc] init];//119,13,187,25
        [secondView addSubview:newsPostTimeNew];
        [newsPostTimeNew setTextColor:[UIColor colorWithRed:183.0/255.0  green:183.0/255.0 blue:183.0/255.0 alpha:1.0f]];
        [newsPostTimeNew setFont: [UIFont fontWithName:@"ProximaNovaACond-Light" size:12.0]];
        newsPostTimeNew.text = [[[feeds objectAtIndex:indexPath.row] objectForKey:@"pubDate"] uppercaseString];
        
       
        
        
            if ([objectDataClass.globalFeedType isEqualToString:@"Photo Gallery"]) {
                
                //Increasing the width of imageview. for photo
                
                lblCategory=[[UILabel alloc]init];
                [lblCategory setFrame:CGRectMake(165, 23, 100, 30)];
                lblCategory.textColor = [UIColor colorWithRed:183.0/255.0  green:183.0/255.0 blue:183.0/255.0 alpha:1.0f];
                [lblCategory setFont:[UIFont fontWithName:@"ProximaNovaACond-Light" size:12.0]];
                lblCategory.textAlignment = NSTextAlignmentRight;
                lblCategory.text = [[[feeds objectAtIndex:indexPath.row] objectForKey:@"category"] uppercaseString];
                
                newsPostTimeNew.frame = CGRectMake(17.0, 30.0, 150, 15);
                
                newsTitleNew.frame = CGRectMake(17.0, 55.0, screenSize.width - 51.0, 40.0);
                newsTitleNew.textColor = [UIColor whiteColor];
                
                
                UIImageView * secondImageView = [[UIImageView alloc] init]; // 2,7,95,85
                [secondView addSubview:secondImageView];
                secondImageView.frame = secondView.bounds;
                secondImageView.contentMode = UIViewContentModeScaleAspectFill;
                secondView.layer.masksToBounds = YES;
                secondView.clipsToBounds = YES;
                [secondView sendSubviewToBack:secondImageView];
                
                // Do something...
                
                UIImageView * gradientImage = [[UIImageView alloc] init];
                gradientImage.frame = secondView.bounds;
                [gradientImage setImage:[UIImage imageNamed:@"Gradient-02@2x.png"]];
                gradientImage.contentMode = UIViewContentModeScaleToFill;
                [secondImageView addSubview:gradientImage];
                [secondView sendSubviewToBack:gradientImage];
                

                NSString * imgURl = [NSString stringWithFormat:@"%@",mediaURL];
                
                if ([imgURl length]>0) {
                    
                    [secondImageView sd_setImageWithURL:[NSURL URLWithString:imgURl] placeholderImage:[UIImage imageNamed:@"PlaceHolder@2x.png"]];
                    
                    
                    
                    
                }else{
                    
                    // [secondImageView sd_setImageWithURL:[NSURL URLWithString:imgURl] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
                    
                    [secondImageView setImage:[UIImage imageNamed:@"PlaceHolder@2x.png"]];
                }
                
                [secondImageView addSubview:lblCategory];
                
                
            
        }
            else if ([objectDataClass.globalFeedType isEqualToString:@"Video Gallery"]){
                
                
                newsPostTimeNew.frame = CGRectMake(17.0, 30.0, 150, 15);
                
                newsTitleNew.frame = CGRectMake(17.0, 55.0, screenSize.width - 51.0, 40.0);
                newsTitleNew.textColor = [UIColor whiteColor];
                
                UIImageView * secondImageView = [[UIImageView alloc] init]; // 2,7,95,85
                [secondView addSubview:secondImageView];
                secondImageView.frame = CGRectMake(0, 0, secondView.frame.size.width, secondView.frame.size.height);
                secondImageView.contentMode = UIViewContentModeScaleAspectFill;
                secondView.layer.masksToBounds = YES;
                secondView.clipsToBounds = YES;
                [secondImageView setImage: [UIImage imageNamed:@"VideoPlaceHolder@2x.png"]];
                [secondView sendSubviewToBack:secondImageView];
                
                // Do something...
                
                UIImageView * gradientImage = [[UIImageView alloc] init];
                gradientImage.frame = CGRectMake(0, 0, secondView.frame.size.width, secondView.frame.size.height);
                [gradientImage setImage:[UIImage imageNamed:@"Gradient-02@2x.png"]];
                gradientImage.contentMode = UIViewContentModeScaleToFill;
                [secondImageView addSubview:gradientImage];
                [secondView sendSubviewToBack:gradientImage];
                
               

                
            }
            else if([objectDataClass.globalFeedType isEqualToString:@"Editorial"])
            {
                UILabel *lblSeperaterLine = [[UILabel alloc] initWithFrame:CGRectMake(17.0, 133, screenSize.width-17, 0.5)];
                [cell addSubview:lblSeperaterLine];
                lblSeperaterLine.backgroundColor = [UIColor lightGrayColor];
                
                newsPostTimeNew.frame = CGRectMake(0.0, 0.0, 150, 15);

                UILabel * lblEditorialCategory = [[UILabel alloc] init];
                [secondView addSubview:lblEditorialCategory];
                [lblEditorialCategory setFont: [UIFont fontWithName:@"ProximaNovaACond-Light" size:12.0]];
                lblEditorialCategory.text = [[[feeds objectAtIndex:indexPath.row] objectForKey:@"category"] uppercaseString];
                [lblEditorialCategory setTextColor:[UIColor colorWithRed:183.0/255.0  green:183.0/255.0 blue:183.0/255.0 alpha:1.0f]];
                lblEditorialCategory.textAlignment= NSTextAlignmentRight;
                
                lblDiscription = [[UILabel alloc] init];//14.0, 108.0, 260.0, 30.0)
                lblDiscription.numberOfLines = 2;
                lblDiscription.textColor = [UIColor colorWithRed:127.0/255.0  green:127.0/255.0 blue:127.0/255.0 alpha:1.0f];
                [lblDiscription setFont:[UIFont fontWithName:@"PTSerif-Regular" size:12.0]];
                
                NSAttributedString *htmlString = [[NSAttributedString alloc] initWithData:[[[feeds objectAtIndex:indexPath.row] objectForKey:@"Description"] dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: [NSNumber numberWithInt:NSUTF8StringEncoding]} documentAttributes:nil error:nil];
                
                lblDiscription.text = [htmlString string];
                [secondView addSubview:lblDiscription];
                
                
                UIImageView *imgEditorial = [[UIImageView alloc] initWithFrame:CGRectMake(screenSize.width - 134, 0, 100.0, 100)];
                
                imgEditorial.contentMode = UIViewContentModeScaleToFill; //UIViewContentModeScaleAspectFill
                imgEditorial.clipsToBounds = YES;
                
                if (mediaURL)
                {
                    newsTitleNew.frame = CGRectMake(0.0, 17.0, 160, 40);
                    lblDiscription.frame = CGRectMake(0.0, 65.0, 170, 35.0);
                    lblEditorialCategory.frame = CGRectMake(screenSize.width-310, 0, 150, 15.0);
                    [imgEditorial sd_setImageWithURL:[NSURL URLWithString:mediaURL] placeholderImage:[UIImage imageNamed:@"PlaceHolder@2x.png"]];
                    [secondView addSubview: imgEditorial];
                }
                else
                {
                    newsTitleNew.frame = CGRectMake(0.0, 17.0, screenSize.width-34, 40);
                    lblDiscription.frame = CGRectMake(0.0, 65.0, screenSize.width-34, 35.0);
                    lblEditorialCategory.frame = CGRectMake(screenSize.width-184, 0, 150, 15.0);
                   
                    
                }
            }
        
    }

    

    return cell;
    
    
}

-(UIImage* )loadThumbNail:(NSURL *)urlVideo
{
    
    
    // Get the data to pass in
    AVAsset *asset = [AVAsset assetWithURL:urlVideo];
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc]initWithAsset:asset];
    
    int frameTimeStart = 30;
    int frameLocation = 10;
    
    //Snatch a frame
    CGImageRef imageRef = [imageGenerator copyCGImageAtTime:CMTimeMake(frameTimeStart,frameLocation) actualTime:nil error:nil];
    UIImage *thumbnail = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef); // CGImageRef won’t be released by ARC
    
    return thumbnail;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    DataClass *obj = [DataClass getInstance];
    
    if (obj.globalCounter != 0) {
        obj.globalCounter = obj.globalCounter - 1;
    }
    
    if ([objectDataClass.globalFeedType isEqualToString:@"Photo Gallery"]) { // For Showing TYPE PHOTO..
        
        
        
        
        PhotoUrl = [[feeds objectAtIndex:indexPath.row] valueForKey:@"Mediaitems"];
        
        if ([PhotoUrl count] > 0 ) {
            
            
            PhotoGallery * obj_photo = [[PhotoGallery alloc] initWithNibName:@"PhotoGallery" bundle:nil];
            PhotoUrl = [feeds objectAtIndex:indexPath.row]; //[feeds [indexPath.row]objectForKey:@"Mediaitems"];
            obj_photo.gatheredDict = [PhotoUrl copy];
            obj_photo.mediaDetailDict = [PhotoUrl copy];
            [self presentViewController:obj_photo animated:YES completion:nil];
            
        }else{
            
            
            
        }
        
    }else if ([objectDataClass.globalFeedType isEqualToString:@"Video Gallery"]){
    
        //Navigating to video player class.
        videoURl = [[NSMutableArray alloc] init];
        
        VideoPlayer *obj_video = [[VideoPlayer alloc] initWithNibName:@"VideoPlayer" bundle:nil];
        videoURl = [feeds objectAtIndex:indexPath.row];
        obj_video.gatheredVideoURl = [videoURl copy];
        [self.navigationController pushViewController:obj_video animated:YES];
        
        
    }
    
    else{
    
    
    
    DetailsViewController * detailsView_Object=[[DetailsViewController alloc] initWithNibName:@"DetailsViewController" bundle:nil];
    NSIndexPath *indexPath1 = [self.uploadTableView indexPathForSelectedRow];
    detailsView_Object.allDataArray = [feeds copy];
    
   
    objectDataClass.globalIndex = (int)indexPath1.row;
    
    DLog(@"selected cell is  --%ld and global index--%ld",(long)indexPath1.row,(long)objectDataClass.globalIndex);
    
    NSString *description_string = [feeds[indexPath.row] objectForKey: @"Description"];

    detailsView_Object.getDescriptionString = description_string;
    
    
    NSDictionary * mediaDict = [feeds [indexPath.row]objectForKey:@"Mediaitems"];
    
    NSString *imageURlForWebView;  //= [feeds[indexPath.row] objectForKey:@"Mediaitems"];//imageUrl;
    
    if(mediaDict.count>0){
        
    imageURlForWebView = [mediaDict valueForKey:@"url"];
    
    }else{
        
    }
    
    
    detailsView_Object.getimageURl= imageURlForWebView;
    DLog(@"inage url for webview--%@",detailsView_Object.getimageURl);
    
    
    //detailsView_Object.getImageURls_Dict =[[NSDictionary alloc] init];
 //   [detailsView_Object.getImageURls_Dict setObject:test_url forKey:@"ImageURL"];
  
    detailsView_Object.getImageURls_Dict = mediaDict;  // test_url[indexPath.row];
    //detailsView_Object.getImageURls_Array = [MediaURl copy];
    
    DLog(@"all urls --%@",detailsView_Object.getImageURls_Dict);
    
    
    
    NSString * storeNewsTitle= [feeds[indexPath.row] objectForKey:@"Title"];
   
    
    
    detailsView_Object.getNewsTitle =storeNewsTitle;
    
    
    
    
    
   // DLog(@"description while navigating is --%@",detailsView_Object.getDescriptionString);
    
    [self.navigationController pushViewController:detailsView_Object animated:YES];
    
    
    }
    
        
}



#pragma mark --Show temperature..

- (IBAction)btn_temperature_Tapped:(id)sender {
 

}

#pragma mark-- Loading the API for category

-(void)loadCategoryAPI {
    
    
    //[self beginRefreshingTableView];
        NSString* urlString = [NSString stringWithFormat:@"%@%@/menu/GetMenuCategories?source=%@" ,kBaseURL,kAPI,@"SkagitTimes"];   
    DLog(@"url string service otp--%@",urlString);
    
        
        PHHTTPSessionManager *manager = [PHHTTPSessionManager manager];
        [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
        {
            DLog(@"JSON: %@", responseObject);
            
            
            NSArray *json = [Utility cleanJsonToObject:responseObject];
            
            
            
            [self.view setUserInteractionEnabled:YES];
            [self.refreshControl endRefreshing];

            if (json.count>0)
            {
               


                NSMutableDictionary *jsonDict= [[NSMutableDictionary alloc] init];
                
                
                if ([[[json objectAtIndex:0]valueForKey:@"FeedsItem"] isKindOfClass:[NSArray class]]) {
                    
                    objectDataClass.globalFeedType=[[[json objectAtIndex:0]valueForKey:@"FeedsItem"][0]valueForKey:@"Type"];
                    
                    tempStringFeedType=objectDataClass.globalFeedType;

                    firstFeedItemId  = [[[[json objectAtIndex:0] valueForKey:@"FeedsItem"] objectAtIndex:0] valueForKey:@"Id_Feed"];
                    
                    objectDataClass.globalcompleteCategory = [json mutableCopy];
                    
                    objectDataClass.globalSubCategory = [[[[json objectAtIndex:0] valueForKey:@"FeedsItem"] objectAtIndex:0] valueForKey:@"Name"];
                    objectDataClass.globalCategory = [NSString stringWithFormat:@"%@",[json objectAtIndex:0][@"Menu"][@"MainCategory"]];

                    
                    [jsonDict setObject:@"YTliMzYyYTktMWMyZC00NTc0LWE4NWMtN2JkMTA2YjAyMGQ3" forKey:@"sessionId"];
                    [jsonDict setObject:[objectDataClass.globalcompleteCategory objectAtIndex:0][@"Menu"][@"MainCategory"] forKey:@"contentId"];
                    [jsonDict setObject:@"" forKey:@"referrer"];
                    [jsonDict setObject:@"IOS" forKey:@"clientInfo"];
                }
                
                // DLog(@"complete json --%@",objectDataClass.globalcompleteCategory);
                // PAYMETER API
                
                DLog(@"%@",jsonDict);
                DataClass *obj = [DataClass getInstance];
                obj.jsonDict = jsonDict;
                DLog(@"%@",obj.jsonDict);
                if ([[NSUserDefaults standardUserDefaults] valueForKey:@"subscribeStatus"] == nil) {

                [sync serviceCall:@"https://syncaccess-demo-posh.stage.syncronex.com/demo/posh/api/svcs/meter/standard?format=JSON" withParams:obj.jsonDict];
                    
                }


                [self callServicesInQueue]; // call webservice in queue

                
            } else {
                
                
                
                UIAlertController * errorAlert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Not found data from server." preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction * errorAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * alert){
                }];
                
                [errorAlert addAction:errorAction];
                [self presentViewController:errorAlert animated:YES completion:nil];
                

                
            }
            
            
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            DLog(@"Error: %@", error);
            
            [self.view setUserInteractionEnabled:YES];
            [self.refreshControl endRefreshing];

            UIAlertController * errorAlert = [UIAlertController alertControllerWithTitle:@"Alert" message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * errorAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * alert){
            }];
            
            [errorAlert addAction:errorAction];
            [self presentViewController:errorAlert animated:YES completion:nil];
            

            
        }];

}


#pragma mark -- loading the Home Json

-(void)loadHomeFeed {
    
    
    homeFeedServiceCallComplete = YES;
    
       NSString* urlString;
        
        if ([objectDataClass.globalCategory isEqualToString:@"Breaking News"])
        {
            //ht tp://prngapi.cloudapp.net/api/BreakingNews?feedid=23&&source=SkagitTimes
            
            
            
            urlString = [NSString stringWithFormat:@"%@%@/BreakingNews?feedid=%@&source=%@",kBaseURL,kAPI,objectDataClass.globalFeedID,@"SkagitTimes"];
                         
            
            NSLog(@"url with feed id %@",urlString);
            
        }
        else
        {
        
            if (objectDataClass.globalFeedID)
            {
                
                
                urlString = [NSString stringWithFormat:@"%@%@/%@/%@?feedid=%@&source=%@",kBaseURL,kAPI,kRssFeed,kGetRssFeed,objectDataClass.globalFeedID,@"SkagitTimes" ];
                             
                
                NSLog(@"url with feed id %@",urlString);
                
            }
            else
            {
                
               
                
                urlString = [NSString stringWithFormat:@"%@%@/%@/%@?feedid=%@&source=%@",kBaseURL,kAPI,kRssFeed,kGetRssFeed,firstFeedItemId,@"SkagitTimes"];
                
                             
                             
                
                NSLog(@"url string home--%@",urlString);
                
            }

        }
        PHHTTPSessionManager *manager = [PHHTTPSessionManager manager];
    
    [self beginRefreshingTableView];
        [manager.requestSerializer setValue:@"PoshMobile" forHTTPHeaderField:@"User-Agent"];
        
        [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
           
            DLog(@"JSON: %@", responseObject);
            NSDictionary *json = [Utility cleanJsonToObject:responseObject];
            
            if (json)
            {
                [self handleServiceCallCompletion];
                
                
                    DLog(@"storing it first time");
                
                
                if ([[json valueForKey:@"items"] isKindOfClass:[NSArray class]]) {
                    
                    
                    feeds= [json valueForKey:@"items"];
                    
//                    [[NSUserDefaults standardUserDefaults]setValue:feeds forKey:@"feesArray"];
//                    [[NSUserDefaults standardUserDefaults]synchronize];
                    
                    [self.uploadTableView reloadData];

                    DLog(@"new feed are --%@",feeds);
                    
                }
                else
                {
                    
                    UIAlertController * errorAlert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"No data received from the server" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction * errorAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * alert){
                        
                        
                    }];
                    
                    [errorAlert addAction:errorAction];
                    [self presentViewController:errorAlert animated:YES completion:nil];
                
                }

                
            }
            else
            {
                UIAlertController * errorAlert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"No data received from the server" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction * errorAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * alert){
                    
                    
                }];
                
                [errorAlert addAction:errorAction];
                [self presentViewController:errorAlert animated:YES completion:nil];

            }
            
            [self.refreshControl endRefreshing];
            
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            DLog(@"Error: %@", error);
            [self.refreshControl endRefreshing];
            [self handleServiceCallCompletion];
           

        }];
    

}

#pragma mark -- UIImage resizing 
-(UIImage*)resizeImage:(UIImage *)image imageSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0,0,size.width,size.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    //here is the scaled image which has been changed to the size specified
    UIGraphicsEndImageContext();
    return newImage;
}


#pragma mark -- calling image picker..
#pragma mark - Image Picker Controller delegate methods   starts ...

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    if (VideoIsTapped == YES ) { // for video is tapped
        
        [[NSUserDefaults standardUserDefaults]setValue:@"DoneVideo" forKey:@"Video_Check"];
        

        
        NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
        
        videoData = [NSData dataWithContentsOfURL:videoURL];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        fileName = [NSString stringWithFormat:@"%@",[self randomStringWithLength:8]];
        tempPath = [documentsDirectory stringByAppendingFormat:@"/%@.mp4",fileName];
        
        
        [[NSUserDefaults standardUserDefaults] setObject:videoData forKey:@"VideoData"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [videoData writeToFile:tempPath atomically:NO];
        DLog(@"this is the pathe of temp of the video ====>%@",tempPath);
        

        UploadVideoView *uploadV = [[UploadVideoView alloc]initWithNibName:@"UploadVideoView" bundle:nil];
        uploadV.receivedPath = tempPath;
        uploadV.ReceivedURl =videoURL;
        uploadV.fileNameforVideo = [self generateUniqueNameVideo];
        [self.navigationController pushViewController:uploadV animated:NO];
        
        [picker dismissViewControllerAnimated:YES completion:nil];
        [self.view setNeedsLayout];
        

    }
    else{ // for photo
        
        
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    mainImage = chosenImage;
    data = UIImagePNGRepresentation(mainImage);
    DLog(@"converted data--%@",data);
    
    //   localUrl = (NSURL *)[info valueForKey:UIImagePickerControllerReferenceURL];
    //    DLog(@"imagepath==================== %@",localUrl);
    
    if(isCameraClicked)
    {
        UIImageWriteToSavedPhotosAlbum(mainImage,  nil,  nil, nil);
        
        
    }
    
    //DLog(@"image is ========%@",mainImage);
    
    DLog(@"info==============%@",info);
    
    //New chamges
    
    UIImage *editedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    //    NSString *docDirPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
//    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
//    NSString *documentsDirectory;
//    for (int i=0; i<[pathArray count]; i++) {
//        documentsDirectory =[pathArray objectAtIndex:i];
//    }
    
    //Gaurav's logic
    
    DLog(@"%lu",(unsigned long)[[[NSUserDefaults standardUserDefaults]objectForKey:@"MyArray"] count]);
    
    
    
    // NSString *myUniqueName = [NSString stringWithFormat:@"%@-%u", name, (NSUInteger)([[NSDate date] timeIntervalSince1970]*10.0)];
    
    //mohit logic
    
    fileName = [NSString stringWithFormat:@"%lu.png",(NSUInteger)([[NSDate date] timeIntervalSince1970]*10.0)];
    
    
    
    //
    
    
    // NSString *documentsDirectory = [pathArray objectAtIndex:0];
    
    localUrl =  [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:fileName];//[documentsDirectory stringByAppendingPathComponent:fileName];
    NSLog (@"File Path = %@", localUrl);
    
    // Get PNG data from following method
    NSData *myData =     UIImagePNGRepresentation(editedImage);
    // It is better to get JPEG data because jpeg data will store the location and other related information of image.
    [myData writeToFile:localUrl atomically:YES];
    
    // Now you can use filePath as path of your image. For retrieving the image back from the path
    //UIImage *imageFromFile = [UIImage imageWithContentsOfFile:localUrl];
    
    
    [[NSUserDefaults standardUserDefaults]setValue:@"DonePhoto" forKey:@"Photo_Check"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    //[picker dismissViewControllerAnimated:YES completion:NULL];
    DLog(@"photo done--%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"Photo_Check"]);
    
    captureduniqueName = [self generateUniqueName];
    
    Nav_valueToPhoto =YES;
    
  //  handleView = YES ;
       
                    UploadPhoto *uploadP = [[UploadPhoto alloc]initWithNibName:@"UploadPhoto" bundle:nil];
                    uploadP.transferedImageData =data;
                    uploadP.transferPhotoUniqueName = captureduniqueName;
                    uploadP.navigateValue = Nav_valueToPhoto;
                    uploadP.transferFileURl =localUrl;
                    [self.navigationController pushViewController:uploadP animated:NO];
                    
              
    
    
   
    
  //  [self.scrollView_Photo setScrollEnabled:YES];
    // [self.scrollView_Photo setContentSize:CGSizeMake(320, 600)];
   // [self.scrollView_Photo setContentOffset:CGPointMake(5, 5) animated:YES];
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self.view setNeedsLayout];
    
    }
}

-(NSString *)generateUniqueNameVideo{
    
    
    // NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    //NSString *finalUnique= [NSString stringWithFormat:@"Video_%.0f.mp4", time];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyyMMdd_HHmmss"];
    
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    
    // int randomValue = arc4random() % 1000;
    //  NSString *unique = [NSString stringWithFormat:@"%@%d",dateString,randomValue];
    finalUniqueVideo = [NSString stringWithFormat:@"Video_%@.mp4",dateString];
    
    return finalUniqueVideo;
    
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    DLog(@"cancel Tapped!");
    [tabBarController setSelectedItem:nil]; // set tab bar unselected

    isPickerTapped = YES;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
  
   // [picker dismissViewControllerAnimated:<#(BOOL)#> completion:<#^(void)completion#>];
    
    [self.view setNeedsLayout];
    
  
    
}



#pragma mark - Image Picker Controller delegate methods   ends ...

-(NSString *)generateUniqueName{
    
    //  NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    // NSString *finalUnique= [NSString stringWithFormat:@"Photo_%.0f.jpg", time];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd_HHmmss"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    // int randomValue = arc4random() % 1000;
    //  NSString *unique = [NSString stringWithFormat:@"%@%d",dateString,randomValue];
    finalUnique = [NSString stringWithFormat:@"Photo_%@.jpg",dateString];
    DLog(@"unique name --%@",finalUnique);
    return finalUnique;
    
}
-(void)loadVideoRecorder{
    
    if (IS_OS_8_OR_LATER) {   // code for ios 8 or above !!!!!!!!!
        
        
        
        DLog(@"capture Video tapped");
      //  isBrowserTapped=YES;
        [self.view endEditing:YES];
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
  
            UIAlertController *DoNothing_alrt = [UIAlertController alertControllerWithTitle:@"Message!" message:@"Camera is not present!" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * doNothingAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * alert ){
                // action.,.........
                
            }];
            [DoNothing_alrt addAction:doNothingAction];
            [self presentViewController:DoNothing_alrt  animated:YES completion:nil];
        }
        else
        {
           

            isBrowserTapped=YES;
            [self startCameraControllerFromViewController: self usingDelegate: self]; // this is calling the camera
            
        }
        
        
    }else { // for IOS less than 7
        
        DLog(@"capture Video tapped");
        //isBrowserTapped=YES;
        [self.view endEditing:YES];
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            
            /*  UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Message!" message:@"Camera is not present!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
             [alert show];
             */
            
            UIAlertController *DoNothing_alrt = [UIAlertController alertControllerWithTitle:@"Message!" message:@"Camera is not present!" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * doNothingAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * alert ){
                // action.,.........
                
            }];
            [DoNothing_alrt addAction:doNothingAction];
            [self presentViewController:DoNothing_alrt  animated:YES completion:nil];
            
        } else {
            
            isBrowserTapped=YES;
            [self startCameraControllerFromViewController: self usingDelegate: self]; // this is calling the camera
            
        }
        
        
    }
    
}

#pragma mark **************** Front Camera Code For recording ****************************
//========================================================================================

- (BOOL) startCameraControllerFromViewController: (UIViewController*) controller
                                   usingDelegate: (id <UIImagePickerControllerDelegate,
                                                   UINavigationControllerDelegate>) delegate {
    
    if (([UIImagePickerController isSourceTypeAvailable:
          UIImagePickerControllerSourceTypeCamera] == NO)
        || (delegate == nil)
        || (controller == nil))
        return NO;
    
    
    
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    cameraUI.cameraDevice=UIImagePickerControllerCameraDeviceRear;
    cameraUI.showsCameraControls = YES;
    cameraUI.navigationBarHidden = YES;
    cameraUI.allowsEditing=YES;
    cameraUI.toolbarHidden = YES;
    cameraUI.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
    cameraUI.delegate = self;
    
    [self presentViewController:cameraUI animated:NO completion:nil];
    
    
    int64_t delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        //[cameraUI startVideoCapture];
        [cameraUI performSelector:@selector(stopVideoCapture) withObject:nil afterDelay:60];
    });
    
    return YES;
}

-(NSString *) randomStringWithLength: (int) len {
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letter characterAtIndex: arc4random_uniform([letter length])]];
    }
    
    return randomString;
}


- (void)video:(NSString*)videoPath didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo
{
    if (error) {
      /*  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Video Saving Failed"  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil, nil];
        [alert show];
    */
        UIAlertController * errorAlert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Video Saving Failed" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * errorAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * alert){
        }];
        
        [errorAlert addAction:errorAction];
        [self presentViewController:errorAlert animated:YES completion:nil];

       }else{
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Video Saved" message:@"Saved To Photo Album"  delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        //        [alert show];
        
    }
}



- (IBAction)loginButton:(id)sender
{
    LoginView * objLogin = [[LoginView alloc] initWithNibName:@"LoginView" bundle:nil];
    [self.navigationController pushViewController:objLogin animated:YES];
}

#pragma mark Web Service Delegate

-(void)syncSuccess:(id) responseObject {
    
    DLog(@"%@",responseObject);
    
    
    
    if ([[responseObject valueForKey:@"statusCode"] integerValue] == 0) {
        
        DataClass *obj = [DataClass getInstance];
        [[NSUserDefaults standardUserDefaults] setValue:[responseObject valueForKey:@"remainingViewCount"] forKey:@"remainingViewCount"];
        [[NSUserDefaults standardUserDefaults] setValue:[responseObject valueForKey:@"registerUrl"] forKey:@"registerUrl"];
        
        obj.globalCounter = [[responseObject valueForKey:@"remainingViewCount"] integerValue];
        
    }
    else {
        
        NSString *cancelTitle =@"OK";
        NSString *message = [responseObject valueForKey:@"statusMsg"];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:message preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            
            // do NOT use alert.textfields or otherwise reference the alert in the block. Will cause retain cycle
        }]];
        [alert show];
    }
    
}

-(void)syncFailure:(NSError*) error {
    //display Error
    NSString *cancelTitle =@"OK";
    
    NSString *message = [error localizedDescription];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        
        // do NOT use alert.textfields or otherwise reference the alert in the block. Will cause retain cycle
    }]];
    [alert show];
}

- (BOOL) startMediaBrowserFromViewController: (UIViewController*) controller
                               usingDelegate: (id <UIImagePickerControllerDelegate,
                                               UINavigationControllerDelegate>) delegate{
    
    if (([UIImagePickerController isSourceTypeAvailable:
          UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO)
        || (delegate == nil)
        || (controller == nil))
        return NO;
    
    UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
    mediaUI.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    mediaUI.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
    
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    mediaUI.allowsEditing = YES;
    
    mediaUI.delegate = delegate;
    
    [controller presentViewController:mediaUI animated:YES completion:nil];//: mediaUI animated: YES];
    return YES;
    
}


@end
