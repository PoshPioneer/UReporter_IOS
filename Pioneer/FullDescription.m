//
//  FullDescription.m
//  pioneer
//
//  Created by Subodh Dharmwan on 02/12/15.
//  Copyright (c) 2015 CYNOTECK. All rights reserved.
//

#import "FullDescription.h"
#import "AppDelegate.h"
#import "DataClass.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "PlayRecordedAudio.h"



@interface FullDescription (){

    AppDelegate *app;
    DataClass * objectDataClass;
    NSURL * globalVideoUrl;
    BOOL checkingAudio_Video;
    NSString* audioUrl;
    
    //MPMoviePlayerController *theMoviPlayer;
}

@end

@implementation FullDescription
@synthesize txtDescription;
@synthesize lblTitle,receivedArray,testing_Imageview,lbl_CategoryType,lbl_Time,videoPlayIcon;

#pragma mark - viewDidLoad

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"receieved array--%@",receivedArray);
    
    objectDataClass = [DataClass getInstance];
    // Do any additional setup after loading the view from its nib.
    app=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    
    
    
    if ([[receivedArray valueForKey:@"Type"] isEqualToString:@"PHOTO"]) {
        
        [videoPlayIcon setHidden:YES];
        lblTitle.text=[receivedArray valueForKey:@"Title"];
        txtDescription.textColor = [UIColor colorWithRed:65.0/255.0 green:65.0/255.0 blue:65.0/255.0 alpha:1.0];
        //txtDescription.text=[receivedArray valueForKey:@"FullStory"];
        
        UITextView * txtNewDescription = [[UITextView alloc] initWithFrame:CGRectMake(12.0, 343.0, 298.0, 211.0)];
        txtNewDescription.textColor =[UIColor colorWithRed:65.0/255.0 green:65.0/255.0 blue:65.0/255.0 alpha:1.0];
        txtNewDescription.editable =NO;
        txtNewDescription.selectable =NO;
        [txtNewDescription setFont:[UIFont fontWithName:@"Helvetica Neue" size:16.0]];
        txtNewDescription.text =[receivedArray valueForKey:@"FullStory"];
        txtNewDescription.backgroundColor =[UIColor clearColor];
        [self.view addSubview:txtNewDescription];
        
        lbl_Time.text = [receivedArray valueForKey:@"Time"];
        lbl_CategoryType.text = [receivedArray valueForKey:@"CategoryName"];
    NSString * path = [receivedArray valueForKey:@"imagePath"];
    
    NSLog(@"path%@",path);
    
    NSLog(@"%@",[NSString stringWithFormat:@"%@/%@",[self applicationDocumentsDirectory],path.lastPathComponent]);
    NSString *fullPath = [NSString stringWithFormat:@"%@/%@",[self applicationDocumentsDirectory],path.lastPathComponent];
    UIImage * myImage = [UIImage imageWithData:[NSData dataWithContentsOfFile:fullPath]];
   
    [testing_Imageview setImage:myImage];
        
    }
    else if ([[receivedArray valueForKey:@"Type"] isEqualToString:@"VIDEO"]){
        
        [videoPlayIcon setHidden:NO];
        
        lblTitle.text=[receivedArray valueForKey:@"Title"];
        txtDescription.textColor = [UIColor colorWithRed:65.0/255.0 green:65.0/255.0 blue:65.0/255.0 alpha:1.0];
        [txtDescription setFont:[UIFont fontWithName:@"Helvetica Neue" size:20.0]];
        //txtDescription.text=[receivedArray valueForKey:@"FullStory"];
        lbl_Time.text = [receivedArray valueForKey:@"Time"];
        lbl_CategoryType.text = [receivedArray valueForKey:@"CategoryName"];
        
        
        
        UITextView * txtNewDescription = [[UITextView alloc] initWithFrame:CGRectMake(12.0, 343.0, 298.0, 211.0)];
        txtNewDescription.textColor =[UIColor colorWithRed:65.0/255.0 green:65.0/255.0 blue:65.0/255.0 alpha:1.0];
        txtNewDescription.editable =NO;
        txtNewDescription.selectable =NO;
        [txtNewDescription setFont:[UIFont fontWithName:@"Helvetica Neue" size:16.0]];
        txtNewDescription.text =[receivedArray valueForKey:@"FullStory"];
         txtNewDescription.backgroundColor =[UIColor clearColor];
        [self.view addSubview:txtNewDescription];
        
        
        [testing_Imageview setHighlighted:YES];
        //NSURL *vedioURL= [receivedArray valueForKey:@"videoPath"];
        
        NSString *fullpath=[receivedArray valueForKey:@"videoPath"];
        NSString *videoPath = [NSString stringWithFormat:@"%@/%@",[self applicationDocumentsDirectory],fullpath.lastPathComponent];
        
        
               NSLog(@" video path%@",videoPath);
        
      
        
        NSURL *videoURL = [NSURL fileURLWithPath:videoPath];
        globalVideoUrl= videoURL;
        
        AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
        AVAssetImageGenerator *generateImg = [[AVAssetImageGenerator alloc] initWithAsset:asset];
        NSError *error = NULL;
        CMTime time = CMTimeMake(1, 65);
        CGImageRef refImg = [generateImg copyCGImageAtTime:time actualTime:NULL error:&error];
        NSLog(@"error==%@, Refimage==%@", error, refImg);
        UIImage *FrameImage= [[UIImage alloc] initWithCGImage:refImg];
       
        [testing_Imageview setImage:FrameImage];
        
        
        
    }
    
    else if ([[receivedArray valueForKey:@"Type"] isEqualToString:@"TEXT"]) {

        
        
        [testing_Imageview setHidden:YES];
        [videoPlayIcon setHidden:YES];
        [txtDescription setHidden:YES];
        lblTitle.text=[receivedArray valueForKey:@"Title"];
        lbl_Time.text = [receivedArray valueForKey:@"Time"];
        lbl_CategoryType.text = [receivedArray valueForKey:@"CategoryName"];
       
        UITextView * txtDescriptionAudio =[[UITextView alloc] initWithFrame:CGRectMake(8.0, 147.0, 298.0, 400.0)];
         txtDescriptionAudio.textColor = [UIColor colorWithRed:65.0/255.0 green:65.0/255.0 blue:65.0/255.0 alpha:1.0];
        [txtDescriptionAudio setFont:[UIFont fontWithName:@"Helvetica Neue" size:16.0]];
        
        NSString *trimmedString = [[receivedArray valueForKey:@"FullStory"] stringByTrimmingCharactersInSet:
                                   [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
       // txtDescriptionAudio.text = [receivedArray valueForKey:@"FullStory"];
        
        txtDescriptionAudio.text=trimmedString;
        
        txtDescriptionAudio.editable=NO;
        txtDescriptionAudio.selectable =NO;
        [txtDescriptionAudio setBackgroundColor:[UIColor clearColor]];
        [self.view addSubview:txtDescriptionAudio];
       
        
        
        
    }else if ([[receivedArray valueForKey:@"Type"] isEqualToString:@"AUDIO"]) {
        
        [videoPlayIcon setHidden:NO];
        
        checkingAudio_Video = YES;
        
        lblTitle.text=[receivedArray valueForKey:@"Title"];
        txtDescription.textColor = [UIColor colorWithRed:65.0/255.0 green:65.0/255.0 blue:65.0/255.0 alpha:1.0];
       // txtDescription.text=[receivedArray valueForKey:@"FullStory"];
        lbl_Time.text = [receivedArray valueForKey:@"Time"];
        lbl_CategoryType.text = [receivedArray valueForKey:@"CategoryName"];
        audioUrl = [receivedArray valueForKey:@"AudioPath"];
        
        
        UITextView * txtNewDescription = [[UITextView alloc] initWithFrame:CGRectMake(12.0, 343.0, 298.0, 211.0)];
        txtNewDescription.textColor =[UIColor colorWithRed:65.0/255.0 green:65.0/255.0 blue:65.0/255.0 alpha:1.0];
        txtNewDescription.editable =NO;
        txtNewDescription.selectable =NO;
        [txtNewDescription setFont:[UIFont fontWithName:@"Helvetica Neue" size:16.0]];
        txtNewDescription.text =[receivedArray valueForKey:@"FullStory"];
         txtNewDescription.backgroundColor =[UIColor clearColor];
        [self.view addSubview:txtNewDescription];
        
    }
}

- (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}




-(void)viewWillAppear:(BOOL)animated {
    
   // self.showTemperature.text = [NSString stringWithFormat:@"%0.0f", objectDataClass.temperature];
    
   // NSLog(@"received array --%@",receivedArray);
    
}

#pragma mark - IBActionBack

- (IBAction)btnBackTo_tapped:(id)sender {
   // [controller.moviePlayer stop];
    [self.navigationController popViewControllerAnimated:YES];
}

//playing video on button click

- (IBAction)videoPlayClicked:(id)sender {
    if (checkingAudio_Video == YES) {
     
        //app.yourFileURL
        CGSize size = [[UIScreen mainScreen]bounds].size;
        
        if (size.height==480) {
            
            PlayRecordedAudio * playaudio = [[PlayRecordedAudio alloc] initWithNibName:@"PlayRecordedAudio3.5" bundle:nil];
            app.yourFileURL =  [NSURL fileURLWithPath:audioUrl];;
            [self.navigationController pushViewController:playaudio animated:YES];
            
            
        }else{
            
            PlayRecordedAudio * playaudio = [[PlayRecordedAudio alloc] initWithNibName:@"PlayRecordedAudio" bundle:nil];
            app.yourFileURL =[NSURL fileURLWithPath:audioUrl];
            [self.navigationController pushViewController:playaudio animated:YES];
            
        }

        
    }else{
    
    
    
    AVPlayer *player = [AVPlayer playerWithURL:globalVideoUrl];
    AVPlayerViewController *playerViewController = [AVPlayerViewController new];
    
    playerViewController.player = player;
    playerViewController.showsPlaybackControls=YES;
    [playerViewController.player play];//Used to Play On start
    [self presentViewController:playerViewController animated:YES completion:nil];
    }
}
@end
