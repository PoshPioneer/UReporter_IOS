//
//  UploadPhoto.m
//  pioneer
//
//  Created by Valeteck on 29/07/14.
//  Copyright (c) 2014 CYNOTECK. All rights reserved.
//

#import "UploadPhoto.h"
#import "AppDelegate.h"
#import "IQActionSheetPickerView.h"
#import "Setting_Screen.h"
#import "KeyChainValteck.h"
#import "UploadVideoView.h"
#import "UploadTextView.h"
#import "UploadAudioView.h"
#import "DataClass.h"
#import <CommonCrypto/CommonHMAC.h>
#import "Base64.h"
#import <CommonCrypto/CommonDigest.h>
#include <ifaddrs.h>
#include <arpa/inet.h>
#import "UploadView.h"
#import "RecordAudioView.h"




//#import <AssetsLibrary/AssetsLibrary.h>
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";


@interface UploadPhoto ()<SyncDelegate,CLLocationManagerDelegate>
{
NSURLSessionUploadTask *task;
NSMutableData *responseData;
    
    NSString *imagePath;
    NSString* localUrl;
    
    
    UIVisualEffectView *visualEffectView;
    UIView * customAlertView;
    NSString *checkStr;
    DataClass * objectDataClass;
    
   
     NSMutableDictionary *PhotocollectedDict;
    NSString *fileName;
    NSString *finalUnique;
    NSData *data ;
    NSString * categoryId_String;
    BOOL VideoIsTapped;
    BOOL isBrowserTapped;
    NSString*finalUniqueVideo;
    NSString *tempPath ;
    NSData* videoData;
    UIImage *imageThumbnail;

    
    // new on 22 april....
    
    NSString * localUrltesting;
    NSData * localImageData;
    
    BOOL checkUserComingFrom;
   NSMutableArray *LocalDataHandleArray;
    
    SyncManager *sync;
    CLLocationManager *locationManager;

   
}
@end
@implementation UploadPhoto


@synthesize photoDataDictionary,transferPhotoUniqueName,navigateValue;
@synthesize circular_Progress_View,transferFileURl;
@synthesize segment_Outlet;
@synthesize txt_Title,txt_View;
@synthesize mainImage;
@synthesize written_Address;
@synthesize cut_Sec,lbl_AddStory_Outlet,lbl_finalPicker_Selected,lbl_Select_new_Category,lbl_selected_File_Outlet,lbl_Title,image_AddStory_Outlet,image_Select_NewCategory,image_Title_Outlet,img_View_Selected_File_Outlet,btn_Reset_Outlet,btn_Selected_new_Category_Outlet,btn_Upload_Outlet;
@synthesize alert_Message;
@synthesize progressView,responseDataForRestOfTheDetailService;
@synthesize ok_For_Success_Outlet;
@synthesize img_ForSuccess_Unsuccess,view_ForSuccess_Unsuccess,isItFirstService;
@synthesize with_Address_Optional_Written;
@synthesize handleView,lbl_output_category ,cutboolValue;

@synthesize tabBarController,audioTabBar,textTabBar,photoTabBar,videoTabBar;

@synthesize takeAPhotoTapped,browseGalleryTapped,submitForReview_Outlet,tempArray,transferImageData,capturedImage,transferedImageData;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        
        // Custom initialization
    }
    return self;
}


-(void)checkCategoryData {
    
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
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

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    objectDataClass = [DataClass getInstance];
    
    PhotocollectedDict = [NSMutableDictionary dictionary];
    
    
    sync = [[SyncManager alloc] init];
    sync.delegate = self;


    img_ForSuccess_Unsuccess.userInteractionEnabled = YES;

    photoDataDictionary=[NSMutableDictionary dictionary];
    
    [lbl_output_category setUserInteractionEnabled:NO];
    timerCheck = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(checkCategoryData) userInfo:nil repeats:YES];
    
    
    segment_Outlet.selectedSegmentIndex=-1;
    segment_Outlet.layer.cornerRadius=2.0;
	segment_Outlet.tintColor =[UIColor redColor];
    
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSLog(@"id's  are =====%@",app.id_CategoryArray);
    NSLog(@"names are =====%@",app.categoryNameArray);
    
    tabBarController.delegate = self;

    
}

-(void)viewWillAppear:(BOOL)animated {
    
    [tabBarController setSelectedItem:[tabBarController.items objectAtIndex:1]];
    [tabBarController setTintColor:[UIColor whiteColor]]; // set tab bar selection color white

    // working .....
    LocalDataHandleArray=[[NSMutableArray alloc]init];
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"SubmitArray"] count]==0) {
        
        ///
        
        
    }else{
        
        LocalDataHandleArray=[[[NSUserDefaults standardUserDefaults]valueForKey:@"SubmitArray"] mutableCopy];

    }
    
    // end.....
    
    
    
    
    
    handleView =YES;
    
    
    if (navigateValue == YES) {
        //generateUniqueName
        lbl_finalPicker_Selected.text = transferPhotoUniqueName;
        
    }else{
        
        //nothing.....
        
        
    }

    [capturedImage setImage:[UIImage imageWithData:transferedImageData]];
    localUrl = transferFileURl;
    mainImage = [[UIImage alloc] initWithData:transferedImageData];
    data =transferedImageData;
    if (tempArray == NULL) {
   
          checkUserComingFrom=TRUE;
    }
    
    else {
        
    
        
//NSLog(@"collected data from review view --%@",tempArray);
        [self.view setNeedsLayout];
        
    txt_Title.text = [[tempArray  objectAtIndex:objectDataClass.globalIndexSelection] valueForKey:@"Title"] ;
    txt_View.text = [[tempArray objectAtIndex:objectDataClass.globalIndexSelection]valueForKey:@"FullStory"];
    id categoryID = [[tempArray objectAtIndex:objectDataClass.globalIndexSelection] valueForKey:@"Id_Category"] ;
    lbl_finalPicker_Selected.text = [[tempArray objectAtIndex:objectDataClass.globalIndexSelection] valueForKey:@"uniqueName"];
        //UIImage *image = [[UIImage alloc] initWithData:data];
        transferImageData = [[tempArray objectAtIndex:objectDataClass.globalIndexSelection] valueForKey:@"transferImage"];
       // mainImage = [UIImage initWithData:transferImageData];
        mainImage = [[UIImage alloc] initWithData:transferImageData];
        localUrltesting = [[tempArray objectAtIndex:objectDataClass.globalIndexSelection]valueForKey:@"fileURl"];
        NSLog(@"local url--%@",localUrltesting);
        [capturedImage setImage:[UIImage imageWithData:transferImageData]];

        
    NSLog(@"category value--%@",categoryID);
    if ([categoryID isEqualToString: @"1"]) {
        
        lbl_output_category.text = @"Politics";
        categoryId_String= categoryID;
        
    }else if ([categoryID isEqualToString:@"2"]){
        
        lbl_output_category.text =@"Sports";
        categoryId_String= categoryID;
        
        
        
    }else if ([categoryID isEqualToString:@"3"]){
        
        lbl_output_category.text =@"Games";
        categoryId_String =categoryID;
        
    }else if ([categoryID isEqualToString:@"4"]){
        lbl_output_category.text =@"Movie";
        categoryId_String= categoryID;
        
    
    }

        handleView = YES ;
        
        
}
    
    
    
    
 
    
    
    
    NSLog(@"viewwillAppear!!!!");
    segment_Outlet.tintColor =[UIColor colorWithRed:132.0/255.0 green:193.0/255.0 blue:185.0/255.0 alpha:1.0];
    
    videoTabBar.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    audioTabBar.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    textTabBar.imageInsets  = UIEdgeInsetsMake(6, 0, -6, 0);
    photoTabBar.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);

    [self.scrollView_Photo setScrollEnabled:YES];
    [self.scrollView_Photo setContentSize:CGSizeMake(320, 700)];
    
    
    
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewDidLayoutSubviews{
    
    NSLog(@"viewDidLayoutSubviews called.");
    // 12 August code .
    
    
    if (!handleView)
    {
        // photo is not taken !!!!!
   
        NSLog(@"inside !handleView");
        [self doItResize:@"hide"];
        

    }else
    {
        // photo has been taken !!!!

                    if (cutboolValue) // when cut_Selected tapped!!!!!!
                    {
                        
                        NSLog(@"inside cutboolValue");
                        cutboolValue=NO ;
                        [self doItResize:@"hide"];
                        
                    }else if (mainImage==nil){ // when no image !!!!!!
                        
                        NSLog(@"inside mainImage==nil");
                        
                        if (isPickerTapped) {
                            
                            
                            [self doItResize:@"hide"];
                        }
                        

                    }else{
                        
                        NSLog(@"inside else below mainImage==nil");

                        [lbl_selected_File_Outlet setHidden:NO];
                        [img_View_Selected_File_Outlet setHidden:NO];
                        [lbl_finalPicker_Selected setHidden:NO];
                        [cut_Sec setHidden:NO];
                        
                        
                        
                        if ([lbl_finalPicker_Selected.text length]==0) {
                            
                            lbl_finalPicker_Selected.text=[self  generateUniqueName];
                            
                        }
                        if (isCameraClicked) {
                            
                            if ([lbl_selected_File_Outlet.text length]==0) {
                                
                                lbl_selected_File_Outlet.text= @"Captured photo";
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
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if(item.tag == 0)
    {
        
        NSLog(@"Video Tab bar tapped");
        [self checkforNavigationInternetconnection:1];
        
    }/*else if (item.tag ==2) {
        
        NSLog(@"Photo tab bar tapped");
        [self checkforNavigationInternetconnection:2];
        
    }*/else if (item.tag ==2){
        
        NSLog(@"Audio Tab bar tapped");
        
        [self checkforNavigationInternetconnection:3];
        
    }else if (item.tag ==3) {
      
      NSLog(@"Text Tab bar tapped");
      
      [self checkforNavigationInternetconnection:4];
      }
}


-(void)doItResize:(NSString *)hideAndShow{
    
   // segment_Outlet.selectedSegmentIndex=-1;

    NSLog(@"doItResize called.");
    
    int  increment_Decrement = 0;
    
    NSString *hide_Show = hideAndShow;
    
    if ([hide_Show isEqualToString:@"show"]) {
        
        increment_Decrement=+56;
        
        [lbl_selected_File_Outlet setHidden:NO];
        [img_View_Selected_File_Outlet setHidden:NO];
        [lbl_finalPicker_Selected setHidden:NO];
        [cut_Sec setHidden:NO];

        
    }else{
        lbl_finalPicker_Selected.text=nil;
        mainImage=nil;
        increment_Decrement=-56;
        [lbl_selected_File_Outlet setHidden:YES];
        [img_View_Selected_File_Outlet setHidden:YES];
        [lbl_finalPicker_Selected setHidden:YES];
        [cut_Sec setHidden:YES];

    }
    
 

}



#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000

- (BOOL)prefersStatusBarHidden {
    return shouldHideStatusBar;
}

#endif

- (IBAction)segmentController_Handler:(id)sender {


//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
//
//    AppDelegate *appDel = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    [appDel hideIt];
//     shouldHideStatusBar = YES ;
//    [self prefersStatusBarHidden];
//    
//#endif
   
    if (IS_OS_8_OR_LATER) {
        // code for ios 8 or above !!!!!!!!!

    ////////
        
        
        if ([sender selectedSegmentIndex]==0) {
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
 
            
        }else if ([sender selectedSegmentIndex]==1){
            
            [self.view endEditing:YES];
            NSLog(@"Browose Tapped");
            
            isCameraClicked=NO;
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            
//            [self addChildViewController:picker];
//            [picker didMoveToParentViewController:self];
//            [self.view addSubview:picker.view];
            [self presentViewController:picker animated:YES completion:NULL];

        }
  
    ///////
    
    }else{
    
    if ([sender selectedSegmentIndex]==0) {
        
        NSLog(@"capture photo tapped");
        
        isCameraClicked=YES;
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:picker animated:YES completion:NULL];
        
        
    }else if ([sender selectedSegmentIndex]==1){
        
        NSLog(@"Browose Tapped");
        
        isCameraClicked=NO;
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
      
        [self presentViewController:picker animated:YES completion:NULL];
       
    }
    
    }
    
}

-(NSString *) randomStringWithLength: (int) len {
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform([letters length])]];
    }
    
    return randomString;
}



#pragma mark - Image Picker Controller delegate methods   starts ...

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    
    if (VideoIsTapped == YES) {
        
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

        
        
        
    }else{
    
    // for Photo..
        
        
    checkUserComingFrom= TRUE;
    
    
    UIImage *chosenImage; //= info[UIImagePickerControllerEditedImage];
    
    if (info[UIImagePickerControllerEditedImage ]) {
        
        chosenImage =info[UIImagePickerControllerEditedImage];
        
    }else{
        
        chosenImage =info[UIImagePickerControllerOriginalImage];

    }
    
    
    
    mainImage = chosenImage;
    data = UIImagePNGRepresentation(mainImage);
    NSLog(@"converted data--%@",data);
    
//   localUrl = (NSURL *)[info valueForKey:UIImagePickerControllerReferenceURL];
//    NSLog(@"imagepath==================== %@",localUrl);
    
    if(isCameraClicked)
    {
        UIImageWriteToSavedPhotosAlbum(mainImage,  nil,  nil, nil);
        
        
    }
    
   // NSLog(@"image is ========%@",mainImage);
    
   // NSLog(@"info==============%@",info);
    
    //New chamges
    
UIImage *editedImage = [info objectForKey:UIImagePickerControllerEditedImage];
//    NSString *docDirPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    
    
    
    NSString *documentsDirectory;
    for (int i=0; i<[pathArray count]; i++) {
        documentsDirectory =[pathArray objectAtIndex:i];
    }
    
    
    NSLog(@"%lu",(unsigned long)[[[NSUserDefaults standardUserDefaults]objectForKey:@"MyArray"] count]);
    
   
   // NSString *myUniqueName = [NSString stringWithFormat:@"%@-%u", name, (NSUInteger)([[NSDate date] timeIntervalSince1970]*10.0)];

    //mohit logic
    
    fileName = [NSString stringWithFormat:@"%lu.png",(unsigned long)([[NSDate date] timeIntervalSince1970]*10.0)];
    
    
    //
    
    
   // NSString *documentsDirectory = [pathArray objectAtIndex:0];
    
    localUrl =  [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:fileName];//[documentsDirectory stringByAppendingPathComponent:fileName];
    NSLog (@"File Path = %@", localUrl);
    
    // Get PNG data from following method
    NSData *myData =     UIImagePNGRepresentation(editedImage);
    // It is better to get JPEG data because jpeg data will store the location and other related information of image.
    [myData writeToFile:localUrl atomically:YES];
    
    // Now you can use filePath as path of your image. For retrieving the image back from the path
    UIImage *imageFromFile = [UIImage imageWithContentsOfFile:localUrl];
    
    
    [[NSUserDefaults standardUserDefaults]setValue:@"DonePhoto" forKey:@"Photo_Check"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    //[picker dismissViewControllerAnimated:YES completion:NULL];
    NSLog(@"photo done--%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"Photo_Check"]);
    
    handleView = YES ;
    
    [capturedImage setImage:[UIImage imageWithData:data]];

    
//    if (IS_OS_8_OR_LATER) {
//        [picker.view removeFromSuperview] ;
//        [picker removeFromParentViewController] ;
//        
//    }else{
    [self.scrollView_Photo setScrollEnabled:YES];
   // [self.scrollView_Photo setContentSize:CGSizeMake(320, 600)];
    [self.scrollView_Photo setContentOffset:CGPointMake(5, 5) animated:YES];
        [picker dismissViewControllerAnimated:YES completion:nil];
    [self.view setNeedsLayout];
  //  }
   
    
//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
//
//     AppDelegate *appDel = (AppDelegate *)[UIApplication sharedApplication].delegate;
//     [appDel showIt];
//     shouldHideStatusBar = NO;
//     [self prefersStatusBarHidden];
//    [self.view setNeedsLayout];
//    
//#endif
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
    [tabBarController setSelectedItem:[tabBarController.items objectAtIndex:1]];

    
    isPickerTapped = YES;
    segment_Outlet.selectedSegmentIndex=-1;
  
    
    
//    if (IS_OS_8_OR_LATER) {   // code for ios 8 or above !!!!!!!!!
//        
//        [picker.view removeFromSuperview] ;
//        [picker removeFromParentViewController] ;
//        
//    }else {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    [self.view setNeedsLayout];

//    }
    
//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
//    
//     AppDelegate *appDel = (AppDelegate *)[UIApplication sharedApplication].delegate;
//     [appDel showIt];
//     shouldHideStatusBar = NO;
//     [self prefersStatusBarHidden];
//    [self.view setNeedsLayout];
//
//#endif


    
}

#pragma mark - Image Picker Controller delegate methods   ends ...

- (IBAction)cut_Selected_FileTapped:(id)sender {
   
    cutboolValue = YES ;
    
    segment_Outlet.selectedSegmentIndex=-1;
//    mainImage=nil;
//    lbl_finalPicker_Selected.text=nil;

    //[self.view setNeedsDisplay];
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
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [lbl_output_category setItemList:[NSArray arrayWithArray:[app.categoryNameArray objectAtIndex:0]]];
    
        
}

-(void)enableOff{
    
    [segment_Outlet setUserInteractionEnabled:NO];
    [cut_Sec setUserInteractionEnabled:NO];
    [lbl_output_category setUserInteractionEnabled:NO];
    [txt_Title setUserInteractionEnabled:NO];
    [txt_View setUserInteractionEnabled:NO];
}

-(void)doneClicked:(UIBarButtonItem*)button
{
    [self.view endEditing:YES];
    //isPickerTapped = NO ;
    
    [segment_Outlet setUserInteractionEnabled:YES];
    [cut_Sec setUserInteractionEnabled:YES];
    [lbl_output_category setUserInteractionEnabled:YES];
    [txt_Title setUserInteractionEnabled:YES];
    [txt_View setUserInteractionEnabled:YES];

}


#pragma mark unused code ios 7.





- (IBAction)back_Tapped:(id)sender {
    
    NSArray *array = [self.navigationController viewControllers];
    
    NSLog(@"Photo content from array is :  %@",array);
    
    
    
    if ([lbl_output_category.text length]>0 ||  mainImage !=nil  || [txt_Title.text length]>0 || [txt_View.text length]>0) {
        
        goBackAlert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Are you sure you want to cancel this news submission?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
        [goBackAlert show];
        
    
    } else{
        

        txt_View.text=nil;
        txt_Title.text=nil;
        lbl_finalPicker_Selected.text=nil;
        lbl_output_category.text=@"Choose Category";
         mainImage=nil;
       // [self.navigationController popViewControllerAnimated:NO];
        [self.navigationController popToViewController:[array objectAtIndex:1] animated:NO];

        
    }
    
}

- (IBAction)reset_Tapped:(id)sender {

    NSArray *array = [self.navigationController viewControllers];
    
    NSLog(@" Text content from array is :  %@",array);

        txt_View.text=nil;
        txt_Title.text=nil;
        lbl_finalPicker_Selected.text=nil;
        lbl_output_category.text=nil;
        mainImage=nil;
    
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
    //  [self doItResize:@"hide"];
    
}

- (IBAction)upload_Tapped:(id)sender {
    
   
    
    [self.view endEditing:YES];
    
    // NSString *server = [[NSUserDefaults standardUserDefaults]stringForKey:@"connection_Internet"];
    if ([Utility connected] == YES) {
    
    if ([lbl_finalPicker_Selected.text length]==0 || [lbl_output_category.text length]==0 || [txt_Title.text length]==0 || [txt_View.text  length]==0 || mainImage ==nil) {
        
        if ([lbl_finalPicker_Selected.text length]==0 || mainImage ==nil) {
            
            alert_Message=@"Please select a file";
        }else if ([lbl_output_category.text length ]==0){
            
            alert_Message=@"Please select a category";
        }else if ([txt_Title.text length]==0){
            
            alert_Message=@"Please enter a title";
        }else if ([txt_View.text length]==0){
            
            alert_Message = @"Please enter a story";
        }

        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:alert_Message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
    }else{
        
        checkStr = [[NSUserDefaults standardUserDefaults]stringForKey:@"address_Default"];
        
        [self blurEffect];
        
        
        [self StartUpdating];
        
        
      /*
        if (!checkStr) {
            
            without_Address = [[UIAlertView alloc]initWithTitle:@"Location auto capturing is off" message:@"Please enter the location for your story" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Submit", nil];
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
       */
        
    }
        
    }else{
        
        UIAlertController *DoNothing_alrt = [UIAlertController alertControllerWithTitle:@"Alert!" message:@"Internet connection is not available.\n Please try again." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * doNothingAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * alert ){

            
        }];
        
        [DoNothing_alrt addAction:doNothingAction];
        [self presentViewController:DoNothing_alrt  animated:YES completion:nil];

    }
    
    
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
    
    NSArray *array = [self.navigationController viewControllers];

    if (alertView == with_Address) {
        
 
        
        with_Address_Optional_Written=[alertView textFieldAtIndex:0].text;
        
        [self  sendphoto_ToServer];
            
        
    }else if(alertView == without_Address){
        
        if (buttonIndex == 0)
        {
            //    UITextField *Location = [alertView textFieldAtIndex:0];
            //    NSLog(@"username: %@", username.text);
            
            NSLog(@"first one ");
            NSLog(@"Entered: %@",[[alertView textFieldAtIndex:0] text]);
            
            if ([[alertView textFieldAtIndex:0].text length]<=0) {
                
                NSLog(@" Text content from array is :  %@",array);
                [self.navigationController popToViewController:[array objectAtIndex:1] animated:NO];
                
            }
            
        }
        else
        {
            [self  sendphoto_ToServer];
            NSLog(@"Entered: %@",[[alertView textFieldAtIndex:0] text]);
            
            //  [with_Address dismissWithClickedButtonIndex:2 animated:YES];
            
        }
        
    }else if (alertView == goBackAlert){
        
        
       // NSArray *array = [self.navigationController viewControllers];
        
        NSLog(@" Text content from array is :  %@",array);

        
        if (buttonIndex==0) {
            
            
            // do nothing ........
            // cancel tapped ...do nothing .....
            
        }else if(buttonIndex==1){
            
            
            txt_View.text=nil;
            txt_Title.text=nil;
            lbl_finalPicker_Selected.text=nil;
            lbl_output_category.text=@"Choose Category";
            mainImage=nil;
            
            
             [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"Photo_Check"];
             [[NSUserDefaults standardUserDefaults]synchronize];

            
            [self.navigationController popToViewController:[array objectAtIndex:1] animated:NO];
        }
        

    }else if (try_AgainInternet_Check==alertView){
        
        
        [self.navigationController popToViewController:[array objectAtIndex:1] animated:NO];

        
            
        }else if (buttonIndex==1){
            
            if (isItFirstService==1) {
                
                // for first service ....
                // ok tapped Try Again....
                NSLog(@"OK_Tapped");
                [self  sendphoto_ToServer];
                
                
                
            }else{
                // for second service ...
                // ok tapped Try Again....
                NSLog(@"OK_Tapped");
                [self  sendRestOfThePhotoDATA:responseDataForRestOfTheDetailService];
                
            }
            
        }
   
    }

    

-(void)sendphoto_ToServer{
    // for gradient...........
    
    layer = [CAGradientLayer layer];
    layer.frame = self.view.bounds;
    UIColor *blackColor = [UIColor colorWithWhite:0.0f alpha:1.0f];
    UIColor *clearColor = [UIColor colorWithWhite:0.0f alpha:1.0f];
    
    // hiding !!!!!
    ///////////////////////////////////////////
    //////////////////////////////////////////
    // looping all subviews except circular view for showing progress...
    
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

    [self.view setAlpha:0.4];
    [self.view setUserInteractionEnabled:NO];
    self.circular_Progress_View.frame = CGRectMake(71, 197, 175, 135);
    [self.view addSubview:self.circular_Progress_View];
    self.circular_Progress_View.thicknessRatio = 0.111111;
    self.circular_Progress_View.outerBackgroundColor=[UIColor lightGrayColor];
    self.circular_Progress_View.innerBackgroundColor=[UIColor lightGrayColor];

    self.circular_Progress_View.progressFillColor=[UIColor redColor];
    UILabel *percentSignLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 55, 25, 25)];
    [self.circular_Progress_View addSubview:percentSignLabel];
    percentSignLabel.text = @"%";
    percentSignLabel.textColor = [UIColor whiteColor];
    percentSignLabel.font = [UIFont systemFontOfSize:25];
    [self.circular_Progress_View bringSubviewToFront:percentSignLabel];



     NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
     NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
   
    //timesgroupcrapi  http://timesgroupcrapi.cloudapp.net/api/UserDet
    NSString * urlstring = [NSString stringWithFormat:@"%@%@%@%@",@"http://prngapi.cloudapp.net/api/blobs?id=",[[NSUserDefaults standardUserDefaults] stringForKey:@"userID_Default"],@"&token=",[GlobalStuff generateToken]];
    NSLog(@"photo url- --%@",urlstring);
    
    
    NSURL *url = [NSURL URLWithString:urlstring];//[NSString stringWithFormat:@"http://prngapi.cloudapp.net/api/blobs?id=%@",[[NSUserDefaults standardUserDefaults] stringForKey:@"userID_Default"]]];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
     cachePolicy:NSURLRequestUseProtocolCachePolicy
     timeoutInterval:300];
     
     [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
     [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
     
     [request setHTTPMethod:@"POST"];
     
     NSData *imageData = UIImageJPEGRepresentation(mainImage, 1.0);
     
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
     [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@; filename=%@\r\n", @"imageFormKey",lbl_finalPicker_Selected.text] dataUsingEncoding:NSUTF8StringEncoding]];
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
    
     task = [session uploadTaskWithStreamedRequest:request];
     [task resume];
     
    
}
#pragma mark - NSURLSessionTaskDelegate

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend
{
    NSLog(@"%lld %lld %lld", bytesSent, totalBytesSent, totalBytesExpectedToSend);
    
    if (totalBytesExpectedToSend==totalBytesSent) {
        
    }
    
    float progress = (double)totalBytesSent / (double)totalBytesExpectedToSend;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [progressView setHidden:NO];
        [self.progressView setProgress:progress];
        self.circular_Progress_View.progress = progress;
        UILabel *percentSignLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 55, 25, 25)];
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

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{

    
    
    NSLog(@"%s: error =========+++++ %@; data =========+++++ %@", __PRETTY_FUNCTION__, error, [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.circular_Progress_View removeFromSuperview];
        [self.view setAlpha:1];
        [self.view setUserInteractionEnabled:YES];
        //[layer removeFromSuperlayer];
        
        if (error==nil) {
            

            
            
            responseDataForRestOfTheDetailService =[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
            [self sendRestOfThePhotoDATA:[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]];

            
        }else{
            
            //when not successfully submitted!!!!!
            
            NSLog(@"error available!");
            
            isItFirstService=1;
            try_AgainInternet_Check = [[UIAlertView alloc]initWithTitle:@"Alert" message:/*@"Internet connection is not available. Please try again."*/error.localizedDescription delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [try_AgainInternet_Check show];
            
        }
        

        
        
    });
    

}

-(void)sendRestOfThePhotoDATA:(NSString *)Id_BlobFromService{
    
   // __block  NSString *categoryId_String;
    
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [ [app.categoryNameArray objectAtIndex:0] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        
        NSString *campareStr = [NSString stringWithFormat:@"%@",[[app.categoryNameArray objectAtIndex:0]objectAtIndex:idx]];
        if ([campareStr isEqualToString:lbl_output_category.text]) {
            
            categoryId_String = [NSString stringWithFormat:@"%@",[[app.id_CategoryArray objectAtIndex:0]objectAtIndex:idx]];
            
        }
        
    }];
    
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    //timesgroupcrapi  http://timesgroupcrapi.cloudapp.net/api/UserDet
    
    NSString * urlstring = [NSString stringWithFormat:@"%@%@",@"http://prngapi.cloudapp.net/api/CJDetails?token=",[GlobalStuff generateToken]];
    
    NSLog(@"photo url --%@",urlstring);
    
    NSURL * url = [NSURL URLWithString:urlstring]; //@"http://prngapi.cloudapp.net/api/CJDetails"];
    //  NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                           timeoutInterval:300];
    
    
    NSMutableDictionary *finalDictionary = [NSMutableDictionary dictionary];
    NSMutableDictionary *headerDict = [NSMutableDictionary dictionary];
    NSMutableDictionary *dictionaryTemp = [NSMutableDictionary dictionary];
    
    
    ////////////////////////////////
    // getting .....
    NSString *  KEY_PASSWORD = @"com.toi.app.password";
    NSString *    idfv = [[KeyChainValteck keyChainLoadKey:app.putValueToKeyChain] valueForKey:KEY_PASSWORD];
    // getting ...
    
    ////////////////////////////////
    
    
    
    [headerDict setValue:@"" forKey:@"DeviceId"];//idfv
    [headerDict setValue:@"" forKey:@"UserId"];  // user id is yet to set ....[[NSUserDefaults standardUserDefaults] stringForKey:@"userID_Default"]
    [headerDict setValue:@"" forKey:@"Source"];
    
    [dictionaryTemp setValue:txt_Title.text forKey:@"Title"];
    [dictionaryTemp setValue:txt_View.text forKey:@"FullStory"];
    [dictionaryTemp setValue:categoryId_String forKey:@"Id_Category"];    // picker view 's category.....
    [dictionaryTemp setValue:[[NSUserDefaults standardUserDefaults] stringForKey:@"userID_Default"] forKey:@"SubmittedBy"];         // user id need to get set here .
    [dictionaryTemp setValue:@"Submitted" forKey:@"JournalStatus"];
    [dictionaryTemp setValue:@"2" forKey:@"Id_MainCategory"];
    [dictionaryTemp setValue:Id_BlobFromService forKey:@"Id_Blob"];
    
    
    checkStr =    [[NSUserDefaults standardUserDefaults]stringForKey:@"address_Default"];
    
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
    
     NSLog(@"Request ON Photo ===%@",finalDictionary);
    
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
//                                                               NSLog(@"final photo o/p is  ==== %@",text);
                                                               
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
                                                               NSString *strMessage = [NSString stringWithFormat:@"%@",[[array valueForKey:@"data"]valueForKey:@"ErrorMessage"]];

                                                               if ([strId isEqualToString:@"114"]) {
                                                                   
                                                                   
                                                                   
                                                                   if (tempArray == NULL) {
                                                                       
                                                                   
                                                                   
                                                                   }
                                                                   else{
                                                                       
                                                                       // Removing index from submitdata class......

                                                                       // start....
                                                                       [LocalDataHandleArray removeObjectAtIndex:objectDataClass.globalIndexSelection];
                                                                       [[NSUserDefaults standardUserDefaults]setValue:LocalDataHandleArray forKey:@"SubmitArray"];
                                                                       // end.....

                                                                   }
                                                                   
                                                                   
                                                                   NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
                                                                [dateFormatter setDateFormat:@"dd/MM/yyyy"];
                                                                   NSString *date=[dateFormatter stringFromDate:[NSDate date]];
//                                                                   NSLog(@"%@",[dateFormatter stringFromDate:[NSDate date]]);
                                                                   
                                                                   NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                                                                   [formatter setDateFormat:@"hh:mm a"];
                                                                   NSString *time=[formatter stringFromDate:[NSDate date]];
                                                                   
                                                                   if([app.myFinalArray count]==0){
                                                                   
                                                                       app.myFinalArray=[[NSMutableArray alloc]init];
                                                                       
                                                                   }else{
                                                                   
                                                                       //do Nothing
                                                                   
                                                                   }
                                                                   
                                                                   
                                                                   
                                                                   
                                                                   
                                                                   [photoDataDictionary setValue:[lbl_output_category.text uppercaseString] forKey:@"CategoryName"];
                                                                   [photoDataDictionary setValue:txt_Title.text forKey:@"Title"];
                                                                   [photoDataDictionary setValue:txt_View.text forKey:@"FullStory"];
                                                                   [photoDataDictionary setValue:@"PHOTO" forKey:@"Type"] ;
                                                                   
                                                                   
                                                                   
                                                                   [photoDataDictionary setValue:[NSString stringWithFormat:@"%@",localUrl] forKey:@"imagePath"];
                                                                   [photoDataDictionary setValue: date forKey:@"Date"];
                                                                   [photoDataDictionary setValue:time forKey:@"Time"];
                                                                   NSLog(@"photo url--%@",[photoDataDictionary valueForKey:@"imagePath"]);
                                                                   if([app.myFinalArray count]<15){
                                                                   
                                                                   [app.myFinalArray addObject:photoDataDictionary];
                                                                   }
                                                                   else{
                                                                       [app.myFinalArray removeObjectAtIndex:0];
                                                                   }
                                                                   
                                                                   [[NSUserDefaults standardUserDefaults]setObject:app.myFinalArray forKey:@"MyArray"];
                                                                   [[NSUserDefaults standardUserDefaults]synchronize];
                                                                   
                                                                   
                                                                   NSLog(@"MyArray is ===== %@",[[NSUserDefaults standardUserDefaults]objectForKey:@"MyArray"]);

                                                                   
                                                                   
//                                                                //   UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:[NSString stringWithFormat:@"%@",[[array valueForKey:@"data"] valueForKey:@"ErrorMessage"]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//                                                                   [alert show];
                                                                   ok_For_Success_Outlet.tag=1;
                                                                   CGSize size = [[UIScreen mainScreen]bounds].size;
                                                                   
                                                                   if (size.height==480) {
                                                                       [img_ForSuccess_Unsuccess setImage:[UIImage imageNamed:@"success3.5.png"]];
                                                                       UIButton *btnUpload=[[UIButton alloc]initWithFrame:CGRectMake(126.0, 227.0, 115.0, 38.0)];
                                                                       [btnUpload setImage:[UIImage imageNamed:@"Sounds Good Btn.png"] forState:UIControlStateNormal];
                                                                       [btnUpload addTarget:self action:@selector(btn_Success_Tapped:) forControlEvents:UIControlEventTouchUpInside];
                                                                       btnUpload .clipsToBounds = YES;
                                                                       [btnUpload.layer setCornerRadius:4.5];
                                                                       [self.selectedView.layer setCornerRadius:4.0];
                                                                       
                                                                       [view_ForSuccess_Unsuccess addSubview:self.selectedView];
                                                                       [self.selectedView addSubview:btnUpload];
                                                                       
                                                                       
                                                                   }else{
                                                                       [img_ForSuccess_Unsuccess setImage:[UIImage imageNamed:@"success.png"]];
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
                                                                   
                                                                   
                                                               }else{
                                                                   
                                                                   
                                                                   NSLog(@"gaurav kestwal");
                                                                   isItFirstService=2;
                                                                   try_AgainInternet_Check = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Error While uploading image" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                                                                   [try_AgainInternet_Check show];
                                                                   

                                                                   

                                                                   
                                                               }
                                                               
                                                               
                                                               
                                                           }else {
                                                               
                                                               // if not successfull............
                                                               NSLog(@"gaurav kestwal2");

                                                               isItFirstService=2;
                                                               try_AgainInternet_Check = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Internet connection is not available. Please try again." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                                                               [try_AgainInternet_Check show];
                                                               
 

                                                               
                                                           }
                                                           
                                                       }];
    [dataTask resume];
    
    
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string  // return NO to not change text
{
    if(range.length + range.location > txt_Title.text.length)
        
    {
              return NO;
           }
      
             NSUInteger newLength = [txt_Title.text length] + [string length] - range.length;
             return newLength <= 50;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)string{
    
//    if (txt_Title == text) {
//        if(range.length + range.location > txt_Title.text.length)
//        {
//            return NO;
//        }
//        
//        NSUInteger newLength = [txt_Title.text length] + [string length] - range.length;
//        return newLength <= 50;
//    
//    
//}
//    else {
    
        if(range.length + range.location > textView.text.length)
        {
            return NO;
        }
        
        NSUInteger newLength = [txt_View.text length] + [string length] - range.length;
        return newLength <= 4000;
    
    
//    }
//    return 0;
    
    
    
}



-(void) textViewDidChange:(UITextView *)textView {
    
    if(txt_View.text.length == 0){
        txt_View.textColor = [UIColor lightGrayColor];
        // txt_View.text = @"Enter Comment Here";
        [txt_View resignFirstResponder];
    }
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    
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

/////// text view delegate ends here!!!!!!



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
        mainImage=nil;
        
        //[self.navigationController popViewControllerAnimated:YES];
        for (UIViewController *controller in self.navigationController.viewControllers) {
            
            if ([controller isKindOfClass:[UploadView class]]) {
                
                [self.navigationController popToViewController:controller
                                                      animated:YES];
                break;
            }
        }
        
    }else{
        
        // when failed!!!
        
        txt_View.text=nil;
        txt_Title.text=nil;
        lbl_finalPicker_Selected.text=nil;
        lbl_output_category.text=@"Choose Category";
        mainImage=nil;
        
        //[self.navigationController popViewControllerAnimated:YES];
        for (UIViewController *controller in self.navigationController.viewControllers) {
            
            if ([controller isKindOfClass:[UploadView class]]) {
                
                [self.navigationController popToViewController:controller
                                                      animated:YES];
                break;
                
                
            
            }
            
        }
        
        
    }
    
    
}


#pragma mark --
#pragma mark -- IBAction
- (IBAction)Video_Tapped:(id)sender {
    
    [self checkforNavigationInternetconnection:1];
    
}

/*- (IBAction)Photo_Tapped:(id)sender {
    
    [self checkforNavigationInternetconnection:2];
    
}*/

- (IBAction)Audio_Tapped:(id)sender {
    
    [self checkforNavigationInternetconnection:3];
    
    
}

- (IBAction)Text_Tapped:(id)sender {
 
 [self checkforNavigationInternetconnection:4];
 
 }


#pragma mark -- checkNavigation.
-(void)checkforNavigationInternetconnection:(int)type{
    
        if (type==1) {
            
            /*CGSize size = [[UIScreen mainScreen]bounds].size;
            
            if (size.height==480) {
                
                UploadVideoView *uploadV = [[UploadVideoView alloc]initWithNibName:@"UploadVideoView3.5" bundle:nil];
                [self.navigationController pushViewController:uploadV animated:NO];
                
            }else{
                
                UploadVideoView *uploadV = [[UploadVideoView alloc]initWithNibName:@"UploadVideoView" bundle:nil];
                [self.navigationController pushViewController:uploadV animated:NO];
                
            }*/
            VideoIsTapped = YES;
            [self loadVideoRecorder];

            
        }/*else if (type==2) {
            
            CGSize size = [[UIScreen mainScreen]bounds].size;
            
            if (size.height==480) {
                
                UploadPhoto *uploadP = [[UploadPhoto alloc]initWithNibName:@"UploadPhoto3.5" bundle:nil];
                [self.navigationController pushViewController:uploadP animated:YES];
                
            }else{
                
                UploadPhoto *uploadP = [[UploadPhoto alloc]initWithNibName:@"UploadPhoto" bundle:nil];
                [self.navigationController pushViewController:uploadP animated:YES];
                
            }
            
            
        }*/else if (type ==3){
            
            
        /*    CGSize size = [[UIScreen mainScreen]bounds].size;
            
            if (size.height==480) {
                
                UploadAudioView *uploadP = [[UploadAudioView alloc]initWithNibName:@"UploadAudioView3.5" bundle:nil];
                [self.navigationController pushViewController:uploadP animated:NO];
                
            }else{
                
                UploadAudioView *uploadP = [[UploadAudioView alloc]initWithNibName:@"UploadAudioView" bundle:nil];
                [self.navigationController pushViewController:uploadP animated:NO];
                
            }*/
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
    }
}


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


- (IBAction)btnTakeAPhotoTapped:(id)sender {
    
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
            
            ///////
        
    }else{
        
     //   if ([sender selectedSegmentIndex]==0) {
            
            NSLog(@"capture photo tapped");
            
            isCameraClicked=YES;
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            
            [self presentViewController:picker animated:YES completion:NULL];
            
  
        
    }

    
    
    
} //END of btnTakeAPhoto


- (IBAction)btnBrowserGalleryTapped:(id)sender {

    if (IS_OS_8_OR_LATER) {
        // code for ios 8 or above !!!!!!!!!
        
            [self.view endEditing:YES];
            NSLog(@"Browose Tapped");
            
            isCameraClicked=NO;
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = NO;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:picker animated:YES completion:NULL];
            

        
    }else{
        
        
            NSLog(@"Browose Tapped");
            
            isCameraClicked=NO;
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = NO;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            
            
            [self presentViewController:picker animated:YES completion:NULL];
            
        //}
        
    }

    
} //END OF btnBrowserGalleryTapped.....

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
    
    
    // label for showing location....
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
    PincodeTxt .delegate =self;
    
    
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
    
    // NSString *server = [[NSUserDefaults standardUserDefaults]stringForKey:@"connection_Internet"];
    
    if ([Utility connected] == YES) {

    [self  sendphoto_ToServer];
    
    }else {
        
        UIAlertController *DoNothing_alrt = [UIAlertController alertControllerWithTitle:@"Alert!" message:@"Internet connection is not available.\n Please try again." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * doNothingAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * alert ){
            
            
        }];
        [DoNothing_alrt addAction:doNothingAction];
        [self presentViewController:DoNothing_alrt  animated:YES completion:nil];
        
    }
    
    
}

#pragma mark -- SubmitForeReview...


- (IBAction)submitForReview:(id)sender {


    NSString *message;
    
    if ([lbl_output_category.text length]==0 || [txt_Title.text length]==0 || [txt_View.text length]==0||[lbl_finalPicker_Selected.text length]==0|| mainImage== 0) {
        
        if ([lbl_output_category.text length]==0) {
            
            message = @"Please select a category";
            
        }else if ([txt_Title.text length]==0){
            
            message=@"Please enter a title";
            
        }else if ([txt_View.text length]==0){
            
            message = @"Please enter a story";
        }else if ([lbl_finalPicker_Selected.text length]==0 || mainImage ==nil) {
            
            message=@"Please select a file";
        }
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
    } else {
        
        
        
        
        
        
      //  __block  NSString *categoryId_String;
        
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
        [dateFormatter setDateFormat:@"dd/MM/yyyy"];
        NSString *date=[dateFormatter stringFromDate:[NSDate date]];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"hh:mm a"];
        NSString *time=[formatter stringFromDate:[NSDate date]];
        
        /*if ([objectDataClass.globalSubmitArray count]==0) {
            
            objectDataClass.globalSubmitArray = [[NSMutableArray alloc] init];
        }
        else {
            
            // do nothing..
            
        }
        */
        
        
        
        
        [PhotocollectedDict setValue:txt_Title.text forKey:@"Title"];
        [PhotocollectedDict setValue:txt_View.text forKey:@"FullStory"];
        [PhotocollectedDict setValue:categoryId_String forKey:@"Id_Category"];    // picker view 's category.....
        [PhotocollectedDict setValue:[[NSUserDefaults standardUserDefaults] stringForKey:@"userID_Default"] forKey:@"SubmittedBy"];         // user id need to get set here .
        [PhotocollectedDict setValue:@"Submitted" forKey:@"JournalStatus"];
        [PhotocollectedDict setValue:@"2" forKey:@"Id_MainCategory"];
      //  [collectedDict setValue:Id_BlobFromService forKey:@"Id_Blob"];
        [PhotocollectedDict setValue:date forKey:@"Date"];
        [PhotocollectedDict setValue:time forKey:@"Time"];
        [PhotocollectedDict setValue:@"PHOTO" forKey:@"Type"];
        [PhotocollectedDict setValue:localUrl forKey:@"fileURl"];
        [PhotocollectedDict setValue:finalUnique forKey:@"uniqueName"];
        //[PhotocollectedDict setValue:data forKey:@"transferImage"];
        [PhotocollectedDict setValue:lbl_output_category.text forKey:@"localCategoryName"];
        
        if (!checkUserComingFrom) {
            
            [PhotocollectedDict setValue:localUrltesting forKey:@"fileURl"];
            [PhotocollectedDict setValue:transferImageData forKey:@"transferImage"];
            
            
            // user cptured image....
        }else{
            
            [PhotocollectedDict setValue:localUrl forKey:@"fileURl"];
            [PhotocollectedDict setValue:data forKey:@"transferImage"];
            
            // user does not....
        }
        
        // app.submitDict = [collectedDict copy];
//          NSLog(@"collected data in app--%@",collectedDict);

      /*  if ([objectDataClass.globalSubmitArray count]<15) {
            
            [objectDataClass.globalSubmitArray  addObject:PhotocollectedDict];
            NSLog(@"global arra neew --%@",objectDataClass.globalSubmitArray);
            
        }else{
            
            [objectDataClass.globalSubmitArray removeObjectAtIndex:0];
            
        }*/
        
        
        if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"SubmitArray"] count]<15) {
            
            
            if (tempArray ==nil) {
                
                [LocalDataHandleArray addObject:PhotocollectedDict];
                
                
            }else{
                
                
                [LocalDataHandleArray removeObjectAtIndex:objectDataClass.globalIndexSelection];
                [LocalDataHandleArray addObject:PhotocollectedDict];
                
            }
            
            
        }else{
            
            [LocalDataHandleArray removeObjectAtIndex:0];
            
            
        }
        
        
        [[NSUserDefaults standardUserDefaults]setValue:LocalDataHandleArray forKey:@"SubmitArray"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
    
        
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Message" message:@"Your information has been saved for later submission." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * alertAction = [UIAlertAction  actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
            
            [self.navigationController popViewControllerAnimated:YES]; 
            
        }];
        
        [alert addAction:alertAction];
        [self presentViewController:alert animated:YES completion:nil];
        
    } // if END....


}


@end

