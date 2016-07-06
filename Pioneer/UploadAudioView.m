//
//  UploadAudioView.m
//  pioneer
//
//  Created by amit bahuguna on 7/29/14.
//  Copyright (c) 2014 CYNOTECK. All rights reserved.
//

#import "UploadAudioView.h"
#import "RecordAudioView.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "IQActionSheetPickerView.h"
#import "Setting_Screen.h"
#import "KeyChainValteck.h"
#import <QuartzCore/QuartzCore.h>
#import "UploadPhoto.h"
#import "UploadTextView.h"
#import "UploadVideoView.h"
#import <CommonCrypto/CommonHMAC.h>
#import "Base64.h"
#import <CommonCrypto/CommonDigest.h>
#include <ifaddrs.h>
#include <arpa/inet.h>
#import "DataClass.h"
#import "PlayRecordedAudio.h"

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
NSString *letter3 = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

@interface UploadAudioView ()<SyncDelegate,CLLocationManagerDelegate>
{
    SyncManager *sync;
    CLLocationManager *locationManager;
    
    
    NSURLSessionUploadTask *task;
    NSMutableData *responseData;
    
    UIVisualEffectView *visualEffectView;
    UIView * customAlertView;
    NSString *checkStr;
    DataClass *objectDataClass;
    
    // used in date .
    NSString* firstDate;
    NSString * secondDate;
    NSDate *now2;
    NSDateFormatter *dateFormatter1;
    NSDate * mow3;
    NSDateFormatter *dateFormatter2;
    NSDateFormatter *df;
    NSDate *date1;
    NSDate *date2;
    long timediff;
    NSString *Finaltoken;
 NSMutableDictionary *AudiocollectedDict;
    NSData *audiotransferData;
     NSString *categoryId_String;
    //added on 11 april
    NSData* data;
    NSString *fileName;
    NSString* localUrl;
    NSString *finalUnique;
    NSString*captureduniqueName;
    NSString * postNotificationData; // for postnotification.
    AppDelegate *app;
    
    
    
    BOOL checkUserComingFrom;
    NSMutableArray *LocalDataHandleArray;
    

    NSData* videoData;
    NSString *tempPath ;
    UIImage *imageThumbnail;
    NSString*finalUniqueVideo;
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

@implementation UploadAudioView
@synthesize audioDataDictionary;           //New changes
@synthesize with_Address_Optional_Written;
@synthesize img_ForSuccess_Unsuccess,view_ForSuccess_Unsuccess,ok_For_Success_Outlet;
@synthesize txt_Title,txt_View;
@synthesize circular_Progress_View;
@synthesize written_Address;
@synthesize cut_Sec,lbl_AddStory_Outlet,lbl_finalPicker_Selected,lbl_Select_new_Category,lbl_selected_File_Outlet,lbl_Title,image_AddStory_Outlet,image_Select_NewCategory,image_Title_Outlet,img_View_Selected_File_Outlet,btn_Reset_Outlet,btn_Selected_new_Category_Outlet,btn_Upload_Outlet;
@synthesize capture_Audio_Outlet;
@synthesize isItFirstService,responseDataForRestOfTheDetailService;
@synthesize isPickerTapped,tempArray,mainImage;

@synthesize tabBarController,audioTabBar,videoTabBar,textTabBar,photoTabBar,submitForreview_outlet;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    sizeOfSubview=[[UIScreen mainScreen]bounds].size;

    size = [[UIScreen mainScreen]bounds].size;
    sync = [[SyncManager alloc] init];
    sync.delegate = self;


    app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    
    img_ForSuccess_Unsuccess.userInteractionEnabled = YES;
    
    AudiocollectedDict = [NSMutableDictionary dictionary];
    
    
    
    audioDataDictionary=[NSMutableDictionary dictionary];
    //[lbl_output_category setUserInteractionEnabled:NO];

    
    lbl_finalPicker_Selected.textColor=[UIColor grayColor];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(callNotification) name:@"doChangeForIt" object:nil];

    //Conforming
    tabBarController.delegate = self;
    
    
    videoTabBar.tag = 1;
    photoTabBar.tag = 2;
    audioTabBar.tag = 3;
    textTabBar.tag  = 4;
    [self.scrollView setScrollEnabled:YES];
    //[img_View_Selected_File_Outlet setHidden:YES];
    
    [self CallMethodForPicker];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];

    objectDataClass=[DataClass getInstance];
    app = (AppDelegate *)[UIApplication sharedApplication].delegate;


    tempArray=objectDataClass.audioDetailsMutableArray;
    
    
    [tabBarController setSelectedItem:[tabBarController.items objectAtIndex:2]];

    [tabBarController setTintColor:[UIColor blackColor]]; // set tab bar selection color white

    // working .....
    LocalDataHandleArray=[[NSMutableArray alloc]init];
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"SubmitArray"] count]==0) {
        
        ///
        
        
    }else{
        
        LocalDataHandleArray=[[[NSUserDefaults standardUserDefaults]valueForKey:@"SubmitArray"] mutableCopy];
        
    }
    
    // end.....
    
    
    
   // [self checkForInternetConnection];
  [self.view setNeedsLayout];
   // lbl_finalPicker_Selected.text=@"";
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeFieldName:)
                                                 name:@"AudioFileName"
                                               object:postNotificationData];
    
    videoTabBar.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    audioTabBar.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    textTabBar.imageInsets  = UIEdgeInsetsMake(6, 0, -6, 0);
    photoTabBar.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    
  //  self.showTemperature.text = [NSString stringWithFormat:@"%0.0f", objectDataClass.temperature];
    
    if (tempArray == NULL) {
        

    }
    
    else{
        
        
        
       // handleView =YES;
        
       // DLog(@"collected data from review view --%@",tempArray);
        [self.view setNeedsLayout];
        
        txt_Title.text = [[tempArray  objectAtIndex:objectDataClass.globalIndexSelection] valueForKey:@"Title"] ;
        txt_View.text =  [[tempArray objectAtIndex:objectDataClass.globalIndexSelection]valueForKey:@"FullStory"];
        lbl_finalPicker_Selected.text =[[tempArray objectAtIndex:objectDataClass.globalIndexSelection] valueForKey:@"uniqueName"];
        
        audiotransferData = [[tempArray objectAtIndex:objectDataClass.globalIndexSelection] valueForKey:@"AudioData"];
        app.recordedData =audiotransferData;
        app.uniqueNameForLableAudio= [[tempArray objectAtIndex:objectDataClass.globalIndexSelection] valueForKey:@"uniqueName"];
        lbl_output_category.text=[[tempArray objectAtIndex:objectDataClass.globalIndexSelection] valueForKey:@"categoryName"];
        
        if (objectDataClass.checkForAudioCurrentCaptureOrNot==YES) {
            
            
        }else{
            
            app.soundFilePathData=[[tempArray objectAtIndex:objectDataClass.globalIndexSelection] valueForKey:@"FileUrlPath"];
            app.recordedData=[[tempArray objectAtIndex:objectDataClass.globalIndexSelection]valueForKey:@"AudioData"];

            
        }
        
    }
}
-(void)changeFieldName:(NSNotificationCenter*)notification{
    
    
    DLog(@"notification center-%@",notification);
    lbl_finalPicker_Selected.text = [[notification valueForKey:@"object"] valueForKey:@"Labelname"];
}

-(void)viewDidLayoutSubviews{
    
    [self.scrollView setContentSize:CGSizeMake(size.width, 540)];
    
   // AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if (app.recordedData==nil ) {
        
    }
    else {
        
        [[NSUserDefaults standardUserDefaults]setValue:@"taken" forKeyPath:@"Audio_Check"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        lbl_selected_File_Outlet.text=@"Recorded audio";
        
        
        lbl_finalPicker_Selected.text = app.uniqueNameForLableAudio;
            
        
        
      }
    
    if (isPickerTapped) {
        
        isPickerTapped=NO;
        
        if (app.recordedData==nil) {
            [self doItResize:@"hide"];
            DLog(@"audio file  is yet to be  taken!");
            
        }
    }else{
        
         NSString *audioCheck = [[NSUserDefaults standardUserDefaults]stringForKey:@"Audio_Check"];
        if (!audioCheck) {
            [self doItResize:@"hide"];
            DLog(@"audio  is yet to be  taken!");
            
        }else{
            
            if (finalCheckForServiceBool) {
                
                // do nothing .....
           
            
            }else{
                
            //  when audio has been taken.....
                [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"Audio_Check"];
                [[NSUserDefaults standardUserDefaults]synchronize];
            DLog(@"audio has been taken!");
            // [self doItResize:@"show"];
            [lbl_selected_File_Outlet setHidden:NO];
            [img_View_Selected_File_Outlet setHidden:NO];
            [lbl_finalPicker_Selected setHidden:NO];
            [cut_Sec setHidden:NO];
                
           // lbl_finalPicker_Selected.text=[self  generateUniqueName];
            }

        }
        
    }
  
}
#pragma mark --
#pragma mark -- TabBar delegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if(item.tag == 1)
    {
        
        DLog(@"Video Tab bar tapped");
        [self checkforNavigationInternetconnection:1];
        
    }else if (item.tag ==2) {
        
        DLog(@"Photo tab bar tapped");
        [self checkforNavigationInternetconnection:2];
        
    }/*else if (item.tag ==3){
        
        DLog(@"Audio Tab bar tapped");
        
        [self checkforNavigationInternetconnection:3];
        
    }*/else if (item.tag ==4) {
        
        DLog(@"Text Tab bar tapped");
        
        [self checkforNavigationInternetconnection:4];
    }
}



-(void) doItResize: (NSString *) hideAndShow
{
    
    lbl_finalPicker_Selected.text = app.uniqueNameForLableAudio;
    
    NSString *hide_Show = hideAndShow;
    
    if ( [hide_Show isEqualToString:@"show"] )
    {
        
        [lbl_selected_File_Outlet setHidden:NO];
        [img_View_Selected_File_Outlet setHidden:NO];
        [lbl_finalPicker_Selected setHidden:NO];
        [cut_Sec setHidden:NO];
        
    }
    else
    {
        [lbl_selected_File_Outlet setHidden:NO];
        [img_View_Selected_File_Outlet setHidden:NO];
        [lbl_finalPicker_Selected setHidden:NO];
        [cut_Sec setHidden:NO];
        
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back_Tapped:(id)sender {
    
    NSArray *array = [self.navigationController viewControllers];
    
    DLog(@"Audio content from array is :  %@",array);

    
   // AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if ([lbl_output_category.text length]>0 ||  app.recordedData !=nil  || [txt_Title.text length]>0 || [txt_View.text length]>0) {
        
        goBackAlert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Are you sure you want to cancel this news submission?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
        [goBackAlert show];
        
    }else{
        
       // AppDelegate *app =  (AppDelegate *)[UIApplication sharedApplication].delegate;
        txt_View.text=nil;
        txt_Title.text=nil;
        lbl_finalPicker_Selected.text=nil;
        lbl_output_category.text=@"Choose Category";
        app.recordedData=nil;
        app.uniqueNameForLableAudio=nil;
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"Audio_Check"];
        [[NSUserDefaults standardUserDefaults]synchronize];

        //[self.navigationController popViewControllerAnimated:NO];
        [self.navigationController popToViewController:[array objectAtIndex:1] animated:NO];
    }
    
}

- (IBAction)capture_audio_tapped:(id)sender{
    
    
    
    if (objectDataClass.audioDetailsMutableArray==nil) {
        
      //  AppDelegate *app =(AppDelegate *)[UIApplication sharedApplication].delegate;
        app.recordedData=nil;
        [self doItResize:@"hide"];
        /*  RecordAudioView *recordview=[[RecordAudioView alloc]initWithNibName:@"RecordAudioView" bundle:Nil];
         
         [self presentViewController:recordview animated:NO completion:nil];
         */
        NSArray *array = [self.navigationController viewControllers];
        
        DLog(@" Text content from array is :  %@",array);
        
        [self.navigationController popToViewController:[array objectAtIndex:2] animated:YES];

        
    }else{
        
        
        RecordAudioView *recordObject=[[RecordAudioView alloc]initWithNibName:@"RecordAudioView" bundle:nil];
        [self.navigationController pushViewController:recordObject animated:YES];
        
        
        
    }
    
    
    
    //isBrowserTapped=YES;
    
    
    
}
- (IBAction)reset_Tapped:(id)sender {
    NSArray *array = [self.navigationController viewControllers];
    
    DLog(@" Text content from array is :  %@",array);
    
    
    
    
  //  AppDelegate *app =  (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    txt_View.text=nil;
    txt_Title.text=nil;
    lbl_finalPicker_Selected.text=nil;
    lbl_output_category.text=nil;
    app.recordedData=nil;
    app.uniqueNameForLableAudio=nil;
    
    if (IS_OS_8_OR_LATER) {
        
    }
    else{
        
        [self doItResize:@"hide"];
    }
   // cutboolValue = YES;
    [self.view setNeedsLayout];
    [self.navigationController popToViewController:[array objectAtIndex:1] animated:NO];
    
}

- (IBAction)upload_Tapped:(id)sender {
    
    //;
    [self.view endEditing:YES];
   // AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    
    
    // NSString *server = [[NSUserDefaults standardUserDefaults]stringForKey:@"connection_Internet"];
    
    if ([Utility connected] == YES) {
    
    
    NSString *alert_Message;
    if ([lbl_finalPicker_Selected.text length]==0 || [lbl_output_category.text length]==0 || [txt_Title.text length]==0 || [txt_View.text  length]==0 || app.recordedData ==nil) {
                            
        if ([lbl_finalPicker_Selected.text length]==0 || app.recordedData==nil) {
                                
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

        
//        if (!checkStr) {
//            
//            without_Address = [[UIAlertView alloc]initWithTitle:@"Location auto capturing is off" message:@"Please enter the location(city) for your news/story" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Submit", nil];
//            without_Address.alertViewStyle=UIAlertViewStylePlainTextInput;
//            UITextField *txtLocation = [without_Address textFieldAtIndex:0];
//            txtLocation.delegate     = self;
//            txtLocation.text         = @"";
//            txtLocation.clearButtonMode = UITextFieldViewModeWhileEditing;
//            [txtLocation setPlaceholder:@"Location"];
//            [without_Address show];
//            
//        }else{
//            
//        /*    with_Address = [[UIAlertView alloc]initWithTitle:@"Your current location" message:[NSString stringWithFormat:@"%@\n\nIf incorrect, please enter the location(city) for your news/story",checkStr] delegate:self cancelButtonTitle:@"Submit" otherButtonTitles:nil ,nil];
//            with_Address.alertViewStyle=UIAlertViewStylePlainTextInput;
//            
//            UITextField *txtLocation = [with_Address textFieldAtIndex:0];
//            txtLocation.delegate     = self;
//            txtLocation.text         = @"";
//            txtLocation.clearButtonMode = UITextFieldViewModeWhileEditing;
//            [txtLocation setPlaceholder:@"Location"];
//            [with_Address show];
//           */
//            
//            [self createCustomUiField];
//        }
        
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

            [self  sendAudio_ToServer];
 //       }
        
        
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
            [self  sendAudio_ToServer];

            DLog(@"seocnd one ");
            DLog(@"Entered: %@",[[alertView textFieldAtIndex:0] text]);
            
            //  [with_Address dismissWithClickedButtonIndex:2 animated:YES];
            
            
        }
        
    }else if (alertView ==goBackAlert){
        
        NSArray *array = [self.navigationController viewControllers];
        
        DLog(@" Text content from array is :  %@",array);

        
        if (buttonIndex==0) {
            
            // do nothing....
            //cancel tapped..
            
            
        }else if (buttonIndex==1){
            
           // AppDelegate *app =  (AppDelegate *)[UIApplication sharedApplication].delegate;
            txt_View.text=nil;
            txt_Title.text=nil;
            lbl_finalPicker_Selected.text=nil;
            lbl_output_category.text=@"Choose Category";
            app.recordedData=nil;
            app.uniqueNameForLableAudio=nil;
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"Audio_Check"];
            [[NSUserDefaults standardUserDefaults]synchronize];

         //   [self.navigationController popViewControllerAnimated:YES];
           
            [self.navigationController popToViewController:[array objectAtIndex:1] animated:NO];
        }
        

    }else if (try_AgainInternet_Check==alertView){
        
        
        NSArray *array = [self.navigationController viewControllers];
        [self.navigationController popToViewController:[array objectAtIndex:1] animated:NO];
        

        
        
        
        
       /*
        if (buttonIndex==0) {
            
            // for first send service....
            // cancel tapped.......
            DLog(@"cancel_Tapped");
            
            ok_For_Success_Outlet.tag=2;
            CGSize size = [[UIScreen mainScreen]bounds].size;
            
            if (size.height==480) {
                [img_ForSuccess_Unsuccess setImage:[UIImage imageNamed:@"unsuccess3.5.png"]];
                
                UIButton *btnUpload=[[UIButton alloc]initWithFrame:CGRectMake(102.0, 299.0, 115.0, 38.0)];
                
                
                [btnUpload setImage:[UIImage imageNamed:@"btn_ip5.png"] forState:UIControlStateNormal];
                [btnUpload addTarget:self action:@selector(btn_Success_Tapped:) forControlEvents:UIControlEventTouchUpInside];
                
                // [button addTarget:self
                //     action:@selector(aMethod:)
                // forControlEvents:UIControlEventTouchUpInside];
                [view_ForSuccess_Unsuccess addSubview:btnUpload];
                
                
            }else{
                [img_ForSuccess_Unsuccess setImage:[UIImage imageNamed:@"unsuccess.png"]];
                UIButton *btnUpload=[[UIButton alloc]initWithFrame:CGRectMake(103.0, 345.0, 115.0, 38.0)];
                [btnUpload setImage:[UIImage imageNamed:@"btn_ip5.png"] forState:UIControlStateNormal];
                [btnUpload addTarget:self action:@selector(btn_Success_Tapped:) forControlEvents:UIControlEventTouchUpInside];
                
                [view_ForSuccess_Unsuccess addSubview:btnUpload];
            }
            
            [self.view addSubview:self.view_ForSuccess_Unsuccess];
            
            
         */
        }else if (buttonIndex==1){
            
            if (isItFirstService==1) {
                
                // for first service ....
                // ok tapped Try Again....
                DLog(@"OK_Tapped");
                
                [self  sendAudio_ToServer];
                
                
                
            }else{
                // for second service ...
                // ok tapped Try Again....
                DLog(@"OK_Tapped");
                [self  sendRestOfTheTextDATA:responseDataForRestOfTheDetailService];
                
            }
            
        }
        
    }
    
    
    



-(void)sendAudio_ToServer{
    //////for gradient......
    
    finalCheckForServiceBool=YES;
    layer = [CAGradientLayer layer];
    layer.frame = self.view.bounds;
    UIColor *blackColor = [UIColor colorWithWhite:0.0f alpha:1.0f];
    UIColor *clearColor = [UIColor colorWithWhite:0.0f alpha:1.0f];
    layer.colors = [NSArray arrayWithObjects:(id)clearColor.CGColor, (id)blackColor.CGColor, nil];
    [self.view.layer insertSublayer:layer atIndex:1];

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
    
    

    
    //////for gradient.......
    float circular_Progress_Viewwidth = (sizeOfSubview.width * 54)/100;
    float circular_Progress_Viewheight = (sizeOfSubview.height * 23.7)/100;
    
    [self.view setAlpha:0.4];
    [self.view setUserInteractionEnabled:NO];
    self.circular_Progress_View.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width / 2 -circular_Progress_Viewwidth/2), ([UIScreen mainScreen].bounds.size.height / 2 -circular_Progress_Viewheight/2), circular_Progress_Viewwidth, circular_Progress_Viewheight);
    [self.view addSubview:self.circular_Progress_View];
    
    
    self.circular_Progress_View.thicknessRatio = 0.111111;
    self.circular_Progress_View.outerBackgroundColor=[UIColor lightGrayColor];
    self.circular_Progress_View.innerBackgroundColor=[UIColor lightGrayColor];

    self.circular_Progress_View.progressFillColor=[UIColor redColor];

    UILabel *percentSignLabel = [[UILabel alloc] initWithFrame:CGRectMake((circular_Progress_View.frame.size.width *63.9)/100, (circular_Progress_View.frame.size.height*41)/100, (circular_Progress_View.frame.size.width *14.5)/100, (circular_Progress_View.frame.size.width *14.5)/100)];
    [self.circular_Progress_View addSubview:percentSignLabel];
    percentSignLabel.text = @"%";
    percentSignLabel.textColor = [UIColor whiteColor];
    percentSignLabel.font = [UIFont systemFontOfSize:25];
    [self.circular_Progress_View bringSubviewToFront:percentSignLabel];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    
    
    //timesgroupcrapi  http://timesgroupcrapi.cloudapp.net/api/UserDet
   
   
    
    NSString * urlString = [NSString stringWithFormat:@"%@%@/blobs?id=%@&token=%@",kBaseURL,kAPI,[[NSUserDefaults standardUserDefaults]stringForKey:@"userID_Default"],[GlobalStuff generateToken]];
    
    NSLog(@"url fro audio--%@",urlString);
    
    NSURL * url =[NSURL URLWithString:urlString];
 
    
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
   // audioData = [[NSData alloc] initWithContentsOfFile:[_audioRecorder.url path]];
  //  AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (app.recordedData) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@; filename=%@\r\n", @"imageFormKey",lbl_finalPicker_Selected.text] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:app.recordedData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    // set the content-length
    NSString *postLength = [NSString stringWithFormat:@"%d", [body length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    task = [session uploadTaskWithStreamedRequest:request];

    
    [task resume];
    
    
    
}

//// DELEGATE METHODS FOR NSURLSESSION

//// delegate methods

#pragma mark - NSURLSessionTaskDelegate

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend
{
    DLog(@"%lld %lld %lld", bytesSent, totalBytesSent, totalBytesExpectedToSend);
    
    [lbl_selected_File_Outlet setHidden:YES];
    [img_View_Selected_File_Outlet setHidden:YES];
    [lbl_finalPicker_Selected setHidden:YES];
    [cut_Sec setHidden:YES];
        
    if (totalBytesExpectedToSend==totalBytesSent) {
        
    }
    
    float progress = (double)totalBytesSent / (double)totalBytesExpectedToSend;
    
    dispatch_async(dispatch_get_main_queue(), ^{


        self.circular_Progress_View.progress = progress;
        UILabel *percentSignLabel = [[UILabel alloc] initWithFrame:CGRectMake((circular_Progress_View.frame.size.width *63.9)/100, (circular_Progress_View.frame.size.height*41)/100, (circular_Progress_View.frame.size.width *14.5)/100, (circular_Progress_View.frame.size.width *14.5)/100)];
        [self.circular_Progress_View addSubview:percentSignLabel];
        percentSignLabel.text = @"%";
        percentSignLabel.textColor = [UIColor whiteColor];
        percentSignLabel.font = [UIFont systemFontOfSize:25];
        [self.circular_Progress_View bringSubviewToFront:percentSignLabel];
        
    });

    
    }

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task needNewBodyStream:(void (^)(NSInputStream *bodyStream))completionHandler
{
    // completionHandler(self.inputStream);
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    DLog(@"%s: error = %@; data = %@", __PRETTY_FUNCTION__, error, [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.circular_Progress_View removeFromSuperview];
        [self.view setAlpha:1];
        [self.view setUserInteractionEnabled:YES];
       // [layer removeFromSuperlayer];

        
        if (error==nil) {
            
            DLog(@"successfully submitted");
            
            
            
            responseDataForRestOfTheDetailService =[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
            [self sendRestOfTheTextDATA:[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]];
            

        }else{
            
            DLog(@"error available!");
            // [self   sendVideo_ToServer];
            isItFirstService=1;
            
            try_AgainInternet_Check = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Internet connection is not available. Please try again." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [try_AgainInternet_Check show];
            
//            ok_For_Success_Outlet.tag=2;
//            CGSize size = [[UIScreen mainScreen]bounds].size;
//            
//            if (size.height==480) {
//                [img_ForSuccess_Unsuccess setImage:[UIImage imageNamed:@"unsuccess3.5.png"]];
//                
//                
//            }else{
//                [img_ForSuccess_Unsuccess setImage:[UIImage imageNamed:@"unsuccess.png"]];
//            }
//            
//            [self.view addSubview:self.view_ForSuccess_Unsuccess];
            
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

/////////
-(void)sendRestOfTheTextDATA:(NSString *)Id_BlobFromService{
    
   // __block  NSString *categoryId_String;
    
   // AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [ [app.categoryNameArray objectAtIndex:0] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        
        NSString *campareStr = [NSString stringWithFormat:@"%@",[[app.categoryNameArray objectAtIndex:0]objectAtIndex:idx]];
        if ([campareStr isEqualToString:lbl_output_category.text]) {
            
            categoryId_String = [NSString stringWithFormat:@"%@",[[app.id_CategoryArray objectAtIndex:0]objectAtIndex:idx]];
            
        }
        
    }];
    
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    
    //timesgroupcrapi   http://timesgroupcrapi.cloudapp.net/api/UserDet

   
    
    
    NSString * urlStringTest = [NSString stringWithFormat:@"%@%@/CJDetails?token=%@", kBaseURL,kAPI, [GlobalStuff generateToken]];
    
    
    
    //  NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    DLog(@"url foraudio rest --%@",urlStringTest);
    
    NSURL *url =[ NSURL URLWithString:urlStringTest];
    
    
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                           timeoutInterval:300];
    
    
    NSMutableDictionary *finalDictionary = [NSMutableDictionary dictionary];
    NSMutableDictionary *headerDict = [NSMutableDictionary dictionary];
    NSMutableDictionary *dictionaryTemp = [NSMutableDictionary dictionary];

    
    ///////////////////////////
//    // getting .....
//    NSString *  KEY_PASSWORD = @"com.toi.app.password";
//    NSString *    idfv = [[KeyChainValteck keyChainLoadKey:app.putValueToKeyChain] valueForKey:KEY_PASSWORD];
    // getting ...
    
    //////////////////////////
    
    [headerDict setValue:@"" forKey:@"DeviceId"]; //idfv
    [headerDict setValue:@"" forKey:@"UserId"];  // user id is yet to set ....[[NSUserDefaults standardUserDefaults] stringForKey:@"userID_Default"]
    [headerDict setValue:@"" forKey:@"Source"];
    
    [dictionaryTemp setValue:txt_Title.text forKey:@"Title"];
    [dictionaryTemp setValue:txt_View.text forKey:@"FullStory"];
    [dictionaryTemp setValue:categoryId_String forKey:@"Id_Category"];    // picker view 's category.....
    [dictionaryTemp setValue:[[NSUserDefaults standardUserDefaults] stringForKey:@"userID_Default"] forKey:@"SubmittedBy"];         // user id need to get set here .
    [dictionaryTemp setValue:@"Submitted" forKey:@"JournalStatus"];
    [dictionaryTemp setValue:@"3" forKey:@"Id_MainCategory"];
    [dictionaryTemp setValue:Id_BlobFromService forKey:@"Id_Blob"];
    
      checkStr =    [[NSUserDefaults standardUserDefaults]stringForKey:@"address_Default"];
  
    if (locationStatus==1) {
    
        if (!checkStr) {
            // when it's empty!!!!!
            
            
            [dictionaryTemp setValue:written_Address forKeyPath:@"LocationDetails"];
            
        }else{
            
            // when it's not empty  (address is not empty!!!!)
            
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
    
    DLog(@" value of addres is ======%@",[dictionaryTemp valueForKey:@"LocationDetails"]);
    
    [finalDictionary setObject:headerDict forKey:@"header"];
    [finalDictionary setValue:dictionaryTemp forKey:@"data"];
    
    
    DLog(@"Request ON Audio ===%@",finalDictionary);
    
    
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
                                                           NSLog(@"Response:%@ %@\n", response, error);
                                                           if(error == nil)
                                                           {
//                                                               NSString * text = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
//                                                               NSLog(@"final audio o/p is  ==== %@",text);
                                                               
                                                               NSError *jsonError;
                                                               NSArray *array = [NSJSONSerialization JSONObjectWithData:data
                                                                                                                options:kNilOptions
                                                                                                                  error:&jsonError];
                                                               
                                                               
                                                               NSLog(@"array is ====%@",array);
                                                               
                                                               
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
                                                            //   NSString *strMessage = [NSString stringWithFormat:@"%@",[[array valueForKey:@"data"]valueForKey:@"ErrorMessage"]];
                                                               
                                                               
                                                               if ([strId isEqualToString:@"114"]) {
                                                                   
                                                                   
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
                                                                   
                                                                   
                                                                   
                                                                   NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                                                                   [formatter setDateFormat:@"hh:mm:ss"];
                                                                   NSString *time=[formatter stringFromDate:[NSDate date]];
                                                                   NSLog(@"Time is ======%@",time);
                                                                   
                                                                   
                                                                   
                                                                   if([app.myFinalArray count]==0){
                                                                       
                                                                       app.myFinalArray=[[NSMutableArray alloc]init];
                                                                       
                                                                   }else{
                                                                       
                                                                       //do Nothing
                                                                       
                                                                   }
                                                                   
                                                                
                                                                   
                                                                   [audioDataDictionary setValue:[lbl_output_category.text uppercaseString] forKey:@"CategoryName"];
                                                                   [audioDataDictionary setValue:txt_Title.text forKey:@"Title"];
                                                                   [audioDataDictionary setValue:txt_View.text forKey:@"FullStory"];
                                                                   [audioDataDictionary setValue:@"AUDIO" forKey:@"Type"];
                                                                   
                                                                   [audioDataDictionary setValue:date forKey:@"Date"];
                                                                   [audioDataDictionary setValue:time forKey:@"Time"];
                                                                   [audioDataDictionary setValue:app.soundFilePathData forKey:@"AudioPath"];
                                                                   NSLog(@"audioDataDictionary=====%@",audioDataDictionary);
                                                                   NSLog(@"audioUrl is=========%@",app.soundFilePathData);
                                                                   
                                                                   
                                                                   NSLog(@"AudiodataDictionary======%@",audioDataDictionary);
                                                                
                                                                   if([app.myFinalArray count]<15){
                                                                       
                                                                       [app.myFinalArray addObject:audioDataDictionary];
                                                                   }
                                                                   else{
                                                                       [app.myFinalArray removeObjectAtIndex:0];
                                                                   }
                                                                   
                                                                   
                                                                   [[NSUserDefaults standardUserDefaults]setValue:app.myFinalArray forKey:@"MyArray"];
                                                                   // [[NSUserDefaults standardUserDefaults]synchronize];
                                                                   
                                                                   
                                                                   
                                                                   

                                                                   
                                                                   
                                                                   
                                                                   
//                                                                   DLog(@"My Array is ===== %@",[[NSUserDefaults standardUserDefaults]objectForKey:@"MyArray"]);
                                                                   
                                                                   ok_For_Success_Outlet.tag=1;
                                                                   
                                                                   
                                                                       
                                                                   [img_ForSuccess_Unsuccess setImage:[UIImage imageNamed:@"success.png"]];
                                                                   UIButton *btnUpload=[[UIButton alloc]initWithFrame:CGRectMake((self.selectedView.frame.size.width *15)/100, (self.selectedView.frame.size.height *84)/100, (self.selectedView.frame.size.width *25.9)/100, (self.selectedView.frame.size.height *12)/100)];
                                                                   [btnUpload setImage:[UIImage imageNamed:@"Sounds Good Btn.png"] forState:UIControlStateNormal];
                                                                   [btnUpload addTarget:self action:@selector(btn_Success_Tapped:) forControlEvents:UIControlEventTouchUpInside];
                                                                   btnUpload .clipsToBounds = YES;
                                                                   [btnUpload.layer setCornerRadius:4.5];
                                                                   [self.selectedView.layer setCornerRadius:4.0];

                                                                   // Add effect to an effect view
                                                                   UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
                                                                   visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
                                                                   visualEffectView.frame = self.view.frame;
                                                                   [self.view_ForSuccess_Unsuccess addSubview:visualEffectView];
                                                                   // end of blur effect
   
                                                                   
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
                                                                   
                                                                   isItFirstService=2;
                                                                   try_AgainInternet_Check = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Error while uploading audio file." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                                                                   [try_AgainInternet_Check show];
                                                              
                                                                   
                                                                   
                                                               
                                                               }
                                                               
                                                               
                                                               
                                                           }else {
                                                
                                                               // if not successfull............
                                                               isItFirstService=2;
//                                                               try_AgainInternet_Check = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Internet connection is not available. Please try again." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
             
                                                                try_AgainInternet_Check = [[UIAlertView alloc]initWithTitle:@"Alert" message:error.localizedDescription delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                                                               
                                                               [try_AgainInternet_Check show];
                                                               
                                                               
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

                                                               

                                                           }
                                                           
                                                       }];
    [dataTask resume];
    
}

/*
#pragma mark ####################################################################
#pragma mark ##############      TextField Delegate    ##########################
#pragma mark ####################################################################

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    
    //textField.text=@"";
    static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
    static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
    static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
    static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
    static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;
    
    CGRect textFieldRect;
    CGRect viewRect;
    
    
    textFieldRect =[self.view.window convertRect:textField.bounds fromView:textField];
    viewRect =[self.view.window convertRect:self.view.bounds fromView:self.view];
    
    
    CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator = midline - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    
    if (heightFraction < 0.0)
    {
        heightFraction = 0.0;
    }
    else if (heightFraction > 1.0)
    {
        heightFraction = 1.0;
    }
    
    UIInterfaceOrientation orientation =[[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ||orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    }
    else
    {
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    
    CGRect viewFrame;
    
    viewFrame= self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    if(textField.tag==0)
    {
        static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
        CGRect viewFrame;
        
        viewFrame= self.view.frame;
        viewFrame.origin.y += animatedDistance;
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
        
        
        [self.view setFrame:viewFrame];
        [UIView commitAnimations];
        
    }
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return TRUE;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view  endEditing:YES]; //may be not required
    [super touchesBegan:touches withEvent:event]; //may be not required
    [self  dismissControls];
}
- (void)dismissControls
{
    [self.view  endEditing:YES]; //may be not required
}
*/
#pragma mark -
#pragma mark ---------------               RESIGN KEYBOARD on touch Method                ---------------
#pragma mark -





#pragma mark -
#pragma mark ---------------               Text View on touch Method                ---------------
#pragma mark -

/*
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        if(txt_View.text.length == 0){
            txt_View.textColor = [UIColor lightGrayColor];
            // txt_View.text = @"Enter Comment Here";
            [txt_View resignFirstResponder];
        }
        return NO;
    }
    
    return YES;
}
*/


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

//- (void)textViewDidBeginEditing:(UITextView *)textView
//{
//    //textField.text=@"";
//	static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
//	static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
//	static const CGFloat MAXIMUM_SCROLL_FRACTION = 1.0;
//	static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
//	static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;
//	
//	CGRect textFieldRect;
//	CGRect viewRect;
//	
//	
//	textFieldRect =[self.view.window convertRect:textView.bounds fromView:textView];
//	viewRect =[self.view.window convertRect:self.view  .bounds fromView:self.view  ];
//	
//	
//	CGFloat midline = textFieldRect.origin.y + 1.0 * textFieldRect.size.height;
//	CGFloat numerator = midline - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
//	CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height;
//	CGFloat heightFraction = numerator / denominator;
//	
//	if (heightFraction < 0.0)
//	{
//		heightFraction = 0.0;
//	}
//	else if (heightFraction > 1.0)
//	{
//		heightFraction = 1.0;
//	}
//	
//	UIInterfaceOrientation orientation =[[UIApplication sharedApplication] statusBarOrientation];
//	if (orientation == UIInterfaceOrientationPortrait ||orientation == UIInterfaceOrientationPortraitUpsideDown)
//	{
//		animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
//	}
//	else
//	{
//		animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
//	}
//	
//	CGRect viewFrame;
//	
//	viewFrame= self.view  .frame;
//	viewFrame.origin.y -= animatedDistance;
//	
//	
//	[UIView beginAnimations:nil context:NULL];
//	[UIView setAnimationBeginsFromCurrentState:YES];
//	[UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
//	
//	[self.view   setFrame:viewFrame];
//	
//	[UIView commitAnimations];
//}
//- (void)textViewDidEndEditing:(UITextView *)textView
//{
//    [textView resignFirstResponder];
//	if(textView.tag==0)
//	{
//		static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
//		CGRect viewFrame;
//		
//		viewFrame= self.view  .frame;
//		viewFrame.origin.y += animatedDistance;
//		
//		[UIView beginAnimations:nil context:NULL];
//		[UIView setAnimationBeginsFromCurrentState:YES];
//		[UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
//		
//		
//		[self.view   setFrame:viewFrame];
//		[UIView commitAnimations];
//        
//    }
//    
//}

/////// text view delegate ends here!!!!!!


- (IBAction)cut_Selected_FileTapped:(id)sender {
    
    // AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [self doItResize:@"hide"];
     app.recordedData=nil;
    lbl_finalPicker_Selected.text=nil;
    app.uniqueNameForLableAudio=nil;
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
   // AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [lbl_output_category setItemList:[NSArray arrayWithArray:[app.categoryNameArray objectAtIndex:0]]];
    
    
}

-(void)doneClicked:(UIBarButtonItem*)button
{
    [self.view endEditing:YES];
}



#pragma mark unused code ios 7.
/*
 -(void)actionSheetPickerView:(IQActionSheetPickerView *)pickerView didSelectTitles:(NSArray *)titles
 {
 switch (pickerView.tag)
 {
 case 9: lbl_output_category.text=[titles componentsJoinedByString:@" - "];
 break;
 default:
 break;
 }
 }

- (IBAction)btn_Selected_new_Category_Tapped:(id)sender {
    
    [self.view endEditing:YES];
    
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    
        if ([app.categoryNameArray count]==0 || [app.id_CategoryArray count]==0) {
    
           // NSLog(@"quite empty!!!!");
            // [app getCategory];
            
            NSLog(@"coming!");
        }else{
    
    
    isPickerTapped=YES;
    IQActionSheetPickerView *picker = [[IQActionSheetPickerView alloc] initWithTitle:@"Choose Category" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    [picker setTag:9];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [picker setTitlesForComponenets:[NSArray arrayWithArray:app.categoryNameArray]];
    [picker showInView:self.view];
            
        }
    app.yourFileURL
}

*/


- (IBAction)setting_Tapped:(id)sender {
    
    Setting_Screen *setting=[[Setting_Screen alloc]initWithNibName:@"Setting_Screen" bundle:nil];
    [self.navigationController pushViewController:setting animated:YES];

}

#pragma mark --playing recording audio button

- (IBAction)PlayAudioButton:(id)sender {
    
        PlayRecordedAudio * playaudio = [[PlayRecordedAudio alloc] initWithNibName:@"PlayRecordedAudio" bundle:nil];
        app.yourFileURL =[NSURL fileURLWithPath:app.soundFilePathData];
        [self.navigationController pushViewController:playaudio animated:YES];

    
    

}


-(void)callNotification{
    
    if (ok_For_Success_Outlet.tag==1) {
        
        // on successfull completion....
       // AppDelegate *app =  (AppDelegate *)[UIApplication sharedApplication].delegate;
        txt_View.text=nil;
        txt_Title.text=nil;
        lbl_finalPicker_Selected.text=nil;
        lbl_output_category.text=@"Choose Category";
        app.recordedData=nil;
        app.uniqueNameForLableAudio=nil;
        
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"Audio_Check"];
        [[NSUserDefaults standardUserDefaults]synchronize];

        
        //[self.navigationController popViewControllerAnimated:YES];
        
        NSArray * viewhierarchy =[self.navigationController viewControllers];
        DLog(@"view hierarchy are as follow--%@",viewhierarchy);
        
        [self.navigationController popToViewController:[viewhierarchy objectAtIndex:1] animated:YES];
        
    }else{
        // when failed!!!
        
       // AppDelegate *app =  (AppDelegate *)[UIApplication sharedApplication].delegate;
        txt_View.text=nil;
        txt_Title.text=nil;
        lbl_finalPicker_Selected.text=nil;
        lbl_output_category.text=@"Choose Category";
        app.recordedData=nil;
        app.uniqueNameForLableAudio=nil;
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"Audio_Check"];
        [[NSUserDefaults standardUserDefaults]synchronize];

        
       // [self.navigationController popViewControllerAnimated:YES];
        
        NSArray * viewhierarchy =[self.navigationController viewControllers];
        DLog(@"view hierarchy are as follow--%@",viewhierarchy);
        
        [self.navigationController popToViewController:[viewhierarchy objectAtIndex:1] animated:YES];
    }

    
}


- (void)btn_Success_Tapped:(id)sender {
  
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"doChangeForIt" object:nil];
    
    
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
//    if (range.length==1) {
//        return YES;
//    }
//    
//    if (textField ==txt_Title) {
//        
//        if ([txt_Title.text length]>=50) {
//            return NO;
//        }
//        
//    }
//    return YES;
    
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
- (IBAction)Video_Tapped:(id)sender {
    
    [self checkforNavigationInternetconnection:1];
    
}

- (IBAction)Photo_Tapped:(id)sender {
    
    [self checkforNavigationInternetconnection:2];
    
}


- (IBAction)Text_Tapped:(id)sender {
    
    [self checkforNavigationInternetconnection:4];
    
}




#pragma  mark --
#pragma mark -- checkNavigation.
-(void)checkforNavigationInternetconnection:(int)type{
    
        if (type==1) {
            
            
            [self loadVideoRecorder];
            
           /*
            CGSize size = [[UIScreen mainScreen]bounds].size;
            
            if (size.height==480) {
                
                UploadVideoView *uploadV = [[UploadVideoView alloc]initWithNibName:@"UploadVideoView3.5" bundle:nil];
                [self.navigationController pushViewController:uploadV animated:NO];
                
            }else{
                
                UploadVideoView *uploadV = [[UploadVideoView alloc]initWithNibName:@"UploadVideoView" bundle:nil];
                [self.navigationController pushViewController:uploadV animated:NO];
                
            }
            
            */
            
        }else if (type==2) {

            
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

            
        }else if (type==4){
            
           
                UploadTextView *text=[[UploadTextView alloc]initWithNibName:@"UploadTextView" bundle:nil];
                [self.navigationController pushViewController:text animated:NO];
                
            
        }
}

#pragma mark -- Adding custom labels, textfield and buttons

-(void)createCustomUiField :(int)locationStatusLocal  {
    
    // creting a custom view which will be like a alertview....
    float customAlertwidth = (sizeOfSubview.width * 95)/100;
    float customAlertheight = (sizeOfSubview.height * 56.6)/100;
    
    customAlertView = [[UIView alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width / 2 -customAlertwidth/2), ([UIScreen mainScreen].bounds.size.height / 2 -customAlertheight/2), customAlertwidth, customAlertheight)];
    
    //self.view.center = customAlertView.center;
    [customAlertView setBackgroundColor: [UIColor whiteColor]];
    customAlertView.clipsToBounds = YES;
    [customAlertView.layer setCornerRadius:4.5];
    
    
    // creating a custom label ....
    UILabel * confirmLocationlabel = [[UILabel alloc] initWithFrame:CGRectMake((customAlertView.frame.size.width*14)/100, (customAlertView.frame.size.height*9.3)/100, (customAlertView.frame.size.width*69)/100, (customAlertView.frame.size.height*6.8)/100)];
    [confirmLocationlabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:20.0]];
    confirmLocationlabel.text = @"Confirm your location";
    [confirmLocationlabel setTextAlignment:NSTextAlignmentCenter];
    [confirmLocationlabel setTextColor:[UIColor grayColor]];
    
    // for location logo..
    UIImageView * locationImage;// = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 70.0, 24.0, 24.0)];
    
    UILabel * enteredLocation = [[UILabel alloc] init];
    
    
    enteredLocation.numberOfLines =3;
    //enteredLocation.adjustsFontSizeToFitWidth = YES;
    //enteredLocation.lineBreakMode = NSLineBreakByWordWrapping;
    
    
//    if (locationStatusLocal ==1) {
//        
//        locationImage = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 70.0, 24.0, 24.0)];
//        //        initWithFrame:CGRectMake(25.0, 57.0, 250.0, 80.0)]
//        [enteredLocation setFrame:CGRectMake(25.0, 57.0, 250.0, 80.0)];
//        [enteredLocation setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
//        enteredLocation.text = checkStr;
//    }else{
//        
//        locationImage = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 70, 30.0, 30.0)];
//        [enteredLocation setFrame:CGRectMake(25.0, 45, 250.0, 80.0)];
//        [enteredLocation setFont:[UIFont fontWithName:@"Roboto-Regular" size:18.0]];
//        enteredLocation.text = @"Location auto capturing is off.";
//        
//    }
    
    if (locationStatusLocal ==1) {
        
        locationImage = [[UIImageView alloc] initWithFrame:CGRectMake(10.0, (customAlertView.frame.size.height*19.8)/100, 30.0, 30.0)];
        //        initWithFrame:CGRectMake(25.0, 57.0, 250.0, 80.0)]
        [enteredLocation setFrame:CGRectMake((customAlertView.frame.size.width*8.2)/100, (customAlertView.frame.size.height*17.7)/100, (customAlertView.frame.size.width*82.2)/100, (customAlertView.frame.size.height*24.9)/100)];
        
        [enteredLocation setFont:[UIFont fontWithName:@"Roboto-Regular" size:(((customAlertView.frame.size.height*6.8)/100)*81.7)/100]];
        enteredLocation.text = checkStr;
    }else{
        
        locationImage = [[UIImageView alloc] initWithFrame:CGRectMake(10.0, (customAlertView.frame.size.height*26.8)/100, 30.0, 30.0)];
        [enteredLocation setFrame:CGRectMake((customAlertView.frame.size.width*8.2)/100, (customAlertView.frame.size.height*17.7)/100, (customAlertView.frame.size.width*82.2)/100, (customAlertView.frame.size.height*25.9)/100)];
        [enteredLocation setFont:[UIFont fontWithName:@"Roboto-Regular" size:(((customAlertView.frame.size.height*6.8)/100)*81.7)/100]];
        enteredLocation.text = @"Location auto capturing is off.";
        
    }

    [locationImage setContentMode:UIViewContentModeScaleAspectFill];
    [locationImage setImage:[UIImage imageNamed:@"location01@2x.jpg"]];
    
    
    [enteredLocation setTextAlignment:NSTextAlignmentCenter];
    
    // custom label
    
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
    
    
    
    //custom textfield for Streets
    
    StreetTxt = [[MYTextField alloc] initWithFrame:CGRectMake((customAlertView.frame.size.width*2.6)/100, (customAlertView.frame.size.height*55.7)/100, (customAlertView.frame.size.width*94.7)/100, (customAlertView.frame.size.height*9.3)/100)];
    [StreetTxt setFont:[UIFont fontWithName:@"Roboto-Thin" size:14.0]];
    [StreetTxt setTextAlignment:NSTextAlignmentLeft];
    StreetTxt.placeholder = @"Street";
    [StreetTxt setBorderStyle:UITextBorderStyleNone];
    StreetTxt.layer.borderWidth =1.0;
    StreetTxt.layer.borderColor = [[UIColor colorWithRed:215.0f/255.0f green:215.0f/255.0f blue:215.0f/255.0f alpha:1.0f] CGColor];
   // StreetTxt.delegate =self;
    
    
    //custom textfield for city....
    
    cityTxt = [[MYTextField alloc] initWithFrame:CGRectMake((customAlertView.frame.size.width*2.6)/100, (customAlertView.frame.size.height*70.7)/100, (customAlertView.frame.size.width*31.9)/100, (customAlertView.frame.size.height*9.3)/100)];
    [cityTxt setFont:[UIFont fontWithName:@"Roboto-Thin" size:14.0]];
    [cityTxt setTextAlignment:NSTextAlignmentLeft];
    cityTxt.placeholder = @"City";
    [cityTxt setBorderStyle:UITextBorderStyleNone];
    cityTxt.layer.borderWidth =1.0;
    cityTxt.layer.borderColor = [[UIColor colorWithRed:215.0f/255.0f green:215.0f/255.0f blue:215.0f/255.0f alpha:1.0f] CGColor];
   // cityTxt.delegate =self;
    
    //custom textfield for state
    
    StateTxt = [[MYTextField alloc] initWithFrame:CGRectMake((customAlertView.frame.size.width*34)/100, (customAlertView.frame.size.height*70.7)/100, (customAlertView.frame.size.width*31.9)/100, (customAlertView.frame.size.height*9.3)/100)];
    [StateTxt setFont:[UIFont fontWithName:@"Roboto-Thin" size:14.0]];
    [StateTxt setTextAlignment:NSTextAlignmentLeft];
    StateTxt.placeholder = @"State";
    [StreetTxt setBorderStyle:UITextBorderStyleNone];
    StateTxt.layer.borderWidth =1.0;
    StateTxt.layer.borderColor = [[UIColor colorWithRed:215.0f/255.0f green:215.0f/255.0f blue:215.0f/255.0f alpha:1.0f] CGColor];
   // StateTxt.delegate =self;
    //custom textfield for Pincode
    
    PincodeTxt = [[MYTextField alloc] initWithFrame:CGRectMake((customAlertView.frame.size.width*65.8)/100, (customAlertView.frame.size.height*70.7)/100, (customAlertView.frame.size.width*31.9)/100, (customAlertView.frame.size.height*9.3)/100)];
    [PincodeTxt setFont:[UIFont fontWithName:@"Roboto-Thin" size:14.0]];
    [PincodeTxt setTextAlignment:NSTextAlignmentLeft];
    PincodeTxt.placeholder = @"Pincode";
    [PincodeTxt setBorderStyle:UITextBorderStyleNone];
    PincodeTxt.layer.borderWidth =1.0;
    PincodeTxt.layer.borderColor = [[UIColor colorWithRed:215.0f/255.0f green:215.0f/255.0f blue:215.0f/255.0f alpha:1.0f] CGColor];
    //PincodeTxt.delegate= self;
    
    
    //custom button with action..
    
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
    
    
    if (locationStatus==1) {
        
        [visualEffectView removeFromSuperview];
        [customAlertView removeFromSuperview];

        [self  sendAudio_ToServer];
        
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

            [self  sendAudio_ToServer];
            
            
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
    
    
    
    DLog(@"user-agent in data--%@",objectDataClass.globalUserAgent);
    
    
    
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
    //    NSLog(@"result-- %@", result1);
    
   // AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSString *  KEY_PASSWORD = @"com.toi.app.password";
    NSString *    idfv = [[KeyChainValteck keyChainLoadKey:app.putValueToKeyChain] valueForKey:KEY_PASSWORD];
    DLog(@"idfv is audio view  =====%@",idfv);
    
    
    
    
    
    NSString * deviceID =  idfv; //app.FinalKeyChainValue; //@"JYGSyzMsYrfZQA1FSqOY58eIZ9k=";
    DLog(@"device id upload audio --%@",deviceID);
    NSString * salt =  [NSString stringWithFormat:@"%@:rz8LuOtFBXphj9WQfvFh",[[NSUserDefaults standardUserDefaults]valueForKey:@"userID_Default"]];
    DLog(@"key is upload audio view --%@",salt);//  @":rz8LuOtFBXphj9WQfvFh";
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

#pragma mark--SubmitFor Review

- (IBAction)submitForReview:(id)sender {
    NSString *message;
   // AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if ([lbl_output_category.text length]==0 || [txt_Title.text length]==0 || [txt_View.text length]==0||[lbl_finalPicker_Selected.text length]==0 || app.recordedData==nil) {
        if ([lbl_finalPicker_Selected.text length]==0 || app.recordedData==nil) {
            
            message=@"Please select a file";
        }
        
     else if ([lbl_output_category.text length]==0) {
            
            message = @"Please select a category";
            
        }else if ([txt_Title.text length]==0){
            message=@"Please enter a title";
            
            
        }else if ([txt_View.text length]==0){
            
            message = @"Please enter a story";
        }
        /*UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        */
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Alert" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * alertAction = [UIAlertAction  actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
            
           
            
        }];
        
        [alert addAction:alertAction];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        
        
        
        
        
        NSString *categoryId_String=[self sendCategoryId:lbl_output_category.text];
        
//        __block  NSString *categoryId_String;
//        
//       // AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
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

        
        
        
        [AudiocollectedDict setValue:txt_Title.text forKey:@"Title"];
        [AudiocollectedDict setValue:txt_View.text forKey:@"FullStory"];
        [AudiocollectedDict setValue:categoryId_String forKey:@"Id_Category"];    // picker view 's category.....
        [AudiocollectedDict setValue:[[NSUserDefaults standardUserDefaults] stringForKey:@"userID_Default"] forKey:@"SubmittedBy"];         // user id need to get set here .
        [AudiocollectedDict setValue:@"Submitted" forKey:@"JournalStatus"];
        [AudiocollectedDict setValue:@"2" forKey:@"Id_MainCategory"];
        //  [collectedDict setValue:Id_BlobFromService forKey:@"Id_Blob"];
        [AudiocollectedDict setValue:lbl_output_category.text forKey:@"categoryName"];
        [AudiocollectedDict setValue:date forKey:@"Date"];
        [AudiocollectedDict setValue:time forKey:@"Time"];
        [AudiocollectedDict setValue:@"AUDIO" forKey:@"Type"];
        //[collectedDict setValue:tempPath forKey:@"fileURl"];
        [AudiocollectedDict setValue:app.recordedData forKey:@"AudioData"];
        
        [AudiocollectedDict setValue:app.uniqueNameForLableAudio forKey:@"uniqueName"];
        [AudiocollectedDict setValue:lbl_output_category.text forKey:@"localCategoryName"];
        
        [AudiocollectedDict setValue:app.soundFilePathData forKey:@"FileUrlPath"];
        
        
        
        
        // app.submitDict = [collectedDict copy];
    //    DLog(@"collected data in app--%@",AudiocollectedDict);
      
        /*
        if ([objectDataClass.globalSubmitArray count]<15) {
            
            [objectDataClass.globalSubmitArray  addObject:AudiocollectedDict];
            DLog(@"global arra neew --%@",objectDataClass.globalSubmitArray);
            
        }else{
            
            [objectDataClass.globalSubmitArray removeObjectAtIndex:0];
            
        }
        
        
        
        [[NSUserDefaults standardUserDefaults]setValue:objectDataClass.globalSubmitArray forKey:@"SubmitArray"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        DLog(@"array length======%lu",[objectDataClass.globalSubmitArray count]);
        // [[NSUserDefaults standardUserDefaults]synchronize];
        
        */
        
        if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"SubmitArray"] count]<15) {
            
            
            if (tempArray == nil) {
                
               // [LocalDataHandleArray addObject:AudiocollectedDict];
                 [LocalDataHandleArray insertObject:AudiocollectedDict atIndex:0];
                
            }else{
                
                
                [LocalDataHandleArray removeObjectAtIndex:objectDataClass.globalIndexSelection];
              //  [LocalDataHandleArray addObject:AudiocollectedDict];
                 [LocalDataHandleArray insertObject:AudiocollectedDict atIndex:0];
                
            }
            
            
        }else{
            
            [LocalDataHandleArray removeObjectAtIndex:0];
            
            
        }
        
        
        [[NSUserDefaults standardUserDefaults]setValue:LocalDataHandleArray forKey:@"SubmitArray"];
        [[NSUserDefaults standardUserDefaults]synchronize];

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
#pragma mark -- calling image picker..
#pragma mark - Image Picker Controller delegate methods   starts ...

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    
//    if (!info[UIImagePickerControllerMediaType]) {
    
        if (!info[UIImagePickerControllerEditedImage]) {
            
        [[NSUserDefaults standardUserDefaults]setValue:@"DoneVideo" forKey:@"Video_Check"];
        
        
            
     
        
        NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
        
        videoData = [NSData dataWithContentsOfURL:videoURL];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        fileName = [NSString stringWithFormat:@"%@",[self randomStringWithLength:8]];
        tempPath = [documentsDirectory stringByAppendingFormat:@"/%@.mp4",fileName];
        
        [videoData writeToFile:tempPath atomically:NO];

        [[NSUserDefaults standardUserDefaults] setObject:videoData forKey:@"VideoData"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    
        NSLog(@"this is the pathe of temp of the video ====>%@",tempPath);
        
        
        
            
            UploadVideoView *uploadV = [[UploadVideoView alloc]initWithNibName:@"UploadVideoView" bundle:nil];
            uploadV.receivedPath = tempPath;
            uploadV.ReceivedURl =videoURL;
            uploadV.fileNameforVideo = [self generateUniqueNameVideo];
            [self.navigationController pushViewController:uploadV animated:NO];
            
       
        
    }else{
    
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
    
    DLog(@"image is ========%@",mainImage);
    
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
    
   // Nav_valueToPhoto =YES;
    
    //  handleView = YES ;
    
        
        UploadPhoto *uploadP = [[UploadPhoto alloc]initWithNibName:@"UploadPhoto" bundle:nil];
        uploadP.transferedImageData =data;
        uploadP.transferPhotoUniqueName = captureduniqueName;
       // uploadP.navigateValue = Nav_valueToPhoto;
        uploadP.transferFileURl =localUrl;
        [self.navigationController pushViewController:uploadP animated:NO];
        
    
    
    }
    
    
    //  [self.scrollView_Photo setScrollEnabled:YES];
    // [self.scrollView_Photo setContentSize:CGSizeMake(320, 600)];
    // [self.scrollView_Photo setContentOffset:CGPointMake(5, 5) animated:YES];
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self.view setNeedsLayout];
    
    
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    DLog(@"cancel Tapped!");
    [tabBarController setSelectedItem:nil]; // set tab bar unselected
    [tabBarController setSelectedItem:[tabBarController.items objectAtIndex:2]];

    isPickerTapped = YES;
  
    [picker dismissViewControllerAnimated:YES completion:NULL];
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
// for video.....


-(void)loadVideoRecorder{
    
    if (IS_OS_8_OR_LATER) {   // code for ios 8 or above !!!!!!!!!
        
        
        
        DLog(@"capture Video tapped");
        //  isBrowserTapped=YES;
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
            
            
            // isBrowserTapped=YES;
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
            
            // isBrowserTapped=YES;
            [self startCameraControllerFromViewController: self usingDelegate: self]; // this is calling the camera
            
        }
        
        
    }
    
}
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


-(NSString *) randomStringWithLength: (int) len {
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letter3 characterAtIndex: arc4random_uniform([letter3 length])]];
    }
    
    return randomString;
}
// start update location
-(void)StartUpdating
{
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate=self;
    
    if ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
    {
        [locationManager requestAlwaysAuthorization];
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
        
        
       /* without_Address = [[UIAlertView alloc]initWithTitle:@"Location auto capturing is off" message:@"Please enter the location for your story" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Submit", nil];
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
        
        // false means off..
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
