//
//  DetailsViewController.m
//  Pioneer
//
//  Created by Deepankar Parashar on 16/02/16.
//  Copyright © 2016 CYNOTECK. All rights reserved.
//

#import "DetailsViewController.h"
#import <UIImageView+WebCache.h>
#import "DataClass.h"
#import "ChildView.h"
#import "SubscribeVC.h"
#import "RecordAudioView.h"
#import "UploadTextView.h"
#import "Setting_Screen.h"
#import "UploadVideoView.h"
#import "UploadPhoto.h"
#import "DBController.h"
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
NSString *letterss = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

@interface DetailsViewController () {

    UIPageControl *pageControl;
     UIScrollView *scrollView;
    NSData *converted_Image;
    DataClass * objectDataClass;
    UILabel * newsTitle ;
    NSUInteger* counterLoop;
    NSUInteger index;
  
    //
    
    UIImage *imageThumbnail;
    NSData* videoData;
    NSString *tempPath ;
    BOOL isBrowserTapped;
    NSString*finalUniqueVideo;
    NSString *fileName;
    BOOL isCameraClicked;
    BOOL VideoIsTapped; // for checking video is tapped.
    NSString* localUrl;
    NSString* captureduniqueName;
    BOOL Nav_valueToPhoto;
    NSString*finalUnique;
    NSData *data ;


}

@end

@implementation DetailsViewController
@synthesize allDataArray,LocalIndex,mainImage,tabBarController;




- (void)viewDidLoad {
    [super viewDidLoad];
    
    

    
    
    DataClass *obj = [DataClass getInstance];
    
    if (obj.globalCounter == 0 )
    {
        if ([[NSUserDefaults standardUserDefaults] valueForKey:@"subscribeStatus"] == nil) {
            
            
            
            UIAlertController *  alert  = [UIAlertController alertControllerWithTitle:@"" message:@"You've read all the free articles for this month." preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Subscribe" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                
                //do something when click button
                
                SubscribeVC *subscribeObj = [[SubscribeVC alloc] initWithNibName:@"SubscribeVC" bundle:nil];
                [self.navigationController pushViewController:subscribeObj animated:YES];
                
                
            }];
            [alert addAction:okAction];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                
                [self.navigationController popViewControllerAnimated:YES];
                
                //do something when click button
            }];
            [alert addAction:cancelAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }

    
    
    // Do any additional setup after loading the view from its nib.

    objectDataClass = [DataClass getInstance];
    
    LocalIndex = objectDataClass.globalIndex;
    
    DLog(@"global index --%ld",(long)LocalIndex);
       
    
    // ------------ adding pageviewcontroller---------
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    self.pageController.dataSource = self;
   // [[self.pageController view] setFrame:[[self view] bounds]];
    [[self.pageController view] setFrame:CGRectMake(0.0, 65.0, 320.0, 450.0)]; //0.0, 64.0, 320.0, 450.0
    
    
    
    // pages are created on demand
    // load the visible page
    // load the page on either side to avoid flashes when the user starts scrolling
   
    
    //----------- Loading childView-----------------
    
    ChildView *initialViewController = [self viewControllerAtIndex:LocalIndex]; //0

    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:self.pageController];
    [[self view] addSubview:[self.pageController view]];
    [self.pageController didMoveToParentViewController:self];
    

    
    
}

- (ChildView *)viewControllerAtIndex:(NSUInteger)index {
    
    ChildView *childViewController = [[ChildView alloc] initWithNibName:@"ChildView" bundle:nil];
    childViewController.testArray = [allDataArray copy];
    
   // childViewController.collectedTitle = self.getNewsTitle;
   // childViewController.collectedDescription = self.getDescriptionString;
    
    //childViewController.completeURls_Array = self.getImageURls_Array;
    childViewController.completeURLs = self.getImageURls_Dict;
    
    childViewController.index = index;
    childViewController.pageIndex = (NSUInteger*)index;    

    
    return childViewController;
    
}

#pragma mark -- UIPagecontroller DataSource...

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    index = [(ChildView *)viewController index];
    
    if (index == 0) {
        
        return nil;
    }
    
    // Decrease the index by 1 to return
    index--;
    
    //objectDataClass.globalIndex--;
    LocalIndex --;
    return [self viewControllerAtIndex:index];
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    index = [(ChildView *)viewController index];
    
    index++;

    if (index == [allDataArray count]) {
    
        return nil;
    
    }
    

    LocalIndex++;


    return [self viewControllerAtIndex:index];
    
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed{
    
    if(completed){
        
        ChildView *enlarge =[self.pageController.viewControllers lastObject];
        
        objectDataClass.globalIndex = *(enlarge.pageIndex);
        
       // NSLog(@"%lu",(unsigned long)indexx);
     
    }
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    // The number of items reflected in the page indicator.
    
    
    return [allDataArray count];
    
}

/*- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    // The selected item reflected in the page indicator.
    
    return 0;

}
*/







-(void) loadImages {
    
  
    
    getImage_Array = [NSMutableArray new];
    
    // DLog(@"description after navigating --%@",self.getDescriptionString);
    
    NSArray *allKeys =[self.getImageURls_Dict allKeys];
    kNumberOfPages = allKeys.count;
    
    
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 65,320,180)];//(0,0,320,460)
   // [self.view addSubview:scrollView];
  //  scrollView.backgroundColor=[UIColor redColor];
    // a page is the width of the scroll view
    scrollView.pagingEnabled = YES;
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * kNumberOfPages, scrollView.frame.size.height);
    //scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.scrollsToTop = NO;
    scrollView.delegate = self;
    
    pageControl.numberOfPages = kNumberOfPages;
    pageControl.currentPage = 0;
    
    
//    [self.view setUserInteractionEnabled:NO];
//    spinner=[SpinnerView loadSpinnerIntoView:self.view];
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        for (int i = 0; i< kNumberOfPages; i++) {
            
    
            NSString *ImageURL = [self.getImageURls_Dict valueForKey:[NSString stringWithFormat:@"url%d",i+1]]; //self.getimageURl;
            NSLog(@"image url -- %@",ImageURL);
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:ImageURL]];
            UIImage *tempImage = [UIImage imageWithData:imageData];
       
            [getImage_Array addObject:tempImage];
        }
        [self loadScrollViewWithPage:0];
        [self loadScrollViewWithPage:1];

        
    });
    
//    [self.view setUserInteractionEnabled:YES];
//    [spinner removeSpinner];

   
}


- (void)loadScrollViewWithPage:(int)page {
    if (page < 0) return;
    if (page >= kNumberOfPages) return;
    
    

    
    UIImageView *imageView =[[UIImageView alloc] init];
    //imageView.backgroundColor = [UIColor yellowColor];
    // add the image view to the scroll view
        CGRect frame = scrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        imageView.frame = frame;
        [scrollView addSubview:imageView];
    
    imageView.image = getImage_Array[page];
    
    
   
//sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[testArray objectAtIndex:0]
    
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    
    // We don't want a "feedback loop" between the UIPageControl and the scroll delegate in
    // which a scroll event generated from the user hitting the page control triggers updates from
    // the delegate method. We use a boolean to disable the delegate logic when the page control is used.
   
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
    
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
    // A possible optimization would be to unload the views+controllers which are no longer visible
}
// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    //pageControlUsed = NO;
    
    
    
    
}



/*
- (void)pageChanged {
    
    int pageNumber = pageControl.currentPage;
    
    CGRect frame = scroll.frame;
    frame.origin.x = frame.size.width*pageNumber;
    frame.origin.y=0;
    
    [scroll scrollRectToVisible:frame animated:YES];


}

*/





-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];

    [tabBarController setSelectedItem:nil]; // set tab bar unselected
    [tabBarController setTintColor:[UIColor blackColor]]; // set tab bar selection color white
    

    DLog(@"all image url--%@",self.getImageURls_Dict);
    
    DLog(@"all data  in details view--%@",allDataArray);
    
    [self removeLikeData];
    for (NSDictionary *obj in allDataArray)
    {
        NSString *strId = [obj valueForKey:@"guid"];
        [self likesData:strId];
        
    }
    
    self.showTemperature.text = [NSString stringWithFormat:@"%0.0f", objectDataClass.temperature];
    
    
  }

-(void)likesData : (NSString *)_id
{
    NSArray *arrDB=[DBController getAllLike_Info : objectDataClass.globalSubCategory];
    
    DLog(@"%@",arrDB);
    DLog(@"%@ arrDB count  = %lu",_id,arrDB.count);
    if (arrDB.count==0) {
        
        // insert row in database
        //[DBController insertIntoUser_Info:info];
        LikeDetail * likeObj = [LikeDetail new];
        likeObj.feedID = _id;
        likeObj.status = @"0";
        likeObj.subCategory = objectDataClass.globalSubCategory;
        
        [DBController insertIntoLike_Info:likeObj];
    }
    else
    {
        BOOL flag =NO;
        for (LikeDetail *obj in arrDB)
        {
            
            
            if ([obj.feedID isEqualToString:_id]) {
                
                flag=YES;
                break;
                
            }
            
            
            
        }
        
        if (flag == NO) {
            
            LikeDetail * likeObj = [LikeDetail new];
            likeObj.feedID = _id;
            likeObj.status = @"0";
            likeObj.subCategory = objectDataClass.globalSubCategory;

            [DBController insertIntoLike_Info:likeObj];
            
        }
        
        
        
    }
}



-(void) removeLikeData
{
    NSArray *arrDB=[DBController getAllLike_Info : objectDataClass.globalSubCategory];
    
    NSLog(@"%ld",arrDB.count);
    NSLog(@"%@",objectDataClass.globalSubCategory);

    for (LikeDetail *obj in arrDB)
    {
        BOOL flag =NO;
        for (NSDictionary *testObj in allDataArray)
        {
            NSString *strGuid = [testObj valueForKey:@"guid"];
            
            
            
            if ([strGuid isEqualToString:obj.feedID])
            {
                
                flag=YES;
                break;
                
            }
            
            
        } // inner loop
        
        if (flag == NO) {
            
            BOOL deleteStatus = [DBController deleteSingleRecordsof_Like_Info:obj.feedID];
            DLog(@"%i",deleteStatus);
        }
        
    } // outer loop
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
    
}



- (IBAction)back_tapped:(id)sender {
 
    DLog(@"back tapped");
    [self.navigationController popViewControllerAnimated:YES];
    
}


#pragma mark-- Share button.

- (IBAction)shareButtonClicked:(id)sender {

  
    
    self.shareLink =[NSString stringWithFormat:@"%@",[[allDataArray objectAtIndex:LocalIndex] valueForKey:@"Link"]];
    
    NSArray * activityItems = @[self.shareLink];

    
    NSArray * applicationActivities = nil;
    NSArray * excludeActivities = @[UIActivityTypeAssignToContact, UIActivityTypeCopyToPasteboard, UIActivityTypePostToWeibo, UIActivityTypePrint, UIActivityTypeMessage];
    
    UIActivityViewController * activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:applicationActivities];
    activityController.excludedActivityTypes = excludeActivities;
    
    [self presentViewController:activityController animated:YES completion:nil];

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



-(void)checkforNavigationInternetconnection:(int)type{
    
    
    if (type==1) {
        
        VideoIsTapped = YES;
        [self loadVideoRecorder];
        
    }else if (type==2) {
        
        VideoIsTapped= NO;
        
        if (IS_OS_8_OR_LATER) {
            // code for ios 8 or above !!!!!!!!!
            
            ////////
            
            
            // if ([sender selectedSegmentIndex]==0) {
            [self.view endEditing:YES];
            DLog(@"capture photo tapped");
            
            //isCameraClicked=YES;
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
            
            //isCameraClicked=YES;
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
            
        
        
        
        
        
    }else if (type ==5){
        
        Setting_Screen *setting=[[Setting_Screen alloc]initWithNibName:@"Setting_Screen" bundle:nil];
        [self.navigationController pushViewController:setting animated:YES];
        
    }
    
}

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
            
            
            //isBrowserTapped=YES;
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
#pragma mark -- calling image picker..
#pragma mark - Image Picker Controller delegate methods   starts ...

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    if (VideoIsTapped == YES ) { // for video is tapped
        
        [[NSUserDefaults standardUserDefaults]setValue:@"DoneVideo" forKey:@"Video_Check"];
        
        //  [picker dismissViewControllerAnimated:YES completion:NULL];
        
        //  handleView = YES ;
        
               
        NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
        
        videoData = [NSData dataWithContentsOfURL:videoURL];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        fileName =[NSString stringWithFormat:@"%lu.png",(NSUInteger)([[NSDate date] timeIntervalSince1970]*10.0)];
        tempPath = [documentsDirectory stringByAppendingFormat:@"/%@.mp4",fileName];
        
        [videoData writeToFile:tempPath atomically:NO];

        [[NSUserDefaults standardUserDefaults] setObject:videoData forKey:@"VideoData"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
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
    
        if(isCameraClicked)
        {
            UIImageWriteToSavedPhotosAlbum(mainImage,  nil,  nil, nil);
        }
        
        UIImage *editedImage = [info objectForKey:UIImagePickerControllerEditedImage];
//        NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
//        NSString *documentsDirectory;
//        for (int i=0; i<[pathArray count]; i++) {
//            documentsDirectory =[pathArray objectAtIndex:i];
//        }
        
        
        //mohit logic
        fileName = [NSString stringWithFormat:@"%lu.png",(NSUInteger)([[NSDate date] timeIntervalSince1970]*10.0)];
        localUrl =  [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:fileName];
        NSLog (@"File Path = %@", localUrl);
        
        // Get PNG data from following method
        NSData *myData = UIImagePNGRepresentation(editedImage);
        
        // It is better to get JPEG data because jpeg data will store the location and other related information of image.
        [myData writeToFile:localUrl atomically:YES];
        
        // Now you can use filePath as path of your image. For retrieving the image back from the path
        [[NSUserDefaults standardUserDefaults]setValue:@"DonePhoto" forKey:@"Photo_Check"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        DLog(@"photo done--%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"Photo_Check"]);
        
        captureduniqueName = [self generateUniqueName];
        Nav_valueToPhoto =YES;
        
        UploadPhoto *uploadP = [[UploadPhoto alloc]initWithNibName:@"UploadPhoto" bundle:nil];
        uploadP.transferedImageData =data;
        uploadP.transferPhotoUniqueName = captureduniqueName;
        uploadP.navigateValue = Nav_valueToPhoto;
        uploadP.transferFileURl =localUrl;
        [self.navigationController pushViewController:uploadP animated:NO];
 
        [picker dismissViewControllerAnimated:YES completion:nil];
        [self.view setNeedsLayout];
        
    }
}

-(NSString *) randomStringWithLength: (int) len {
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letterss characterAtIndex: arc4random_uniform([letterss length])]];
    }
    
    return randomString;
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

@end
