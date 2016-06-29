//
//  Submission.m
//  pioneer
//
//  Created by Subodh Dharmwan on 25/11/15.
//  Copyright (c) 2015 CYNOTECK. All rights reserved.
//

#import "Submission.h"
#import "Setting_Screen.h"
#import "RecordAudioView.h"
#import "ReporterEntry.h"
#import "AppDelegate.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <QuickLook/QuickLook.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "FullDescription.h"
#import "PlayRecordedAudio.h"
#import "DataClass.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UploadView.h"
#import "UploadTextView.h"
#import "UploadVideoView.h"
#import "UploadPhoto.h"

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
NSString *letter6 = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

@interface Submission (){
    AppDelegate *app;
   NSMutableArray *reverseArray;
    NSURL *yourFileURL;
    int i;
    QLPreviewController *previewController;
    UIImage *image;
    NSString *urlString;
    AVAudioPlayer *player;
    RecordAudioView *recordAudio;
    MPMoviePlayerController *controller;
    NSInteger rowCount;
    UIAlertView *alert;
    int tempTag;
    DataClass * objectDataClass;
    UIImage* imageFromPath;
    
    
    
    
    
    BOOL VideoIsTapped; // for checking video is tapped.
    
    // new variable for video
    UIImage *imageThumbnail;
    NSData* videoData;
    NSString *tempPath ;
    BOOL isBrowserTapped;
    NSString*finalUniqueVideo;
    
    SyncManager *sync;

    
    BOOL isCameraClicked;
    BOOL isPickerTapped;
    NSString *fileName;
    NSString* localUrl;
    NSData *data ;
    NSString* captureduniqueName;
    BOOL Nav_valueToPhoto;

    NSString*finalUnique;

}

@end

@implementation Submission
@synthesize myTable;
@synthesize lblMeassage,tabBarController,mainImage;
#pragma mark - viewDidLoad

- (void)viewDidLoad {
    [super viewDidLoad];
   [myTable setSeparatorInset:UIEdgeInsetsZero];
    myTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    myTable.opaque = YES;
    myTable.backgroundView = nil;
    myTable.backgroundColor=[UIColor clearColor];
    // Do any additional setup after loading the view from its nib.
    recordAudio=[[RecordAudioView alloc]init];
    
    app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    reverseArray=[[NSMutableArray alloc]init];
    reverseArray = [[[app.myFinalArray reverseObjectEnumerator]allObjects]mutableCopy];
  
    self.myTable.opaque=NO;
    
    previewController=[[QLPreviewController alloc]init];
    previewController.delegate=self;
    previewController.dataSource=self;
    
    objectDataClass = [DataClass getInstance];
    
    
    
}


#pragma mark - viewWillAppear

-(void)viewWillAppear:(BOOL)animated{
    
    [tabBarController setSelectedItem:nil]; // set tab bar unselected
    [tabBarController setTintColor:[UIColor whiteColor]]; // set tab bar selection color white
    
    if ([app.myFinalArray count]==0) {
        lblMeassage.hidden=NO;
    } else{
    lblMeassage.hidden=YES;
    }
    [myTable reloadData];
}

-(void)loadFileFromDocumentFolder:(NSString *) filename {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,    NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *outputPath = [documentsDirectory stringByAppendingPathComponent:filename ];
    
    DLog(@"outputPath: %@", outputPath);
    imageFromPath = [UIImage imageWithContentsOfFile:outputPath];
    
//    if (theImage) {
//      imageFromPath  = [[UIImage alloc] initWithImage:theImage];
//        [self.view addSubview:display];
//    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView DataSources

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        
    if ([app.myFinalArray count]==0) {
        lblMeassage.hidden=NO;
    } else{
        
        lblMeassage.hidden=YES;
        }
        return [app.myFinalArray count];
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    
    NSString * cellIdentityfier=@"cell";
    ReporterEntry *cell = (ReporterEntry *)[tableView dequeueReusableCellWithIdentifier:cellIdentityfier];
    if (cell == nil) {
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ReporterEntry" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    rowCount=indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
     cell.lbl_type.text=[[reverseArray objectAtIndex:indexPath.row]valueForKey:@"CategoryName"];
    
    if ([[[reverseArray objectAtIndex:indexPath.row]valueForKey:@"Type"]isEqualToString:@"TEXT"]) {
        
        [cell.onlyVideoIcon setHidden:YES];
        // for text setting the frame......
        UILabel * Date = [[UILabel alloc] initWithFrame:CGRectMake(27.0, 19.0, 90.0, 24.0)];
        [Date setTextColor:[UIColor darkGrayColor]];

        Date.text=[[reverseArray objectAtIndex:indexPath.row]valueForKey:@"Date"];
        [Date setFont:[UIFont fontWithName:@"Roboto-Regular" size:12.0]];
        [cell addSubview:Date];
        
        
        
        UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(27.0,51.0,280.0,41.0)];
        title.text =[[reverseArray objectAtIndex:indexPath.row]valueForKey:@"Title"];
        [title setFont:[UIFont fontWithName:@"Roboto-Regular" size:15.0]];
       /// title.numberOfLines =2;
        [cell addSubview:title];
        
        UILabel * fullStory = [[UILabel alloc] initWithFrame:CGRectMake(27.0,96.0,280.0,37.0)];
        fullStory.text =[[reverseArray objectAtIndex:indexPath.row]valueForKey:@"FullStory"];
        [fullStory setFont:[UIFont fontWithName:@"Roboto-Light" size:14.0]];
       // fullStory.numberOfLines =2;
        [cell addSubview:fullStory];
        
        
        [cell.imageView setHidden:YES];
        [cell.lblTitle setHidden:YES];
        [cell.lblFullStory setHidden:YES];
        [cell.lblDate setHidden:YES];
        
    }
    
    else if ([[[reverseArray objectAtIndex:indexPath.row] valueForKey:@"Type"]isEqualToString:@"AUDIO"]){
        
        [cell.onlyVideoIcon setHidden:YES];
        [cell.lblTitle setHidden:YES];   
        [cell.lblFullStory setHidden:YES];
        [cell.lblDate setHidden:YES];    
        [cell.lblTime setHidden:YES];
        
        
        UILabel * Date = [[UILabel alloc] initWithFrame:CGRectMake(27.0, 19.0, 90.0, 24.0)];
        [Date setTextColor:[UIColor darkGrayColor]];
        Date.text=[[reverseArray objectAtIndex:indexPath.row]valueForKey:@"Date"];
        [Date setFont:[UIFont fontWithName:@"Roboto-Regular" size:12.0]];
        [cell addSubview:Date];
        
        
        UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(27.0,51.0,280.0,41.0)];
        title.text =[[reverseArray objectAtIndex:indexPath.row]valueForKey:@"Title"];
          [title setFont:[UIFont fontWithName:@"Roboto-Regular" size:15.0]];
        /// title.numberOfLines =2;
        [cell addSubview:title];
        
        UILabel * fullStory = [[UILabel alloc] initWithFrame:CGRectMake(27.0,96.0,280.0,37.0)];
        fullStory.text =[[reverseArray objectAtIndex:indexPath.row]valueForKey:@"FullStory"];
         [fullStory setFont:[UIFont fontWithName:@"Roboto-Light" size:14.0]];
        // fullStory.numberOfLines =2;
        [cell addSubview:fullStory];
        
        
    }
    
    
    
    else if ([[[reverseArray objectAtIndex:indexPath.row] valueForKey:@"Type"]isEqualToString:@"PHOTO"]) {
    
        [cell.onlyVideoIcon setHidden:YES];

        cell.lblTitle.text=[[reverseArray objectAtIndex:indexPath.row]valueForKey:@"Title"];
        cell.lblFullStory.text=[[reverseArray objectAtIndex:indexPath.row]valueForKey:@"FullStory"];
        cell.lblDate.text=[[reverseArray objectAtIndex:indexPath.row]valueForKey:@"Date"];
        cell.lblTime.text=[[reverseArray objectAtIndex:indexPath.row]valueForKey:@"Time"];
  //for image path showing image to imageview ,,,
    
    NSString * path = [[reverseArray objectAtIndex:indexPath.row] valueForKey:@"imagePath"];
    DLog(@"path%@",path);
  
    DLog(@"%@",[NSString stringWithFormat:@"%@/%@",[self applicationDocumentsDirectory],path.lastPathComponent]);
    
    NSString *fullPath = [NSString stringWithFormat:@"%@/%@",[self applicationDocumentsDirectory],path.lastPathComponent];
       UIImage * myImage = [UIImage imageWithData:[NSData dataWithContentsOfFile:fullPath]];
       [cell.imageView setImage:myImage];
        
    }else if ([[[reverseArray objectAtIndex:indexPath.row] valueForKey:@"Type"] isEqualToString:@"VIDEO"]){
        
        // for VIDEO....
        
        cell.lblTitle.text=[[reverseArray objectAtIndex:indexPath.row]valueForKey:@"Title"];
        cell.lblFullStory.text=[[reverseArray objectAtIndex:indexPath.row]valueForKey:@"FullStory"];
        cell.lblDate.text=[[reverseArray objectAtIndex:indexPath.row]valueForKey:@"Date"];
        cell.lblTime.text=[[reverseArray objectAtIndex:indexPath.row]valueForKey:@"Time"];

        
        NSString * path = [[reverseArray objectAtIndex:indexPath.row] valueForKey:@"videoPath"];
        DLog(@" video path%@",path);
        
        DLog(@"%@",[NSString stringWithFormat:@"%@/%@",[self applicationDocumentsDirectory],path.lastPathComponent]);
        
        NSString *fullPath = [NSString stringWithFormat:@"%@/%@",[self applicationDocumentsDirectory],path.lastPathComponent];

        NSURL *videoURL = [NSURL fileURLWithPath:fullPath];
        
      
        AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
        AVAssetImageGenerator *generateImg = [[AVAssetImageGenerator alloc] initWithAsset:asset];
        NSError *error = NULL;
        CMTime time = CMTimeMake(1, 65);
        CGImageRef refImg = [generateImg copyCGImageAtTime:time actualTime:NULL error:&error];
        DLog(@"error==%@, Refimage==%@", error, refImg);
        
        UIImage *FrameImage= [[UIImage alloc] initWithCGImage:refImg];
        [cell.imageView setImage:FrameImage];
        [cell.onlyVideoIcon setHidden:NO];

     
    }
       [cell.btnDelete addTarget:self action:@selector(btnDataDelete:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnReadMore addTarget:self action:@selector(btnReadMore:) forControlEvents:UIControlEventTouchUpInside];
        cell.btnReadMore.tag=indexPath.row;
        app.indexpath=cell.btnReadMore.tag;
        cell.btnDelete.tag = indexPath.row;
        cell.backgroundColor=[UIColor clearColor];
    /*NSString *path;
     NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
     path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"snijtechniekendir/videos"];
     path = [path stringByAppendingPathComponent:[videos objectAtIndex:indexPath.row]];
     
     NSURL *videoURL = [NSURL fileURLWithPath:path];
     
     DLog(@"video url: %@", videoURL);
     
     MPMoviePlayerController *player = [[MPMoviePlayerController alloc] initWithContentURL:videoURL];
     
     UIImage *thumbnail = [player thumbnailImageAtTime:1 timeOption:MPMovieTimeOptionNearestKeyFrame];
     
     UIImageView *cellimage = [[UIImageView alloc] initWithFrame:CGRectMake(2, 2 , 400, 400)];
     
     [cell.contentView addSubview:cellimage];
     NSData *imgData = UIImagePNGRepresentation(thumbnail);
     DLog(@"lenght of video thumb: %@", [imgData length]);
     [self.view addSubview:cellimage];
     [cellimage setImage:thumbnail];*/
    
    return cell;
    
    }

#pragma mark - ReadMoreButton

-(void)btnReadMore:(id)sender{
    app.Title=[[reverseArray objectAtIndex:[sender tag]]valueForKey:@"Title"];
    app.Description=[[reverseArray objectAtIndex:[sender tag]]valueForKey:@"FullStory"];
    app.indexpath=[sender tag];
    CGSize size = [[UIScreen mainScreen]bounds].size;
    
    if (size.height==480) {
        
        FullDescription *fulldes=[[FullDescription alloc]initWithNibName:@"FullDescription3.5" bundle:nil];
        [self.navigationController pushViewController:fulldes animated:YES];
        }else{
        FullDescription *fullDescription=[[FullDescription alloc]initWithNibName:@"FullDescription" bundle:nil];
        [self.navigationController pushViewController:fullDescription animated:YES];
        }
     }

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
   // app.Title=[[reverseArray objectAtIndex:indexPath.row]valueForKey:@"Title"];
    //app.Description=[[reverseArray objectAtIndex:indexPath.row]valueForKey:@"FullStory"];
    //app.indexpath=[sender tag];
    CGSize size = [[UIScreen mainScreen]bounds].size;
    
    if (size.height==480) {
        
        
        FullDescription *fulldes=[[FullDescription alloc]initWithNibName:@"FullDescription3.5" bundle:nil];
        
        fulldes.receivedArray = [[reverseArray objectAtIndex:indexPath.row] copy];
        
        [self.navigationController pushViewController:fulldes animated:YES];
    
    } else {
    
        
        FullDescription *fullDescription=[[FullDescription alloc]initWithNibName:@"FullDescription" bundle:nil];
        
        fullDescription.receivedArray = [[reverseArray objectAtIndex:indexPath.row] copy];
        [self.navigationController pushViewController:fullDescription animated:YES];
    
    
    }


    

}







#pragma mark - deleteButton

-(void)btnDataDelete:(id)sender{
    
    alert=[[UIAlertView alloc]initWithTitle:@"Message" message:@"Are you sure you want to delete this record?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];

    [alert show];
    tempTag = (int)[sender tag];


}
#pragma mark - AlertViewDelegates

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (buttonIndex==0) {
        //do Nothing
    } else if (buttonIndex==1){
    
        [reverseArray removeObjectAtIndex:tempTag];
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"MyArray"];
        
        [app.myFinalArray removeAllObjects];
        
        for(NSDictionary *d in reverseArray){
                        [app.myFinalArray addObject:d];
        }
        
        [[NSUserDefaults standardUserDefaults] setValue:[[app.myFinalArray objectEnumerator]allObjects] forKey:@"MyArray"];
        [[[app.myFinalArray reverseObjectEnumerator]allObjects]mutableCopy];
        [myTable reloadData];
      }
}

#pragma mark - TableViewDelegates

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
      
        
        [reverseArray removeObjectAtIndex:indexPath.row];
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"MyArray"];
        
        [app.myFinalArray removeAllObjects];
        
        for(NSDictionary *d in reverseArray){
            [app.myFinalArray addObject:d];
        }
        
        [[NSUserDefaults standardUserDefaults] setValue:[[app.myFinalArray objectEnumerator]allObjects] forKey:@"MyArray"];
        [[[app.myFinalArray reverseObjectEnumerator]allObjects]mutableCopy];
        [myTable reloadData];

    }
}
// Returns the URL to the application's Documents directory.
/*
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}
 */
- (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}
/*- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if([[[reverseArray objectAtIndex:indexPath.row]valueForKey:@"Type"] isEqualToString:@"PHOTO" ])
    {
       urlString=[[reverseArray objectAtIndex:indexPath.row]valueForKey:@"imagePath"] ;
       image =  [[UIImage alloc] initWithContentsOfFile:urlString];
       [previewController reloadData];
       [self presentViewController:previewController animated:YES completion:nil];
       [previewController.navigationItem setRightBarButtonItem:nil];
    }else if([[[reverseArray objectAtIndex:indexPath.row]valueForKey:@"Type"] isEqualToString:@"VIDEO"]){
        
        NSURL *videoURL=[NSURL fileURLWithPath:[[reverseArray objectAtIndex:indexPath.row]valueForKey:@"videoPath"]];
        controller = [[MPMoviePlayerController alloc]
                                               initWithContentURL:videoURL];
        self.mc = controller;
        controller.view.frame = self.view.bounds;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MPMoviePlayerDidExitFullscreen:) name:MPMoviePlayerDidExitFullscreenNotification object:nil];
        [self.view addSubview:controller.view]; //Show the view
        [controller play]; //Start playing
        
        } else if([[[reverseArray objectAtIndex:indexPath.row]valueForKey:@"Type"] isEqualToString:@"AUDIO"]){
        
        
        CGSize size = [[UIScreen mainScreen]bounds].size;
        if (size.height==480) {
            
            app.yourFileURL = [NSURL URLWithString:[[reverseArray objectAtIndex:indexPath.row]valueForKey:@"AudioPath"]];
            PlayRecordedAudio *playObj=[[PlayRecordedAudio alloc]initWithNibName:@"PlayRecordedAudio3.5" bundle:nil];
            [self.navigationController pushViewController:playObj animated:YES];
            
        } else{
            
            app.yourFileURL = [NSURL URLWithString:[[reverseArray objectAtIndex:indexPath.row]valueForKey:@"AudioPath"]];
            
            PlayRecordedAudio *playObj=[[PlayRecordedAudio alloc]initWithNibName:@"PlayRecordedAudio" bundle:nil];
            
            [self.navigationController pushViewController:playObj animated:YES];
            
            }
    }
    }*/
#pragma mark - MPMoviePlayer Stop

- (void)MPMoviePlayerDidExitFullscreen:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerDidExitFullscreenNotification
                                                  object:nil];
    
    [controller stop];
    [controller.view removeFromSuperview];
}


#pragma mark - QLPreviewControlerDelegates

- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller{

    return  1;
    
    
}
- (id <QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index{
    
   
    if (urlString.length == 0){
        urlString = @"";
    }
    NSURL *url=[NSURL fileURLWithPath:urlString];
    return url;
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - BackButton
- (IBAction)btnBackTapped:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
    
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
        [randomString appendFormat: @"%C", [letter6 characterAtIndex: arc4random_uniform([letter6 length])]];
    }
    
    return randomString;
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
        DLog(@"this is the value of sucess---%hhd",success);
        DLog(@"this is the pathe of temp of the video ====>%@",tempPath);
        
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
        
        NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
        
        
        
        NSString *documentsDirectory;
        for (int i=0; i<[pathArray count]; i++) {
            documentsDirectory =[pathArray objectAtIndex:i];
        }
        
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


@end
