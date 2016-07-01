//
//  AppDelegate.m
//  pioneer
//  Created by CYNOTECK on 7/25/14.
//  Copyright (c) 2014 CYNOTECK. All rights reserved.

#import "AppDelegate.h"
#import "Reachability.h"
#import "KeyChainValteck.h"
#import <WindowsAzureMessaging/WindowsAzureMessaging.h>
#import "UIAlertController+Window.h"
#import "UploadView.h"
#import "DBController.h"
#import "PHCachingURLProtocol.h"


@implementation AppDelegate
@synthesize id_CategoryArray,categoryNameArray;
@synthesize recordedData,uniqueNameForLableAudio;
@synthesize responseData;
@synthesize window;
@synthesize putValueToKeyChain;
@synthesize device_Token,randomNumber;
@synthesize genderArr ;
@synthesize myFinalArray;
@synthesize soundFilePathData,Title,Description,indexpath;
@synthesize FinalKeyChainValue,submitDict,textDictionarySubmit,FinalSubmitForReview;



#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

-(NSString *) randomStringWithLength: (int) len
{
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++)
    {
        [randomString appendFormat: @"%C", [lettersString characterAtIndex: arc4random_uniform([lettersString length])]];
    }
    
    return randomString;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    [DBController copyDatabaseIfNeeded]; // TODO: //>     Initialize DBController
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

    [NSURLProtocol registerClass:[PHCachingURLProtocol class]];
    
    sync = [[SyncManager alloc] init];
    sync.delegate = self;

    //[self StartUpdating];

    // randomNumber = [self randomStringWithLength:5];
    myFinalArray = [[NSMutableArray alloc] init];

    myFinalArray=[[[NSUserDefaults standardUserDefaults]objectForKey:@"MyArray"]mutableCopy];

    FinalSubmitForReview = [[NSMutableArray alloc] init];

    FinalSubmitForReview = [[[NSUserDefaults standardUserDefaults] objectForKey:@"SubmitArray"] mutableCopy];

    putValueToKeyChain=@"Times_Of_India_Newspaper12346789Maharashtra619ss1apkTestingqwetyxmf12223";
    AppDelegate *app1 = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSString *  KEY_PASSWORD = @"com.toi.app.password"; //"appleDevelopment"
    NSString *  idfv_Local = [[KeyChainValteck keyChainLoadKey:app1.putValueToKeyChain] valueForKey:KEY_PASSWORD];
    DLog(@"time stamp is ====== %@",idfv_Local);

    // end
    
    lettersString=@"abcdfghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890";
    
    if (idfv_Local ==nil)
    {

        timestamp = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
        timestamp = [timestamp stringByAppendingString:[self  randomStringWithLength:9]];
        timestamp=[timestamp stringByReplacingOccurrencesOfString:@"." withString:@""];
        DLog(@"this is our finlal one value ..........%@",timestamp);

        FinalKeyChainValue= [GlobalStuff getDeviceId]; //timestamp;
        randomNumber=@"";
        
    }
    else
    {
        NSString *  KEY_PASSWORD = @"com.toi.app.password";
        NSString *  idfv_Local = [[KeyChainValteck keyChainLoadKey:putValueToKeyChain] valueForKey:KEY_PASSWORD];
        DLog(@"this is idfv locatl---%@",idfv_Local);
        randomNumber = idfv_Local ;
        
      //  [self showMainScreen];
        
        // end
    }
    
    ///////////////////////////// one time condition !!!!  end !
    
    DLog(@"random no is === %@",randomNumber);
    
    
#pragma mark ####################################################################
#pragma mark ##   Remote notification for both ios 7 & lower and ios 8!!!!!!!!!!!
#pragma mark ####################################################################
    
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        
        // use registerUserNotificationSettings
        
        DLog(@"for ios 8");
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        
        
    }
    else
    {
        // use registerForRemoteNotifications
        
        DLog(@"for ios 7");

        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
        
    }
#else
    // use registerForRemoteNotifications
    
    DLog(@"for ios 7");
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    
#endif
 
#pragma mark ####################################################################
#pragma mark ##     Start     StoryBoard of iPhone 4S , iPad , iPhone 5        ##
#pragma mark ####################################################################
    
    CGSize size = [[UIScreen mainScreen]bounds].size;
    
    UIStoryboard *mainStoryboard = nil;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {  // for iphone ....
        
        if (size.height==568)
        {
            mainStoryboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
        }
        else
        {
            mainStoryboard = [UIStoryboard storyboardWithName:@"Main_iPhone3.5" bundle:nil];
        }
        
        
    } // end for iphone .....

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [mainStoryboard instantiateInitialViewController];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0,320, 20)];
        view.backgroundColor=[UIColor whiteColor];
        view.tag = 109 ;
        [self.window.rootViewController.view addSubview:view];
    }
    
    [self.window makeKeyAndVisible];
  
    return YES;

}

-(void) showMainScreen
{
    AppDelegate *app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    NSString *  KEY_PASSWORD = @"com.toi.app.password"; //"appleDevelopment"
    NSString *  idfv_Local = [[KeyChainValteck keyChainLoadKey:app.putValueToKeyChain] valueForKey:KEY_PASSWORD];
    DLog(@"saved key  is =====%@",idfv_Local);
    
    if ([idfv_Local length]!=0) {
        
        NSString* urlString = [NSString stringWithFormat:@"http://prngapi.cloudapp.net/api/UserDetails?deviceId=&source=&token=%@",[GlobalStuff generateToken]];
        DLog(@"URL===%@",urlString);
        
        PHHTTPSessionManager *manager = [PHHTTPSessionManager manager];
        [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            DLog(@"JSON: %@", responseObject);
            NSDictionary *json = [Utility cleanJsonToObject:responseObject];
            
            if (json)
            {
                
                
                
                if ([[NSString stringWithFormat:@"%@",[[json valueForKey:@"data"]valueForKey:@"RegisteredwithSyncronex"]] isEqualToString:@"0"])
                {
                    
                    DLog(@"keychain is not null");
                    CGSize size = [[UIScreen mainScreen]bounds].size;
                    
                    if (size.height==480)
                    {
                        
                        UploadView *up=[[UploadView alloc]initWithNibName:@"UploadView3.5" bundle:nil];
                        [self.navigationController pushViewController:up animated:NO];
                        
                        
                    }
                    else
                    {
                        
                        UploadView *up=[[UploadView alloc]initWithNibName:@"UploadView" bundle:nil];
                        [self.navigationController pushViewController:up animated:NO];
                        
                    }
                    
                    
                }
                else
                {
                    
                    
                    
                    
                }
                
                NSString *userID_Default = [NSString stringWithFormat:@"%@",[[json valueForKey:@"header"] valueForKey:@"UserId"]];
                [[NSUserDefaults standardUserDefaults]setValue:userID_Default forKeyPath:@"userID_Default"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                
                
                
                
                
            }
            
            
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            DLog(@"Error: %@", error);
            
            
        }];
        
        
    }

}


-(void)hideIt
{
    [[self.window.rootViewController.view viewWithTag:109] setHidden:YES];
}


-(void)showIt
{

    [[self.window.rootViewController.view viewWithTag:109] setHidden:NO];

}


#pragma mark ####################################################################
#pragma mark ##     PUSH NOTIFICATION HANDLING      ## START
#pragma mark ####################################################################

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken{
   
    DLog(@"======%@",deviceToken);

    NSString *strWithoutSpaces  = [NSString stringWithFormat:@"%@",deviceToken];
    strWithoutSpaces = [strWithoutSpaces stringByReplacingOccurrencesOfString:@" " withString:@""];
    strWithoutSpaces = [strWithoutSpaces stringByReplacingOccurrencesOfString:@"<" withString:@""];
    device_Token = [strWithoutSpaces stringByReplacingOccurrencesOfString:@">" withString:@""];
     DLog(@"Push Token is: %@", device_Token);
    
    /*
     NSCharacterSet *angleBrackets = [NSCharacterSet characterSetWithCharactersInString:@"<>"];
     self.device_Token = [[deviceToken description] stringByTrimmingCharactersInSet:angleBrackets];
     */
     
    // Push Token is: 8f19f49d3dd43ef564d781df65dbe90f2934b4d28db968dabe2540ef95d41c34

    //////
    // for getting ....
    NSString *  KEY_PASSWORD = @"com.toi.app.password";
    NSString *  idfv_Local = [[KeyChainValteck keyChainLoadKey:putValueToKeyChain] valueForKey:KEY_PASSWORD];
    DLog(@"idfv is =====%@",idfv_Local);
    // for getting .....

    /*
     // older !!!
     
     SBNotificationHub* hub = [[SBNotificationHub alloc] initWithConnectionString:
     @"Endpoint=sb://toicjnotificationhub-ns.servicebus.windows.net/;SharedAccessKeyName=DefaultFullSharedAccessSignature;SharedAccessKey=P6k4oyfooa2E7KZz+wNJ7/kTM3nPM3H2ZKM9Fneuu+A=" notificationHubPath:@"toicjnotificationhub"];
  
     */
    
   /* SBNotificationHub* hub = [[SBNotificationHub alloc] initWithConnectionString:
                              @"Endpoint=sb://toicjnotificationhubns.servicebus.windows.net/;SharedAccessKeyName=DefaultFullSharedAccessSignature;SharedAccessKey=U3Mmj1sRJwXa5PwEJBwBj26JiiMPihR9niJpJokwpI4=" notificationHubPath:@"toicjnotificationhub"];
     
    */
    
    
    
    //Pioneer App
    
    
    SBNotificationHub* hub = [[SBNotificationHub alloc] initWithConnectionString:
                              @"Endpoint=sb://prrnghub.servicebus.windows.net/;SharedAccessKeyName=DefaultFullSharedAccessSignature;SharedAccessKey=wtcGbwkS4TfgR2lNQWdTVUJn63jDMh9P8r+acoiwgAs=" notificationHubPath:@"prrnghub"];
    
    
    
    
    /*   http://timesgroupcrapi.cloudapp.net        // For Pioneer appp ------- http://prngapi.cloudapp.net
    SBNotificationHub* hub = [[SBNotificationHub alloc] initWithConnectionString:
                              @"Endpoint=sb://toicrnotification-ns.servicebus.windows.net/;SharedAccessKeyName=DefaultFullSharedAccessSignature;SharedAccessKey=L04ekioSLXTMHbpRGG1GT3CbcJbSPsmHSqoDZ4b0v/I=" notificationHubPath:@"toicrnotification"];
    */
    
    
    
    // changed on 19- jan - 2016..
    
   /* SBNotificationHub* hub = [[SBNotificationHub alloc] initWithConnectionString:
                              @"Endpoint=sb://toicrnotification-ns.servicebus.windows.net/;SharedAccessKeyName=DefaultFullSharedAccessSignature;SharedAccessKey=L04ekioSLXTMHbpRGG1GT3CbcJbSPsmHSqoDZ4b0v/I=" notificationHubPath:@"timesgroupcrhub"];
    
    */
    
    
   // Changed on 22 -Jan - 2015.
    
    /*SBNotificationHub* hub = [[SBNotificationHub alloc] initWithConnectionString:
                              @"Endpoint=sb://toicrnotification-ns.servicebus.windows.net/;SharedAccessKeyName=DefaultFullSharedAccessSignature;SharedAccessKey=LKKzl6zmgrNk8sYRnA1wP1syiyVHdLu+edZLcGZ3COE=" notificationHubPath:@"timesgroupcrhub"];
    
    */
    
    //changed on 23-01-2016
    
    /*
    SBNotificationHub* hub = [[SBNotificationHub alloc] initWithConnectionString:
                              @"Endpoint=sb://timesgroupcr-ns.servicebus.windows.net/;SharedAccessKeyName=DefaultFullSharedAccessSignature;SharedAccessKey=4gmNpJrY/N0GkbdjqC3rEvf3IOpu4++pUJXbvmD1Z+U=" notificationHubPath:@"timesgroupcr-hub"];
    
    
    */
    
    
    
    
    //[NSString stringWithFormat:@"%i",randomNumber]
    NSSet *setis = [NSSet setWithObjects:[GlobalStuff getDeviceId], nil];
    [hub registerNativeWithDeviceToken:deviceToken tags:setis completion:^(NSError* error) {
        if (error != nil) {
            DLog(@"Error registering for notifications: %@", error);
        }
    }];

    
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error{
    
	DLog(@"Failed to get token, error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
	application.applicationIconBadgeNumber=application.applicationIconBadgeNumber+1;
    
    // DLog(@"userInfo is =====%@",userInfo);
    
    UIApplicationState state = [application applicationState];
    
    if (state == UIApplicationStateActive){   // for active state .....
        
        //Do stuff that you would do if the application is active

        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        
        //////////////window azure..
        
        /*
         
         o/p of push notification from azure is -{
         aps =     {
         alert = "Your article has been published";
         };
         }

         
         */
        DLog(@"o/p of push notification from azure is -%@", userInfo);
        
        
        NSString *message = [[userInfo valueForKey:@"aps"]valueForKey:@"alert"];
        
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Message" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
        ///window azure....

    } else{    // for background state .....
        
        //Do stuff that you would do if the application was not active
        
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        
        DLog(@"o/p of push notification from azure is -%@", userInfo);
        /*
         
         aps =     {
         alert = "Notification Hub test notification";
         };
         }
         
         
         
         */
        
        
        NSString *message = [[userInfo valueForKey:@"aps"]valueForKey:@"alert"];

        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Message" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];

    }
    
}

#pragma mark ####################################################################
#pragma mark ##     PUSH NOTIFICATION HANDLING      ## END
#pragma mark ####################################################################

- (void)applicationWillResignActive:(UIApplication *)application
{
    [self.window endEditing:YES];

    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
   // [self StartUpdating];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
    DLog(@"MyArray is ===== %@",[[NSUserDefaults standardUserDefaults]objectForKey:@"MyArray"]);
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
   // DLog(@"active final submitteed array--%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"SubmitArray"]);
}


- (void)applicationWillTerminate:(UIApplication *)application
{
    
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//Alert Method

-(void) alertMessage:(NSString *) title message :(NSString *) message
{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        
        // do NOT use alert.textfields or otherwise reference the alert in the block. Will cause retain cycle
    }]];
    [alert show];

}

// start update location
-(void)StartUpdating
{
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    [locationManager startUpdatingLocation];
}

#pragma mark location delegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    DLog(@"didFailWithError: %@", error);
 //   [self alertMessage:@"Alert!"  message: @"There was an error while getting the location"];
    
}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    DLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil)
    {
        
        DLog(@"lat is ====%@",[NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude]);
        DLog(@"long is ====%@",[NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude]);
        locationManager = nil;
        [locationManager stopUpdatingLocation];
        [self getAdrressFromLatLong:currentLocation.coordinate.latitude lon:currentLocation.coordinate.longitude];
        
    }
}


-(void)getAdrressFromLatLong : (CGFloat)lat lon:(CGFloat)lon{
    // coding to send data to server .......start
    
    NSString *urlString = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f&amp;sensor=false",lat,lon];
    
    [sync getServiceCall:urlString withParams:nil];

 }


#pragma mark Web Service Delegate

-(void)syncSuccess:(id)responseObject
{
    
    DLog(@"%@",responseObject);
    
    DLog(@"op address is ===%@",[[[responseObject valueForKey:@"results"] valueForKey:@"formatted_address"]objectAtIndex:0]);
    [[NSUserDefaults standardUserDefaults]setValue:[NSString stringWithFormat:@"%@",[[[responseObject valueForKey:@"results"] valueForKey:@"formatted_address"]objectAtIndex:0]] forKey:@"address_Default"];
    
    _userAddress = [[NSUserDefaults standardUserDefaults]stringForKey:@"address_Default"];
    
}

-(void)syncFailure:(NSError*) error
{
    
  //  [self alertMessage:@"Message" message:[error localizedDescription]];;
    
}


-(void)getCategory{

    __block id json;
   id_CategoryArray=[[NSMutableArray alloc]init];
    categoryNameArray=[[NSMutableArray alloc]init];
    
    // categoryNameArray = [NSMutableArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",nil] ;
    
   // NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    /////////////////////start
    NSMutableDictionary *finalDictionary = [NSMutableDictionary dictionary];
    NSMutableDictionary *headerDict = [NSMutableDictionary dictionary];
    NSMutableDictionary *dictionaryTemp = [NSMutableDictionary dictionary];
    
    
    // for getting ....
    NSString *  KEY_PASSWORD = @"com.toi.app.password";
    NSString *  idfv_Local = [[KeyChainValteck keyChainLoadKey:putValueToKeyChain] valueForKey:KEY_PASSWORD];
    DLog(@"getCategory idfv_Local  is =====%@",idfv_Local);
    // for getting .....
    

    [headerDict setValue:@"" forKey:@"DeviceId"];  // THIS WILL CHANGE & WILL USE "idfv"  idfv_Local
    [headerDict setValue:@"" forKey:@"UserId"];//[[NSUserDefaults standardUserDefaults]stringForKey:@"userID_Default"]
    [headerDict setValue:@"" forKey:@"Source"];  //SkagitTimes
    
    [finalDictionary setObject:headerDict forKey:@"header"];
    [finalDictionary setValue:dictionaryTemp forKey:@"data"];
    
    DLog(@"get Category data is = %@",finalDictionary);
    
    NSError *error = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:finalDictionary
                        
                                                       options:kNilOptions
                                                         error:&error];
    
// http://timesgroupcrapi.cloudapp.net   <---->  http://78dbfe55d0844370aacb49be8d573db3 <---> http://toicj -->toicj.cloudapp.net
    
    
    
    NSString * urlString = [NSString stringWithFormat:@"%@%@",@"http://prngapi.cloudapp.net/api/Category?token=",[GlobalStuff generateToken]];
    
    DLog(@"get category app url --%@",urlString);

    NSURL *url= [NSURL URLWithString:urlString]; //@"http://prngapi.cloudapp.net/api/Category"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:jsonData];
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc]init]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               
                               if (response ==nil || data ==nil) {
                                   
                                   DLog(@"error catched!");

                               }
                               
                               else{
                               NSError *jsonError;
                                json = [NSJSONSerialization JSONObjectWithData:data
                                                                          options:kNilOptions
                                                                            error:&jsonError];
                               
                               DLog(@"o/p of getCategory  is =   %@",json);
                               
                               if (json) {
                                  
                                   if([json valueForKey:@"Message"] != nil) {
                                       // The key existed...
                                       
                                       // amit joshi commented  5 august ...
                                     DLog(@"go back to main !");
// /*
                                      // getting .....
                                      AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
                                      NSString *  KEY_PASSWORD = @"com.toi.app.password";
                                      NSString *    idfv = [[KeyChainValteck keyChainLoadKey:app.putValueToKeyChain] valueForKey:KEY_PASSWORD];
                                      DLog(@"idfv is =====%@",idfv);
                                      // getting ...
                                   
                                   }
                                   else {
                                       // No joy...

                                [ id_CategoryArray addObject: [[[json valueForKey:@"data"]valueForKey:@"Categories"]valueForKey:@"Id_Category"]];
                                [ categoryNameArray addObject: [[[json valueForKey:@"data"]valueForKey:@"Categories"]valueForKey:@"Name"]];
                                     
                                   }

                                   
                                   /*
                                    
                                    json is  {
                                    Message = "DeviceId is invalid";
                                    }
                                    
                                    //////
                                    
                                    json is  {
                                    data =     {
                                    Categories =         (
                                    {
                                    "Id_Category" = 1;
                                    Name = "Road Accident";
                                    },
                                    {
                                    "Id_Category" = 2;
                                    Name = Politics;
                                    },
                                    {
                                    "Id_Category" = 3;
                                    Name = Business;
                                    },
                                    {
                                    "Id_Category" = 4;
                                    Name = Technology;
                                    }
                                    );
                                    };
                                    header =     {
                                    DeviceId = "a@gmail.com";
                                    UserId = 50397;
                                    };
                                    }
                                    */
                                   
                                   // PickerViewForCategory.delegate=self;
                                   //return to main thread
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       DLog(@"inside main thread!");
                                       [self registerPushNotification_Method];
                                   });
                                   
                               }
                               else{
                                   
                                   DLog(@"An error occured: %@", jsonError);
                              
                               }
                             
                               }
                  
                               if([json valueForKey:@"Message"] != nil) {
                               DLog(@"go back to main !");
                                 
                                 // getting .....
                                 AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
                                 NSString *  KEY_PASSWORD = @"com.toi.app.password";
                                 NSString *    idfv = [[KeyChainValteck keyChainLoadKey:app.putValueToKeyChain] valueForKey:KEY_PASSWORD];
                                 DLog(@"idfv is =====%@",idfv);

                               }else{
                                   
                               
                               }

                               
                           }];
    
    
}


-(void)registerPushNotification_Method
{
    // for getting ....

    NSString *  KEY_PASSWORD = @"com.toi.app.password";
    NSString *  idfv_Local = [[KeyChainValteck keyChainLoadKey:putValueToKeyChain] valueForKey:KEY_PASSWORD];
    DLog(@"idfv is =====%@",idfv_Local);
    // for getting .....

    __block id json;
    NSMutableDictionary *finalDictionary = [NSMutableDictionary dictionary];
    
    [finalDictionary setValue:@"ios" forKey:@"platform"];
    [finalDictionary setValue:@"" forKey:@"instId"];
    [finalDictionary setValue:randomNumber forKey:@"channelUri"];
    [finalDictionary setValue:device_Token forKey:@"deviceToken"];
    [finalDictionary setValue:idfv_Local forKey:@"deviceId"];
    [finalDictionary setValue:[[NSUserDefaults standardUserDefaults]stringForKey:@"userID_Default"] forKey:@"userId"];
    
    DLog(@"final dict is amit====%@",finalDictionary);
   // DLog(@"push notification ====%@",finalDictionary);
    NSError *error = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:finalDictionary
                        
                                                       options:kNilOptions
                                                         error:&error];
//timesgroupcrapi   SkagitTimes
    
    NSString * urlString = [NSString stringWithFormat:@"%@%@",@"http://prngapi.cloudapp.net/api/registerdevice?token=",[GlobalStuff generateToken]];
    DLog(@"push url--%@",urlString);
    
    NSURL *url = [NSURL URLWithString:urlString];       //@"http://prngapi.cloudapp.net/api/registerdevice"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:jsonData];

    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc]init]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               
                               if (response ==nil || data ==nil) {
                                   
                                   DLog(@"error catched!");

                               }
                               
                               else{
                                   NSError *jsonError;
                                   
                                   
                                   json = [NSJSONSerialization JSONObjectWithData:data
                                                                          options:kNilOptions
                                                                            error:&jsonError];
                                   
                                   
                    NSString * text = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
                                DLog(@"deep o/p is ==== %@",text);

                                   //o/p is ==== "successfully updated" //
                                   /*
                                    
                                    •	JSON format is used to send notifications.
                                    {“data”:{“message”:”The report has been published”}}.
                                    
                                    */

                                   if (json) {
                                       
                                   }else{
                                       
                                      // DLog(@"error occured!");
                                   }
                                   
                                   
                               }
                               
                               
                           }];
    
}

@end
