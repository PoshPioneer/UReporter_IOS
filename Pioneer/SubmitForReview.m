
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



@interface SubmitForReview () {
    
    AppDelegate * app;
    DataClass * objectDataClass;
    NSMutableArray * collectionArray;
    NSInteger temptag;
    UILabel * Date;
    UILabel * title;
    UILabel * fullStory;
    
    
    NSData *localImageDataForImage;
    UIImage *FrameImage;
    
    NSMutableArray *reverseArray;
}

@end

@implementation SubmitForReview
@synthesize collectedDict,tableview;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
    // Do any additional setup after loading the view from its nib.
    objectDataClass =[DataClass getInstance];
     //collectionArray = [[NSMutableArray alloc] init];
    app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
}
-(void)viewWillAppear:(BOOL)animated {
    
   
    
    
   // collectedDict = [objectDataClass.globaltextDict copy];
    //DLog(@"copyed data in array--%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"SubmitArray"]);
   

    
    //using this code----- 14 March-------
    
    app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    reverseArray=[[NSMutableArray alloc]init];
    
    reverseArray=[[[NSUserDefaults standardUserDefaults]objectForKey:@"SubmitArray"] mutableCopy] ;
    //collectionArray = [app.FinalSubmitForReview copy];
    
    collectionArray =[[[reverseArray reverseObjectEnumerator] allObjects] mutableCopy]; // reverse array having original data... collection array having reverse data....
    
    
    
    
    
    //collectionArray = [[[collectionArray reverseObjectEnumerator] allObjects] mutableCopy];

    
    
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

-(void)viewWillDisappear:(BOOL)animated {
    
    
   
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
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Do something...
        dispatch_async(dispatch_get_main_queue(), ^{

        
        
        
        });
    });
      // cell.lbl_type.text = [[collectionArray objectAtIndex:indexPath.row] valueForKey:@"CategoryName"];
    NSString * pathFile = [[collectionArray objectAtIndex:indexPath.row] valueForKey:@"fileURl"];
    
    
     NSString*  typeCheck =[[collectionArray objectAtIndex:indexPath.row] valueForKey:@"Type"];
    DLog(@"Type cHECKKKKKK--%@",typeCheck);
    
    
    
    
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
            AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
            AVAssetImageGenerator *generateImg = [[AVAssetImageGenerator alloc] initWithAsset:asset];
            NSError *error = NULL;
            CMTime time = CMTimeMake(1, 65);
            CGImageRef refImg = [generateImg copyCGImageAtTime:time actualTime:NULL error:&error];
            DLog(@"error==%@, Refimage==%@", error, refImg);

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

                
                FrameImage= [[UIImage alloc] initWithCGImage:refImg];
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
    
    
    CGSize size = [[UIScreen mainScreen]bounds].size;
    
    if (size.height==480) {
        
        SubmitForReviewDetails *fulldes=[[SubmitForReviewDetails alloc]initWithNibName:@"SubmitForReviewDetails3.5" bundle:nil];
        [self.navigationController pushViewController:fulldes animated:YES];
        
    }else{
        
        SubmitForReviewDetails *fullDescription=[[SubmitForReviewDetails alloc]initWithNibName:@"SubmitForReviewDetails" bundle:nil];
        [self.navigationController pushViewController:fullDescription animated:YES];
        
        
    }
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
        
        CGSize size = [[UIScreen mainScreen]bounds].size;
        
        if (size.height==480) {
            UploadTextView *text=[[UploadTextView alloc]initWithNibName:@"UploadTextView3.5" bundle:nil];
            text.tempArray = [collectionArray copy];
        //    DLog(@"while nav --%@",text.tempArray);
            
            [self.navigationController pushViewController:text animated:NO];
            
        }else{
            UploadTextView *text=[[UploadTextView alloc]initWithNibName:@"UploadTextView" bundle:nil];
            text.tempArray = [collectionArray copy];
          //  DLog(@"while nav --%@",text.tempArray);
            [self.navigationController pushViewController:text animated:NO];
        
    }
    
    }else if ([[[collectionArray objectAtIndex:indexPath.row] valueForKey:@"Type"]isEqualToString:@"PHOTO"]) {
        // for Photo view navigation
        CGSize size = [[UIScreen mainScreen]bounds].size;
        
        if (size.height==480) {
            
            UploadPhoto *uploadP = [[UploadPhoto alloc]initWithNibName:@"UploadPhoto3.5" bundle:nil];
            uploadP.tempArray = [collectionArray copy];
          //  DLog(@"photo nav data--%@",uploadP.tempArray);
            [self.navigationController pushViewController:uploadP animated:NO];
            
        }else{
            
            UploadPhoto *uploadP = [[UploadPhoto alloc]initWithNibName:@"UploadPhoto" bundle:nil];
            uploadP.tempArray = [collectionArray copy];
           // DLog(@"photo nav data--%@",uploadP.tempArray);
            [self.navigationController pushViewController:uploadP animated:NO];
            
        }

        
        
    } else if ([[[collectionArray objectAtIndex:indexPath.row] valueForKey:@"Type"]isEqualToString:@"VIDEO"]) {
        // for Video View navigation
        
        CGSize size = [[UIScreen mainScreen]bounds].size;
        
        if (size.height==480) {
            
            UploadVideoView *uploadV = [[UploadVideoView alloc]initWithNibName:@"UploadVideoView3.5" bundle:nil];
            uploadV.tempArray = [collectionArray copy];
            
            uploadV.thumbImageForView=FrameImage;
           // DLog(@"video nav array--%@",uploadV.tempArray);
            [self.navigationController pushViewController:uploadV animated:NO];
            
        }else{
            
            UploadVideoView *uploadV = [[UploadVideoView alloc]initWithNibName:@"UploadVideoView" bundle:nil];
            uploadV.tempArray = [collectionArray copy];
            uploadV.thumbImageForView=FrameImage;

          //  DLog(@"video nav array--%@",uploadV.tempArray);
            [self.navigationController pushViewController:uploadV animated:NO];
            
        }
        
        
    }else if ([[[collectionArray objectAtIndex:indexPath.row] valueForKey:@"Type"]isEqualToString:@"AUDIO"]) {
        
        // for Audio view navigation
        
        CGSize size = [[UIScreen mainScreen]bounds].size;
        
        if (size.height==480) {
            
            UploadAudioView *uploadP = [[UploadAudioView alloc]initWithNibName:@"UploadAudioView3.5" bundle:nil];
            uploadP.tempArray = [collectionArray copy];
            [self.navigationController pushViewController:uploadP animated:NO];
            
        }else{
            
            UploadAudioView *uploadP = [[UploadAudioView alloc]initWithNibName:@"UploadAudioView" bundle:nil];
            uploadP.tempArray = [collectionArray copy];
            [self.navigationController pushViewController:uploadP animated:NO];
            
        }
        
    }
    
}

- (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}
@end

