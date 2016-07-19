//
//  UploadVideoView.m
//  pioneer
//
//  Created by CYNOTECK on 7/25/14.
//  Copyright (c) 2014 CYNOTECK. All rights reserved.
//

#import "UploadVideoView.h"
#import <QuartzCore/QuartzCore.h>
#import "IQActionSheetPickerView.h"
#import "AppDelegate.h"
#import "Setting_Screen.h"
#import "PICircularProgressView.h"
#import "KeyChainValteck.h"
#import "UploadTextView.h"
#import "UploadAudioView.h"
#import "UploadPhoto.h"
#import "DataClass.h"
#import <CommonCrypto/CommonHMAC.h>
#import "Base64.h"
#import <CommonCrypto/CommonDigest.h>
#include <ifaddrs.h>
#include <arpa/inet.h>
#import "RecordAudioView.h"






#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)


//NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

// NSString *letter = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

@interface UploadVideoView ()<SyncDelegate,CLLocationManagerDelegate>
{
    SyncManager *sync;
    CLLocationManager *locationManager;

    
    
    NSURLSessionUploadTask *task;
    NSURLSessionUploadTask *taskSecond;

    NSMutableData *responseData;
    NSData *videoData;
    UIImage *imageThumbnail;
    NSURLSession *session ;
    NSString *tempPath ;
    UIVisualEffectView *visualEffectView;
    UIView * customAlertView;
    NSString *checkStr;
    DataClass * objectDataClass;
    // used in date .
    NSString* firstDate;
    NSString * secondDate;
    NSDate *now2;
    NSDateFormatter *dateFormatter1;
    NSDate * mow3;
    NSDateFormatter *dateFormatter2;
    NSDateFormatter *df;
    NSString *Finaltoken;
    NSMutableDictionary *VideocollectedDict;
    NSString *finalUnique;
    NSData * transferedVideoData;
    NSString* categoryId_String;
    NSData*data;
    NSString *fileName;
    NSString* localUrl;
    NSString *captureduniqueName;
    NSString *letter;
    BOOL isPhotoTabSelected; // for checking if photo is tabed or not.
    
    NSData* receivedVideoData; // while recieving data..


    BOOL checkUserComingFrom;
    NSMutableArray *LocalDataHandleArray;
    AppDelegate *app;
    CGSize size;

    UITextField * StreetTxt;
    UITextField * cityTxt;
    UITextField * StateTxt;
    UITextField * PincodeTxt;
    
    int locationStatus;
    NSString *myLocationAddress;
    
    
    CGSize sizeOfSubview;

    
    
}

@end
@implementation UploadVideoView
@synthesize videoDataDictionary,mainImage,ReceivedURl,fileNameforVideo;                      //New changes
@synthesize progressView;
@synthesize written_Address;
@synthesize txt_Title,txt_View;
@synthesize segment_Outlet;
@synthesize circular_Progress_View;
@synthesize cut_Sec,lbl_AddStory_Outlet,lbl_finalPicker_Selected,lbl_Select_new_Category,lbl_selected_File_Outlet,lbl_Title,image_AddStory_Outlet,image_Select_NewCategory,image_Title_Outlet,img_View_Selected_File_Outlet,btn_Reset_Outlet,btn_Selected_new_Category_Outlet,btn_Upload_Outlet;
@synthesize alert_Message;
@synthesize location_Txt,CaptureOnLocation_View;
@synthesize current_Location_lbl,current_Location_View;
@synthesize successfull_View,tryagain_View;
@synthesize address_Location;
@synthesize img_ForSuccess_Unsuccess,view_ForSuccess_Unsuccess,ok_For_Success_Outlet,responseDataForRestOfTheDetailService;
@synthesize isItFirstService;
@synthesize with_Address_Optional_Written,videoDataImage;
@synthesize handleView,cutboolValue;
@synthesize tabBarController,audioTabBar,videoTabBar,textTabBar,photoTabBar;
@synthesize startVideoRecording,submitForReview,tempArray,receivedPath;
@synthesize thumbImageForView;






- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


//-(void)checkCategoryData {
//    
//    if ([app.categoryNameArray count]==0 || [app.id_CategoryArray count]==0) {
//        
//        DLog(@"quite empty!!!!");
//        // [app getCategory];
//        
//        DLog(@"coming!");
//    }else{
//        
//        lbl_output_category.userInteractionEnabled=YES ;
//        [timerCheck invalidate];
//        
//    }
//
//    
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    sizeOfSubview=[[UIScreen mainScreen]bounds].size;

    app = (AppDelegate *)[UIApplication sharedApplication].delegate;

    size = [[UIScreen mainScreen]bounds].size;
    letter = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

    sync = [[SyncManager alloc] init];
    sync.delegate = self;
    

   // [self loadVideoRecorder];
    
    objectDataClass = [DataClass getInstance];
    
    img_ForSuccess_Unsuccess.userInteractionEnabled = YES;
    VideocollectedDict = [NSMutableDictionary dictionary];
    
    
    videoDataDictionary=[NSMutableDictionary dictionary];
    
   // [lbl_output_category setUserInteractionEnabled:YES];
//    timerCheck = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(checkCategoryData) userInfo:nil repeats:YES];
    
    segment_Outlet.selectedSegmentIndex=-1;
    segment_Outlet.layer.cornerRadius=2.0;
	//segment_Outlet.tintColor =[UIColor redColor];
    
    tabBarController.delegate = self;
    
    
    videoTabBar.tag = 1;
    photoTabBar.tag = 2;
    audioTabBar.tag = 3;
    textTabBar.tag  = 4;
    
    [self.scrollView_Video setScrollEnabled:YES];
   // [self.scrollView_Video setContentSize:CGSizeMake(320, 780)];
    [self CallMethodForPicker];
    
    
    if (tempArray == NULL) {
        
        NSURL *videoURL = ReceivedURl;
        videoData = [NSData dataWithContentsOfURL:videoURL];
        
    }
    
    else{
        
        //NSLog(@"collected data from review view --%@",tempArray);
        [self.view setNeedsLayout];
        
        txt_Title.text = [[tempArray  objectAtIndex:objectDataClass.globalIndexSelection] valueForKey:@"Title"] ;
        txt_View.text = [[tempArray objectAtIndex:objectDataClass.globalIndexSelection]valueForKey:@"FullStory"];
        //id categoryID = [[tempArray objectAtIndex:objectDataClass.globalIndexSelection] valueForKey:@"Id_Category"] ;
        lbl_finalPicker_Selected.text = [[tempArray objectAtIndex:objectDataClass.globalIndexSelection] valueForKey:@"uniqueName"];
        transferedVideoData = [[tempArray objectAtIndex:objectDataClass.globalIndexSelection] valueForKey:@"videoData"];
        videoData = transferedVideoData;
        tempPath=[[tempArray objectAtIndex:objectDataClass.globalIndexSelection] valueForKey:@"fileURl"];
        NSString * localUrltesting = [[tempArray objectAtIndex:objectDataClass.globalIndexSelection]valueForKey:@"fileURl"];
        lbl_output_category.text=[[tempArray objectAtIndex:objectDataClass.globalIndexSelection] valueForKey:@"categoryName"];
        receivedPath=[[tempArray objectAtIndex:objectDataClass.globalIndexSelection] valueForKey:@"fileURl"];

        NSLog(@"local url--%@",localUrltesting);
        
        
        /// start.....
        
       // [videoDataImage setImage:[self fixOrientationForImage:thumbImageForView]];
        
        // [videoDataImage setImage:thumbImageForView];
        
        
        handleView = YES ;
        
    }
    
}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Video Screen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];


    [tabBarController setSelectedItem:[tabBarController.items objectAtIndex:0]];
    [tabBarController setTintColor:[UIColor blackColor]]; // set tab bar selection color white

   // self.showTemperature.text = [NSString stringWithFormat:@"%0.0f", objectDataClass.temperature];
    
    
    // working .....
    LocalDataHandleArray=[[NSMutableArray alloc]init];
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"SubmitArray"] count]==0) {
        
        ///
        
        
    }else{
        
        LocalDataHandleArray=[[[NSUserDefaults standardUserDefaults]valueForKey:@"SubmitArray"] mutableCopy];


    }
    
    // end.....

    
    
    [self doItResize:@"show"];
    
   
   // videoData = [NSData dataWithContentsOfFile:ReceivedURl];
   // DLog(@"received data from uploadview --%@",receivedPath);
    tempPath = receivedPath;
    [self generateThumbnailFrompath];
    
    NSLog(@"received url --%@",ReceivedURl);
   // DLog(@"converted path --%@", [NSData dataWithContentsOfFile:ReceivedURl]);
    
    segment_Outlet.tintColor =[UIColor colorWithRed:180.0/255.0 green:32.0/255.0 blue:33.0/255.0 alpha:1.0];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(callMe) name:@"myNotification" object:nil];// this is for navigation of the result view to game view

   // NSUInteger localSelection = objectDataClass.globalIndexSelection;

    
   // segment_Outlet.selectedSegmentIndex=-1;
	// Set a tint color
    
    segment_Outlet.layer.cornerRadius=2.0;
	segment_Outlet.tintColor =[UIColor redColor];
    //segment_Outlet.tintColor =[UIColor colorWithRed:180.0/255.0 green:32.0/255.0 blue:33.0/255.0 alpha:1.0];
    
    videoTabBar.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    audioTabBar.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    textTabBar.imageInsets  = UIEdgeInsetsMake(6, 0, -6, 0);
    photoTabBar.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
}

-(void)generateThumbnailFrompath{
    
    // NSString * path = [[reverseArray objectAtIndex:indexPath.row] valueForKey:@"videoPath"];
    DLog(@" video path%@",tempPath);
    
    DLog(@"%@",[NSString stringWithFormat:@"%@/%@",[self applicationDocumentsDirectory],tempPath.lastPathComponent]);
    
    NSString *fullPath = [NSString stringWithFormat:@"%@/%@",[self applicationDocumentsDirectory],tempPath.lastPathComponent];
    
    NSURL *videoURL = [NSURL fileURLWithPath:fullPath];
    ///var/mobile/Containers/Data/Application/C414839A-C936-423C-BB02-91A5ABBB3163/Documents/O8RiF86v.mp
    
    /*
     AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
     AVAssetImageGenerator *generateImg = [[AVAssetImageGenerator alloc] initWithAsset:asset];
     NSError *error = NULL;
     CMTime time = CMTimeMake(1, 65);
     CGImageRef refImg = [generateImg copyCGImageAtTime:time actualTime:NULL error:&error];
     NSLog(@"error==%@, Refimage==%@", error, refImg);
     
     UIImage *FrameImage= [[UIImage alloc] initWithCGImage:refImg];
     [videoDataImage setImage:[self fixOrientationForImage:FrameImage]];
     */
    
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
    [videoDataImage setImage:thumb];
    
    CGImageRelease(image);
    
    
    
    //  [videoDataImage setImage:FrameImage];
}



- (NSString *)applicationDocumentsDirectory {
    
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

-(void)callMe {
    
    [current_Location_View removeFromSuperview];        // for the remove the pop navigation view which comes first
}


-(void)viewDidLayoutSubviews {
    
    [self.scrollView_Video setContentSize:CGSizeMake(size.width, 600)];
    
    NSLog(@"viewDidLayoutSubview");
    
    // 12 August code .
    
    if (!handleView)
    {
        // photo is not taken !!!!!
        
        DLog(@"inside !handleView");
      //  [self doItResize:@"show"];
        
    }else
    {
        // photo has been taken !!!!
        
        if (cutboolValue) // when cut_Selected tapped!!!!!!
        {
            
            DLog(@"inside cutboolValue");
            cutboolValue=NO ;
           // [self doItResize:@"hide"];
            
        }else if (videoData==nil){ // when no image !!!!!!
            
            DLog(@"inside mainImage==nil");
            
            if (isPickerTapped) {
                
                [self doItResize:@"hide"];
            }
            
            
        }else{
            
            DLog(@"inside else below mainImage==nil");
            
            [lbl_selected_File_Outlet setHidden:NO];
            [img_View_Selected_File_Outlet setHidden:NO];
            [lbl_finalPicker_Selected setHidden:NO];
            [cut_Sec setHidden:NO];
            
            
            if ([lbl_finalPicker_Selected.text length]==0) {
                
                lbl_finalPicker_Selected.text=[self  generateUniqueName];
                
            }
            if (isBrowserTapped) {
                
                if ([lbl_selected_File_Outlet.text length]==0) {
                    
                    lbl_selected_File_Outlet.text= @"Captured video";
                }
                
            }else{
                if ([lbl_selected_File_Outlet.text length]==0) {
                    
                    lbl_selected_File_Outlet.text= @"Selected file";
                    
                }
            }
            
            
        }

    }
}

#pragma mark --
#pragma mark -- TabBar delegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    
   /* if(item.tag == 1)
    {
        DLog(@"Video Tab bar tapped");
        [self checkforNavigationInternetconnection:1];

        
    }else*/
    
    if (item.tag ==2) {
        
              DLog(@"Photo tab bar tapped");
      [self checkforNavigationInternetconnection:2];
      
    }else if (item.tag ==3){
      
      DLog(@"Audio Tab bar tapped");
      
      [self checkforNavigationInternetconnection:3];
      
      }else if (item.tag ==4) {
          
          DLog(@"Text Tab bar tapped");
          
          [self checkforNavigationInternetconnection:4];
      }
}


-(NSString *)generateUniqueName{
    
    
   // NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
//NSString *finalUnique= [NSString stringWithFormat:@"Video_%.0f.mp4", time];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyyMMdd_HHmmss"];
    
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    
   // int randomValue = arc4random() % 1000;
  //  NSString *unique = [NSString stringWithFormat:@"%@%d",dateString,randomValue];
    finalUnique = [NSString stringWithFormat:@"Video_%@.mp4",dateString];
    
    return finalUnique;
    
}




-(void)doItResize:(NSString *)hideAndShow{
  
    NSString *hide_Show = hideAndShow;
    if ([hide_Show isEqualToString:@"show"]) {
        
       // videoData = [NSData dataWithContentsOfFile:ReceivedURl];
        lbl_finalPicker_Selected.text=fileNameforVideo;
        [lbl_selected_File_Outlet setHidden:NO];
        [img_View_Selected_File_Outlet setHidden:NO];
        [lbl_finalPicker_Selected setHidden:NO];
        [cut_Sec setHidden:NO];
        
        
    }else{
        
        lbl_finalPicker_Selected.text=nil;
        videoData=nil;
        [lbl_selected_File_Outlet setHidden:YES];
        [img_View_Selected_File_Outlet setHidden:YES];
        [lbl_finalPicker_Selected setHidden:YES];
        [cut_Sec setHidden:YES];
        
    }

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)back_Tapped:(id)sender {
    
    NSArray *array = [self.navigationController viewControllers];
    
    DLog(@"Video content from array is :  %@",array);

    if ([lbl_output_category.text length]>0 || videoData !=nil  || [txt_Title.text length]>0 || [txt_View.text length]>0) {
        
        goBackAlert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Are you sure you want to cancel this news submission?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
        [goBackAlert show];
        
    }else{
        txt_View.text=nil;
        txt_Title.text=nil;
        lbl_finalPicker_Selected.text=nil;
        lbl_output_category.text=@"Choose Category";
        videoData=nil; // testing video data
       // [self.navigationController popViewControllerAnimated:NO];
        [self.navigationController popToViewController:[array objectAtIndex:1] animated:NO];
    }
    
}


- (IBAction)reset_Tapped:(id)sender {
    
    NSArray *array = [self.navigationController viewControllers];
    
    DLog(@" Text content from array is :  %@",array);
    
    
    
        txt_View.text=nil;
    txt_Title.text=nil;
    lbl_finalPicker_Selected.text=nil;
    lbl_output_category.text=nil;
    videoData=nil; //// testing video data
    
    segment_Outlet.selectedSegmentIndex=-1;
    
    if (IS_OS_8_OR_LATER) {
        //cutboolValue = YES;
    }
    else{
        [self doItResize:@"hide"];
    }
    cutboolValue = YES;
    [self.view setNeedsLayout];

        
    
    
    [self.navigationController popToViewController:[array objectAtIndex:1] animated:YES];
    //cutboolValue = YES;
    //  [self doItResize:@"hide"];

}

- (IBAction)upload_Tapped:(id)sender {
    
    [self.view endEditing:YES];
    
    
    
    // NSString *server = [[NSUserDefaults standardUserDefaults]stringForKey:@"connection_Internet"];
    
    if ([Utility connected] == YES) {
        
    
    if ([lbl_finalPicker_Selected.text length]==0 || [lbl_output_category.text length]==0 || [txt_Title.text length]==0 || [txt_View.text  length]==0 || videoData ==nil) {
        
        if ([lbl_finalPicker_Selected.text length]==0 || videoData ==nil) {
            
            alert_Message=@"Please select a file";
        }else if ([lbl_output_category.text length]==0){
            
            alert_Message=@"Please select a category";
        }else if ([txt_Title.text length]==0){
            
            alert_Message=@"Please enter a title";
        }else if ([txt_View.text length]==0){
            
            alert_Message = @"Please enter a story";
        }
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:alert_Message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
    }else{
        
        checkStr =    [[NSUserDefaults standardUserDefaults]stringForKey:@"address_Default"];
        [self blurEffect];
        [self StartUpdating];

        
        
    }
        
    }else{
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Internet connection is not available. Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];

        
    }

    
}
- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
   
    if (alertView==without_Address) {
        
        UITextField *textField = [alertView textFieldAtIndex:0];
        if ([textField.text length] == 0)
        {
            return NO;
        }
        written_Address=[alertView textFieldAtIndex:0].text;

    }else if (alertView==with_Address){
        
        with_Address_Optional_Written=[alertView textFieldAtIndex:0].text;
        
    }

    return YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    if (alertView == with_Address) {
        
        // do nothing for now !!!
        
        
//        if (buttonIndex==0) {
//            
//            DLog(@"cancel tapped!");
//            
//        }else{
        
        with_Address_Optional_Written=[alertView textFieldAtIndex:0].text;

            [self  sendVideo_ToServer];
   //     }
        
      
        
    }else if(alertView ==without_Address){
    
    
    if (buttonIndex == 0)
    {
        //    UITextField *Location = [alertView textFieldAtIndex:0];
        //    DLog(@"username: %@", username.text);
        
        DLog(@"first one ");
        
        DLog(@"Entered: %@",[[alertView textFieldAtIndex:0] text]);
        
        if ([[alertView textFieldAtIndex:0].text length]<=0) {
         
            
            NSArray *array = [self.navigationController viewControllers];
            
            DLog(@" Text content from array is :  %@",array);
            [self.navigationController popToViewController:[array objectAtIndex:1] animated:NO];
            
            
        }
        
    }
    else{
        
        [self  sendVideo_ToServer];
        
        DLog(@"seocnd one ");
        DLog(@"Entered: %@",[[alertView textFieldAtIndex:0] text]);
        
        //  [with_Address dismissWithClickedButtonIndex:2 animated:YES];
        
        
    }

    }else if (alertView == goBackAlert){
        
        NSArray *array = [self.navigationController viewControllers];
        
        DLog(@" Text content from array is :  %@",array);
        
        if (buttonIndex==0) {
            
            //do nothing ..
            //cancel tapped..
            
        }else if (buttonIndex==1){
            
            txt_View.text=nil;
            txt_Title.text=nil;
            lbl_finalPicker_Selected.text=nil;
            lbl_output_category.text=@"Choose Category";
            videoData=nil; // testing video data
           // [self.navigationController popViewControllerAnimated:YES];
            
            [self.navigationController popToViewController:[array objectAtIndex:1] animated:NO];

        }

    }else if (try_AgainInternet_Check==alertView){
        
        
        NSArray *array = [self.navigationController viewControllers];
        [self.navigationController popToViewController:[array objectAtIndex:1] animated:NO];

        
        
        }else if (buttonIndex==1){
            
            if (isItFirstService==1) {
                
                // for first service ....
                // ok tapped Try Again....
                DLog(@"OK_Tapped");
                
                 //responseData = [NSMutableData data];
                //[task resume];
                //
                [session invalidateAndCancel];
                [self  sendVideo_ToServer];

            }else if(isItFirstService ==2){
                // for second service ...
                // ok tapped Try Again....
                DLog(@"OK_Tapped");
                        [self uploadThumbnail:responseDataForRestOfTheDetailService];

            }else{
                
                [self  sendRestOfTheVideoDATA:responseDataForRestOfTheDetailService];
            }

        }
        
    }

-(void)sendVideo_ToServer{
    
 // for gradient...........
    
    
    layer = [CAGradientLayer layer];
    layer.frame = self.view.bounds;
    UIColor *blackColor = [UIColor colorWithWhite:0.0f alpha:1.0f];
    UIColor *clearColor = [UIColor colorWithWhite:0.0f alpha:1.0f];
   
    // hiding !!!!!
    ///////////////////////////////////////////
    //////////////////////////////////////////
    // looping all subviews except circular view for showing progress...
    
    
//    [lbl_finalPicker_Selected setHidden:YES];
//    [cut_Sec setHidden:YES];
//    [img_View_Selected_File_Outlet setHidden:YES];
    
    // working.
    
    [lbl_finalPicker_Selected removeFromSuperview];
    [cut_Sec removeFromSuperview];
    [img_View_Selected_File_Outlet removeFromSuperview];
    
    
    
    for (UIView *subview in self.view.subviews)
    {

        if ([subview isEqual:circular_Progress_View]) {
            subview.hidden=NO;
         
            // do nothing .
        }else{
            
            subview.hidden = YES;
            
        }
    
    }
    

    ///////////////////////////////////////
    ///////////////////////////////////////
    
    layer.colors = [NSArray arrayWithObjects:(id)clearColor.CGColor, (id)blackColor.CGColor, nil];
    [self.view.layer insertSublayer:layer atIndex:1];

    //for gradient.........
    
    float circular_Progress_Viewwidth = (sizeOfSubview.width * 54)/100;
    float circular_Progress_Viewheight = (sizeOfSubview.height * 23.7)/100;
    
    [self.view setAlpha:0.4];
    [self.view setUserInteractionEnabled:NO];
    self.circular_Progress_View.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width / 2 -circular_Progress_Viewwidth/2), ([UIScreen mainScreen].bounds.size.height / 2 -circular_Progress_Viewheight/2), circular_Progress_Viewwidth, circular_Progress_Viewheight);

//    [self.view setAlpha:0.4];
//    [self.view setUserInteractionEnabled:NO];
//    self.circular_Progress_View.frame = CGRectMake(71, 197, 175, 135);
    [self.view addSubview:self.circular_Progress_View];
    self.circular_Progress_View.thicknessRatio = 0.111111;
    self.circular_Progress_View.outerBackgroundColor=[UIColor lightGrayColor];
    self.circular_Progress_View.innerBackgroundColor=[UIColor lightGrayColor];
    self.circular_Progress_View.progressFillColor=[UIColor redColor];


    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    
    //timesgroupcrapi  http://timesgroupcrapi.cloudapp.net/api/UserDet
    
    
    
    
    NSString * urlString = [NSString stringWithFormat:@"%@%@/%@?id=%@&token=%@",kBaseURL,kAPI,kblobs,[[NSUserDefaults standardUserDefaults] stringForKey:@"userID_Default"],[GlobalStuff generateToken]];
                            
    
    
    NSLog(@"video url--%@",urlString);
    
    
    NSURL *url =[ NSURL URLWithString:urlString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:300];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPMethod:@"POST"];
    
    //    NSData *imageData = UIImageJPEGRepresentation(mainImage, 1.0);
    //
    NSString *boundary = @"unique-consistent-ssssssss";
    
    // set Content-Type in HTTP header
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // post body
    NSMutableData *body = [NSMutableData data];
    
    //    // add params (all params are strings)
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@\r\n\r\n", @"imageCaption"] dataUsingEncoding:NSUTF8StringEncoding]];
    //    [body appendData:[[NSString stringWithFormat:@"%@\r\n", @"Some Caption"] dataUsingEncoding:NSUTF8StringEncoding]];
    //
    videoData= [[NSUserDefaults standardUserDefaults] objectForKey:@"VideoData"];
    // add image data
    if (videoData) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@; filename=%@\r\n", @"imageFormKey",lbl_finalPicker_Selected.text] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:videoData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    // set the content-length
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    
    
    task = [session uploadTaskWithStreamedRequest:request];
    [task resume];
    
}


-(void)newOne
{
    layer = [CAGradientLayer layer];
    layer.frame = self.view.bounds;
    UIColor *blackColor = [UIColor colorWithWhite:0.0f alpha:1.0f];
    UIColor *clearColor = [UIColor colorWithWhite:0.0f alpha:1.0f];
    
    // hiding !!!!!
    ///////////////////////////////////////////
    //////////////////////////////////////////
    // looping all subviews except circular view for showing progress...
    
    for (UIView *subview in self.view.subviews)
    {
        
        if ([subview isEqual:circular_Progress_View]) {
            subview.hidden=NO;
            
            // do nothing .
        }else{
            
            subview.hidden = YES;
            
        }
        
    }
    
    
    ///////////////////////////////////////
    ///////////////////////////////////////
    
    layer.colors = [NSArray arrayWithObjects:(id)clearColor.CGColor, (id)blackColor.CGColor, nil];
    [self.view.layer insertSublayer:layer atIndex:1];
    
    //for gradient.........
    
//    [self.view setAlpha:0.4];
//    [self.view setUserInteractionEnabled:NO];
//    self.circular_Progress_View.frame = CGRectMake(71, 197, 175, 135);
//    [self.view addSubview:self.circular_Progress_View];
//    self.circular_Progress_View.thicknessRatio = 0.111111;
//    self.circular_Progress_View.outerBackgroundColor=[UIColor lightGrayColor];
//    self.circular_Progress_View.innerBackgroundColor=[UIColor lightGrayColor];
//    self.circular_Progress_View.progressFillColor=[UIColor redColor];
//    
//    UILabel *percentSignLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 55, 25, 25)];
//    [self.circular_Progress_View addSubview:percentSignLabel];
//    percentSignLabel.text = @"%";
//    percentSignLabel.textColor = [UIColor whiteColor];
//    percentSignLabel.font = [UIFont systemFontOfSize:25];
//    [self.circular_Progress_View bringSubviewToFront:percentSignLabel];
    
    
    
    
    float circular_Progress_Viewwidth = (sizeOfSubview.width * 54)/100;
    float circular_Progress_Viewheight = (sizeOfSubview.height * 23.7)/100;
    
    [self.view setAlpha:0.4];
    [self.view setUserInteractionEnabled:NO];
    self.circular_Progress_View.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width / 2 -circular_Progress_Viewwidth/2), ([UIScreen mainScreen].bounds.size.height / 2 -circular_Progress_Viewheight/2), circular_Progress_Viewwidth, circular_Progress_Viewheight);
    
    //circular_Progress_View.backgroundColor = [UIColor lightGrayColor];
    
    [self.view addSubview:self.circular_Progress_View];
    self.circular_Progress_View.thicknessRatio = 0.111111;
    self.circular_Progress_View.outerBackgroundColor=[UIColor lightGrayColor];
    self.circular_Progress_View.innerBackgroundColor=[UIColor lightGrayColor];
    
    self.circular_Progress_View.progressFillColor=[UIColor redColor];
    UILabel *percentSignLabel = [[UILabel alloc] initWithFrame:CGRectMake((circular_Progress_View.frame.size.width *63.9)/100, (circular_Progress_View.frame.size.height*41)/100, (circular_Progress_View.frame.size.width *14.5)/100, (circular_Progress_View.frame.size.width *14.5)/100)];
    percentSignLabel.text = @"%";
    percentSignLabel.textColor = [UIColor whiteColor];
    percentSignLabel.font = [UIFont systemFontOfSize:25];
    
    [self.circular_Progress_View addSubview:percentSignLabel];
    [self.circular_Progress_View bringSubviewToFront:percentSignLabel];

    
    
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    
    //timesgroupcrapi   http://timesgroupcrapi.cloudapp.net/api/UserDet
    
    
    
    
    NSString * urlstring = [NSString stringWithFormat:@"%@%@/%@?id=%@&token=%@",kBaseURL,kAPI,kblobs,[[NSUserDefaults standardUserDefaults] stringForKey:@"userID_Default"],[GlobalStuff generateToken] ];
                            
    
    DLog(@"url video 2--%@",urlstring);
    
    
    NSURL *url = [NSURL URLWithString:urlstring];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:300];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPMethod:@"POST"];
    
    //    NSData *imageData = UIImageJPEGRepresentation(mainImage, 1.0);
    //
    NSString *boundary = @"unique-consistent-ssssssss";
    
    // set Content-Type in HTTP header
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // post body
    NSMutableData *body = [NSMutableData data];
    
    //    // add params (all params are strings)
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@\r\n\r\n", @"imageCaption"] dataUsingEncoding:NSUTF8StringEncoding]];
    //    [body appendData:[[NSString stringWithFormat:@"%@\r\n", @"Some Caption"] dataUsingEncoding:NSUTF8StringEncoding]];
    //
    // add image data
    if (videoData) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@; filename=%@\r\n", @"imageFormKey",lbl_finalPicker_Selected.text] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:videoData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    // set the content-length
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    
    
    taskSecond = [session uploadTaskWithStreamedRequest:request];
    [taskSecond resume];

}

//// delegate methods

#pragma mark - NSURLSessionTaskDelegate



- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend
{
    DLog(@"%lld %lld %lld", bytesSent, totalBytesSent, totalBytesExpectedToSend);
    
    
    
    if (totalBytesExpectedToSend==totalBytesSent) {
        
    }
    
    float progress = (double)totalBytesSent / (double)totalBytesExpectedToSend;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [progressView setHidden:NO];
       // [self.progressView setProgress:progress];
        self.circular_Progress_View.progress = progress;
        UILabel *percentSignLabel = [[UILabel alloc] initWithFrame:CGRectMake((circular_Progress_View.frame.size.width *63.9)/100, (circular_Progress_View.frame.size.height*41)/100, (circular_Progress_View.frame.size.width *14.5)/100, (circular_Progress_View.frame.size.width *14.5)/100)];
        percentSignLabel.text = @"%";
        
        [self.circular_Progress_View addSubview:percentSignLabel];
       // percentSignLabel.text = @"%";
        percentSignLabel.textColor = [UIColor whiteColor];
        percentSignLabel.font = [UIFont systemFontOfSize:25];
        [self.circular_Progress_View bringSubviewToFront:percentSignLabel];

    });

}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task needNewBodyStream:(void (^)(NSInputStream *bodyStream))completionHandler
{
    // completionHandler(self.inputStream);
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    
    DLog(@"%s: error =========+++++ %@; data ==========+++++ %@", __PRETTY_FUNCTION__, error, [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
    
    
    if (responseData==nil) {
        
        DLog(@"connection has broken.");

    }

    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.circular_Progress_View removeFromSuperview];
        [self.view setAlpha:1];
        [self.view setUserInteractionEnabled:YES];
       // [layer removeFromSuperlayer];
        
        if (error==nil ) {
            
            DLog(@"successfully submitted");
            
            responseDataForRestOfTheDetailService =[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
            
            DLog(@"ressssssssssssssssss---%@",responseDataForRestOfTheDetailService);
         
            [self uploadThumbnail:[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]];

        }else{
            
            DLog(@"error available!");
           // [self   sendVideo_ToServer];

            
            isItFirstService=1;
            try_AgainInternet_Check = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Internet connection is not available. Please try again." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            
            [try_AgainInternet_Check show];
            
            
            
        }
        
    });
    
}

#pragma mark - NSURLSessionDataDelegate

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler
{
    responseData = [NSMutableData data];
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    [responseData appendData:data];
}

-(void)sendRestOfTheVideoDATA:(NSString *)Id_BlobFromService{
    
   // __block  NSString *categoryId_String;
    
    [ [app.categoryNameArray objectAtIndex:0] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        
        NSString *campareStr = [NSString stringWithFormat:@"%@",[[app.categoryNameArray objectAtIndex:0]objectAtIndex:idx]];
        if ([campareStr isEqualToString:lbl_output_category.text]) {
            
            categoryId_String = [NSString stringWithFormat:@"%@",[[app.id_CategoryArray objectAtIndex:0]objectAtIndex:idx]];
            
        }
        
    }];
    

    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    //timesgroupcrapi  http://timesgroupcrapi.cloudapp.net/api/UserDet
    
    
    NSString * urlstring = [NSString stringWithFormat:@"%@%@/CJDetails?token=%@",kBaseURL,kAPI,[GlobalStuff generateToken]];
                            
    
    
    DLog(@"video url 3--%@",urlstring);
    
    NSURL * url = [NSURL URLWithString:urlstring];     //  NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                           timeoutInterval:300];
    
    NSMutableDictionary *finalDictionary = [NSMutableDictionary dictionary];
    NSMutableDictionary *headerDict = [NSMutableDictionary dictionary];
    NSMutableDictionary *dictionaryTemp = [NSMutableDictionary dictionary];
    
    
    [headerDict setValue:@"" forKey:@"DeviceId"];
    [headerDict setValue:@"" forKey:@"UserId"];  // user id is yet to set ....[[NSUserDefaults standardUserDefaults] stringForKey:@"userID_Default"]
    [headerDict setValue:@"" forKey:@"Source"];
    
    [dictionaryTemp setValue:txt_Title.text forKey:@"Title"];
    [dictionaryTemp setValue:txt_View.text forKey:@"FullStory"];
    [dictionaryTemp setValue:categoryId_String forKey:@"Id_Category"];    // picker view 's category.....
    [dictionaryTemp setValue:[[NSUserDefaults standardUserDefaults] stringForKey:@"userID_Default"] forKey:@"SubmittedBy"];         // user id need to get set here .
    [dictionaryTemp setValue:@"Submitted" forKey:@"JournalStatus"];
    [dictionaryTemp setValue:@"1" forKey:@"Id_MainCategory"];
    [dictionaryTemp setValue:Id_BlobFromService forKey:@"Id_Blob"];
    
    checkStr =    [[NSUserDefaults standardUserDefaults]stringForKey:@"address_Default"];
    
    if (locationStatus ==1) {
        if (!checkStr) {
            // when it's empty!!!!!
            
            [dictionaryTemp setValue:written_Address forKeyPath:@"LocationDetails"];
            
        }else{
            
            // when it's not empty (address is not empty !!!!!)
            NSCharacterSet *charSet = [NSCharacterSet whitespaceCharacterSet];
            NSString *trimmedString = [with_Address_Optional_Written stringByTrimmingCharactersInSet:charSet];
            if ([trimmedString isEqualToString:@""]) {
                
                // it's empty or contains only white spaces
                [dictionaryTemp setValue:checkStr forKey:@"LocationDetails"];
                
            }else{
                
                [dictionaryTemp setValue:with_Address_Optional_Written forKey:@"LocationDetails"];
            }

        
    }
        
    }else{
        
        [dictionaryTemp setValue:myLocationAddress forKey:@"LocationDetails"];

        
    }
    
    DLog(@" subodh value of addres is ======%@",[dictionaryTemp valueForKey:@"LocationDetails"]);
    
    [finalDictionary setObject:headerDict forKey:@"header"];
    [finalDictionary setValue:dictionaryTemp forKey:@"data"];
    
     DLog(@"Request ON Video ===%@",finalDictionary);
    [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [urlRequest setHTTPMethod:@"POST"];
    NSError *error;
    
    [urlRequest setHTTPBody:[NSJSONSerialization dataWithJSONObject:finalDictionary
                                                            options:kNilOptions
                                                              error:&error]];
    

    /*
     NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
     cachePolicy:NSURLRequestUseProtocolCachePolicy
     timeoutInterval:300];
     */
    
    NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:urlRequest
                                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                           DLog(@"Response:%@ %@\n", response, error);
                                                           if(error == nil)
                                                         {
//                                                               NSString * text = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
//                                                               DLog(@"final audio o/p is  ==== %@",text);
                                                             
                                                   
                                                             NSError *jsonError;
                                                             NSArray *array = [NSJSONSerialization JSONObjectWithData:data
                                                                                                              options:kNilOptions
                                                                                                                error:&jsonError];

                                                             DLog(@"array is ====%@",array);
                                                             
                                                             /*
                                                              array is ===={
                                                              data =     {
                                                              ErrorId = 114;
                                                              ErrorMessage = "Story has been submitted successfully.";
                                                              };
                                                              header =     {
                                                              DeviceId = "<null>";
                                                              UserId = 0;
                                                              };
                                                              }
                                                              */
                                                             
                                                             NSString *strId = [NSString stringWithFormat:@"%@",[[array valueForKey:@"data"]valueForKey:@"ErrorId"]];
                                                             
                                                             if ([strId isEqualToString:@"114"]) {
                                                                 
//                                                                 UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:[NSString stringWithFormat:@"%@",[[array valueForKey:@"data"] valueForKey:@"ErrorMessage"]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//                                                                 [alert show];
                                                                 
                                                                 
                                                                 if (tempArray ==nil) {
                                                                     
                                                                     [[NSUserDefaults standardUserDefaults]setValue:LocalDataHandleArray forKey:@"SubmitArray"];
                                                                     
                                                                 }else{
                                                                     
                                                                     
                                                                     // start....
                                                                     [LocalDataHandleArray removeObjectAtIndex:objectDataClass.globalIndexSelection];
                                                                     [[NSUserDefaults standardUserDefaults]setValue:LocalDataHandleArray forKey:@"SubmitArray"];
                                                                     // end.....
                                                                 }
                                                                 
                                                                 
                                                                 
                                                                 
                                                                 NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
                                                                [dateFormatter setDateFormat:@"dd-MM-yyyy  hh:mm a"];
                                                                 NSString *date=[dateFormatter stringFromDate:[NSDate date]];
//                                                                 DLog(@"%@",[dateFormatter stringFromDate:[NSDate date]]);
                                                                 
                                                                 
                                                                 NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                                                                 [formatter setDateFormat:@"hh:mm:ss"];
                                                                 NSString *time=[formatter stringFromDate:[NSDate date]];
                                                                 
                                                                 
                                                                 if([app.myFinalArray count]==0){
                                                                     
                                                                     app.myFinalArray=[[NSMutableArray alloc]init];
                                                                     
                                                                 }else{
                                                                     
                                                                     //do Nothing
                                                                     
                                                                 }
                                                                 
                                                                 
                                                                 
                                                                 [videoDataDictionary setValue:[lbl_output_category.text uppercaseString] forKey:@"CategoryName"];
                                                                 [videoDataDictionary setValue:txt_Title.text forKey:@"Title"];
                                                                 [videoDataDictionary setValue:txt_View.text forKey:@"FullStory"];
                                                                 [videoDataDictionary setValue:@"VIDEO" forKey:@"Type"];
                                                                 [videoDataDictionary setValue:tempPath forKey:@"videoPath"];
                                                                 [videoDataDictionary setValue:date forKey:@"Date"];
                                                                 [videoDataDictionary setValue:time forKey:@"Time"];
                                                                 
                                                                 
                                                               //  [app.myFinalArray addObject:videoDataDictionary];
                                                                 
                                                                 if([app.myFinalArray count]<15){
                                                                     
                                                                     [app.myFinalArray addObject:videoDataDictionary];
                                                                 }
                                                                 else{
                                                                     [app.myFinalArray removeObjectAtIndex:0];
                                                                 }
                                                                 
                                                                 
                                                                 
                                                                 [[NSUserDefaults standardUserDefaults]setValue:app.myFinalArray forKey:@"MyArray"];
                                                                 // [[NSUserDefaults standardUserDefaults]synchronize];
                                                                 
                                                                 
                                                                 
                                                                 
                                                                 
                                                                 DLog(@"My Array is ===== %@",[[NSUserDefaults standardUserDefaults]objectForKey:@"MyArray"]);
                                                                 
                                                               
                                                                 ok_For_Success_Outlet.tag=1;
                                                                 
                                                                 
                                                                     
//         [img_ForSuccess_Unsuccess setImage:[UIImage imageNamed:@"success.png"]];
//         //UIButton *btnUpload=[[UIButton alloc]initWithFrame:CGRectMake(103.0, 435.0, 115.0, 38.0)];
//         UIButton *btnUpload=[[UIButton alloc]initWithFrame:CGRectMake(86.0, 241.0, 115.0, 38.0)];
//         [btnUpload setImage:[UIImage imageNamed:@"Sounds Good Btn.png"] forState:UIControlStateNormal];
//         [btnUpload addTarget:self action:@selector(btn_Success_Tapped:) forControlEvents:UIControlEventTouchUpInside];
//         btnUpload .clipsToBounds = YES;
//         [btnUpload.layer setCornerRadius:4.5];
//         
//         [self.selectedView.layer setCornerRadius:4.0];
//         [view_ForSuccess_Unsuccess addSubview:self.selectedView];
//         [self.selectedView addSubview:btnUpload];
//    
//     [self.view addSubview:self.view_ForSuccess_Unsuccess];
                                                                 
                                                                 [img_ForSuccess_Unsuccess setImage:[UIImage imageNamed:@"success.png"]];
                                                                 UIButton *btnUpload=[[UIButton alloc]initWithFrame:CGRectMake((self.selectedView.frame.size.width *15)/100, (self.selectedView.frame.size.height *84)/100, (self.selectedView.frame.size.width *25.9)/100, (self.selectedView.frame.size.height *12)/100)];
                                                                 [btnUpload setImage:[UIImage imageNamed:@"Sounds Good Btn.png"] forState:UIControlStateNormal];
                                                                 [btnUpload addTarget:self action:@selector(btn_Success_Tapped:) forControlEvents:UIControlEventTouchUpInside];
                                                                 btnUpload .clipsToBounds = YES;
                                                                 [btnUpload.layer setCornerRadius:4.5];
                                                                 [self.selectedView.layer setCornerRadius:4.0];
                                                                 
                                                                 
                                                                 self.view_ForSuccess_Unsuccess.frame = self.view.frame;
                                                                 [view_ForSuccess_Unsuccess addSubview:self.selectedView];
                                                                 [self.selectedView addSubview:btnUpload];
                                                                 [self.view addSubview:self.view_ForSuccess_Unsuccess];
          
                                                                 
                                                             }else{
                                                                 
                                                                 /*
                                                                 ok_For_Success_Outlet.tag=2;
                                                                  CGSize size = [[UIScreen mainScreen]bounds].size;
                                                                  
                                                                  if (size.height==480) {
                                                                  [img_ForSuccess_Unsuccess setImage:[UIImage imageNamed:@"unsuccess3.5.png"]];
                                                                  
                                                                  
                                                                  }else{
                                                                  [img_ForSuccess_Unsuccess setImage:[UIImage imageNamed:@"unsuccess.png"]];
                                                                  }
                                                                  
                                                                  [self.view addSubview:self.view_ForSuccess_Unsuccess];
                                                                  */
                                                                 
                                                                 isItFirstService=3;
                                                                 try_AgainInternet_Check = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Internet connection is not available. Please try again." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                                                                 [try_AgainInternet_Check show];
                                                                 
                                                             }

                                                             
                                                           
                                                         }else{
                                                             
                                                             // if not successfull............
                                                             isItFirstService=3;
                                                             try_AgainInternet_Check = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Internet connection is not available. Please try again." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                                                             [try_AgainInternet_Check show];
                                                             
                                                             
                                                         }
                                                           
                                                       }];
    [dataTask resume];
    
    
}


-(void)uploadThumbnail:(NSString *)Id_BlobFromService
{
    ///////////////////////////////////////
    ///////////////////////////////////////
    
    
    
    
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    
    

    
    
    NSString * urlstring = [NSString stringWithFormat:@"%@%@/VideoThumbnail?id=%@&token=%@",kBaseURL,kAPI,Id_BlobFromService,Finaltoken];
    
                            
                            
    DLog(@"url video 4 --%@",urlstring);
    
    
    NSURL *url = [NSURL URLWithString:urlstring];    
    DLog(@"%@",url);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:300];
    
    [request addValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPMethod:@"POST"];
    
    NSData *imageData = UIImageJPEGRepresentation(imageThumbnail, 1.0);
    
    NSString *boundary = @"unique-consistent-ssssssss";
    
    // set Content-Type in HTTP header
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // post body
    NSMutableData *body = [NSMutableData data];
    
    // add params (all params are strings)
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@\r\n\r\n", @"imageCaption"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", @"Some Caption"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    
    
    // add image data
    if (imageData) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@; filename=%@\r\n", @"imageFormKey",@"imagefromios"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    // set the content-length
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    // NSData *postData = [NSJSONSerialization dataWithJSONObject:finalDictionary options:0 error:&error];
    //[request setHTTPBody:postData];
    
    
    NSURLSessionDataTask * dataTask =[session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    DLog(@"Response:%@ %@\n", response, error);
                                                    if(error == nil)
                                                    {
                                                        DLog(@" I am already INSIDE");
                                                        
                                                        [self sendRestOfTheVideoDATA:Id_BlobFromService];
                                                    }else{
                                                        
                                                        
                                                        
                                                        /*
                                                        ok_For_Success_Outlet.tag=2;
                                                        CGSize size = [[UIScreen mainScreen]bounds].size;
                                                        
                                                        if (size.height==480) {
                                                            [img_ForSuccess_Unsuccess setImage:[UIImage imageNamed:@"unsuccess3.5.png"]];
                                                            
                                                            
                                                        }else{
                                                            [img_ForSuccess_Unsuccess setImage:[UIImage imageNamed:@"unsuccess.png"]];
                                                        }
                                                        
                                                        [self.view addSubview:self.view_ForSuccess_Unsuccess];
                                                         
                                                         */
                                                        
                                                        
                                                         isItFirstService=2;
                                                         try_AgainInternet_Check = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Internet connection is not available. Please try again." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                                                         [try_AgainInternet_Check show];


                                                    }
                                                    
                                                    
                                                }];
    
    
    [dataTask resume];
    
    // task = [session uploadTaskWithStreamedRequest:request];
    // [task resume];
    
    
    
    
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

// For responding to the user accepting a newly-captured picture or movie

- (void) imagePickerController: (UIImagePickerController *) picker  didFinishPickingMediaWithInfo: (NSDictionary *) info {

    if (isPhotoTabSelected == YES) {//Photo is selected..
        
        //---------------------------------
        UIImage *chosenImage; //= info[UIImagePickerControllerEditedImage];
        
        if (info[UIImagePickerControllerEditedImage ]) {
            
            chosenImage =info[UIImagePickerControllerEditedImage];
            
        }else{
            
            chosenImage =info[UIImagePickerControllerOriginalImage];
            
        }
        
        mainImage = chosenImage;
        data = UIImagePNGRepresentation(mainImage);
        
        //   localUrl = (NSURL *)[info valueForKey:UIImagePickerControllerReferenceURL];
        //    DLog(@"imagepath==================== %@",localUrl);
        
        if(isCameraClicked)
        {
            UIImageWriteToSavedPhotosAlbum(mainImage,  nil,  nil, nil);
            
            
        }
        
        DLog(@"image is ========%@",mainImage);
        
        DLog(@"info==============%@",info);
        
        //New changes
        
        UIImage *editedImage = [info objectForKey:UIImagePickerControllerEditedImage];
        //    NSString *docDirPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
       // NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
        
        
        
//        NSString *documentsDirectory;
//        for (int i=0; i<[pathArray count]; i++) {
//            documentsDirectory =[pathArray objectAtIndex:i];
//        }
        
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
        
        // Nav_valueToPhoto =YES;
        
        //  handleView = YES ;
        
            UploadPhoto *uploadP = [[UploadPhoto alloc]initWithNibName:@"UploadPhoto" bundle:nil];
            uploadP.transferedImageData =data;
            uploadP.transferPhotoUniqueName = captureduniqueName;
            // uploadP.navigateValue = Nav_valueToPhoto;
            uploadP.transferFileURl =localUrl;
            [self.navigationController pushViewController:uploadP animated:NO];
            
        

    
   }
    
    else{ // for video
        
        [[NSUserDefaults standardUserDefaults]setValue:@"DoneVideo" forKey:@"Video_Check"];
        handleView = YES ;
     
        NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
        
        videoData = [NSData dataWithContentsOfURL:videoURL];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        fileName = [NSString stringWithFormat:@"%@",[self randomStringWithLength:8]];
        tempPath = [documentsDirectory stringByAppendingFormat:@"/%@.mp4",fileName];
        
        receivedPath=tempPath;
        
        [videoData writeToFile:tempPath atomically:NO];

        [[NSUserDefaults standardUserDefaults] setObject:videoData forKey:@"VideoData"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        

    }
    [self generateThumbnailFrompath];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self.view setNeedsLayout];


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

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)string{
    
    if(range.length + range.location > textView.text.length)
    {
        return NO;
    }
    
    NSUInteger newLength = [txt_View.text length] + [string length] - range.length;
    return newLength <= 4000;
    
}


-(void) textViewDidChange:(UITextView *)textView
{
    if(txt_View.text.length == 0){
        txt_View.textColor = [UIColor lightGrayColor];
       // txt_View.text = @"Enter Comment Here";
        [txt_View resignFirstResponder];
    }
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if (txt_View.textColor == [UIColor lightGrayColor]) {
       // txt_View.text = @"";
        txt_View.textColor = [UIColor blackColor];
    }
    
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    [textView resignFirstResponder];
	return TRUE;
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

// For responding to the user tapping Cancel.
- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker {
    
    // when capture video is tapped!!!
    // for both borowse and capture !!!!
    DLog(@"tapped cancel!");
    [self dismissViewControllerAnimated:YES completion:nil];
    segment_Outlet.selectedSegmentIndex=-1;

}

- (IBAction)segmentController_Handler:(id)sender {
    
    if (IS_OS_8_OR_LATER) {   // code for ios 8 or above !!!!!!!!!
    
        if ([sender selectedSegmentIndex]==0) {
            
            DLog(@"capture Video tapped");
            isBrowserTapped=YES;
            [self.view endEditing:YES];
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
                
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Message!" message:@"Camera is not present!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                
            } else {
                
                isBrowserTapped=YES;
                [self startCameraControllerFromViewController: self usingDelegate: self]; // this is calling the camera
                
            }
            
        }else if ([sender selectedSegmentIndex]==1){
            
            [self.view endEditing:YES];
            DLog(@"Browose Tapped");
            isBrowserTapped=NO;
            [self startMediaBrowserFromViewController: self usingDelegate: self];
        }
    }
    else{
        
        
        if ([sender selectedSegmentIndex]==0) {
            
            DLog(@"capture Video tapped");
             isBrowserTapped=YES;
            [self.view endEditing:YES];
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
                
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Message!" message:@"Camera is not present!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                
            } else {
                
                isBrowserTapped=YES;
                [self startCameraControllerFromViewController: self usingDelegate: self]; // this is calling the camera
                
            }
            
            
            
        }else if ([sender selectedSegmentIndex]==1){
            
            [self.view endEditing:YES];
            DLog(@"Browose Tapped");
            isBrowserTapped=NO;
            [self startMediaBrowserFromViewController: self usingDelegate: self];
            
            
            
        }

        
    }
    
}

- (IBAction)cut_Selected_FileTapped:(id)sender {
    
    cutboolValue = YES ;
  
    segment_Outlet.selectedSegmentIndex=-1;
   // [self doItResize:@"hide"];
   // videoData=nil;
  //  lbl_finalPicker_Selected.text=nil;
    [self.view setNeedsLayout];
    



}

# pragma Mark Use picker for ios 8 & 7 ..

-(void)CallMethodForPicker{
    
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    [toolbar setBarStyle:UIBarStyleBlackTranslucent];
    [toolbar sizeToFit];
    UIBarButtonItem *buttonflexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *buttonDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneClicked:)];
    
    [toolbar setItems:[NSArray arrayWithObjects:buttonflexible,buttonDone, nil]];
    lbl_output_category .inputAccessoryView = toolbar;
    //AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [lbl_output_category setItemList:[NSArray arrayWithArray:[app.categoryNameArray objectAtIndex:0]]];
    
    
}

-(void)doneClicked:(UIBarButtonItem*)button
{
    [self.view endEditing:YES];
}




#pragma mark unused code ios 7.





- (IBAction)Location_Submitt_Tapped:(id)sender {
    
    
    if ([location_Txt.text isEqualToString:@"Dehradun"]) {          // this check for the testing purpose ........
        
        [self.view addSubview:successfull_View];
        
    }
    else{
        [self.view addSubview:tryagain_View];
    }
        

  //  [CaptureOnLocation_View removeFromSuperview];
    
    
}
- (IBAction)current_Location_Submitt_Tapped:(id)sender {
    [current_Location_View removeFromSuperview];
}

// error and sussfull submitt button

- (IBAction)tryagain_Tapped:(id)sender {
    
    [tryagain_View removeFromSuperview];
}

- (IBAction)SuccessfullySubmitted_Tapped:(id)sender {   // this is pop view for sub mitted this code will be......
    
  //  [successfull_View removeFromSuperview];
    
  //  [successfull_View removeFromSuperview];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"myNotification" object:nil userInfo:nil];
    NSArray *myArr = [self.navigationController viewControllers];
    [self.navigationController popToViewController:[myArr objectAtIndex:1] animated:YES];

    
}
- (IBAction)setting_Tapped:(id)sender {
    
    Setting_Screen *setting=[[Setting_Screen alloc]initWithNibName:@"Setting_Screen" bundle:nil];
    [self.navigationController pushViewController:setting animated:YES];

}

- (void)btn_Success_Tapped:(id)sender {
    
    
    if (ok_For_Success_Outlet.tag==1) {
        
        // on successfull completion....
        txt_View.text=nil;
        txt_Title.text=nil;
        lbl_finalPicker_Selected.text=nil;
        lbl_output_category.text=@"Choose Category";
        videoData=nil;
        
        //[self.navigationController popViewControllerAnimated:YES];
        
        NSArray * viewsList = [self.navigationController viewControllers];
        
        DLog(@"views list --%@",viewsList);
        [self.navigationController popToViewController:[viewsList objectAtIndex:1] animated:YES];

        
        
    }else{
        // when failed!!!
        
        txt_View.text=nil;
        txt_Title.text=nil;
        lbl_finalPicker_Selected.text=nil;
        lbl_output_category.text=@"Choose Category";
        videoData=nil;
        
       // [self.navigationController popViewControllerAnimated:YES];
        
        NSArray * viewsList =[self.navigationController viewControllers];
        
        DLog(@"views list --%@",viewsList);
        [self.navigationController popToViewController:[viewsList objectAtIndex:1] animated:YES];

        
        
    }
    
    
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    
    if (textField == txt_Title)
    {
        if(range.length + range.location > txt_Title.text.length)
        {
            return NO;
        }
        
        NSUInteger newLength = [txt_Title.text length] + [string length] - range.length;
        return newLength <= 50;
        
    }else{
        
        return YES;
    }

    
}
#pragma mark --
#pragma mark -- IBAction
/*- (IBAction)Video_Tapped:(id)sender {
    
    [self checkforNavigationInternetconnection:1];
    
}*/

- (IBAction)Photo_Tapped:(id)sender {
    
    [self checkforNavigationInternetconnection:2];
    
}

- (IBAction)Audio_Tapped:(id)sender {
    
    [self checkforNavigationInternetconnection:3];
    
    
}

- (IBAction)Text_Tapped:(id)sender {
    
    [self checkforNavigationInternetconnection:4];
    
}


#pragma  mark --
#pragma mark -- checkNavigation.
/*
-(void)checkforNavigationInternetconnection:(int)type{
    
    
 if (type==2) {
            
            
            isPhotoTabSelected =YES;
            
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
                  [self.navigationController pushViewController:text animated:NO];
                  
              
          }
}

*/


-(void)checkforNavigationInternetconnection:(int)type{
    
    
    
    if (type==2)
        
    {
        
        
        UIAlertController *alrController=[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *takeVideo=[UIAlertAction actionWithTitle:@"Capture" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            isPhotoTabSelected =YES;
            isCameraClicked=YES;
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:picker animated:YES completion:NULL];
            
        }];
        
        UIAlertAction *gallery=[UIAlertAction actionWithTitle:@"Choose From Gallery" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            isCameraClicked=NO;
            isPhotoTabSelected =YES;
            
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = NO;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:picker animated:YES completion:NULL];
            
            
            
        }];
        
        UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            [tabBarController setSelectedItem:[tabBarController.items objectAtIndex:0]];
            [tabBarController setTintColor:[UIColor blackColor]]; // set tab bar selection color white
            
            
            
        }];
        
        
        [alrController addAction:takeVideo];
        [alrController addAction:gallery];
        [alrController addAction:cancel];
        
        
        [self presentViewController:alrController animated:YES completion:nil];
        
    }
    
    else if (type ==3){
        
        RecordAudioView *recordview=[[RecordAudioView alloc]initWithNibName:@"RecordAudioView" bundle:Nil];
        [self.navigationController pushViewController:recordview  animated:YES];
        
    }else if (type==4){
        
        UploadTextView *text=[[UploadTextView alloc]initWithNibName:@"UploadTextView" bundle:nil];
        [self.navigationController pushViewController:text animated:NO];
    }
}



- (IBAction)startVideoRecordingTapped:(id)sender {

    if (IS_OS_8_OR_LATER) {   // code for ios 8 or above !!!!!!!!!
        
        
            
            DLog(@"capture Video tapped");
            isBrowserTapped=YES;
            [self.view endEditing:YES];
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
                
                /*UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Message!" message:@"Camera is not present!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
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
            
        
    }else { // for IOS less than 7
        
        DLog(@"capture Video tapped");
        isBrowserTapped=YES;
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
#pragma mark -- Adding custom labels, textfield and buttons

-(void)createCustomUiField :(int)locationStatusLocal {
    
    // creting a custom view which will be like a alertview....
    
    float customAlertwidth = (sizeOfSubview.width * 95)/100;
    float customAlertheight = (sizeOfSubview.height * 56.6)/100;
    
    customAlertView = [[UIView alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width / 2 -customAlertwidth/2), ([UIScreen mainScreen].bounds.size.height / 2 -customAlertheight/2), customAlertwidth, customAlertheight)];
    
    //self.view.center = customAlertView.center;
    [customAlertView setBackgroundColor: [UIColor whiteColor]];
    customAlertView.clipsToBounds = YES;
    [customAlertView.layer setCornerRadius:4.5];
    
    
    

    // creating a custom label ....
//    UILabel * confirmLocationlabel = [[UILabel alloc] initWithFrame:CGRectMake(43.0, 30.0, 210, 22.0)];
    
    UILabel * confirmLocationlabel = [[UILabel alloc] initWithFrame:CGRectMake((customAlertView.frame.size.width*14)/100, (customAlertView.frame.size.height*9.3)/100, (customAlertView.frame.size.width*69)/100, (customAlertView.frame.size.height*6.8)/100)];

    [confirmLocationlabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:20.0]];
    confirmLocationlabel.text = @"Confirm your location";
    [confirmLocationlabel setTextAlignment:NSTextAlignmentCenter];
    [confirmLocationlabel setTextColor:[UIColor grayColor]];
    
    // for location logo..
    UIImageView * locationImage;// = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 70.0, 24.0, 24.0)];
    
    UILabel * enteredLocation = [[UILabel alloc] init];
    
    
    enteredLocation.numberOfLines =3;
    
    
    if (locationStatusLocal ==1) {
        
        locationImage = [[UIImageView alloc] initWithFrame:CGRectMake(10.0, (customAlertView.frame.size.height*19.4)/100, 30.0, 30.0)];
        //        initWithFrame:CGRectMake(25.0, 57.0, 250.0, 80.0)]
        [enteredLocation setFrame:CGRectMake((customAlertView.frame.size.width*8.2)/100, (customAlertView.frame.size.height*17.7)/100, (customAlertView.frame.size.width*82.2)/100, (customAlertView.frame.size.height*24.9)/100)];
        
        [enteredLocation setFont:[UIFont fontWithName:@"Roboto-Regular" size:(((customAlertView.frame.size.height*6.8)/100)*81.7)/100]];
        enteredLocation.text = checkStr;
    }else{
        
        locationImage = [[UIImageView alloc] initWithFrame:CGRectMake(6.0, (customAlertView.frame.size.height*26.4)/100, 30.0, 30.0)];
        [enteredLocation setFrame:CGRectMake((customAlertView.frame.size.width*8.2)/100, (customAlertView.frame.size.height*17.7)/100, (customAlertView.frame.size.width*82.2)/100, (customAlertView.frame.size.height*25.9)/100)];
        [enteredLocation setFont:[UIFont fontWithName:@"Roboto-Regular" size:(((customAlertView.frame.size.height*6.8)/100)*81.7)/100]];
        enteredLocation.text = @"Location auto capturing is off.";
        
    }

    
    [locationImage setContentMode:UIViewContentModeScaleAspectFill];
    [locationImage setImage:[UIImage imageNamed:@"location01@2x.jpg"]];
    
    
    [enteredLocation setTextAlignment:NSTextAlignmentCenter];
    
    // custom label
    
//    UILabel * incorrectLocationLabel = [[UILabel alloc] initWithFrame:CGRectMake(8.0, 115, 288.0, 60)];
    
    UILabel * incorrectLocationLabel = [[UILabel alloc] initWithFrame:CGRectMake((customAlertView.frame.size.width*2.6)/100, (customAlertView.frame.size.height*37.8)/100, (customAlertView.frame.size.width*94.7)/100, (customAlertView.frame.size.height*14)/100)];

    incorrectLocationLabel.numberOfLines=2;
    
    
    if (locationStatusLocal == 1) {
        
        [incorrectLocationLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:13.0]];
        incorrectLocationLabel.text  =  @"If incorrect, please enter the location for your story";
        [incorrectLocationLabel setTextAlignment:NSTextAlignmentCenter];
        
    }else{
        
        [incorrectLocationLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:18.0]];
        incorrectLocationLabel.text  =  @"Please enter the location details of your news/story.";
        [incorrectLocationLabel setTextAlignment:NSTextAlignmentLeft];
        [incorrectLocationLabel setTextColor:[UIColor grayColor]];
        incorrectLocationLabel.numberOfLines=2;
        
        
    }
    
    
    // incorrectLocationLabel.adjustsFontSizeToFitWidth = YES;
    
    
    
    
    
    
    //custom textfield for Streets
    
//    StreetTxt = [[MYTextField alloc] initWithFrame:CGRectMake(8.0, 179.0, 279.0, 30.0)];
    StreetTxt = [[MYTextField alloc] initWithFrame:CGRectMake((customAlertView.frame.size.width*2.6)/100, (customAlertView.frame.size.height*55.7)/100, (customAlertView.frame.size.width*94.7)/100, (customAlertView.frame.size.height*9.3)/100)];

    [StreetTxt setFont:[UIFont fontWithName:@"Roboto-Thin" size:14.0]];
    [StreetTxt setTextAlignment:NSTextAlignmentLeft];
    StreetTxt.placeholder = @"Street";
    [StreetTxt setBorderStyle:UITextBorderStyleNone];
    StreetTxt.layer.borderWidth =1.0;
    StreetTxt.layer.borderColor = [[UIColor colorWithRed:215.0f/255.0f green:215.0f/255.0f blue:215.0f/255.0f alpha:1.0f] CGColor];
    //StreetTxt.delegate =self;
    
    
    //custom textfield for city....
    
//    cityTxt = [[MYTextField alloc] initWithFrame:CGRectMake(8.0, 222.0, 97.0, 30.0)];
    cityTxt = [[MYTextField alloc] initWithFrame:CGRectMake((customAlertView.frame.size.width*2.6)/100, (customAlertView.frame.size.height*70.7)/100, (customAlertView.frame.size.width*31.9)/100, (customAlertView.frame.size.height*9.3)/100)];

    [cityTxt setFont:[UIFont fontWithName:@"Roboto-Thin" size:14.0]];
    [cityTxt setTextAlignment:NSTextAlignmentLeft];
    cityTxt.placeholder = @"City";
    [cityTxt setBorderStyle:UITextBorderStyleNone];
    cityTxt.layer.borderWidth =1.0;
    cityTxt.layer.borderColor = [[UIColor colorWithRed:215.0f/255.0f green:215.0f/255.0f blue:215.0f/255.0f alpha:1.0f] CGColor];
   // cityTxt.delegate =self;
    
    //custom textfield for state
    
//    StateTxt = [[MYTextField alloc] initWithFrame:CGRectMake(115.0, 222.0, 83.0, 30.0)];
    
    StateTxt = [[MYTextField alloc] initWithFrame:CGRectMake((customAlertView.frame.size.width*34)/100, (customAlertView.frame.size.height*70.7)/100, (customAlertView.frame.size.width*31.9)/100, (customAlertView.frame.size.height*9.3)/100)];

    [StateTxt setFont:[UIFont fontWithName:@"Roboto-Thin" size:14.0]];
    [StateTxt setTextAlignment:NSTextAlignmentLeft];
    StateTxt.placeholder = @"State";
    [StreetTxt setBorderStyle:UITextBorderStyleNone];
    StateTxt.layer.borderWidth =1.0;
    StateTxt.layer.borderColor = [[UIColor colorWithRed:215.0f/255.0f green:215.0f/255.0f blue:215.0f/255.0f alpha:1.0f] CGColor];
    //StateTxt.delegate =self;
    //custom textfield for Pincode
    
//    PincodeTxt = [[MYTextField alloc] initWithFrame:CGRectMake(205.0, 222.0, 83.0, 30.0)];
    PincodeTxt = [[MYTextField alloc] initWithFrame:CGRectMake((customAlertView.frame.size.width*65.8)/100, (customAlertView.frame.size.height*70.7)/100, (customAlertView.frame.size.width*31.9)/100, (customAlertView.frame.size.height*9.3)/100)];

    [PincodeTxt setFont:[UIFont fontWithName:@"Roboto-Thin" size:14.0]];
    [PincodeTxt setTextAlignment:NSTextAlignmentLeft];
    PincodeTxt.placeholder = @"Pincode";
    [PincodeTxt setBorderStyle:UITextBorderStyleNone];
    PincodeTxt.layer.borderWidth =1.0;
    PincodeTxt.layer.borderColor = [[UIColor colorWithRed:215.0f/255.0f green:215.0f/255.0f blue:215.0f/255.0f alpha:1.0f] CGColor];
  //  PincodeTxt.delegate= self;
    
    
    //custom button with action..
    
//    UIButton * submitButton = [[UIButton alloc] initWithFrame:CGRectMake(92.0, 272.0, 120.0, 40.0)];
    UIButton * submitButton = [[UIButton alloc] initWithFrame:CGRectMake((customAlertView.frame.size.width*30.2)/100, (customAlertView.frame.size.height*84.7)/100, (customAlertView.frame.size.width*39.4)/100, (customAlertView.frame.size.height*12.4)/100)];

    [submitButton setBackgroundImage:[UIImage imageNamed:@"Submit btn 640X1136.png"] forState:UIControlStateNormal];
    [submitButton addTarget:self action:@selector(submitButtonTap) forControlEvents:UIControlEventTouchUpInside];
    submitButton.clipsToBounds = YES;
    [submitButton.layer setCornerRadius:4.0];
    
    
    //Adding all custom labels and tetxfield to subview...
    [self.view addSubview:customAlertView];
    [customAlertView addSubview:confirmLocationlabel];
    [customAlertView addSubview:locationImage];
    [customAlertView addSubview:enteredLocation];
    [customAlertView addSubview:incorrectLocationLabel];
    [customAlertView addSubview:StreetTxt];
    [customAlertView addSubview:cityTxt];
    [customAlertView addSubview:StateTxt];
    [customAlertView addSubview:PincodeTxt];
    [customAlertView addSubview:submitButton];
    
}

- (void) textFieldDidBeginEditing:(UITextField *)textField {
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    textField.leftView = paddingView;
    textField.leftViewMode = UITextFieldViewModeAlways;
}

-(void) blurEffect {
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    
    // Add effect to an effect view
    visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    visualEffectView.frame = self.view.frame;
    
    
    [self.view addSubview:visualEffectView];
    
    
}


#pragma mark -- Custom Button called...
-(void)submitButtonTap {
    DLog(@"submit tapped");
    
    // NSString *server = [[NSUserDefaults standardUserDefaults]stringForKey:@"connection_Internet"];
    
    
    
    if (locationStatus==1) {
        
        [visualEffectView removeFromSuperview];
        [customAlertView removeFromSuperview];

         [self  sendVideo_ToServer];
        
        
    }else{
        
        if([StreetTxt.text length]==0 || [cityTxt.text length]==0 || [StateTxt.text length]==0 ||[PincodeTxt.text length]==0){
            
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Location cannot be empty,all fields are mandatory." message:@"Please enter a valid location." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * actionAlert = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction* alert){
                
                
            }];
            [alert addAction:actionAlert];
            [self presentViewController:alert animated:YES completion:nil];
            
        }else{
            
            
            myLocationAddress=[NSString stringWithFormat:@"%@, %@, %@, %@",StreetTxt.text,cityTxt.text, StateTxt.text, PincodeTxt.text];
            [visualEffectView removeFromSuperview];
            [customAlertView removeFromSuperview];

            [self  sendVideo_ToServer];
            
            
        }
    }
    
    
}

#pragma mark  generating the token-----

-(void)generateToken {
    
    
    //get creation time --
    now2 = [NSDate date];
    
    dateFormatter1 = [[NSDateFormatter alloc] init];
    dateFormatter1.dateFormat = @"hh:mm:ss";
    [dateFormatter1 setTimeZone:[NSTimeZone systemTimeZone]];
    
    
    firstDate = [dateFormatter1 stringFromDate:now2];
    
    
    
    
    
    
    //programmatically get user agent
    
    //UIWebView* webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    NSString* UserAgent = objectDataClass.globalUserAgent; ///[webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    
    
    
    DLog(@"user-agent in data video --%@",UserAgent);
    
    
    
    //get ipaddress
    [self getIPAddress];
    
    NSDate * now = [NSDate date];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    // [outputFormatter setDateFormat:@"HH:mm:ss"];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [outputFormatter setTimeZone:timeZone];
    [outputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //NSString *newDateString = [outputFormatter stringFromDate:[now timeIntervalSince1970 ]];
    
    
    DLog(@"newDateString %f", [now timeIntervalSince1970 ]);
    
    
    double Finaldate = [now timeIntervalSince1970] ;
    
    double milliseconds = Finaldate *1000;
    
    DLog(@"final date---%f",milliseconds);
    
    //    NSString *myStringValue = @"hello";
    //    NSString *mySecretKey = @"some";
    //    NSString *result1 = [ViewController hashedString:myStringValue withKey:mySecretKey];
    //    DLog(@"result-- %@", result1);
    
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSString *  KEY_PASSWORD = @"com.toi.app.password";
    NSString *    idfv = [[KeyChainValteck keyChainLoadKey:app.putValueToKeyChain] valueForKey:KEY_PASSWORD];
    DLog(@"idfv is audio view  =====%@",idfv);
    
    
    
    
    
    NSString * deviceID =  idfv; //app.FinalKeyChainValue; //@"JYGSyzMsYrfZQA1FSqOY58eIZ9k=";
    DLog(@"device id upload video --%@",deviceID);
    NSString * salt =  [NSString stringWithFormat:@"%@:rz8LuOtFBXphj9WQfvFh",[[NSUserDefaults standardUserDefaults]valueForKey:@"userID_Default"]];
    DLog(@"key is upload video view --%@",salt);//  @":rz8LuOtFBXphj9WQfvFh";
    NSString * IPAddress = [self getIPAddress];
    NSString * sourceParam = @"SkagitTimes";
    //  NSString * userAgent = @"iOS";
    double  ticks =  ((milliseconds * 10000) + 621355968000000000);
    DLog(@"ticks--%0.00000f",ticks);
    
    NSString *hashLeft = [NSString stringWithFormat:@"%@:%@:%@:%f:%@", deviceID,IPAddress ,UserAgent,ticks,sourceParam];
    DLog(@"final string--%@",hashLeft);
    
    
    
    // DLog(@"ip address--%@",IPAddress);
    NSData *saltData = [salt dataUsingEncoding:NSUTF8StringEncoding];
    NSData *paramData = [hashLeft dataUsingEncoding:NSUTF8StringEncoding];//deviceID
    
    NSMutableData* hash = [NSMutableData dataWithLength:CC_SHA256_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA256, saltData.bytes, saltData.length, paramData.bytes, paramData.length, hash.mutableBytes);
    NSString *base64LeftHash = [Base64 base64forData:hash];
    DLog(@"left hash  base 64--%@",base64LeftHash);
    
    
    
    // rightHash...
    
    NSString *hashRight =[NSString stringWithFormat:@"%@:%0.00000f:%@",deviceID,ticks,sourceParam];
    DLog(@"right Hash --%@",hashRight);
    
    NSString *token = [NSString stringWithFormat:@"%@:%@",base64LeftHash,hashRight];
    DLog(@"concated hash --%@",token);
    //   NSData *saltData2 = [salt dataUsingEncoding:NSUTF8StringEncoding];
    NSData *paramData2 = [token dataUsingEncoding:NSUTF8StringEncoding];//deviceID
    
    //    NSMutableData* hash2 = [NSMutableData dataWithLength:CC_SHA256_DIGEST_LENGTH];
    //CCHmac(kCCHmacAlgSHA256, saltData2.bytes, saltData2.length, paramData2.bytes, paramData2.length, hash2.mutableBytes);
    Finaltoken = [Base64 base64forData:paramData2];
    DLog(@"final token--%@",Finaltoken);
    
    
}

- (NSNumber *)dateToSecondConvert:(NSString *)string {
    
    NSArray *components = [string componentsSeparatedByString:@":"];
    
    NSInteger hours   = [[components objectAtIndex:0] integerValue];
    NSInteger minutes = [[components objectAtIndex:1] integerValue];
    NSInteger seconds = [[components objectAtIndex:2] integerValue];
    
    return [NSNumber numberWithInteger:(hours * 60 * 60) + (minutes * 60) + seconds];
    
    
}



#pragma mark-- getIPAddress...

- (NSString *)getIPAddress {
    
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                    
                }
                
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    
    DLog(@"IP Address--%@",address);
    return address;
    
}



+ (NSString*)base64forData:(NSData*)theData {
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];
    
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    NSInteger i;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {  value |= (0xFF & input[j]);  }  }  NSInteger theIndex = (i / 3) * 4;  output[theIndex + 0] = table[(value >> 18) & 0x3F];
        output[theIndex + 1] = table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6) & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0) & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding]; }

#pragma mark- -submitForReview..


- (IBAction)submitForReview:(id)sender {
    NSString *message;
    
    if ([lbl_output_category.text length]==0 || [txt_Title.text length]==0 || [txt_View.text length]==0||[lbl_finalPicker_Selected.text length]==0 || videoData ==nil) {
        
        if ([lbl_finalPicker_Selected.text length]==0 || videoData ==nil) {
            
            message=@"Please select a file";
        }
        else if ([lbl_output_category.text length]==0) {
            
            message = @"Please select a category";
            
        }else if ([txt_Title.text length]==0){
            message=@"Please enter a title";
            
            
        }else if ([txt_View.text length]==0){
            
            message = @"Please enter a story";
        }
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
    } else {
        
        
        
        categoryId_String=[self sendCategoryId:lbl_output_category.text];
        
        
//       // __block  NSString *categoryId_String;
//        
//        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
//        [ [app.categoryNameArray objectAtIndex:0] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//            
//            
//            NSString *campareStr = [NSString stringWithFormat:@"%@",[[app.categoryNameArray objectAtIndex:0]objectAtIndex:idx]];
//            if ([campareStr isEqualToString:lbl_output_category.text]) {
//                
//                categoryId_String = [NSString stringWithFormat:@"%@",[[app.id_CategoryArray objectAtIndex:0]objectAtIndex:idx]];
//                
//            }
//            
//        }];
        
        
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd-MM-yyyy  hh:mm a"];
        NSString *date=[dateFormatter stringFromDate:[NSDate date]];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"hh:mm:ss"];
        NSString *time=[formatter stringFromDate:[NSDate date]];
        
        if ([objectDataClass.globalSubmitArray count]==0) {
            
            objectDataClass.globalSubmitArray = [[NSMutableArray alloc] init];
        }
        else {
            
            // do nothing..
            
        }
        
        
        [VideocollectedDict setValue:txt_Title.text forKey:@"Title"];
        [VideocollectedDict setValue:txt_View.text forKey:@"FullStory"];
        [VideocollectedDict setValue:categoryId_String forKey:@"Id_Category"];    // picker view 's category.....
        [VideocollectedDict setValue:[[NSUserDefaults standardUserDefaults] stringForKey:@"userID_Default"]forKey:@"SubmittedBy"];         // user id need to get set here .
        
        
        [VideocollectedDict setValue:lbl_output_category.text forKey:@"categoryName"];
        [VideocollectedDict setValue:@"Submitted" forKey:@"JournalStatus"];
        [VideocollectedDict setValue:@"2" forKey:@"Id_MainCategory"];
        [VideocollectedDict setValue:date forKey:@"Date"];
        [VideocollectedDict setValue:time forKey:@"Time"];
        [VideocollectedDict setValue:@"VIDEO" forKey:@"Type"];
        [VideocollectedDict setValue:tempPath forKey:@"fileURl"];
        [VideocollectedDict setValue:finalUnique forKey:@"uniqueName"];
        [VideocollectedDict setValue:videoData  forKey:@"videoData"];
        [VideocollectedDict setValue:lbl_output_category.text forKey:@"localCategoryName"];
        
        // app.submitDict = [collectedDict copy];
        //DLog(@"collected data in app--%@",VideocollectedDict);
        /*
        if ([objectDataClass.globalSubmitArray count]<15) {
            
            [objectDataClass.globalSubmitArray  addObject:VideocollectedDict];
            DLog(@"global arra neew --%@",objectDataClass.globalSubmitArray);
            
        }else{
            
            [objectDataClass.globalSubmitArray removeObjectAtIndex:0];
            
        }
        
        
        
        [[NSUserDefaults standardUserDefaults]setValue:objectDataClass.globalSubmitArray forKey:@"SubmitArray"];
        DLog(@"array length======%lu",[objectDataClass.globalSubmitArray count]);
        // [[NSUserDefaults standardUserDefaults]synchronize];
        
        */
        
        if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"SubmitArray"] count]<15) {
            
            
            if (tempArray == nil) {
                
                //[LocalDataHandleArray addObject:VideocollectedDict];
                 [LocalDataHandleArray insertObject:VideocollectedDict atIndex:0];
                
            }else{
                
                
                [LocalDataHandleArray removeObjectAtIndex:objectDataClass.globalIndexSelection];
                //[LocalDataHandleArray addObject:VideocollectedDict];
                 [LocalDataHandleArray insertObject:VideocollectedDict atIndex:0];
            }
            
            
        }else{
            
            [LocalDataHandleArray removeObjectAtIndex:0];
            
            
        }
        
        
        [[NSUserDefaults standardUserDefaults]setValue:LocalDataHandleArray forKey:@"SubmitArray"];
        [[NSUserDefaults standardUserDefaults]synchronize];

        
        
        
     //   DLog(@"My Array is ===== %@",[[NSUserDefaults standardUserDefaults]objectForKey:@"SubmitArray"]);
        
        
        
        //objectDataClass.globaltextDict = [collectedDict copy];
        
        
        //objectDataClass.globalSubmitArray  = [objectDataClass.globaltextDict copy];
        
        //NSMutableArray *aArr = [NSMutableArray arrayWithObjects:aDic,nil];
        
        
        
        
        
//        objectDataClass.globalSubmitArray = [NSMutableArray arrayWithObjects:collectedDict, nil];
//        
//        DLog(@"gloabal array  photo--%@",objectDataClass.globalSubmitArray);
//        
//        
//        [[NSUserDefaults standardUserDefaults]setValue:objectDataClass.globalSubmitArray forKey:@"SubmitArray"];
//        [[NSUserDefaults standardUserDefaults]synchronize];
//        
//        DLog(@"nsuser array photo--%@",[[[NSUserDefaults standardUserDefaults] objectForKey:@"SubmitArray"] mutableCopy]);
        
        
        // showing alertcontroller...
        
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Message" message:@"Your information has been saved for later submission." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * alertAction = [UIAlertAction  actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
            
            NSArray *array = [self.navigationController viewControllers];
            [self.navigationController popToViewController:[array objectAtIndex:1] animated:YES];
            
        }];
        
        [alert addAction:alertAction];
        [self presentViewController:alert animated:YES completion:nil];
        
    } // if END....
}

//#pragma mark -- calling image picker..
//#pragma mark - Image Picker Controller delegate methods   starts ...
//
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
//    
//    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
//    mainImage = chosenImage;
//    data = UIImagePNGRepresentation(mainImage);
//    DLog(@"converted data--%@",data);
//    
//    //   localUrl = (NSURL *)[info valueForKey:UIImagePickerControllerReferenceURL];
//    //    DLog(@"imagepath==================== %@",localUrl);
//    
//    if(isCameraClicked)
//    {
//        UIImageWriteToSavedPhotosAlbum(mainImage,  nil,  nil, nil);
//        
//        
//    }
//    
//    DLog(@"image is ========%@",mainImage);
//    
//    DLog(@"info==============%@",info);
//    
//    //New chamges
//    
//    UIImage *editedImage = [info objectForKey:UIImagePickerControllerEditedImage];
//    //    NSString *docDirPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//    
//    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
//    
//    
//    
//    NSString *documentsDirectory;
//    for (int i=0; i<[pathArray count]; i++) {
//        documentsDirectory =[pathArray objectAtIndex:i];
//    }
//    
//    //Gaurav's logic
//    
//    DLog(@"%lu",(unsigned long)[[[NSUserDefaults standardUserDefaults]objectForKey:@"MyArray"] count]);
//    
//    
//    // NSString *myUniqueName = [NSString stringWithFormat:@"%@-%u", name, (NSUInteger)([[NSDate date] timeIntervalSince1970]*10.0)];
//    
//    //mohit logic
//    
//    fileName = [NSString stringWithFormat:@"%lu.png",(NSUInteger)([[NSDate date] timeIntervalSince1970]*10.0)];
//    
//    
//    //
//    
//    
//    // NSString *documentsDirectory = [pathArray objectAtIndex:0];
//    
//    localUrl =  [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:fileName];//[documentsDirectory stringByAppendingPathComponent:fileName];
//    NSLog (@"File Path = %@", localUrl);
//    
//    // Get PNG data from following method
//    NSData *myData =     UIImagePNGRepresentation(editedImage);
//    // It is better to get JPEG data because jpeg data will store the location and other related information of image.
//    [myData writeToFile:localUrl atomically:YES];
//    
//    // Now you can use filePath as path of your image. For retrieving the image back from the path
//    //UIImage *imageFromFile = [UIImage imageWithContentsOfFile:localUrl];
//    
//    
//    [[NSUserDefaults standardUserDefaults]setValue:@"DonePhoto" forKey:@"Photo_Check"];
//    [[NSUserDefaults standardUserDefaults]synchronize];
//    //[picker dismissViewControllerAnimated:YES completion:NULL];
//    DLog(@"photo done--%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"Photo_Check"]);
//    
//    captureduniqueName = [self generateUniqueName];
//    
//    Nav_valueToPhoto =YES;
//    
//    //  handleView = YES ;
//    CGSize size = [[UIScreen mainScreen]bounds].size;
//    
//    if (size.height==480) {
//        
//        UploadPhoto *uploadP = [[UploadPhoto alloc]initWithNibName:@"UploadPhoto3.5" bundle:nil];
//        uploadP.transferedImageData =data;
//        uploadP.transferPhotoUniqueName = captureduniqueName;
//        uploadP.navigateValue = Nav_valueToPhoto;
//        uploadP.transferFileURl =localUrl;
//        [self.navigationController pushViewController:uploadP animated:NO];
//        
//    }else{
//        
//        UploadPhoto *uploadP = [[UploadPhoto alloc]initWithNibName:@"UploadPhoto" bundle:nil];
//        uploadP.transferedImageData =data;
//        uploadP.transferPhotoUniqueName = captureduniqueName;
//        uploadP.navigateValue = Nav_valueToPhoto;
//        uploadP.transferFileURl =localUrl;
//        [self.navigationController pushViewController:uploadP animated:NO];
//        
//    }
//    
//    
//    
//    
//    //  [self.scrollView_Photo setScrollEnabled:YES];
//    // [self.scrollView_Photo setContentSize:CGSizeMake(320, 600)];
//    // [self.scrollView_Photo setContentOffset:CGPointMake(5, 5) animated:YES];
//    [picker dismissViewControllerAnimated:YES completion:nil];
//    [self.view setNeedsLayout];
//    
//    
//}
//
//
//- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
//    
//    DLog(@"cancel Tapped!");
//    
//    isPickerTapped = YES;
//    //   segment_Outlet.selectedSegmentIndex=-1;
//    
//    
//    
//    //    if (IS_OS_8_OR_LATER) {   // code for ios 8 or above !!!!!!!!!
//    //
//    //        [picker.view removeFromSuperview] ;
//    //        [picker removeFromParentViewController] ;
//    //
//    //    }else {
//    //  [self.scrollView_Photo setScrollEnabled:NO];
//    [picker dismissViewControllerAnimated:YES completion:NULL];
//    [self.view setNeedsLayout];
//    
//    
//    
//    
//    
//}
//
//#pragma mark - Image Picker Controller delegate methods   ends ...
//
//-(NSString *)generateUniqueName{
//    
//    //  NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
//    // NSString *finalUnique= [NSString stringWithFormat:@"Photo_%.0f.jpg", time];
//    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyyMMdd_HHmmss"];
//    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
//    // int randomValue = arc4random() % 1000;
//    //  NSString *unique = [NSString stringWithFormat:@"%@%d",dateString,randomValue];
//    finalUnique = [NSString stringWithFormat:@"Photo_%@.jpg",dateString];
//    DLog(@"unique name --%@",finalUnique);
//    return finalUnique;
//    
//}


#pragma mark --Browse Gallery Button
- (IBAction)browseGalleryButton:(id)sender {
    /*if (IS_OS_8_OR_LATER) {
        // code for ios 8 or above !!!!!!!!!
        
        
        DLog(@"Browose Tapped");
        
        isCameraClicked=NO;
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = NO;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        //            [self addChildViewController:picker];
        //            [picker didMoveToParentViewController:self];
        //            [self.view addSubview:picker.view];
        [self presentViewController:picker animated:YES completion:NULL];
        
        // }
        
        ///////
        
    }else{
        
        
        DLog(@"Browose Tapped");
        
        isCameraClicked=NO;
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = NO;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        
        [self presentViewController:picker animated:YES completion:NULL];
        
        //}
        
    }
*/
    isBrowserTapped =YES;
    [self startMediaBrowserFromViewController: self usingDelegate: self];


}

-(void)loadVideoRecorder{
    
    if (IS_OS_8_OR_LATER) {   // code for ios 8 or above !!!!!!!!!
        
        
        
        DLog(@"capture Video tapped");
        isBrowserTapped=YES;
        [self.view endEditing:YES];
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            
            /*UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Message!" message:@"Camera is not present!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
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
        
        
    }else { // for IOS less than 7
        
        DLog(@"capture Video tapped");
        
        isBrowserTapped=YES;
        [self.view endEditing:YES];
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            
            /*  UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Message!" message:@"Camera is not present!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
             [alert show];
             */
            
            UIAlertController *DoNothing_alrt = [UIAlertController alertControllerWithTitle:@"Message!" message:@"Camera is not present!" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * doNothingAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * alert )
            {
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




// start update location
-(void)StartUpdating
{
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
    {
        [locationManager requestWhenInUseAuthorization];
    }
    [locationManager startUpdatingLocation];
}

#pragma mark location delegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    DLog(@"didFailWithError: %@", error);
    
    
    if([CLLocationManager locationServicesEnabled]){
        
        DLog(@"Location Services Enabled");
        
        if ([CLLocationManager  authorizationStatus] == kCLAuthorizationStatusDenied) {
            
            /*without_Address = [[UIAlertView alloc]initWithTitle:@"Location auto capturing is off" message:@"Please enter the location for your story" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Submit", nil];
            without_Address.alertViewStyle=UIAlertViewStylePlainTextInput;
            UITextField *txtLocation = [without_Address textFieldAtIndex:0];
            txtLocation.delegate     = self;
            txtLocation.text         = @"";
            txtLocation.clearButtonMode = UITextFieldViewModeWhileEditing;
            [txtLocation setPlaceholder:@"Location"];
            [self.view endEditing:YES];
            [without_Address show];*/
            locationStatus=0;
            [self createCustomUiField:locationStatus];

            
            
        }
        
    }
    else {
        
        
      /*  without_Address = [[UIAlertView alloc]initWithTitle:@"Location auto capturing is off" message:@"Please enter the location for your story" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Submit", nil];
        without_Address.alertViewStyle=UIAlertViewStylePlainTextInput;
        UITextField *txtLocation = [without_Address textFieldAtIndex:0];
        txtLocation.delegate     = self;
        txtLocation.text         = @"";
        txtLocation.clearButtonMode = UITextFieldViewModeWhileEditing;
        [txtLocation setPlaceholder:@"Location"];
        [self.view endEditing:YES];
        [without_Address show];*/
        locationStatus=0;
        [self createCustomUiField:locationStatus];

        
        
    }
    
    
    
    
    
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
    
    
    if ([Utility connected] == YES )
    {
        
        NSString *urlString = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f&amp;sensor=false",lat,lon];
        [sync getServiceCall:urlString withParams:nil];
    }
    else
    {
        
        
    }
    
    
    
    
}


#pragma mark Web Service Delegate

-(void)syncSuccess:(id)responseObject
{
    
    DLog(@"%@",responseObject);
    
    DLog(@"op address is ===%@",[[[responseObject valueForKey:@"results"] valueForKey:@"formatted_address"]objectAtIndex:0]);
    
    [[NSUserDefaults standardUserDefaults]setValue:[NSString stringWithFormat:@"%@",[[[responseObject valueForKey:@"results"] valueForKey:@"formatted_address"]objectAtIndex:0]] forKey:@"address_Default"];
    
    checkStr = [[NSUserDefaults standardUserDefaults]stringForKey:@"address_Default"];
    
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"LocationCheck"] isEqualToString:@"LocationOn"]) {
        
        locationStatus=1;
        [self createCustomUiField:locationStatus];
        
        
    }else{

        locationStatus=0;
        [self createCustomUiField:locationStatus];
        
        
        
//        without_Address = [[UIAlertView alloc]initWithTitle:@"Unable to get current Location." message:@"Please enter the location for your story" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Submit", nil];
//        without_Address.alertViewStyle=UIAlertViewStylePlainTextInput;
//        UITextField *txtLocation = [without_Address textFieldAtIndex:0];
//        txtLocation.delegate     = self;
//        txtLocation.text         = @"";
//        txtLocation.clearButtonMode = UITextFieldViewModeWhileEditing;
//        [txtLocation setPlaceholder:@"Location"];
//        [self.view endEditing:YES];
//        [without_Address show];
        
        
    }
}

-(void)syncFailure:(NSError*) error
{
    
    //[self alertMessage:@"Message" message:[error localizedDescription]];;
    
    //checkStr = @"";
    if (!checkStr) {
        
        without_Address = [[UIAlertView alloc]initWithTitle:@"Unable to get current Location." message:@"Please enter the location for your story" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Submit", nil];
        without_Address.alertViewStyle=UIAlertViewStylePlainTextInput;
        UITextField *txtLocation = [without_Address textFieldAtIndex:0];
        txtLocation.delegate     = self;
        txtLocation.text         = @"";
        txtLocation.clearButtonMode = UITextFieldViewModeWhileEditing;
        [txtLocation setPlaceholder:@"Location"];
        [self.view endEditing:YES];
        [without_Address show];
        
    }else{
        
        
        //[self createCustomUiField];
        
    }
    
}

-(NSString*)sendCategoryId :(NSString*)textFieldText{
    
    
    NSString *tempCategoryId;
    for (int index=0; index <app.final_Id_Array.count; index++) {
        
        NSString *tempString=[[app.final_Id_Array objectAtIndex:index] valueForKey:@"Name"];
        
        if ([tempString isEqualToString:textFieldText]) {
            
            tempCategoryId=[[app.final_Id_Array objectAtIndex:index] valueForKey:@"Id_Category"];
            return tempCategoryId;
            
        }else{
            
            // nothing...
        }
    }
    
    return NULL;
}




@end
