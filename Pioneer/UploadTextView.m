//
//  UploadTextView.m
//  pioneer
//
//  Created by amit bahuguna on 7/30/14.
//  Copyright (c) 2014 CYNOTECK. All rights reserved.
//

#import "UploadTextView.h"
#import "RecordAudioView.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "IQActionSheetPickerView.h"
#import "Setting_Screen.h"
#import "KeyChainValteck.h"
#import "UploadPhoto.h"
#import "UploadAudioView.h"
#import "UploadVideoView.h"
#import "DataClass.h"
#import <CommonCrypto/CommonHMAC.h>
#import "Base64.h"
#import <CommonCrypto/CommonDigest.h>
#include <ifaddrs.h>
#include <arpa/inet.h>
#import "SubmitForReview.h"




#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
NSString *letter2 = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

@interface UploadTextView() <SyncDelegate,CLLocationManagerDelegate>
{
    SyncManager *sync;
    CLLocationManager *locationManager;


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
    NSDate *date1;
    NSDate *date2;
    long timediff;
    NSString *Finaltoken;
    SubmitForReview * objSubmit;
    NSMutableDictionary *collectedDict;
    
    NSData *data ;
    NSString *fileName;
    NSString* localUrl;
    NSString*finalUnique;
     NSString* captureduniqueName;
    
    
    BOOL checkUserComingFrom;
    NSMutableArray *LocalDataHandleArray;
    
    NSData* videoData;
    NSString *tempPath ;
    UIImage *imageThumbnail;
    NSString*finalUniqueVideo;


    
    
    
}

@end

@implementation UploadTextView
@synthesize txt_Title,txt_View,mainImage;
@synthesize segment_Outlet;
@synthesize textDataDictionary,tempArray;          //New changes



@synthesize cut_Sec,lbl_AddStory_Outlet,lbl_finalPicker_Selected,lbl_Select_new_Category,lbl_selected_File_Outlet,lbl_Title,image_AddStory_Outlet,image_Select_NewCategory,image_Title_Outlet,img_View_Selected_File_Outlet,btn_Reset_Outlet,btn_Selected_new_Category_Outlet,btn_Upload_Outlet;
@synthesize written_Address;
@synthesize img_ForSuccess_Unsuccess,view_ForSuccess_Unsuccess,ok_For_Success_Outlet;
@synthesize with_Address_Optional_Written;
@synthesize tabBarController,audioTabBar,videoTabBar,photoTabBar,textTabBar;
@synthesize circular_Progress_View;




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        // Custom initialization
        
    }
 
    return self;
    
}



-(void)checkCategoryData {
    
  //  AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if ([app.categoryNameArray count]==0 || [app.id_CategoryArray count]==0) {
        
        NSLog(@"quite empty!!!!");
        // [app getCategory];
        
        NSLog(@"coming!");
    }else{
        
        lbl_output_category.userInteractionEnabled=YES ;
        [self CallMethodForPicker];
        [timerCheck invalidate];
        
    }
    
}



- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    
    sync = [[SyncManager alloc] init];
    sync.delegate = self;

    
    
    collectedDict = [NSMutableDictionary dictionary];
    
    objectDataClass = [DataClass getInstance];
    
    img_ForSuccess_Unsuccess.userInteractionEnabled = YES;
    
    app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [lbl_output_category setUserInteractionEnabled:NO];
    timerCheck = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(checkCategoryData) userInfo:nil repeats:YES];

    tabBarController.delegate = self;
    
    
    videoTabBar.tag = 1;
    photoTabBar.tag = 2;
    audioTabBar.tag = 3;
    textTabBar.tag  = 4;
    tabBarController.backgroundColor =[UIColor colorWithRed:(20.0/255.0) green:(20.0/255.0) blue:(20.0/255.0) alpha:1.0];
    
    
    // Do any additional setup after loading the view from its nib.
    
    /*[self.scrollView_Text addSubview:lbl_Select_new_Category];
    [self.scrollView_Text addSubview:image_Select_NewCategory];
    [self.scrollView_Text addSubview:lbl_output_category];
    [self.scrollView_Text addSubview:lbl_Title];
    [self.scrollView_Text addSubview:image_Title_Outlet];
    [self.scrollView_Text addSubview:txt_Title];
    [self.scrollView_Text addSubview:lbl_AddStory_Outlet];
    [self.scrollView_Text addSubview:self.image_txtView];
    [self.scrollView_Text addSubview:txt_View];
    [self.scrollView_Text addSubview:btn_Upload_Outlet];
    [self.scrollView_Text addSubview:btn_Reset_Outlet];
    */
    
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    
    [tabBarController setSelectedItem:[tabBarController.items objectAtIndex:3]];
    
    [tabBarController setTintColor:[UIColor whiteColor]]; // set tab bar selection color white

    
    
    
    
    // working .....
    LocalDataHandleArray=[[NSMutableArray alloc]init];
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"SubmitArray"] count]==0) {
        
        ///
        
        
    }else{
        
        LocalDataHandleArray=[[[NSUserDefaults standardUserDefaults]valueForKey:@"SubmitArray"] mutableCopy];
        
    }
    
    // end.....

    
    
    
    
    
    
    if (tempArray==NULL) {
        
   
        
    } else {
        
        
        checkUserComingFrom=TRUE;
        
        txt_Title.text = [[tempArray  objectAtIndex:objectDataClass.globalIndexSelection] valueForKey:@"Title"] ;
        txt_View.text = [[tempArray objectAtIndex:objectDataClass.globalIndexSelection]valueForKey:@"FullStory"];
        id categoryID = [[tempArray objectAtIndex:objectDataClass.globalIndexSelection] valueForKey:@"Id_Category"] ;
        NSLog(@"category value--%@",categoryID);
        
        if ([categoryID isEqualToString: @"1"]) {
            
            lbl_output_category.text = @"Politics";
            
        }else if ([categoryID isEqualToString:@"2"]) {
            
            lbl_output_category.text =@"Sports";
            
            
        }else if ([categoryID isEqualToString:@"3"]){
            
            lbl_output_category.text =@"Games";
            
        }else if ([categoryID isEqualToString:@"4"]){
            
            lbl_output_category.text =@"Movie";
        }
    }
    
    
    NSLog(@"it's great !");
    segment_Outlet.selectedSegmentIndex=0;
	// Set a tint color
    
    segment_Outlet.layer.cornerRadius=2.0;
	segment_Outlet.tintColor =[UIColor redColor];     //[UIColor colorWithRed:255/196 green:255/51 blue:255/41 alpha:1.0];
    
    videoTabBar.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    audioTabBar.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    textTabBar.imageInsets  = UIEdgeInsetsMake(6, 0, -6, 0);
    photoTabBar.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);

    
    [self.scrollView_Text setScrollEnabled:YES];
    [self.scrollView_Text setContentSize:CGSizeMake(320, 500)];
    
}

-(void)viewDidLayoutSubviews{
    
    //AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSLog(@"id is =====%@",app.id_CategoryArray);//  app.id_CategoryArray
    NSLog(@"name is ===%@",app.categoryNameArray);
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back_Tapped:(id)sender {
    
    NSArray *array = [self.navigationController viewControllers];
    
    NSLog(@" Text content from array is :  %@",array);

    
    if ([lbl_output_category.text length]>0 || [txt_Title.text length]>0 || [txt_View.text length]>0) {
        
        
        goBackAlert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Are you sure you want to cancel this news submission?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
        [goBackAlert show];
        
        
       
    }else{
        
        txt_View.text=nil;
        txt_Title.text=nil;
        lbl_finalPicker_Selected.text=nil;
        lbl_output_category.text=@"Choose Category";

        
        [self.navigationController popToViewController:[array objectAtIndex:1] animated:NO];
    
    }
    
}

#pragma mark --
#pragma mark -- TabBar delegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if(item.tag == 1)
    {
        
        NSLog(@"Video Tab bar tapped");
        [self checkforNavigationInternetconnection:1];
        
    }else if (item.tag ==2) {
      
        NSLog(@"Photo tab bar tapped");
        [self checkforNavigationInternetconnection:2];
      
      }else if (item.tag ==3){
          
          NSLog(@"Audio Tab bar tapped");
          
          [self checkforNavigationInternetconnection:3];
          
      }

}

- (IBAction)reset_Tapped:(id)sender {
    NSArray *array = [self.navigationController viewControllers];
    
    NSLog(@" Text content from array is :  %@",array);
    
    txt_View.text=nil;
    txt_Title.text=nil;
    lbl_finalPicker_Selected.text=nil;
    lbl_output_category.text=nil;
    
    [self.navigationController popToViewController:[array objectAtIndex:1] animated:YES];
    
    
}
/*NSString *rawString = [textField text]; NSRange range = [rawString rangeOfCharacterFromSet:whitespace]; */

- (IBAction)upload_Tapped:(id)sender {
    
    
    [self.view endEditing:YES];

    NSString *message;
    
    if ([Utility connected] == YES) {
    

    if ([lbl_output_category.text length]==0 || [txt_Title.text length]==0 || [txt_View.text length]==0) {
        
        if ([lbl_output_category.text length]==0) {
            
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
        UIAlertAction * actionAlert = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction* alert){
        }];
        [alert addAction:actionAlert];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        
        checkStr =    [[NSUserDefaults standardUserDefaults]stringForKey:@"address_Default"];
        
        [self blurEffect];
        [self StartUpdating];
//
//        if (!checkStr) {
//            
//            without_Address = [[UIAlertView alloc]initWithTitle:@"Location auto capturing is off" message:@"Please enter the location(city) for your news/story" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Submit", nil];
//            without_Address.alertViewStyle=UIAlertViewStylePlainTextInput;
//            UITextField *txtLocation = [without_Address textFieldAtIndex:0];
//            txtLocation.delegate     = self;
//            txtLocation.text         = @"";
//            txtLocation.clearButtonMode = UITextFieldViewModeWhileEditing;
//            [txtLocation setPlaceholder:@"Location"];
//            [self.view endEditing:YES];
//            [without_Address show];
//            
//        }else{
//            
//          /*  with_Address = [[UIAlertView alloc]initWithTitle:@"Your current location" message:[NSString stringWithFormat:@"%@\n\nIf incorrect, please enter the location(city) for your news/story",checkStr] delegate:self cancelButtonTitle:@"Submit" otherButtonTitles:nil ,nil];
//            with_Address.alertViewStyle=UIAlertViewStylePlainTextInput;
//            
//            UITextField *txtLocation = [with_Address textFieldAtIndex:0];
//            txtLocation.delegate     = self;
//            txtLocation.text         = @"";
//            txtLocation.clearButtonMode = UITextFieldViewModeWhileEditing;
//            [txtLocation setPlaceholder:@"Location"];
//            [self.view endEditing:YES];
//            [with_Address show];
//            */
//            
//            
//            // calling method for creating the UIFileds.....
//            [self createCustomUiField];
//            
//            
//        }
        
    }
        
    }else{
        
     /*   UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Internet connection is not available. Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
*/
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Internet connection is not available. Please try again." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * actionAlert = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction* alert){
        }];
        [alert addAction:actionAlert];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    
    
}



- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    
    if (alertView == without_Address) {
        
    UITextField *textField = [alertView textFieldAtIndex:0];
        
    if ([textField.text length] == 0)
    {
        return NO;
    }
        written_Address=[alertView textFieldAtIndex:0].text;

    }else if (alertView==with_Address){//with_Address
        
        with_Address_Optional_Written=[alertView textFieldAtIndex:0].text;
        
    }

    return YES;
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    if (alertView == with_Address) {
        
        // do nothing for now !!!
        
//        if (buttonIndex==0) {
//            
//            NSLog(@"cancel tapped!");
//            
//        }else{
        
        with_Address_Optional_Written=[alertView textFieldAtIndex:0].text;
        
            [self  sendText_ToServer];
            
       // }
        
        
    }else if(alertView ==without_Address){
        
        
        if (buttonIndex == 0)
        {
            //    UITextField *Location = [alertView textFieldAtIndex:0];
            //    NSLog(@"username: %@", username.text);
            
            NSLog(@"first one ");
            NSLog(@"Entered: %@",[[alertView textFieldAtIndex:0] text]);
            
            if ([[alertView textFieldAtIndex:0].text length]<=0) {
                
                NSArray *array = [self.navigationController viewControllers];
                
                NSLog(@" Text content from array is :  %@",array);
                [self.navigationController popToViewController:[array objectAtIndex:1] animated:NO];
                
               
            }
            
        }
        else{
            [self  sendText_ToServer];
            
            NSLog(@"seocnd one ");
            NSLog(@"Entered: %@",[[alertView textFieldAtIndex:0] text]);
            
            //  [with_Address dismissWithClickedButtonIndex:2 animated:YES];
            
            
        }
        
    }else if (alertView ==goBackAlert){
        
        NSArray *array = [self.navigationController viewControllers];
        
        NSLog(@" Text content from array is :  %@",array);

        
        if (buttonIndex==0) {
            
            // cancel tapped...
            
            
        }else if(buttonIndex ==1){

            txt_View.text=nil;
            txt_Title.text=nil;
            lbl_finalPicker_Selected.text=nil;
            lbl_output_category.text=@"Choose Category";
           // [self.navigationController popViewControllerAnimated:YES];
            
            [self.navigationController popToViewController:[array objectAtIndex:1] animated:NO];
            
        }

    }else if (try_AgainInternet_Check==alertView){
        
        
        NSArray *array = [self.navigationController viewControllers];
        [self.navigationController popToViewController:[array objectAtIndex:1] animated:NO];
        

        }else if (buttonIndex==1){
            
            // on ok tapped!!!!!!!!!!!

            [self sendText_ToServer];
            
        }
        
    }
    




//h ttp://hayageek.com/ios-nsurlsession-example/#get-post
-(void)sendText_ToServer {
    
    
    layer = [CAGradientLayer layer];
    layer.frame = self.view.bounds;
    UIColor *blackColor = [UIColor colorWithWhite:0.0f alpha:1.0f];
    UIColor *clearColor = [UIColor colorWithWhite:0.0f alpha:1.0f];
    layer.colors = [NSArray arrayWithObjects:(id)clearColor.CGColor, (id)blackColor.CGColor, nil];
    [self.view.layer insertSublayer:layer atIndex:1];
    __block  NSString *categoryId_String;
    
    //AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [ [app.categoryNameArray objectAtIndex:0] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        
        NSString *campareStr = [NSString stringWithFormat:@"%@",[[app.categoryNameArray objectAtIndex:0]objectAtIndex:idx]];
        if ([campareStr isEqualToString:lbl_output_category.text]) {
            
            categoryId_String = [NSString stringWithFormat:@"%@",[[app.id_CategoryArray objectAtIndex:0]objectAtIndex:idx]];
            
        }
        
    }];
    
    // hiding !!!!!
    ///////////////////////////////////////////
    //////////////////////////////////////////
    // looping all subviews except circular view for showing progress...
    
    for (UIView *subview in self.view.subviews)
    {
        
        
           // subview.hidden = YES;
        
        if ([subview isEqual:circular_Progress_View]) {
            
            subview.hidden=NO;
            // do nothing .
        }else{
            
            subview.hidden = YES;
            
        }
        
    }
    
    
    //[self.view setAlpha:0.4];
    [self.view setUserInteractionEnabled:NO];
    self.circular_Progress_View.frame = CGRectMake(71, 197, 175, 135);
    [self.view addSubview:self.circular_Progress_View];
    self.circular_Progress_View.thicknessRatio = 0.111111;
    self.circular_Progress_View.outerBackgroundColor=[UIColor lightGrayColor];
    self.circular_Progress_View.innerBackgroundColor=[UIColor lightGrayColor];
    
    self.circular_Progress_View.progressFillColor=[UIColor redColor];
    
    ///////////////////////////////////////
    ///////////////////////////////////////
    
    
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    
    
    //timesgroupcrapi  http://timesgroupcrapi.cloudapp.net/api/UserDet
    
    NSString * urlstring = [NSString stringWithFormat:@"%@%@",@"http://prngapi.cloudapp.net/api/CJDetails?token=",[GlobalStuff generateToken]];
    NSLog(@"text url --%@",urlstring);
    
    
    NSURL * url = [NSURL URLWithString:urlstring]; //@"http://prngapi.cloudapp.net/api/CJDetails"];
  //  NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
   
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url
                                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                          timeoutInterval:300];

    
    NSMutableDictionary *finalDictionary = [NSMutableDictionary dictionary];
    NSMutableDictionary *headerDict = [NSMutableDictionary dictionary];
    NSMutableDictionary *dictionaryTemp = [NSMutableDictionary dictionary];
    
    ///////////////////////////
    // getting .....z
    NSString *  KEY_PASSWORD = @"com.toi.app.password";
    NSString *    idfv = [[KeyChainValteck keyChainLoadKey:app.putValueToKeyChain] valueForKey:KEY_PASSWORD];
    // getting ...
    
    //////////////////////////
    
    [headerDict setValue:@"" forKey:@"DeviceId"];//idfv
    [headerDict setValue:@"" forKey:@"UserId"];  // user id is yet to set ....[[NSUserDefaults standardUserDefaults] stringForKey:@"userID_Default"]
    [headerDict setValue:@"" forKey:@"Source"];
    
    [dictionaryTemp setValue:txt_Title.text forKey:@"Title"];
    [dictionaryTemp setValue:txt_View.text forKey:@"FullStory"];
    [dictionaryTemp setValue:categoryId_String forKey:@"Id_Category"];    // picker view 's category.....
    [dictionaryTemp setValue:[[NSUserDefaults standardUserDefaults] stringForKey:@"userID_Default"] forKey:@"SubmittedBy"];         // user id need to get set here .
    [dictionaryTemp setValue:@"Submitted" forKey:@"JournalStatus"];
    [dictionaryTemp setValue:@"4" forKey:@"Id_MainCategory"];
    [dictionaryTemp setValue:@"" forKey:@"Id_Blob"];
    
    
    
    NSString *checkStr =    [[NSUserDefaults standardUserDefaults]stringForKey:@"address_Default"];
    
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
    
    NSLog(@" subodh value of addres is ======%@",[dictionaryTemp valueForKey:@"LocationDetails"]);

    [finalDictionary setObject:headerDict forKey:@"header"];
    [finalDictionary setValue:dictionaryTemp forKey:@"data"];
    
     NSLog(@"Request ON Text ===%@",finalDictionary);
    
   
    
    
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
    
    //AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    
    
    NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:urlRequest
                                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                           NSLog(@"Response:%@ %@\n", response, error);
                                                           if(error == nil)
                                                           {
//                                                               NSString * text = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
//                                                               NSLog(@"o/p is ==== %@",text);
                                                               
                                                               NSError *jsonError;
                                                               id array = [NSJSONSerialization JSONObjectWithData:data
                                                                                                                options:kNilOptions
                                                                                                                  error:&jsonError];
                                                               
                                                               

                                                               NSLog(@"array is ====%@",array);
                                                               [self.view setUserInteractionEnabled:YES];
                                                               
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
                                                               
                                                              // [layer removeFromSuperlayer];
                                                               NSString *strId = [NSString stringWithFormat:@"%@",[[array valueForKey:@"data"]valueForKey:@"ErrorId"]];
                                                               
                                                             //  NSMutableArray *arrTesting=[[NSMutableArray alloc]init];
                                                               
                                                               
                                                               
                                                               
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
                                                                   [dateFormatter setDateFormat:@"dd/MM/yyyy"];
                                                                   NSString *date=[dateFormatter stringFromDate:[NSDate date]];
                                                                   
                                                                   NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                                                                   [formatter setDateFormat:@"hh:mm a"];
                                                                   NSString *time=[formatter stringFromDate:[NSDate date]];
                                                                   
//                                                                   NSLog(@"Current Date: %@", [formatter stringFromDate:[NSDate date]]);
                                                                   
                                                                   if([app.myFinalArray count]==0){
                                                                       
                                                                       app.myFinalArray=[[NSMutableArray alloc]init];
                                                                       
                                                                   }else{
                                                                       
                                                                       //do Nothing
                                                                       
                                                                   }
                                                                   
                                                                   textDataDictionary=[NSMutableDictionary dictionary];
                                                                   
                                                                   [textDataDictionary setValue:[lbl_output_category.text uppercaseString] forKey:@"CategoryName"];
                                                                   [textDataDictionary setValue:txt_Title.text forKey:@"Title"];
                                                                   [textDataDictionary setValue:txt_View.text forKey:@"FullStory"];
                                                                   [textDataDictionary setValue:@"TEXT" forKey:@"Type"];
                                                                   [textDataDictionary setValue:date forKey:@"Date"];
                                                                   [textDataDictionary setValue:time forKey:@"Time"];
                                                                  
                                                                   NSLog(@"test dict--%@",textDataDictionary);
                                                                   

                                                                   
                                                                   if([app.myFinalArray count]<15){
                                                                       
                                                                       [app.myFinalArray addObject:textDataDictionary];
                                                                   }
                                                                   else{
                                                                       [app.myFinalArray removeObjectAtIndex:0];
                                                                   }
                                                                   

                                                                   [[NSUserDefaults standardUserDefaults]setValue:app.myFinalArray forKey:@"MyArray"];
                                                                   NSLog(@"array length======%lu",[app.myFinalArray count]);
                                                                  // [[NSUserDefaults standardUserDefaults]synchronize];
                                                                   
                                                                   
                                                                   
                                                                   
                                                                   
                                                                   NSLog(@"My Array is ===== %@",[[NSUserDefaults standardUserDefaults]objectForKey:@"MyArray"]);
                                                                   
                                                                   
//                                                                   UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:[NSString stringWithFormat:@"%@",[[array valueForKey:@"data"] valueForKey:@"ErrorMessage"]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//                                                                   [alert show];
                                                                   
                                                                   ok_For_Success_Outlet.tag=1;
                                                                   
                                                                   CGSize size = [[UIScreen mainScreen]bounds].size;
                                                                   
                                                                   if (size.height==480) {
                                                                       [img_ForSuccess_Unsuccess setImage:[UIImage imageNamed:@"success3.5.png"]];
                                                                       UIButton *btnUpload=[[UIButton alloc]initWithFrame:CGRectMake(126.0, 227.0, 115.0, 38.0)];
                                                                       
//                                                                       [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"SubmitArray"];
                                                                       //[[NSUserDefaults standardUserDefaults]synchronize];
                                                                       NSLog(@"removed from nsuserdefault--%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"SubmitArray"]);
                                                                       
                                                                       
                                                                      [btnUpload setImage:[UIImage imageNamed:@"Sounds Good Btn.png"] forState:UIControlStateNormal];
                                                                       [btnUpload addTarget:self action:@selector(btn_Success_Tapped:) forControlEvents:UIControlEventTouchUpInside];
                                                                       btnUpload .clipsToBounds = YES;
                                                                       [btnUpload.layer setCornerRadius:4.5];
                                                                       [self.selectedView.layer setCornerRadius:4.0];
                                                                       
                                                                       
                                                                       [view_ForSuccess_Unsuccess addSubview:self.selectedView];
                                                                       [self.selectedView addSubview:btnUpload];
                                                                       
                                                                   }else{
                                                                  //     [img_ForSuccess_Unsuccess setImage:[UIImage imageNamed:@"success.png"]];
                                                                       
                                                                       
                                                                       [img_ForSuccess_Unsuccess setImage:[UIImage imageNamed:@"success.png"]];
                                                                       UIButton *btnUpload=[[UIButton alloc]initWithFrame:CGRectMake(86.0, 241.0, 115.0, 38.0)];
                                                                       
                                                                 //      [tempArray removeObjectAtIndex:objectDataClass.globalIndexSelection];
                                                                       
                                                                       

//                                                                       [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"SubmitArray"];
                                                                      // [[NSUserDefaults standardUserDefaults]synchronize];
                                                                       NSLog(@"removed from nsuserdefault--%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"SubmitArray"]);
                                                                       
                                                                       
                                                                       [btnUpload setImage:[UIImage imageNamed:@"Sounds Good Btn.png"] forState:UIControlStateNormal];
                                                                       [btnUpload addTarget:self action:@selector(btn_Success_Tapped:) forControlEvents:UIControlEventTouchUpInside];
                                                                       btnUpload .clipsToBounds = YES;
                                                                       [btnUpload.layer setCornerRadius:4.5];
                                                                       [self.selectedView.layer setCornerRadius:4.0];
                                                                       
                                                                       [view_ForSuccess_Unsuccess addSubview:self.selectedView];
                                                                       [self.selectedView addSubview:btnUpload];
                                                                       
                                                                      
                                                                   }
                                                                   [self.view addSubview:self.view_ForSuccess_Unsuccess];
                                                                   
                                                                   
                                                               }
                                                               
                                                               else{
                                                                   
                                                                  
                                                                   ok_For_Success_Outlet.tag=2;
                                                                  
                            try_AgainInternet_Check = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Error While uploading text." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                                                    [try_AgainInternet_Check show];
                                                                   
                                                                  /*
                                                                   CGSize size = [[UIScreen mainScreen]bounds].size;
                                                                   
                                                                   if (size.height==480) {
                                                                    //   [img_ForSuccess_Unsuccess setImage:[UIImage imageNamed:@"unsuccess3.5.png"]];
                                                                       
                                                                       [img_ForSuccess_Unsuccess setImage:[UIImage imageNamed:@"unsuccess3.5.png"]];
                                                                       UIButton *btnUpload=[[UIButton alloc]initWithFrame:CGRectMake(126.0, 227.0, 115.0, 38.0)];
//                                                                       [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"SubmitArray"];
//                                                                       [[NSUserDefaults standardUserDefaults]synchronize];
                                                                       NSLog(@"removed from nsuserdefault--%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"SubmitArray"]);
                                                                       
                                                                       [btnUpload setImage:[UIImage imageNamed:@"Sounds Good Btn.png"] forState:UIControlStateNormal];
                                                                       [btnUpload addTarget:self action:@selector(btn_Success_Tapped:) forControlEvents:UIControlEventTouchUpInside];
                                                                       btnUpload .clipsToBounds = YES;
                                                                       [btnUpload.layer setCornerRadius:4.5];
                                                                       [self.selectedView.layer setCornerRadius:4.0];
                                                                       
                                                                       [view_ForSuccess_Unsuccess addSubview:self.selectedView];
                                                                       [self.selectedView addSubview:btnUpload];
                                                                       

                                                                       
                                                                   }else{
                                                                       [img_ForSuccess_Unsuccess setImage:[UIImage imageNamed:@"unsuccess.png"]];
                                                                       UIButton *btnUpload=[[UIButton alloc]initWithFrame:CGRectMake(86.0, 241.0, 115.0, 38.0)];
                                                                       
                                                                       
                                                                     //  [tempArray removeObjectAtIndex:objectDataClass.globalIndexSelection];

                                                                       
//                                                                       [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"SubmitArray"];
                                                                      // [[NSUserDefaults standardUserDefaults]synchronize];
                                                                       NSLog(@"removed from nsuserdefault--%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"SubmitArray"]);
                                                                       
                                                                       
                                                                       [btnUpload setImage:[UIImage imageNamed:@"Sounds Good Btn.png"] forState:UIControlStateNormal];
                                                                       [btnUpload addTarget:self action:@selector(btn_Success_Tapped:) forControlEvents:UIControlEventTouchUpInside];
                                                                       btnUpload .clipsToBounds = YES;
                                                                       [btnUpload.layer setCornerRadius:4.5];
                                                                       [self.selectedView.layer setCornerRadius:4.0];
                                                                       [view_ForSuccess_Unsuccess addSubview:self.selectedView];
                                                                       [self.selectedView addSubview:btnUpload];
                                                                       
                                                                   }
                                                                   
                                                                   [self.view addSubview:self.view_ForSuccess_Unsuccess];
                                                                   
                                                                   


                                                                  */
                                                                   
                                                                   
                                                                   
                                                                   
                                                                   
                                                                   
                                                                   
                                                                   
                                                               }

                                                               
                                                           }else {
                                                            

//                                                               try_AgainInternet_Check = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Internet connection is not available. Please try again." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//                                                               [try_AgainInternet_Check show];
//                                                               
                                                               ok_For_Success_Outlet.tag=2;
                                                               CGSize size = [[UIScreen mainScreen]bounds].size;
                                                               
                                                               if (size.height==480) {
                                                                   
//                                                                   [img_ForSuccess_Unsuccess setImage:[UIImage imageNamed:@"unsuccess3.5.png"]];
                                                                   
                                                                   [img_ForSuccess_Unsuccess setImage:[UIImage imageNamed:@"unsuccess3.5.png"]];
                                                                   UIButton *btnUpload=[[UIButton alloc]initWithFrame:CGRectMake(126.0, 227.0, 115.0, 38.0)];
                                                                   [btnUpload setImage:[UIImage imageNamed:@"Sounds Good Btn.png"] forState:UIControlStateNormal];
                                                                   [btnUpload addTarget:self action:@selector(btn_Success_Tapped:) forControlEvents:UIControlEventTouchUpInside];
                                                                   btnUpload .clipsToBounds = YES;
                                                                   [btnUpload.layer setCornerRadius:4.5];
                                                                   [self.selectedView.layer setCornerRadius:4.0];
                                                                   
                                                                   [view_ForSuccess_Unsuccess addSubview:self.selectedView];
                                                                   [self.selectedView addSubview:btnUpload];
                                                                   
                                                                   
                                                                   
                                                               }else{
                                                                //   [img_ForSuccess_Unsuccess setImage:[UIImage imageNamed:@"unsuccess.png"]];
                                                                   [img_ForSuccess_Unsuccess setImage:[UIImage imageNamed:@"unsuccess.png"]];
                                                                   UIButton *btnUpload=[[UIButton alloc]initWithFrame:CGRectMake(86.0, 241.0, 115.0, 38.0)];
                                                                   [btnUpload setImage:[UIImage imageNamed:@"Sounds Good Btn.png"] forState:UIControlStateNormal];
                                                                   [btnUpload addTarget:self action:@selector(btn_Success_Tapped:) forControlEvents:UIControlEventTouchUpInside];
                                                                   btnUpload .clipsToBounds = YES;
                                                                   [btnUpload.layer setCornerRadius:4.5];
                                                                   [self.selectedView.layer setCornerRadius:4.0];
                                                                   [view_ForSuccess_Unsuccess addSubview:self.selectedView];
                                                                   [self.selectedView addSubview:btnUpload];
                                                                   
                                                               }
                                                               
                                                               [self.view addSubview:self.view_ForSuccess_Unsuccess];
                                                               


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
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
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
/*
- (IBAction)btn_Selected_new_Category_Tapped:(id)sender {
    [self.view endEditing:YES];
    
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    
    if ([app.categoryNameArray count]==0 || [app.id_CategoryArray count]==0) {
        
        // NSLog(@"quite empty!!!!");
        // [app getCategory];
        
        NSLog(@"coming!");
    }else{
    
    IQActionSheetPickerView *picker = [[IQActionSheetPickerView alloc] initWithTitle:@"Choose Category" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    [picker setTag:9];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [picker setTitlesForComponenets:[NSArray arrayWithArray:app.categoryNameArray]];
    [picker showInView:self.view];
        
        
    }

}

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

*/


- (IBAction)setting_Tappeed:(id)sender {
    
    Setting_Screen *setting=[[Setting_Screen alloc]initWithNibName:@"Setting_Screen" bundle:nil];
    [self.navigationController pushViewController:setting animated:YES];

}

-(void) btn_Success_Tapped:(id)sender{
    
    
    
    
    if (ok_For_Success_Outlet.tag==1) {
        
        // on successfull completion....
        txt_View.text=nil;
        txt_Title.text=nil;
        lbl_finalPicker_Selected.text=nil;
        lbl_output_category.text=@"Choose Category";
        
        NSArray * viewhierarchy =[self.navigationController viewControllers];
        NSLog(@"view hierarchy are as follow--%@",viewhierarchy);
        
        [self.navigationController popToViewController:[viewhierarchy objectAtIndex:1] animated:YES];
        
        //[self.navigationController popViewControllerAnimated:YES];
        
        
    }else{
        // when failed!!!
        
        txt_View.text=nil;
        txt_Title.text=nil;
        lbl_finalPicker_Selected.text=nil;
        lbl_output_category.text=@"Choose Category";
        
        //[self.navigationController popViewControllerAnimated:YES];
        
        
        
        NSArray * viewhierarchy =[self.navigationController viewControllers];
        NSLog(@"view hierarchy are as follow--%@",viewhierarchy);
        
        [self.navigationController popToViewController:[viewhierarchy objectAtIndex:1] animated:YES];
        
        
    }
    
    
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
//    
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

- (IBAction)Audio_Tapped:(id)sender {
    
    [self checkforNavigationInternetconnection:3];
    
    
}

/*- (IBAction)Text_Tapped:(id)sender {
    
    [self checkforNavigationInternetconnection:4];
    
}*/

-(void)loadVideoRecorder{
    
    if (IS_OS_8_OR_LATER) {   // code for ios 8 or above !!!!!!!!!
        
        
        
        NSLog(@"capture Video tapped");
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
             
//             CGSize size = [[UIScreen mainScreen]bounds].size;
//             
//             if (size.height==480) {
//                 
//                 UploadPhoto *uploadP = [[UploadPhoto alloc]initWithNibName:@"UploadPhoto3.5" bundle:nil];
//                 [self.navigationController pushViewController:uploadP animated:NO];
//                 
//             }else{
//                 
//                 UploadPhoto *uploadP = [[UploadPhoto alloc]initWithNibName:@"UploadPhoto" bundle:nil];
//                 [self.navigationController pushViewController:uploadP animated:NO];
//                 
//             }
             
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
             
             
          /*  CGSize size = [[UIScreen mainScreen]bounds].size;
            
            if (size.height==480) {
                
                UploadAudioView *uploadP = [[UploadAudioView alloc]initWithNibName:@"UploadAudioView3.5" bundle:nil];
                [self.navigationController pushViewController:uploadP animated:NO];
                
            }else{
                
                UploadAudioView *uploadP = [[UploadAudioView alloc]initWithNibName:@"UploadAudioView" bundle:nil];
                [self.navigationController pushViewController:uploadP animated:NO];
                
            }*/
             RecordAudioView *recordview=[[RecordAudioView alloc]initWithNibName:@"RecordAudioView" bundle:Nil];
             [self.navigationController pushViewController:recordview  animated:YES];
             
           
         }
}


#pragma mark -- blur effect

-(void) blurEffect {
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    // Add effect to an effect view
    visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    visualEffectView.frame = self.view.frame;
    [self.view addSubview:visualEffectView];
    
  
}


#pragma mark -- Custom Button called...
-(void)submitButtonTap {
    NSLog(@"submit tapped");
    [visualEffectView removeFromSuperview];
    [customAlertView removeFromSuperview];
    
    
    [self  sendText_ToServer];

    
}

#pragma mark -- Adding custom labels, textfield and buttons

-(void)createCustomUiField {
    
    // creting a custom view which will be like a alertview....
    
    customAlertView = [[UIView alloc] initWithFrame:CGRectMake(8.0, 129.0, 304.0, 322.0)];
    [customAlertView setBackgroundColor: [UIColor whiteColor]];
    customAlertView.clipsToBounds = YES;
    [customAlertView.layer setCornerRadius:4.5];
    
    
    // creating a custom label ....
    UILabel * confirmLocationlabel = [[UILabel alloc] initWithFrame:CGRectMake(54.0, 17.0, 196.0, 21.0)];
    [confirmLocationlabel setFont:[UIFont fontWithName:@"Roboto-Light" size:18.0]];
    confirmLocationlabel.text = @"Confirm your location";
    [confirmLocationlabel setTextAlignment:NSTextAlignmentCenter];
    
    // for location logo..
    UIImageView * locationImage = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 70.0, 24.0, 24.0)];
    [locationImage setContentMode:UIViewContentModeScaleAspectFill];
    [locationImage setImage:[UIImage imageNamed:@"location01@2x.jpg"]];
    
    UILabel * enteredLocation = [[UILabel alloc] initWithFrame:CGRectMake(25.0, 57.0, 250.0, 80.0)];
    [enteredLocation setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
    
    enteredLocation.numberOfLines =3;
    enteredLocation.adjustsFontSizeToFitWidth = YES;
    enteredLocation.lineBreakMode = NSLineBreakByWordWrapping;
    
    enteredLocation.text = checkStr;
    [enteredLocation setTextAlignment:NSTextAlignmentLeft];
    
    // custom label
    
    UILabel * incorrectLocationLabel = [[UILabel alloc] initWithFrame:CGRectMake(8.0, 138.0, 288.0, 23.0)];
    [incorrectLocationLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:13.0]];
    incorrectLocationLabel.text  =  @"If incorrect, please enter the location for your story";
    incorrectLocationLabel.adjustsFontSizeToFitWidth = YES;
    [incorrectLocationLabel setTextAlignment:NSTextAlignmentCenter];
    
    
    
    
    
    //custom textfield for Streets
    
    UITextField * StreetTxt = [[UITextField alloc] initWithFrame:CGRectMake(8.0, 179.0, 279.0, 30.0)];
    [StreetTxt setFont:[UIFont fontWithName:@"Roboto-Thin" size:14.0]];
    [StreetTxt setTextAlignment:NSTextAlignmentLeft];
    StreetTxt.placeholder = @"  Street";
    [StreetTxt setBorderStyle:UITextBorderStyleNone];
    StreetTxt.layer.borderWidth =1.0;
    StreetTxt.layer.borderColor = [[UIColor colorWithRed:215.0f/255.0f green:215.0f/255.0f blue:215.0f/255.0f alpha:1.0f] CGColor];
    StreetTxt.delegate =self;
    
    
    //custom textfield for city....
    
    UITextField * cityTxt = [[UITextField alloc] initWithFrame:CGRectMake(8.0, 222.0, 97.0, 30.0)];
    [cityTxt setFont:[UIFont fontWithName:@"Roboto-Thin" size:14.0]];
    [cityTxt setTextAlignment:NSTextAlignmentLeft];
    cityTxt.placeholder = @"  City";
    [cityTxt setBorderStyle:UITextBorderStyleNone];
    cityTxt.layer.borderWidth =1.0;
    cityTxt.layer.borderColor = [[UIColor colorWithRed:215.0f/255.0f green:215.0f/255.0f blue:215.0f/255.0f alpha:1.0f] CGColor];
     cityTxt.delegate =self;
    
    //custom textfield for state
    
    UITextField * StateTxt = [[UITextField alloc] initWithFrame:CGRectMake(115.0, 222.0, 83.0, 30.0)];
    [StateTxt setFont:[UIFont fontWithName:@"Roboto-Thin" size:14.0]];
    [StateTxt setTextAlignment:NSTextAlignmentLeft];
    StateTxt.placeholder = @"  State";
    [StreetTxt setBorderStyle:UITextBorderStyleNone];
    StateTxt.layer.borderWidth =1.0;
    StateTxt.layer.borderColor = [[UIColor colorWithRed:215.0f/255.0f green:215.0f/255.0f blue:215.0f/255.0f alpha:1.0f] CGColor];
    StateTxt.delegate =self;
    //custom textfield for Pincode
    
    UITextField * PincodeTxt = [[UITextField alloc] initWithFrame:CGRectMake(205.0, 222.0, 83.0, 30.0)];
    [PincodeTxt setFont:[UIFont fontWithName:@"Roboto-Thin" size:14.0]];
    [PincodeTxt setTextAlignment:NSTextAlignmentLeft];
    PincodeTxt.placeholder = @" Pincode";
    [PincodeTxt setBorderStyle:UITextBorderStyleNone];
    PincodeTxt.layer.borderWidth =1.0;
    PincodeTxt.layer.borderColor = [[UIColor colorWithRed:215.0f/255.0f green:215.0f/255.0f blue:215.0f/255.0f alpha:1.0f] CGColor];
    PincodeTxt.delegate= self;
    
    
    //custom button with action..
    
    UIButton * submitButton = [[UIButton alloc] initWithFrame:CGRectMake(92.0, 272.0, 120.0, 40.0)];
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
#pragma mark  generating the token-----

-(void)generateToken {
    
    
    //get creation time --
    now2 = [NSDate date];
    
    dateFormatter1 = [[NSDateFormatter alloc] init];
    dateFormatter1.dateFormat = @"hh:mm:ss";
    [dateFormatter1 setTimeZone:[NSTimeZone systemTimeZone]];
    
    
    firstDate = [dateFormatter1 stringFromDate:now2];
    
    
    
    
    
    
    //programmatically get user agent
    
    UIWebView* webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    NSString* UserAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    
    objectDataClass.globalUserAgent = UserAgent;
    
    NSLog(@"user-agent in data--%@",objectDataClass.globalUserAgent);
    
    
    
    //get ipaddress
    [self getIPAddress];
    
    NSDate * now = [NSDate date];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    // [outputFormatter setDateFormat:@"HH:mm:ss"];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [outputFormatter setTimeZone:timeZone];
    [outputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //NSString *newDateString = [outputFormatter stringFromDate:[now timeIntervalSince1970 ]];
    
    
    NSLog(@"newDateString %f", [now timeIntervalSince1970 ]);
    
    
    double Finaldate = [now timeIntervalSince1970] ;
    
    double milliseconds = Finaldate *1000;
    
    NSLog(@"final date---%f",milliseconds);
    
    //    NSString *myStringValue = @"hello";
    //    NSString *mySecretKey = @"some";
    //    NSString *result1 = [ViewController hashedString:myStringValue withKey:mySecretKey];
    //    NSLog(@"result-- %@", result1);
    
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSString *  KEY_PASSWORD = @"com.toi.app.password";
    NSString *    idfv = [[KeyChainValteck keyChainLoadKey:app.putValueToKeyChain] valueForKey:KEY_PASSWORD];
    NSLog(@"idfv is =====%@",idfv);
    
    
    
    
    
    NSString * deviceID =  idfv; //app.FinalKeyChainValue; //@"JYGSyzMsYrfZQA1FSqOY58eIZ9k=";
    NSLog(@"device id upload--%@",deviceID);
    NSString * salt =  [NSString stringWithFormat:@"%@:rz8LuOtFBXphj9WQfvFh",[[NSUserDefaults standardUserDefaults]valueForKey:@"userID_Default"]];
    NSLog(@"key is upload view --%@",salt);//  @":rz8LuOtFBXphj9WQfvFh";
    NSString * IPAddress = [self getIPAddress];
    NSString * sourceParam = @"SkagitTimes";
    //  NSString * userAgent = @"iOS";
    double  ticks =  ((milliseconds * 10000) + 621355968000000000);
    NSLog(@"ticks--%0.00000f",ticks);
    
    NSString *hashLeft = [NSString stringWithFormat:@"%@:%@:%@:%f:%@", deviceID,IPAddress ,UserAgent,ticks,sourceParam];
    NSLog(@"final string--%@",hashLeft);
    
    
    
    // NSLog(@"ip address--%@",IPAddress);
    NSData *saltData = [salt dataUsingEncoding:NSUTF8StringEncoding];
    NSData *paramData = [hashLeft dataUsingEncoding:NSUTF8StringEncoding];//deviceID
    
    NSMutableData* hash = [NSMutableData dataWithLength:CC_SHA256_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA256, saltData.bytes, saltData.length, paramData.bytes, paramData.length, hash.mutableBytes);
    NSString *base64LeftHash = [Base64 base64forData:hash];
    NSLog(@"left hash  base 64--%@",base64LeftHash);
    
    
    
    // rightHash...
    
    NSString *hashRight =[NSString stringWithFormat:@"%@:%0.00000f:%@",deviceID,ticks,sourceParam];
    NSLog(@"right Hash --%@",hashRight);
    
    NSString *token = [NSString stringWithFormat:@"%@:%@",base64LeftHash,hashRight];
    NSLog(@"concated hash --%@",token);
    //   NSData *saltData2 = [salt dataUsingEncoding:NSUTF8StringEncoding];
    NSData *paramData2 = [token dataUsingEncoding:NSUTF8StringEncoding];//deviceID
    
    //    NSMutableData* hash2 = [NSMutableData dataWithLength:CC_SHA256_DIGEST_LENGTH];
    //CCHmac(kCCHmacAlgSHA256, saltData2.bytes, saltData2.length, paramData2.bytes, paramData2.length, hash2.mutableBytes);
    Finaltoken = [Base64 base64forData:paramData2];
    NSLog(@"final token--%@",Finaltoken);
    
    
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
    
    NSLog(@"IP Address--%@",address);
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


#pragma mark -- Submit for review button.

- (IBAction)submitForReviewButton:(id)sender {

    NSString *message;
    
    if ([lbl_output_category.text length]==0 || [txt_Title.text length]==0 || [txt_View.text length]==0) {
        
        if ([lbl_output_category.text length]==0) {
            
            message = @"Please select a category";
            
        }else if ([txt_Title.text length]==0){
            message=@"Please enter a title";
            
            
        }else if ([txt_View.text length]==0){
            
            message = @"Please enter a story";
        }
      /*  UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        */
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Alert" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * actionAlert = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction* alert){
            
            
        }];
        [alert addAction:actionAlert];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
    
    
    
    
    
    
    __block  NSString *categoryId_String;
    
    //AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [ [app.categoryNameArray objectAtIndex:0] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        
        NSString *campareStr = [NSString stringWithFormat:@"%@",[[app.categoryNameArray objectAtIndex:0]objectAtIndex:idx]];
        if ([campareStr isEqualToString:lbl_output_category.text]) {
            
            categoryId_String = [NSString stringWithFormat:@"%@",[[app.id_CategoryArray objectAtIndex:0]objectAtIndex:idx]];
            
        }
    }];
    

    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    NSString *date=[dateFormatter stringFromDate:[NSDate date]];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm a"];
    NSString *time=[formatter stringFromDate:[NSDate date]];
    
    
      /*  if ([objectDataClass.globalSubmitArray count]==0) {
            
            objectDataClass.globalSubmitArray = [[NSMutableArray alloc] init];
        }
        else {
            
            // do nothing..
            
        }*/
    
    
    [collectedDict setValue:txt_Title.text forKey:@"Title"];
    [collectedDict setValue:txt_View.text forKey:@"FullStory"];
    [collectedDict setValue:categoryId_String forKey:@"Id_Category"];    // picker view 's category.....
    [collectedDict setValue:[[NSUserDefaults standardUserDefaults] stringForKey:@"userID_Default"] forKey:@"SubmittedBy"];         // user id need to get set here .
    [collectedDict setValue:@"Submitted" forKey:@"JournalStatus"];
    [collectedDict setValue:@"4" forKey:@"Id_MainCategory"];
    [collectedDict setValue:@"" forKey:@"Id_Blob"];
    [collectedDict setValue:date forKey:@"Date"];
    [collectedDict setValue:time forKey:@"Time"];
    [collectedDict setValue:@"TEXT" forKey:@"Type"];
    [collectedDict setValue:lbl_output_category.text forKey:@"localCategoryName"];
    
    
     
        
        if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"SubmitArray"] count]<15) {
            
            
            if (tempArray == nil) {
                
                [LocalDataHandleArray addObject:collectedDict];
                
                
            }else{
                
                
                [LocalDataHandleArray removeObjectAtIndex:objectDataClass.globalIndexSelection];
                [LocalDataHandleArray addObject:collectedDict];
                
            }
            
            
        }else{
            
            [LocalDataHandleArray removeObjectAtIndex:0];
            
            
        }
        
        
        [[NSUserDefaults standardUserDefaults]setValue:LocalDataHandleArray forKey:@"SubmitArray"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        
        
        
    
    // showing alertcontroller...
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Message" message:@"Your information has been saved for later submission." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * alertAction = [UIAlertAction  actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
    
        [self.navigationController popViewControllerAnimated:YES]; 
    
    }];
    
    [alert addAction:alertAction];
    [self presentViewController:alert animated:YES completion:nil];
    
    } // if END....
}

//For video.....
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
        [randomString appendFormat: @"%C", [letter2 characterAtIndex: arc4random_uniform([letter2 length])]];
    }
    
    return randomString;
}

#pragma mark -- calling image picker..
#pragma mark - Image Picker Controller delegate methods   starts ...

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    
    if (info[UIImagePickerControllerMediaType]) {
        [[NSUserDefaults standardUserDefaults]setValue:@"DoneVideo" forKey:@"Video_Check"];
        
        
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
        
    }else{
        
        
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
        
        NSLog(@"image is ========%@",mainImage);
        
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
        
        // Nav_valueToPhoto =YES;
        
        //  handleView = YES ;
        CGSize size = [[UIScreen mainScreen]bounds].size;
        
        if (size.height==480) {
            
            UploadPhoto *uploadP = [[UploadPhoto alloc]initWithNibName:@"UploadPhoto3.5" bundle:nil];
            uploadP.transferedImageData =data;
            uploadP.transferPhotoUniqueName = captureduniqueName;
            [self.navigationController pushViewController:uploadP animated:NO];
            
        }else{
            
            UploadPhoto *uploadP = [[UploadPhoto alloc]initWithNibName:@"UploadPhoto" bundle:nil];
            uploadP.transferedImageData =data;
            uploadP.transferPhotoUniqueName = captureduniqueName;
            //  uploadP.navigateValue = Nav_valueToPhoto;
            [self.navigationController pushViewController:uploadP animated:NO];
            
        }
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self.view setNeedsLayout];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [tabBarController setSelectedItem:nil]; // set tab bar unselected
    [tabBarController setSelectedItem:[tabBarController.items objectAtIndex:3]];

    NSLog(@"cancel Tapped!");
    
    isPickerTapped = YES;
    //   segment_Outlet.selectedSegmentIndex=-1;
    
    
    
    //    if (IS_OS_8_OR_LATER) {   // code for ios 8 or above !!!!!!!!!
    //
    //        [picker.view removeFromSuperview] ;
    //        [picker removeFromParentViewController] ;
    //
    //    }else {
    //  [self.scrollView_Photo setScrollEnabled:NO];
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
    NSLog(@"unique name --%@",finalUnique);
    return finalUnique;
    
}
// For Video.....

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
    NSLog(@"didFailWithError: %@", error);
    
    
    if([CLLocationManager locationServicesEnabled]){
        
        NSLog(@"Location Services Enabled");
        
        if ([CLLocationManager  authorizationStatus] == kCLAuthorizationStatusDenied) {
            
            without_Address = [[UIAlertView alloc]initWithTitle:@"Location auto capturing is off" message:@"Please enter the location for your story" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Submit", nil];
            without_Address.alertViewStyle=UIAlertViewStylePlainTextInput;
            UITextField *txtLocation = [without_Address textFieldAtIndex:0];
            txtLocation.delegate     = self;
            txtLocation.text         = @"";
            txtLocation.clearButtonMode = UITextFieldViewModeWhileEditing;
            [txtLocation setPlaceholder:@"Location"];
            [self.view endEditing:YES];
            [without_Address show];
            
            
        }
        
    }
    else {
        
        
        without_Address = [[UIAlertView alloc]initWithTitle:@"Location auto capturing is off" message:@"Please enter the location for your story" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Submit", nil];
        without_Address.alertViewStyle=UIAlertViewStylePlainTextInput;
        UITextField *txtLocation = [without_Address textFieldAtIndex:0];
        txtLocation.delegate     = self;
        txtLocation.text         = @"";
        txtLocation.clearButtonMode = UITextFieldViewModeWhileEditing;
        [txtLocation setPlaceholder:@"Location"];
        [self.view endEditing:YES];
        [without_Address show];
        
        
    }
    
    
    
    
    
}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil)
    {
        
        NSLog(@"lat is ====%@",[NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude]);
        NSLog(@"long is ====%@",[NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude]);
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
    
    NSLog(@"%@",responseObject);
    
    NSLog(@"op address is ===%@",[[[responseObject valueForKey:@"results"] valueForKey:@"formatted_address"]objectAtIndex:0]);
    
    [[NSUserDefaults standardUserDefaults]setValue:[NSString stringWithFormat:@"%@",[[[responseObject valueForKey:@"results"] valueForKey:@"formatted_address"]objectAtIndex:0]] forKey:@"address_Default"];
    
    checkStr = [[NSUserDefaults standardUserDefaults]stringForKey:@"address_Default"];
    
    [self createCustomUiField];
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
        
        
        [self createCustomUiField];
        
    }
    
}


@end