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


}

@property (strong, nonatomic) CCKFNavDrawer *rootNav;

@end

@implementation UploadView

@synthesize iOutlet,mainImagePhoto;
@synthesize tabBarController,photoTabBar,videoTabBar,audioTabBar,textTabBar;
@synthesize show_temperature,mainImage ,tableView;


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
    
    if ([Utility connected] == YES)
    {
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.view setUserInteractionEnabled:NO];
            spinner=[SpinnerView loadSpinnerIntoView:self.view];
            
        });
        
         [self checkUserAlreadyAvailableService];
         [self loadWeather];
         [self loadHomeFeed];
        
    }

}

-(void) handleServiceCallCompletion
{
    
    if(checkUserAlreadyAvailableServiceCallComplete && homeFeedServiceCallComplete && loadWeatherServiceCallComplete)
    {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.view setUserInteractionEnabled:YES];
            [spinner removeSpinner];
            
        });
        
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    sync = [[SyncManager alloc] init];
    sync.delegate = self;
    
    objectDataClass =[DataClass getInstance];
    [self.tableView setBackgroundView:nil];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.show_temperature setHidden:YES];
    [self setNeedsStatusBarAppearanceUpdate];
    
    
    
    tabBarController.delegate = self;
    
    
    videoTabBar.tag = 0;
    photoTabBar.tag = 1;
    audioTabBar.tag = 2;
    textTabBar.tag  = 3;
    
    //CCFnavDrawer
    NSLog(@"global feed id--%@ and type--%@",objectDataClass.globalFeedID,objectDataClass.globalFeedType);
    
    self.rootNav = (CCKFNavDrawer *)self.navigationController;
    [self.rootNav setCCKFNavDrawerDelegate:self];

    [self loadApiAndCheckInternet];
    

}

-(void)loadApiAndCheckInternet{
    
    if ([Utility connected] == YES) {
        //do nothing.
        
        [self loadCategoryAPI];
        //----------------XMLParser--------------------------------------------------------//
        
    } else {
        
        if ([[NSUserDefaults standardUserDefaults] valueForKey:@"userName"] == nil && [[[NSUserDefaults standardUserDefaults] valueForKey:@"subscribeStatus"] isEqualToString:@"1"]) {
            
            LoginView *loginView=[[LoginView alloc]initWithNibName:@"LoginView" bundle:nil];
            [self presentViewController:loginView animated:YES completion:nil];
        }
        else
        {
            UIAlertController * errorAlert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Internet connection is not available. Please try again." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction  *errorAction = [UIAlertAction actionWithTitle:@"Try again" style:UIAlertActionStyleDefault handler:^(UIAlertAction  *alert){
                
                
                [self loadApiAndCheckInternet];
                
                
            }];
            
            [errorAlert addAction:errorAction];
            [self presentViewController:errorAlert animated:YES completion:nil];
        }
    }

    
}

-(void)loadWeather {
    
    
    
    loadWeatherServiceCallComplete = YES;
    [self handleServiceCallCompletion];
    
    if ([Utility connected] == YES) {
        //do nothing.
  
        // weather api url...
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager POST:@"http://api.openweathermap.org/data/2.5/weather?zip=98274,us&appid=025fd416c44e35caa638609d50f6c056&units=metric" parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
        {
            NSLog(@"JSON: %@", responseObject);
            NSDictionary *json = [Utility cleanJsonToObject:responseObject];
            
            if (json) {
                
                NSString * temperature  = [NSString stringWithFormat:@"%@",[[json valueForKey:@"main"] valueForKey:@"temp"]];
                
                //setting temperature to label.....
                show_temperature.text = [NSString stringWithFormat:@"%0.0f",[temperature floatValue]];
                NSLog(@"temperature is --%0.0f",[show_temperature.text floatValue]);
                
                //setting temp to global variable......
                objectDataClass.temperature = [temperature floatValue];
                NSLog(@"global temp --%0.0f",objectDataClass.temperature);

                
            } else {
                
            }
            
            
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            [self handleServiceCallCompletion];
        }];
    
 
        
    } else {
        
        UIAlertController * errorAlert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Internet connection is not available. Please try again." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * errorAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * alert){
        }];
        
        [errorAlert addAction:errorAction];
        [self presentViewController:errorAlert animated:YES completion:nil];

        
    }

}


-(void)gobackToHomeScreen
{

    NSLog(@"goBackToHomeScreen");
    [self.navigationController popViewControllerAnimated:YES];

}
- (void) receiveNotification:(NSNotification *) notification
{
    
    if ([[notification name] isEqualToString:@"RefreshUploadeView"]){

          [self loadCategoryAPI];
    }
}

-(void)viewWillAppear:(BOOL)animated {
    
    // pending ......
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveNotification:) name:@"RefreshUploadeView" object:nil];
    
    //[[NSNotificationCenter defaultCenter]removeObserver:self name:@"RefreshUploadeView" object:nil];
    
    

    [tabBarController setSelectedItem:nil]; // set tab bar unselected
    [tabBarController setTintColor:[UIColor whiteColor]]; // set tab bar selection color white
    
    
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
    
    NSString* urlString = [NSString stringWithFormat:@"http://prngapi.cloudapp.net/api/UserDetails?deviceId=&source=&token=%@",[GlobalStuff generateToken]];
    NSLog(@"URL===%@",urlString);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *json = [Utility cleanJsonToObject:responseObject];
        
        if (json)
        {
           
           [self handleServiceCallCompletion];
            
            if ([[NSString stringWithFormat:@"%@",[[json valueForKey:@"data"]valueForKey:@"IsLocationEnabled"]] isEqualToString:@"0"])
            {
                
                // no location details are there ...
                
            }
            else
            {
                
                locationManager = [[CLLocationManager alloc] init];
                locationManager.delegate = self;
                locationManager.desiredAccuracy = kCLLocationAccuracyBest;
                [locationManager requestAlwaysAuthorization];
                [locationManager startUpdatingLocation];
                
                
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
        
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
        [self handleServiceCallCompletion];
    }];


    
}

#pragma mark --
#pragma mark -- TabBar delegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if(item.tag == 0)
    {
                NSLog(@"Video Tab bar tapped");
        [self checkforNavigationInternetconnection:1];
        
    }else if (item.tag ==1) {
        
        NSLog(@"Image tab bar tapped");
        [self checkforNavigationInternetconnection:2];
        
    }else if (item.tag ==2){
        
      
        NSLog(@"Audio Tab bar tapped");

    [self checkforNavigationInternetconnection:3];
        
    }else if (item.tag ==3) {
        
               NSLog(@"Text Tab bar tapped");
        
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
                NSLog(@"capture photo tapped");
                
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
                
                NSLog(@"capture photo tapped");
                
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
            
            CGSize size = [[UIScreen mainScreen]bounds].size;
            
            if (size.height==480) {
                UploadTextView *text=[[UploadTextView alloc]initWithNibName:@"UploadTextView3.5" bundle:nil];
                [self.navigationController pushViewController:text animated:NO];
                
            }else{
                UploadTextView *text=[[UploadTextView alloc]initWithNibName:@"UploadTextView" bundle:nil];
                [self.navigationController pushViewController:text animated:NO];
                
            }

            
            
            
            
        }else if (type ==5){
            
            Setting_Screen *setting=[[Setting_Screen alloc]initWithNibName:@"Setting_Screen" bundle:nil];
            [self.navigationController pushViewController:setting animated:YES];
            
        }


}



- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    
    [self.view setUserInteractionEnabled:YES];
    [spinner removeSpinner];
//    UIAlertView *errorAlert = [[UIAlertView alloc]
//                               initWithTitle:@"Alert" message:@"There was an error while getting the location." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [errorAlert show];
}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        
        NSLog(@"lat is ====%@",[NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude]);
        NSLog(@"long is ====%@",[NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude]);
        [self getAdrressFromLatLong:currentLocation.coordinate.latitude lon:currentLocation.coordinate.longitude];
        locationManager = nil;
        [locationManager stopUpdatingLocation];
        
        
    }
}


-(void)getAdrressFromLatLong : (CGFloat)lat lon:(CGFloat)lon{
    // coding to send data to server .......start
    ///// we need to fetch location.....
//    [self.view setUserInteractionEnabled:NO];
//    spinner=[SpinnerView loadSpinnerIntoView:self.view];

    NSString *urlString = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f&amp;sensor=false",lat,lon];
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc]init]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               NSError *jsonError;
                               NSArray *array = [NSJSONSerialization JSONObjectWithData:data
                                                                                options:kNilOptions
                                                                                  error:&jsonError];
                               if (array) {
                                   
                                   for (NSDictionary * dict in array) {
                                       
                                       NSLog(@"op address is ===%@",[[[array valueForKey:@"results"] valueForKey:@"formatted_address"]objectAtIndex:0]);
                                       [[NSUserDefaults standardUserDefaults]setValue:[NSString stringWithFormat:@"%@",[[[array valueForKey:@"results"] valueForKey:@"formatted_address"]objectAtIndex:0]] forKey:@"address_Default"];
                                       [[NSUserDefaults standardUserDefaults]synchronize];
                                       
                                   }
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
                                   NSLog(@"An error occuredasdfadsfadsf: %@", jsonError);
                                   
                               }
                           }];

    // coding to send data to server .......end..
    
}


#pragma mark-- For Static Menu items.

- (void)StaticMenuItems:(NSInteger)indexValue{
    
    NSLog(@"index value--%lu",(unsigned long)indexValue);
    
    DataClass *obj = [DataClass getInstance];
    
    if ( [obj.globalcompleteCategory count] ==indexValue) {
        NSLog(   @"this is edit profile");
        CGSize size = [[UIScreen mainScreen]bounds].size;
        
        if (size.height==480) {
            EditProfile *edit = [[EditProfile alloc]initWithNibName:@"EditProfile3.5" bundle:nil];
            [self.navigationController pushViewController:edit animated:YES];
            
            
        }else{
            EditProfile *edit = [[EditProfile alloc]initWithNibName:@"EditProfile" bundle:nil];
            [self.navigationController pushViewController:edit animated:YES];
        }

        
    }else if ( [obj.globalcompleteCategory count]+1 == indexValue) {
        NSLog(@"terms and conditions!!!");
        
        CGSize size = [[UIScreen mainScreen]bounds].size;
        
        if (size.height==480) {
            TermsAndConditions *termsandconditions = [[TermsAndConditions alloc]initWithNibName:@"TermsAndConditions3.5 " bundle:nil];
            [self.navigationController pushViewController:termsandconditions animated:YES];
            
            
        }else{
            
            
            TermsAndConditions *termsandconditions = [[TermsAndConditions alloc]initWithNibName:@"TermsAndConditions" bundle:nil];
            [self.navigationController pushViewController:termsandconditions animated:YES];
            
            
        }
        
    }else if ( [obj.globalcompleteCategory count]+2 == indexValue) {
        
       
        NSLog(@" privacy policy");
        CGSize size = [[UIScreen mainScreen]bounds].size;
        
        if (size.height==480) {
            PrivacyPolicy *termsOfUse = [[PrivacyPolicy alloc]initWithNibName:@"PrivacyPolicy3.5" bundle:nil];
            [self.navigationController pushViewController:termsOfUse animated:YES];
            
            
        }else{
            
            
            PrivacyPolicy *termsOfUse = [[PrivacyPolicy alloc]initWithNibName:@"PrivacyPolicy" bundle:nil];
            [self.navigationController pushViewController:termsOfUse animated:YES];
            
        }
        
    }else if ([obj.globalcompleteCategory count]+3 == indexValue) {
        
        NSLog(@"About us!!!!");

        
        CGSize size = [[UIScreen mainScreen]bounds].size;
        
        if (size.height==480) {
            
            About *abt = [[About alloc]initWithNibName:@"About3.5" bundle:nil];
            [self.navigationController pushViewController:abt animated:YES];
            
        }else{
            
            About *abt = [[About alloc]initWithNibName:@"About" bundle:nil];
            [self.navigationController pushViewController:abt animated:YES];
            
            
        }

        
    }else if ([obj.globalcompleteCategory count]+4 == indexValue){
         NSLog(@"my submission");
        
         CGSize size = [[UIScreen mainScreen]bounds].size;
        
        if (size.height==480) {
            
            
            Submission *submission=[[Submission alloc]initWithNibName:@"Submission3.5" bundle:nil];
            
            [self.navigationController pushViewController:submission animated:YES];
            
        }
        else{
            
            
            Submission *submission=[[Submission alloc]initWithNibName:@"Submission" bundle:nil];
            
            [self.navigationController pushViewController:submission animated:YES];
            
            
        }

       
        
       
        
       
        
    }else if ( [obj.globalcompleteCategory count]+5 == indexValue) {
        NSLog(@"save for later");
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
    
     NSLog(@"CCKFNavDrawerSelection =================== %li", (long)selectionIndex);
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
            [self.navigationController pushViewController:staticObj animated:YES];
            
            
            
        }else if ([objectDataClass.globalFeedType isEqualToString:@"Live Streaming"]) {
            //For opening link in external browser.
            
            UIApplication *mySafari = [UIApplication sharedApplication];
            NSURL *myURL = [[NSURL alloc]initWithString:objectDataClass.globalstaticLink];
            
                            [mySafari openURL:myURL];
            if (![mySafari openURL:myURL])
            {
            
                //  opening didn&#039;t work
            
            }
            
        }
        else{
            
            DataClass *obj = [DataClass getInstance];
            
            if([Utility connected] == YES)
            {
                
                
                [self.view setUserInteractionEnabled:NO];
                spinner=[SpinnerView loadSpinnerIntoView:self.view];
                
                if ([[NSUserDefaults standardUserDefaults] valueForKey:@"subscribeStatus"] == nil)
                {
                // serive for global counter.....
                [sync serviceCall:@"https://syncaccess-demo-posh.stage.syncronex.com/demo/posh/api/svcs/meter/standard?format=JSON" withParams:obj.jsonDict];
                }
                
                NSString* urlString;
                if (objectDataClass.globalFeedID)
                {
                    urlString = [NSString stringWithFormat:@"http://prngapi.cloudapp.net/api/RssFeed/GetRssFeed?feedid=%@&source=%@",objectDataClass.globalFeedID,@"SkagitTimes"];
                    NSLog(@"url with feed id %@",urlString);
                    
                }
                else
                {
                    
                    urlString = [NSString stringWithFormat:@"http://prngapi.cloudapp.net/api/RssFeed/GetRssFeed?feedid=%@&source=%@",firstFeedItemId,@"SkagitTimes"];
                    
                    
                    NSLog(@"url string home--%@",urlString);
                    
                }
                
                AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
                    
                    NSLog(@"JSON: %@", responseObject);
                    NSDictionary *json = [Utility cleanJsonToObject:responseObject];
                    [self.view setUserInteractionEnabled:YES];
                    [spinner removeSpinner];
                    if (json)
                    {
                        
                            NSLog(@"storing it first time");
                        
                        if ([[json valueForKey:@"items"] isKindOfClass:[NSArray class]] && [[json valueForKey:@"items"] count]>0)
                        {
                            
                            
                            feeds= [json valueForKey:@"items"];
                            [tableView reloadData];
                                
                            
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
                    [spinner removeSpinner];
                    
                }];
                

            }
            else
            {
                
                
                UIAlertController * errorAlert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Internet connection is not available. Please try again." preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction * errorAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * alert){
                }];
                
                [errorAlert addAction:errorAction];
                [self presentViewController:errorAlert animated:YES completion:nil];
                
                
            }
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
        
        return 200.0;
    }
    
    return 110.0;
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
    UIView * firstIndexView;
    UIView *secondView;
    UILabel *newsTitleNew;
  
    cell.backgroundColor = [UIColor clearColor];
    cell.backgroundView = [UIView new] ;
    cell.selectedBackgroundView = [UIView new];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSMutableArray *testArray =[[NSMutableArray alloc] init];
    NSArray *mediaArray =[[feeds objectAtIndex:indexPath.row] objectForKey:@"Mediaitems"] ;
    NSString * testing;
    if ([mediaArray  count]>0) {
        
        NSString* imageURltemp = [mediaArray[0] valueForKey:@"url"];
        testing = imageURltemp;
        
    }

    if (0 == indexPath.row) {
        
        firstIndexView = [[UIView alloc] initWithFrame:CGRectMake(2.0, 6.0, 301.0, 190.0)];
        [firstIndexView setBackgroundColor:[UIColor whiteColor]];
        
        UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:firstIndexView.bounds];
        firstIndexView.layer.masksToBounds = NO;
        firstIndexView.layer.shadowColor = [UIColor whiteColor].CGColor;
        firstIndexView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
        firstIndexView.layer.shadowOpacity = 0.5f;
        firstIndexView.layer.shadowRadius = 2.0;
        firstIndexView.layer.shadowPath = shadowPath.CGPath;
        firstIndexlabel.layer.cornerRadius =3.0f;

        firstIndexlabel  = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 145.0, 280.0, 40.0)];//14.0, 128.0, 280.0, 40.0
        firstIndexlabel.numberOfLines = 3;
        firstIndexlabel.textColor = [UIColor whiteColor];
        firstIndexlabel.lineBreakMode = NSLineBreakByWordWrapping;

        [firstIndexlabel setFont:[UIFont fontWithName:@"Helvetica Neue" size:20.0]];
        firstIndexlabel.text =[[feeds objectAtIndex:indexPath.row] objectForKey:@"Title"];

        
        newsPostTime_lbl = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 125.0, 260.0, 30.0)];//14.0, 108.0, 260.0, 30.0)
        newsPostTime_lbl.numberOfLines= 2;
        newsPostTime_lbl.adjustsFontSizeToFitWidth = YES;
        newsPostTime_lbl.textColor = [UIColor whiteColor];
        newsPostTime_lbl.lineBreakMode =NSLineBreakByWordWrapping;
        [newsPostTime_lbl setFont:[UIFont fontWithName:@"Helvetica Neue" size:15.0]];
        newsPostTime_lbl.text =[[feeds objectAtIndex:indexPath.row] objectForKey:@"pubDate"];
        
        UIImageView * gradientImage = [[UIImageView alloc] init];
        gradientImage.frame = firstIndexView.bounds;
        [gradientImage setImage:[UIImage imageNamed:@"Gradient-02@2x.png"]];
        gradientImage.contentMode = UIViewContentModeScaleToFill;


        [cell addSubview:firstIndexView];
        [firstIndexView addSubview:gradientImage];
        [firstIndexView addSubview:firstIndexlabel];
        [firstIndexView addSubview:newsPostTime_lbl];
       
    }
    else
    {
        //ads
        secondView = [[UIView alloc] initWithFrame:CGRectMake(2.0, 6.0, 301.0, 100.0)];
        [secondView setBackgroundColor:[UIColor whiteColor]];
        UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:secondView.bounds];
        secondView.layer.masksToBounds = NO;
        secondView.layer.shadowColor = [UIColor whiteColor].CGColor;
        secondView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
        secondView.layer.shadowOpacity = 0.5f;
        secondView.layer.shadowRadius = 2.0;
        secondView.layer.shadowPath = shadowPath.CGPath;
        secondView.layer.cornerRadius= 3.0;
        [cell addSubview:secondView];
        
     
        if (testing) {
            
            
        }
        else
        {
        //for label with images..

        newsTitleNew = [[UILabel alloc] initWithFrame:CGRectMake(119.0, 37.0, 170.0, 54.0)];
        newsTitleNew.numberOfLines = 2;
        newsTitleNew.adjustsFontSizeToFitWidth = YES;
        newsTitleNew.lineBreakMode = NSLineBreakByWordWrapping;
        [newsTitleNew setFont: [UIFont fontWithName:@"Roboto-Regular" size:14.0]];
        newsTitleNew .text  =  [[feeds objectAtIndex:indexPath.row] objectForKey:@"Title"];
        [secondView addSubview:newsTitleNew];
        
            
        UILabel * newsPostTimeNew = [[UILabel alloc] initWithFrame:CGRectMake(119.0, 10.0, 180.0, 30.0)];//119,13,187,25
        [newsPostTimeNew setTextColor:[UIColor whiteColor]];
        newsPostTimeNew.numberOfLines =1;
        newsPostTimeNew.adjustsFontSizeToFitWidth = YES;
        newsPostTimeNew.lineBreakMode = NSLineBreakByWordWrapping;
        [newsPostTimeNew setFont: [UIFont fontWithName:@"Roboto-Regular" size:12.0]];
        newsPostTimeNew.text = [[feeds objectAtIndex:indexPath.row] objectForKey:@"pubDate"];
        [secondView addSubview:newsPostTimeNew];

            
        }
    }
    
    NSLog(@"testing array for media url --%@",testing);
    //for index 0..
    if (testing) {
        
    if (0 == indexPath.row )
    {

        [testArray addObject:testing];
        NSLog(@"testarray for image -%@",testArray);
        NSString * imgURl = [NSString stringWithFormat:@"%@",testing];

        UIImageView * firstImageView =[[UIImageView alloc] initWithFrame:CGRectMake(2.0, 6.0, 301.0, 190.0)]; //2,6,301,170
        firstImageView.contentMode = UIViewContentModeScaleAspectFill;
        firstImageView.layer.masksToBounds = YES;
        firstImageView.clipsToBounds= YES;

        if ([objectDataClass.globalFeedType isEqualToString:@"Video Gallery"]) {
            
            [firstImageView setImage:[UIImage imageNamed:@"VideoPlaceHolder@2x.png"]];
            
        }else{
            
            [firstImageView sd_setImageWithURL:[NSURL URLWithString:imgURl] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        }
        

        UIImageView * gradientImage = [[UIImageView alloc] init];
        gradientImage.frame = firstImageView.bounds;
        [gradientImage setImage:[UIImage imageNamed:@"Gradient-02@2x.png"]];
        gradientImage.contentMode = UIViewContentModeScaleToFill;


        [cell addSubview:firstImageView];
        [firstImageView addSubview:gradientImage];
        [firstImageView addSubview:newsPostTime_lbl];
        [firstImageView addSubview:firstIndexlabel];
        
             
        }//for 1 and further index....
        [testArray addObject:testing];
       // testArray = [testing copy];
        NSLog(@"test array in 2 --%@",testArray);
        
        if ([objectDataClass.globalFeedType isEqualToString:@"Photo Gallery"]) {
            
            //Increasing the width of imageview. for photo
            
            UIImageView * secondImageView = [[UIImageView alloc] initWithFrame:CGRectMake(2.0, 3.0, 295.0, 95.0)]; // 2,7,95,85
            secondImageView.contentMode = UIViewContentModeScaleAspectFill;
            secondView.layer.masksToBounds = YES;
            secondView.clipsToBounds = YES;
            
            UIImageView * gradientImage = [[UIImageView alloc] init];
            gradientImage.frame = secondView.bounds;
            [gradientImage setImage:[UIImage imageNamed:@"Gradient-02@2x.png"]];
            gradientImage.contentMode = UIViewContentModeScaleToFill;

            NSString * imgURl = [NSString stringWithFormat:@"%@",testing];
            
            if ([imgURl length]>0) {
            
                [secondImageView sd_setImageWithURL:[NSURL URLWithString:imgURl] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];

            }else{
                
               // [secondImageView sd_setImageWithURL:[NSURL URLWithString:imgURl] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];

                [secondImageView setImage:[UIImage imageNamed:@"PlaceHolder@2x.png"]];
            }
            

            [secondImageView addSubview:gradientImage];

            
            //UILabel for title
            UILabel * labelImage = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 40.0, 241.0, 48.0)];
            labelImage.numberOfLines =2;
            labelImage.adjustsFontSizeToFitWidth= YES;
            labelImage.lineBreakMode = NSLineBreakByWordWrapping;
            [labelImage setFont: [UIFont fontWithName:@"Helvetica Neue Light" size:15.0]];
            labelImage.textColor = [UIColor whiteColor];
            labelImage.text = [[feeds objectAtIndex:indexPath.row] objectForKey:@"Title"];
            [secondImageView addSubview:labelImage];

            //uilabel for time
            UILabel * newsPostTimeNew = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 10.0, 180.0, 30.0)];//119,13,187,25
            [newsPostTimeNew setTextColor:[UIColor whiteColor]];
            newsPostTimeNew.numberOfLines =1;
            newsPostTimeNew.adjustsFontSizeToFitWidth = YES;
            newsPostTimeNew.lineBreakMode = NSLineBreakByWordWrapping;
            [newsPostTimeNew setFont:[UIFont fontWithName:@"Helvetica Neue Light" size:12.0]];
            newsPostTimeNew.text = [[feeds objectAtIndex:indexPath.row] objectForKey:@"pubDate"];
            [secondImageView addSubview:newsPostTimeNew];

            [secondView addSubview:secondImageView];

            
            
        }
        
        else if ([objectDataClass.globalFeedType isEqualToString:@"Video Gallery"]){
            
            UIImageView * secondImageView = [[UIImageView alloc] initWithFrame:CGRectMake(2.0, 3.0, 295.0, 95.0)]; // 2,7,95,85
            
            NSString * imgURl = [NSString stringWithFormat:@"%@",testing];
           // NSURL *imageUrlForThumb=[NSURL URLWithString:imgURl];
            
            
            
                
                secondImageView.contentMode = UIViewContentModeScaleAspectFill;
                secondView.layer.masksToBounds = YES;
                secondView.clipsToBounds = YES;
                
                UIImageView * gradientImage = [[UIImageView alloc] init];
                gradientImage.frame = secondView.bounds;
                [gradientImage setImage:[UIImage imageNamed:@"Gradient-02@2x.png"]];
                gradientImage.contentMode = UIViewContentModeScaleToFill;
               // NSURL *thumbnailURL = [NSURL URLWithString:imgURl];
            [secondImageView setImage: [UIImage imageNamed:@"VideoPlaceHolder@2x.png"]];

                // Do something...

                   // if ([imgURl length]>0) {
//                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
//                            
//                            
//                            AVAsset *asset = [AVAsset assetWithURL:thumbnailURL];
//                            AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc]initWithAsset:asset];
//                            
//                            int frameTimeStart = 30;
//                            int frameLocation = 10;
//                            
//                            //Snatch a frame
//                            CGImageRef imageRef = [imageGenerator copyCGImageAtTime:CMTimeMake(frameTimeStart,frameLocation) actualTime:nil error:nil];
//                            UIImage *thumbnail = [UIImage imageWithCGImage:imageRef];
//                            CGImageRelease(imageRef); // CGImageRef won’t be released by ARC
//                            
//                            
//                            if(thumbnail){
//                                // do UI stuff back in UI land
//                                dispatch_async(dispatch_get_main_queue(), ^{
//                                    
//                                    secondImageView.image = thumbnail;
//                                    
//                                });
//                                
//                                
//                                
//                            }
//                        });
//                    }else{
//                        
//                        [secondImageView setImage:[UIImage imageNamed:@"PlaceHolder.png"]];
//                    }

            
            [secondImageView addSubview:gradientImage];

            
            //UILabel for title
            UILabel * labelImage = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 40.0, 241.0, 48.0)];
            labelImage.numberOfLines =2;
            labelImage.adjustsFontSizeToFitWidth= YES;
            labelImage.lineBreakMode = NSLineBreakByWordWrapping;
            [labelImage setFont: [UIFont fontWithName:@"Helvetica Neue Light" size:15.0]];
            labelImage.textColor = [UIColor whiteColor];
            labelImage.text = [[feeds objectAtIndex:indexPath.row] objectForKey:@"Title"];
            [secondImageView addSubview:labelImage];
            
            //uilabel for time
            UILabel * newsPostTimeNew = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 10.0, 180.0, 30.0)];//119,13,187,25
            [newsPostTimeNew setTextColor:[UIColor whiteColor]];
            newsPostTimeNew.numberOfLines =1;
            newsPostTimeNew.adjustsFontSizeToFitWidth = YES;
            newsPostTimeNew.lineBreakMode = NSLineBreakByWordWrapping;
            [newsPostTimeNew setFont:[UIFont fontWithName:@"Helvetica Neue Light" size:12.0]];
            newsPostTimeNew.text = [[feeds objectAtIndex:indexPath.row] objectForKey:@"pubDate"];
            [secondImageView addSubview:newsPostTimeNew];
            
            [secondView addSubview:secondImageView];

            
        }
        else
        {
        // if this is not photo then it will be mp4 ...
            
            
            //Showing normal view.
        UIImageView * secondImageView = [[UIImageView alloc] initWithFrame:CGRectMake(2.0, 7.0, 95.0, 85.0)]; // 2,7,85,85
        secondImageView.contentMode = UIViewContentModeScaleAspectFit;
            
            
            if ([testing length]>0) {
                
                [secondImageView sd_setImageWithURL:[NSURL URLWithString:testing] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
                
            }else{
                
                // [secondImageView sd_setImageWithURL:[NSURL URLWithString:imgURl] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
                
                [secondImageView setImage:[UIImage imageNamed:@"PlaceHolder.png"]];
            }
//        [secondImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",testing] ]];
        
            [secondView addSubview:secondImageView];
  
            UILabel * newsPostTimeNew = [[UILabel alloc] initWithFrame:CGRectMake(100.0, 10.0, 100.0, 30.0)];//119,13,187,25
            [newsPostTimeNew setTextColor:[UIColor darkGrayColor]];
            
            newsPostTimeNew.numberOfLines =1;
            newsPostTimeNew.adjustsFontSizeToFitWidth = YES;
            newsPostTimeNew.lineBreakMode = NSLineBreakByWordWrapping;
            [newsPostTimeNew setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
            newsPostTimeNew.text = [[feeds objectAtIndex:indexPath.row] objectForKey:@"pubDate"];
            [secondView addSubview:newsPostTimeNew];
            
            
            
            UILabel * labelAfterNoImage2 = [[UILabel alloc] initWithFrame:CGRectMake(100.0, 40.0, 150.0, 48.0)];
            labelAfterNoImage2.numberOfLines =2;
            labelAfterNoImage2.adjustsFontSizeToFitWidth= YES;
            labelAfterNoImage2.lineBreakMode = NSLineBreakByWordWrapping;
            [labelAfterNoImage2 setFont: [UIFont fontWithName:@"Roboto-Regular" size:16.0]];
            labelAfterNoImage2.textColor = [UIColor blackColor];
            labelAfterNoImage2.text = [[feeds objectAtIndex:indexPath.row] objectForKey:@"Title"];
            [secondView addSubview:labelAfterNoImage2];
        
        }
     
    }else{
        
        [newsTitleNew setHidden:YES];
 
        if (indexPath.row==0) {
            
            UIImageView * firstImageView =[[UIImageView alloc] initWithFrame:CGRectMake(2.0, 6.0, 301.0, 190.0)]; //2,6,301,170
            firstImageView.contentMode = UIViewContentModeScaleAspectFill;
            firstImageView.layer.masksToBounds = YES;
            firstImageView.clipsToBounds= YES;
            
            
            [firstImageView setImage:[UIImage imageNamed:@"PlaceHolder@2x.png"]];
            
            
            UIImageView * gradientImage = [[UIImageView alloc] init];
            gradientImage.frame = firstImageView.bounds;
            [gradientImage setImage:[UIImage imageNamed:@"Gradient-02@2x.png"]];
            gradientImage.contentMode = UIViewContentModeScaleToFill;
            
            
            [cell addSubview:firstImageView];
            [firstImageView addSubview:gradientImage];
            
            
            // no image in celll , then add title to label .
            
            UILabel * newsPostTimeNew = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 100.0, 180.0, 30.0)];//119,13,187,25
            [newsPostTimeNew setTextColor:[UIColor lightGrayColor]];
            
            newsPostTimeNew.numberOfLines =1;
            newsPostTimeNew.adjustsFontSizeToFitWidth = YES;
            newsPostTimeNew.lineBreakMode = NSLineBreakByWordWrapping;
            [newsPostTimeNew setFont: [UIFont fontWithName:@"Roboto-Regular" size:14.0]];
            newsPostTimeNew.text = [[feeds objectAtIndex:indexPath.row] objectForKey:@"pubDate"];
            [firstImageView addSubview:newsPostTimeNew];
            
            
            
            UILabel * labelAfterNoImage2 = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 130.0, 241.0, 48.0)];
            labelAfterNoImage2.numberOfLines =2;
            labelAfterNoImage2.adjustsFontSizeToFitWidth= YES;
            labelAfterNoImage2.lineBreakMode = NSLineBreakByWordWrapping;
            [labelAfterNoImage2 setFont: [UIFont fontWithName:@"Roboto-Regular" size:16.0]];
            labelAfterNoImage2.textColor = [UIColor whiteColor];
            labelAfterNoImage2.text = [[feeds objectAtIndex:indexPath.row] objectForKey:@"Title"];
            [firstImageView addSubview:labelAfterNoImage2];

            
            
        }else{
            
            UIImageView * secondImageView = [[UIImageView alloc] initWithFrame:CGRectMake(2.0, 3.0, 295.0, 95.0)]; // 2,7,95,85
            secondImageView.contentMode = UIViewContentModeScaleAspectFill;
            secondView.layer.masksToBounds = YES;
            secondView.clipsToBounds = YES;
            [secondImageView setImage:[UIImage imageNamed:@"PlaceHolder@2x.png"]];
            
            UIImageView * gradientImage = [[UIImageView alloc] init];
            gradientImage.frame = secondView.bounds;
            [gradientImage setImage:[UIImage imageNamed:@"Gradient-02@2x.png"]];
            gradientImage.contentMode = UIViewContentModeScaleToFill;
            
            [secondImageView addSubview:gradientImage];
            
            [secondView addSubview:secondImageView];

            
            // no image in celll , then add title to label .
            
            UILabel * newsPostTimeNew = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 100.0, 180.0, 30.0)];//119,13,187,25
            [newsPostTimeNew setTextColor:[UIColor lightGrayColor]];
            
            newsPostTimeNew.numberOfLines =1;
            newsPostTimeNew.adjustsFontSizeToFitWidth = YES;
            newsPostTimeNew.lineBreakMode = NSLineBreakByWordWrapping;
            [newsPostTimeNew setFont: [UIFont fontWithName:@"Roboto-Regular" size:14.0]];
            newsPostTimeNew.text = [[feeds objectAtIndex:indexPath.row] objectForKey:@"pubDate"];
            [secondImageView addSubview:newsPostTimeNew];
            
            
            
            UILabel * labelAfterNoImage2 = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 130.0, 241.0, 48.0)];
            labelAfterNoImage2.numberOfLines =2;
            labelAfterNoImage2.adjustsFontSizeToFitWidth= YES;
            labelAfterNoImage2.lineBreakMode = NSLineBreakByWordWrapping;
            [labelAfterNoImage2 setFont: [UIFont fontWithName:@"Roboto-Regular" size:16.0]];
            labelAfterNoImage2.textColor = [UIColor whiteColor];
            labelAfterNoImage2.text = [[feeds objectAtIndex:indexPath.row] objectForKey:@"Title"];
            [secondImageView addSubview:labelAfterNoImage2];
            
        }
    }
        
    NSLog(@"image url -- %@",testing);

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
    
    
    
    

    
    
    
    
    
//    CGImageRelease(imageRef); // CGImageRef won’t be released by ARC
//    
//    
//    NSLog(@"------------------------------------URL-%@---------------------------------",urlVideo);
//    
//    
//    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:urlVideo options:nil];
//    AVAssetImageGenerator *generate = [[AVAssetImageGenerator alloc] initWithAsset:asset];
//    generate.appliesPreferredTrackTransform=TRUE;
//    NSError *err = NULL;
//    CMTime time = CMTimeMake(30, 10);
//    CGImageRef imgRef = [generate copyCGImageAtTime:time actualTime:NULL error:&err];
//    NSLog(@"err==%@, imageRef==%@", err, imgRef);
//    return [[UIImage alloc] initWithCGImage:imgRef];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    DataClass *obj = [DataClass getInstance];
    
    if (obj.globalCounter != 0) {
        obj.globalCounter = obj.globalCounter - 1;
    }
    
    if ([objectDataClass.globalFeedType isEqualToString:@"Photo Gallery"]) { // For Showing TYPE PHOTO..
        NSMutableArray * PhotoUrl = [[NSMutableArray alloc] init];
        
        
        
        PhotoGallery * obj_photo = [[PhotoGallery alloc] initWithNibName:@"PhotoGallery" bundle:nil];
        
        PhotoUrl = [feeds objectAtIndex:indexPath.row]; //[feeds [indexPath.row]objectForKey:@"Mediaitems"];
        
        
        
        obj_photo.gatheredDict = [PhotoUrl copy];
        obj_photo.transferedArray = [PhotoUrl copy];
        NSLog(@"photo url--%@",obj_photo.transferedArray);
        
        
     //   detailsView_Object.getimageURl= imageURlForWebView;
      //  detailsView_Object.getImageURls_Dict = [MediaURl copy];  // test_url[indexPath.row];
        [self.navigationController pushViewController:obj_photo animated:YES];
        
               
        
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
    NSIndexPath *indexPath1 = [self.tableView indexPathForSelectedRow];
    detailsView_Object.allDataArray = [feeds copy];
    
   
    objectDataClass.globalIndex = (int)indexPath1.row;
    
    NSLog(@"selected cell is  --%ld and global index--%ld",(long)indexPath1.row,(long)objectDataClass.globalIndex);
    
    NSString *description_string = [feeds[indexPath.row] objectForKey: @"Description"];

    detailsView_Object.getDescriptionString = description_string;
    
    
    NSDictionary * mediaDict = [feeds [indexPath.row]objectForKey:@"Mediaitems"];
    
    NSString *imageURlForWebView;  //= [feeds[indexPath.row] objectForKey:@"Mediaitems"];//imageUrl;
    
    if(mediaDict.count>0){
        
    imageURlForWebView = [mediaDict valueForKey:@"url"];
    
    }else{
        
    }
    
    
    detailsView_Object.getimageURl= imageURlForWebView;
    NSLog(@"inage url for webview--%@",detailsView_Object.getimageURl);
    
    
    //detailsView_Object.getImageURls_Dict =[[NSDictionary alloc] init];
 //   [detailsView_Object.getImageURls_Dict setObject:test_url forKey:@"ImageURL"];
  
    detailsView_Object.getImageURls_Dict = mediaDict;  // test_url[indexPath.row];
    //detailsView_Object.getImageURls_Array = [MediaURl copy];
    
    NSLog(@"all urls --%@",detailsView_Object.getImageURls_Dict);
    
    
    
    NSString * storeNewsTitle= [feeds[indexPath.row] objectForKey:@"Title"];
   
    
    
    detailsView_Object.getNewsTitle =storeNewsTitle;
    
    
    
    
    
   // NSLog(@"description while navigating is --%@",detailsView_Object.getDescriptionString);
    
    [self.navigationController pushViewController:detailsView_Object animated:YES];
    
    
    }
    
        
}



#pragma mark --Show temperature..

- (IBAction)btn_temperature_Tapped:(id)sender {
 

}

#pragma mark-- Loading the API for category

-(void)loadCategoryAPI {
    
    
    if ([Utility connected] == YES) {
        
        [self.view setUserInteractionEnabled:NO];
        spinner=[SpinnerView loadSpinnerIntoView:self.view];
       // spinner.ce
        
       
        
        NSString* urlString = [NSString stringWithFormat:@"http://prngapi.cloudapp.net/api/menu/GetMenuCategories?source=%@",@"SkagitTimes"];
    NSLog(@"url string service otp--%@",urlString);
    
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
        {
            NSLog(@"JSON: %@", responseObject);
            
            
            NSArray *json = [Utility cleanJsonToObject:responseObject];
            
            
            
            [self.view setUserInteractionEnabled:YES];
            [spinner removeSpinner];

            if (json.count>0)
            {
               


                NSMutableDictionary *jsonDict= [[NSMutableDictionary alloc] init];
                
                
                if ([[[json objectAtIndex:0]valueForKey:@"FeedsItem"] isKindOfClass:[NSArray class]]) {
                    
                    objectDataClass.globalFeedType=[[[json objectAtIndex:0]valueForKey:@"FeedsItem"][0]valueForKey:@"Type"];
                    
                    firstFeedItemId  = [[[[json objectAtIndex:0] valueForKey:@"FeedsItem"] objectAtIndex:0] valueForKey:@"Id_Feed"];
                    
                    objectDataClass.globalcompleteCategory = [json mutableCopy];
                    
                    [jsonDict setObject:@"YTliMzYyYTktMWMyZC00NTc0LWE4NWMtN2JkMTA2YjAyMGQ3" forKey:@"sessionId"];
                    [jsonDict setObject:[objectDataClass.globalcompleteCategory objectAtIndex:0][@"Menu"][@"MainCategory"] forKey:@"contentId"];
                    [jsonDict setObject:@"" forKey:@"referrer"];
                    [jsonDict setObject:@"IOS" forKey:@"clientInfo"];
                }
                
                // NSLog(@"complete json --%@",objectDataClass.globalcompleteCategory);
                // PAYMETER API
                
                NSLog(@"%@",jsonDict);
                DataClass *obj = [DataClass getInstance];
                obj.jsonDict = jsonDict;
                NSLog(@"%@",obj.jsonDict);
                if ([[NSUserDefaults standardUserDefaults] valueForKey:@"subscribeStatus"] == nil) {

                [sync serviceCall:@"https://syncaccess-demo-posh.stage.syncronex.com/demo/posh/api/svcs/meter/standard?format=JSON" withParams:obj.jsonDict];
                    
                }else{
                    
                    // no....
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
            NSLog(@"Error: %@", error);
            
            [self.view setUserInteractionEnabled:YES];
            [spinner removeSpinner];

            UIAlertController * errorAlert = [UIAlertController alertControllerWithTitle:@"Alert" message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * errorAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * alert){
            }];
            
            [errorAlert addAction:errorAction];
            [self presentViewController:errorAlert animated:YES completion:nil];
            

            
        }];

        

        

    } else {
    
    UIAlertController * errorAlert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Internet connection is not available. Please try again." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * errorAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * alert){
    }];
    
    [errorAlert addAction:errorAction];
    [self presentViewController:errorAlert animated:YES completion:nil];
    
    
}

}


#pragma mark -- loading the Home Json

-(void)loadHomeFeed {
    
    
    homeFeedServiceCallComplete = YES;
    
    if ([Utility connected] == YES) {
        
        NSString* urlString;
        if (objectDataClass.globalFeedID)
        {
            urlString = [NSString stringWithFormat:@"http://prngapi.cloudapp.net/api/RssFeed/GetRssFeed?feedid=%@&source=%@",objectDataClass.globalFeedID,@"SkagitTimes"];
            NSLog(@"url with feed id %@",urlString);
            
        }
        else
        {
            
            urlString = [NSString stringWithFormat:@"http://prngapi.cloudapp.net/api/RssFeed/GetRssFeed?feedid=%@&source=%@",firstFeedItemId,@"SkagitTimes"];
            
            
            NSLog(@"url string home--%@",urlString);
            
        }

        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
           
            NSLog(@"JSON: %@", responseObject);
            NSDictionary *json = [Utility cleanJsonToObject:responseObject];
            
            if (json)
            {
                [self handleServiceCallCompletion];
                
                
                    NSLog(@"storing it first time");
                
                
                if ([[json valueForKey:@"items"] isKindOfClass:[NSArray class]]) {
                    
                    
                    feeds= [json valueForKey:@"items"] ;
                    
                    [tableView reloadData];

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
            else
            {
                UIAlertController * errorAlert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"No data received from the server" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction * errorAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * alert){
                    
                    
                }];
                
                [errorAlert addAction:errorAction];
                [self presentViewController:errorAlert animated:YES completion:nil];

            }
            
            
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            [self handleServiceCallCompletion];
           

        }];
        
     
    } else {
        
        
        UIAlertController * errorAlert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Internet connection is not available. Please try again." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * errorAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * alert){
        }];
        
        [errorAlert addAction:errorAction];
        [self presentViewController:errorAlert animated:YES completion:nil];
        
        
    }
    
    

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
        
        //  [picker dismissViewControllerAnimated:YES completion:NULL];
        
      //  handleView = YES ;
        
        if ([[info objectForKey:@"UIImagePickerControllerMediaType"] rangeOfString:@"movie"].location!=NSNotFound)
        {
            MPMoviePlayerController *theMovie = [[MPMoviePlayerController alloc] initWithContentURL:[info objectForKey:@"UIImagePickerControllerMediaURL"]];
            theMovie.view.frame = self.view.bounds;
            theMovie.controlStyle = MPMovieControlStyleNone;
            theMovie.shouldAutoplay=NO;
            imageThumbnail = [theMovie thumbnailImageAtTime:0 timeOption:MPMovieTimeOptionExact];
            
        }
        
        NSString *moviePath = [[info objectForKey:UIImagePickerControllerMediaURL] path];
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum (moviePath)) {
            // UISaveVideoAtPathToSavedPhotosAlbum (moviePath,self, @selector(video:didFinishSavingWithError:contextInfo:),NULL);
        }
        
        NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
        
        videoData = [NSData dataWithContentsOfURL:videoURL];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        NSString *fileName = [NSString stringWithFormat:@"%@",[self randomStringWithLength:8]];
        tempPath = [documentsDirectory stringByAppendingFormat:@"/%@.mp4",fileName];
        
        
        [[NSUserDefaults standardUserDefaults] setObject:videoData forKey:@"VideoData"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        BOOL success = [videoData writeToFile:tempPath atomically:NO];
        NSLog(@"this is the value of sucess---%hhd",success);
        NSLog(@"this is the pathe of temp of the video ====>%@",tempPath);
        
        if (isBrowserTapped)
        {
            
        }
        
        
        CGSize size = [[UIScreen mainScreen]bounds].size;
        
        if (size.height==480) {
            
            UploadVideoView *uploadV = [[UploadVideoView alloc]initWithNibName:@"UploadVideoView3.5" bundle:nil];
            uploadV.receivedPath = tempPath;
            uploadV.ReceivedURl =videoURL;
            uploadV.fileNameforVideo = [self generateUniqueNameVideo];
            [self.navigationController pushViewController:uploadV animated:NO];
            
        }else{
            
            UploadVideoView *uploadV = [[UploadVideoView alloc]initWithNibName:@"UploadVideoView" bundle:nil];
             uploadV.receivedPath = tempPath;
            uploadV.ReceivedURl =videoURL;
             uploadV.fileNameforVideo = [self generateUniqueNameVideo];
            [self.navigationController pushViewController:uploadV animated:NO];
            
        }
        
        
        [picker dismissViewControllerAnimated:YES completion:nil];
        [self.view setNeedsLayout];
        

    }
    else{ // for photo
        
        
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    mainImage = chosenImage;
    data = UIImagePNGRepresentation(mainImage);
    NSLog(@"converted data--%@",data);
    
    //   localUrl = (NSURL *)[info valueForKey:UIImagePickerControllerReferenceURL];
    //    NSLog(@"imagepath==================== %@",localUrl);
    
    if(isCameraClicked)
    {
        UIImageWriteToSavedPhotosAlbum(mainImage,  nil,  nil, nil);
        
        
    }
    
    //NSLog(@"image is ========%@",mainImage);
    
    NSLog(@"info==============%@",info);
    
    //New chamges
    
    UIImage *editedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    //    NSString *docDirPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    
    
    
    NSString *documentsDirectory;
    for (int i=0; i<[pathArray count]; i++) {
        documentsDirectory =[pathArray objectAtIndex:i];
    }
    
    //Gaurav's logic
    
    NSLog(@"%lu",(unsigned long)[[[NSUserDefaults standardUserDefaults]objectForKey:@"MyArray"] count]);
    
    
    
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
    NSLog(@"photo done--%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"Photo_Check"]);
    
    captureduniqueName = [self generateUniqueName];
    
    Nav_valueToPhoto =YES;
    
  //  handleView = YES ;
    CGSize size = [[UIScreen mainScreen]bounds].size;
    
                if (size.height==480) {
    
                    UploadPhoto *uploadP = [[UploadPhoto alloc]initWithNibName:@"UploadPhoto3.5" bundle:nil];
                    uploadP.transferedImageData =data;
                    uploadP.transferPhotoUniqueName = captureduniqueName;
                    uploadP.navigateValue = Nav_valueToPhoto;
                    uploadP.transferFileURl =localUrl;
                    [self.navigationController pushViewController:uploadP animated:NO];
    
                }else{
    
                    UploadPhoto *uploadP = [[UploadPhoto alloc]initWithNibName:@"UploadPhoto" bundle:nil];
                    uploadP.transferedImageData =data;
                    uploadP.transferPhotoUniqueName = captureduniqueName;
                    uploadP.navigateValue = Nav_valueToPhoto;
                    uploadP.transferFileURl =localUrl;
                    [self.navigationController pushViewController:uploadP animated:NO];
                    
                }
    
    
   
    
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
    
    NSLog(@"cancel Tapped!");
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
    NSLog(@"unique name --%@",finalUnique);
    return finalUnique;
    
}
-(void)loadVideoRecorder{
    
    if (IS_OS_8_OR_LATER) {   // code for ios 8 or above !!!!!!!!!
        
        
        
        NSLog(@"capture Video tapped");
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
        
        NSLog(@"capture Video tapped");
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
    
    NSLog(@"%@",responseObject);
    
    
    
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





@end
