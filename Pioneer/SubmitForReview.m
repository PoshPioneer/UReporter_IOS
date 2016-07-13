
//  SubmitForReview.m
//  Pioneer
//
//  Created by Deepankar Parashar on 11/03/16.
//  Copyright © 2016 CYNOTECK. All rights reserved.
//

#import "SubmitForReview.h"
#import "DataClass.h"
#import "submitCell.h"
#import "UploadTextView.h"
#import "UploadAudioView.h"
#import "UploadPhoto.h"
#import "UploadVideoView.h"
#import "FullDescription.h"
#import "SubmitForReviewDetails.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "RecordAudioView.h"
#import "Setting_Screen.h"

NSString *letter8 = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)


@interface SubmitForReview () {
    
    AppDelegate * app;
    DataClass * objectDataClass;
    NSMutableArray * collectionArray;
    NSInteger temptag;
    UILabel * Date;
    UILabel * title;
    UILabel * fullStory;
    BOOL VideoIsTapped;
    BOOL isCameraClicked;
    BOOL isBrowserTapped;
    NSData *localImageDataForImage;
    UIImage *FrameImage;
    NSString*finalUniqueVideo;
    NSData* videoData;
    NSString *tempPath;
    NSData *data ;
    NSString *fileName;
    NSString* localUrl;
    NSString* captureduniqueName;
    NSString*finalUnique;
    BOOL Nav_valueToPhoto;
    UIImage *imageThumbnail;
    NSString *moviePath;
    
    
    NSDateFormatter *dateFormatter;
    NSDateFormatter *timeFormatter ;
    NSInteger dayDifference;
    NSString *timeDifference;



}

@end

@implementation SubmitForReview
@synthesize collectedDict,tableview,mainImage,tabBarController;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
    // Do any additional setup after loading the view from its nib.
    objectDataClass =[DataClass getInstance];
     //collectionArray = [[NSMutableArray alloc] init];
    app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
}
-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];

    dateFormatter=[[NSDateFormatter alloc] init];
    timeFormatter=[[NSDateFormatter alloc]init];

    [tabBarController setSelectedItem:nil]; // set tab bar unselected


    
    //using this code----- 14 March-------
    
    app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    collectionArray =[[[NSUserDefaults standardUserDefaults]objectForKey:@"SubmitArray"] mutableCopy] ;

      //  DLog(@"collection array from submitforreview--%@",collectionArray);
    [tableview reloadData];
    
    
    if (collectionArray.count == 0) {
        
        UIAlertController * alertShow = [UIAlertController alertControllerWithTitle:@"Message" message:@"There are no Items." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * alertAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        
        }];
        
        [alertShow addAction:alertAction];
        [self presentViewController:alertShow animated:YES completion:nil];
        
    
    }else {
        
        // do nothing....
        
    }
    
    
   
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark -- IBAction
- (IBAction)backButtonClicked:(id)sender {


    [self.navigationController popViewControllerAnimated:YES];
    
}


#pragma mark-- UITableView Delegate and DataSource...

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    //return objectDataClass.globalSubmitArray.count;
    
    return collectionArray.count;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString * cellIdentityfier=@"cell";
    submitCell *cell = (submitCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentityfier];
    if (cell == nil)
    {
    
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"submitCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    
    }
    else {
        
       /*
        for (UIView *object in cell.subviews)
        {
            
//            if ([object isKindOfClass:[UIImageView alloc]]) {
//                
//            }
            [object removeFromSuperview];
            
        }
        [cell prepareForReuse];
        
        */
        
    }
    
//    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
//        // Do something...
//        dispatch_async(dispatch_get_main_queue(), ^{
//
//        
//        
//        
//        });
//    });
      // cell.lbl_type.text = [[collectionArray objectAtIndex:indexPath.row] valueForKey:@"CategoryName"];
    
    NSString * pathFile = [[collectionArray objectAtIndex:indexPath.row] valueForKey:@"fileURl"];
    NSString*  typeCheck =[[collectionArray objectAtIndex:indexPath.row] valueForKey:@"Type"];

    
    
    if ([typeCheck isEqualToString:@"PHOTO"]) {
        
        
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            
            
            localImageDataForImage = [[collectionArray objectAtIndex:indexPath.row] valueForKey:@"transferImage"];
            UIImage * myImage = [UIImage imageWithData:localImageDataForImage];

            dispatch_async(dispatch_get_main_queue(), ^{
                
                [cell.lblFullStoryForTxt setHidden:YES];
                [cell.lblDateForTxt setHidden:YES];
                [cell.lblTitleForTxt setHidden:YES];
                
                [cell.ImageFromPath setHidden:NO];
                [cell.videoIcon setHidden:NO];
                [cell.titleLabel setHidden:NO];
                [cell.datelabel setHidden:NO];
                [cell.timeLabel setHidden:NO];
                [cell.fullStoryLabel setHidden:NO];
                
                [cell.videoIcon setHidden:YES];
                cell.titleLabel.text =[[collectionArray objectAtIndex:indexPath.row] valueForKey:@"Title"];
                cell.datelabel.text = [[collectionArray objectAtIndex:indexPath.row] valueForKey:@"Date"];
                cell.timeLabel.text = [[collectionArray objectAtIndex:indexPath.row] valueForKey:@"Time"];
                cell.fullStoryLabel.text = [[collectionArray objectAtIndex:indexPath.row] valueForKey:@"FullStory"];
                cell.lbl_type.text = [[collectionArray objectAtIndex:indexPath.row] valueForKey:@"localCategoryName"];
                [cell.ImageFromPath setImage:myImage];

            });
        });
        
        
        
        
        // hiding label while video will be there....
    
    }
    
    else if ([[[collectionArray objectAtIndex:indexPath.row] valueForKey:@"Type"]isEqualToString:@"VIDEO"]) {
        
        // hiding label while video will be there....
        
        
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            
            NSString *fullPath = [NSString stringWithFormat:@"%@/%@",[self applicationDocumentsDirectory],pathFile.lastPathComponent];
            NSURL *videoURL = [NSURL fileURLWithPath:fullPath];
            
            
            /*
            AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
            AVAssetImageGenerator *generateImg = [[AVAssetImageGenerator alloc] initWithAsset:asset];
            NSError *error = NULL;
            CMTime time = CMTimeMake(1, 65);
            CGImageRef refImg = [generateImg copyCGImageAtTime:time actualTime:NULL error:&error];
            NSLog(@"error==%@, Refimage==%@", error, refImg);
             
             */
            
            
            
            AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
            AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
            gen.appliesPreferredTrackTransform = YES;
            CMTime time = CMTimeMakeWithSeconds(0.0, 600);
            NSError *error = nil;
            CMTime actualTime;
            
            CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
            FrameImage = [[UIImage alloc] initWithCGImage:image];
            
            CGImageRelease(image);

            
            
            
            

            dispatch_async(dispatch_get_main_queue(), ^{
                
                [cell.lblFullStoryForTxt setHidden:YES];
                [cell.lblDateForTxt setHidden:YES];
                [cell.lblTitleForTxt setHidden:YES];
                
                
                [cell.ImageFromPath setHidden:NO];
                [cell.videoIcon setHidden:NO];
                [cell.titleLabel setHidden:NO];
                [cell.datelabel setHidden:NO];
                [cell.timeLabel setHidden:NO];
                [cell.fullStoryLabel setHidden:NO];
                
                [cell.videoIcon setHidden:NO];
                
                cell.titleLabel.text =[[collectionArray objectAtIndex:indexPath.row] valueForKey:@"Title"];
                
                cell.datelabel.text = [[collectionArray objectAtIndex:indexPath.row] valueForKey:@"Date"];
                cell.timeLabel.text = [[collectionArray objectAtIndex:indexPath.row] valueForKey:@"Time"];
                
                cell.fullStoryLabel.text = [[collectionArray objectAtIndex:indexPath.row] valueForKey:@"FullStory"];
                
                cell.lbl_type.text =[[collectionArray objectAtIndex:indexPath.row] valueForKey:@"localCategoryName"];

                
                //cell.ImageFromPath.contentMode = UIViewContentModeScaleAspectFit;
                [cell.ImageFromPath setImage:FrameImage];

                
            });
        });

        
        
        
        
    }
    
    else if ([[[collectionArray objectAtIndex:indexPath.row] valueForKey:@"Type"]isEqualToString:@"TEXT"]){
        
        
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            // Do something...
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [cell.lblFullStoryForTxt setHidden:NO];
                [cell.lblDateForTxt setHidden:NO];
                [cell.lblTitleForTxt setHidden:NO];

                
                
                cell.lbl_type.text =[[collectionArray objectAtIndex:indexPath.row] valueForKey:@"localCategoryName"];
                cell.lblDateForTxt.text=[[collectionArray objectAtIndex:indexPath.row] valueForKey:@"Date"];
                cell.lblTitleForTxt.text =[[collectionArray objectAtIndex:indexPath.row] valueForKey:@"Title"];
                cell.lblFullStoryForTxt.text =[[collectionArray objectAtIndex:indexPath.row] valueForKey:@"FullStory"];
                
                [cell.videoIcon setHidden:YES];
                [cell.titleLabel setHidden:YES];
                [cell.datelabel setHidden:YES];
                [cell.timeLabel setHidden:YES];
                [cell.fullStoryLabel setHidden:YES];
                [cell.ImageFromPath setHidden:YES];

            });
        });
    }
    
    else if ([[[collectionArray objectAtIndex:indexPath.row] valueForKey:@"Type"]isEqualToString:@"AUDIO"]){
        
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            // Do something...
            dispatch_async(dispatch_get_main_queue(), ^{


                [cell.lblFullStoryForTxt setHidden:NO];
                [cell.lblDateForTxt setHidden:NO];
                [cell.lblTitleForTxt setHidden:NO];
        
                
        cell.lbl_type.text =[[collectionArray objectAtIndex:indexPath.row] valueForKey:@"localCategoryName"];
        cell.lblDateForTxt.text=[[collectionArray objectAtIndex:indexPath.row] valueForKey:@"Date"];
        cell.lblTitleForTxt.text =[[collectionArray objectAtIndex:indexPath.row] valueForKey:@"Title"];
        cell.lblFullStoryForTxt.text =[[collectionArray objectAtIndex:indexPath.row] valueForKey:@"FullStory"];
        
        [cell.videoIcon setHidden:YES];
        [cell.titleLabel setHidden:YES];
        [cell.datelabel setHidden:YES];
        [cell.timeLabel setHidden:YES];
        [cell.fullStoryLabel setHidden:YES];
        [cell.ImageFromPath setHidden:YES];

            });
        });

        
        /*
        [cell.lblFullStoryForTxt setHidden:YES];
        [cell.lblDateForTxt setHidden:YES];
        [cell.lblTitleForTxt setHidden:YES];

        Date = [[UILabel alloc] initWithFrame:CGRectMake(27.0, 19.0, 90.0, 24.0)];
        Date.text=[[collectionArray objectAtIndex:indexPath.row] valueForKey:@"Date"];
        [cell addSubview:Date];
        
        
        title = [[UILabel alloc] initWithFrame:CGRectMake(27.0,51.0,155.0,41.0)];
        title.text =[[collectionArray objectAtIndex:indexPath.row] valueForKey:@"Title"];
        /// title.numberOfLines =2;
        [cell addSubview:title];
        
        fullStory = [[UILabel alloc] initWithFrame:CGRectMake(27.0,96.0,152.0,37.0)];
        fullStory.text =[[collectionArray objectAtIndex:indexPath.row] valueForKey:@"FullStory"];
        // fullStory.numberOfLines =2;
        [cell addSubview:fullStory];
        cell.lbl_type.text =[[ collectionArray objectAtIndex:indexPath.row] valueForKey:@"localCategoryName"] ;
        
        [cell.videoIcon setHidden:YES];
        [cell.titleLabel setHidden:YES];
        [cell.datelabel setHidden:YES];
        [cell.timeLabel setHidden:YES];
        [cell.fullStoryLabel setHidden:YES];
        */
    }
    
    
    [cell.btnReadMore addTarget:self action:@selector(btnReadMore:) forControlEvents:UIControlEventTouchUpInside];
    cell.btnReadMore.tag=indexPath.row;
    app.ReviewIndexPath=cell.btnReadMore.tag;
    temptag = indexPath.row;
    

    return cell;
    
}

-(void)btnReadMore:(id)sender{
   
    
    app.Title=[[collectionArray objectAtIndex:[sender tag]]valueForKey:@"Title"];
    app.Description=[[collectionArray objectAtIndex:[sender tag]]valueForKey:@"FullStory"];

    app.ReviewIndexPath=[sender tag];
    
    
    
        
        SubmitForReviewDetails *fullDescription=[[SubmitForReviewDetails alloc]initWithNibName:@"SubmitForReviewDetails" bundle:nil];
        [self.navigationController pushViewController:fullDescription animated:YES];
        
        
    
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [collectionArray removeObjectAtIndex:indexPath.row];
        [[NSUserDefaults standardUserDefaults]setValue:collectionArray forKey:@"SubmitArray"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        [tableView reloadData];
        
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 150;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    objectDataClass.globalIndexSelection = indexPath.row;
    DLog(@"cell index is %lu",(unsigned long)objectDataClass.globalIndexSelection);
    
    if ([[[collectionArray objectAtIndex:indexPath.row]valueForKey:@"Type"]isEqualToString:@"TEXT"]) {
        
        //for TEXT view navigation
        
        
            UploadTextView *text=[[UploadTextView alloc]initWithNibName:@"UploadTextView" bundle:nil];
            text.tempArray = [collectionArray copy];
          //  NSLog(@"while nav --%@",text.tempArray);
            [self.navigationController pushViewController:text animated:NO];
        
    
    
    }else if ([[[collectionArray objectAtIndex:indexPath.row] valueForKey:@"Type"]isEqualToString:@"PHOTO"]) {
        // for Photo view navigation
       
            
            UploadPhoto *uploadP = [[UploadPhoto alloc]initWithNibName:@"UploadPhoto" bundle:nil];
            uploadP.tempArray = [collectionArray copy];
           // NSLog(@"photo nav data--%@",uploadP.tempArray);
            [self.navigationController pushViewController:uploadP animated:NO];
            
        

        
        
    } else if ([[[collectionArray objectAtIndex:indexPath.row] valueForKey:@"Type"]isEqualToString:@"VIDEO"]) {
        // for Video View navigation
        
        
            
            UploadVideoView *uploadV = [[UploadVideoView alloc]initWithNibName:@"UploadVideoView" bundle:nil];
            uploadV.tempArray = [collectionArray copy];
            uploadV.thumbImageForView=FrameImage;

          //  NSLog(@"video nav array--%@",uploadV.tempArray);
            [self.navigationController pushViewController:uploadV animated:NO];
            
        
        
        
    }else if ([[[collectionArray objectAtIndex:indexPath.row] valueForKey:@"Type"]isEqualToString:@"AUDIO"]) {
        
        // for Audio view navigation
        
        
            UploadAudioView *uploadP = [[UploadAudioView alloc]initWithNibName:@"UploadAudioView" bundle:nil];
            uploadP.tempArray = [collectionArray copy];
            objectDataClass.audioDetailsMutableArray=collectionArray;

            //NSLog(@"while nav to audio view--%@",uploadP.tempArray);
            [self.navigationController pushViewController:uploadP animated:NO];
            
        
        
    }
    
}

- (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}


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
        
        
            UploadTextView *text=[[UploadTextView alloc]initWithNibName:@"UploadTextView" bundle:nil];
            [self.navigationController pushViewController:text animated:NO];
            
       
        
        
        
        
        
    }else if (type ==5){
        
        Setting_Screen *setting=[[Setting_Screen alloc]initWithNibName:@"Setting_Screen" bundle:nil];
        [self.navigationController pushViewController:setting animated:YES];
        
    }
    
    
}
*/

-(void)checkforNavigationInternetconnection:(int)type{
    if (type==1) {
        
        
        VideoIsTapped = YES;
        UIAlertController *alrController=[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *takeVideo=[UIAlertAction actionWithTitle:@"Capture" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            
            [self loadVideoRecorder];
        }];
        
        UIAlertAction *gallery=[UIAlertAction actionWithTitle:@"Choose From Gallery" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            isBrowserTapped =YES;
            
            [self startMediaBrowserFromViewController: self usingDelegate: self];
            
        }];
        
        UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            [tabBarController setSelectedItem:nil]; // set tab bar unselected
            
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
            
        }];
        
        
        [alrController addAction:takeVideo];
        [alrController addAction:gallery];
        [alrController addAction:cancel];
        
        
        [self presentViewController:alrController animated:YES completion:nil];
        
        
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

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    if (VideoIsTapped == YES ) { // for video is tapped
        
        [[NSUserDefaults standardUserDefaults]setValue:@"DoneVideo" forKey:@"Video_Check"];
        
        //  [picker dismissViewControllerAnimated:YES completion:NULL];
        
        //  handleView = YES ;
        
        
       
        
        NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
        
        videoData = [NSData dataWithContentsOfURL:videoURL];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        fileName = [NSString stringWithFormat:@"%@",[self randomStringWithLength:8]];
        tempPath = [documentsDirectory stringByAppendingFormat:@"/%@.mp4",fileName];
        
        
        [[NSUserDefaults standardUserDefaults] setObject:videoData forKey:@"VideoData"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [videoData writeToFile:tempPath atomically:NO];
        NSLog(@"this is the pathe of temp of the video ====>%@",tempPath);
        
        if (isBrowserTapped)
        {
            
        }
        
        
        
            
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
        
//        NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
//        NSString *documentsDirectory;
//        for (int i=0; i<[pathArray count]; i++) {
//            documentsDirectory =[pathArray objectAtIndex:i];
//        }
        
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

-(NSString *) randomStringWithLength: (int) len {
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letter8 characterAtIndex: arc4random_uniform([letter8 length])]];
    }
    
    return randomString;
}

-(NSString *)generateUniqueName {
    
    //  NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    // NSString *finalUnique= [NSString stringWithFormat:@"Photo_%.0f.jpg", time];
    //NSDateFormatter *dateFormatterl = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd_HHmmss"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    // int randomValue = arc4random() % 1000;
    //  NSString *unique = [NSString stringWithFormat:@"%@%d",dateString,randomValue];
    finalUnique = [NSString stringWithFormat:@"Photo_%@.jpg",dateString];
    NSLog(@"unique name --%@",finalUnique);
    return finalUnique;
    
}



#pragma mark Time Date Calculation
//Calculate the time difference.......

- (NSString *)calculateDuration:(NSDate *)oldTime secondDate:(NSDate *)currentTime {
    
    NSDate *date1 = oldTime;
    NSDate *date2 = currentTime;
    
    NSTimeInterval secondsBetween = [date2 timeIntervalSinceDate:date1];
    
    int hh = secondsBetween / (60*60);
    double rem = fmod(secondsBetween, (60*60));
    int mm = rem / 60;
    rem = fmod(rem, 60);
    int ss = rem;
    
    NSString *str = [NSString stringWithFormat:@"%02d:%02d:%02d",hh,mm,ss];
    
    return str;
}



//Calculate the day Difference .......

- (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime {
    
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&fromDate interval:NULL forDate:fromDateTime];
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&toDate interval:NULL forDate:toDateTime];
    
    NSDateComponents *difference = [calendar components:NSCalendarUnitDay fromDate:fromDate toDate:toDate options:0];
    
    return [difference day];
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

