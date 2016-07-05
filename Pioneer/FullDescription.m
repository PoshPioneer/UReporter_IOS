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
    
    
    // By Pushpank
    
    UILabel *lblTitle;
    CGSize screenSize;
    UIScrollView *scrollView;
    UILabel *lblSubmittedTime;
    UILabel *lblCategory;
    UIImageView *imageView;
    UILabel *lblDescription;
    UIButton *btnVideoPlay;

    
}

@end

@implementation FullDescription
@synthesize receivedArray;

#pragma mark - viewDidLoad

- (void)viewDidLoad {
    [super viewDidLoad];
    screenSize =[[UIScreen mainScreen] bounds].size;
    
    // initialize scroll view

    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,64, screenSize.width,screenSize.height )];
    [self.view addSubview:scrollView];

    // initialize title label

    lblTitle = [[UILabel alloc] init];
    lblTitle.frame = CGRectMake(8,10,screenSize.width-16,60);
    lblTitle.numberOfLines = 2;
    lblTitle.adjustsFontSizeToFitWidth = YES;
    lblTitle.lineBreakMode = NSLineBreakByWordWrapping;
    [lblTitle setBackgroundColor:[UIColor clearColor]];
    [lblTitle setFont:[UIFont fontWithName:@"Helvetica Neue Bold" size:15.0]];
    lblTitle.textAlignment = NSTextAlignmentCenter;
    [scrollView addSubview:lblTitle];
    
    
    // initialize time label
    
    lblSubmittedTime = [[UILabel alloc] init];
//    lblSubmittedTime.frame = CGRectMake(8,lblTitle.bounds.origin.y + lblTitle.frame.size.height +5,screenSize.width*0.28,screenSize.height*0.049);
    
      lblSubmittedTime.frame = CGRectMake(8,lblTitle.bounds.origin.y + lblTitle.frame.size.height +5,screenSize.width*0.90,screenSize.height*0.049);
    lblSubmittedTime.adjustsFontSizeToFitWidth = YES;
    lblSubmittedTime.lineBreakMode = NSLineBreakByWordWrapping;
    [lblSubmittedTime setBackgroundColor:[UIColor clearColor]];
    lblSubmittedTime.textAlignment = NSTextAlignmentLeft;
    [scrollView addSubview:lblSubmittedTime];
    
    
    


    // initialize category label
    
    lblCategory = [[UILabel alloc] init];
    lblCategory.frame = CGRectMake(200,lblTitle.bounds.origin.y + lblTitle.frame.size.height +5,screenSize.width*0.28,screenSize.height*0.049);
    lblCategory.adjustsFontSizeToFitWidth = YES;
    lblCategory.lineBreakMode = NSLineBreakByWordWrapping;
    [lblCategory setBackgroundColor:[UIColor clearColor]];
    lblCategory.textAlignment = NSTextAlignmentRight;
    [scrollView addSubview:lblCategory];
    
    // initialize imageView
    
    imageView = [[UIImageView alloc] init];

    // initialize Description Label

    lblDescription = [[UILabel alloc] init];
    [scrollView addSubview:lblDescription];
   [lblDescription setFont:[UIFont fontWithName:@"Helvetica Neue" size:16.0]];
    lblDescription.numberOfLines = 0;
    lblDescription.textColor = [UIColor colorWithRed:65.0/255.0 green:65.0/255.0 blue:65.0/255.0 alpha:1.0];
    [lblDescription sizeToFit];

    // initialize play video Button
    btnVideoPlay = [UIButton buttonWithType:UIButtonTypeCustom];
    objectDataClass = [DataClass getInstance];
    // Do any additional setup after loading the view from its nib.
    
    app=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    
    lblTitle.text=[receivedArray valueForKey:@"Title"];
    lblDescription.textColor = [UIColor colorWithRed:65.0/255.0 green:65.0/255.0 blue:65.0/255.0 alpha:1.0];
    NSString *trimmedDescription = [[receivedArray valueForKey:@"FullStory"] stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    lblDescription.text = trimmedDescription;
    lblSubmittedTime.text = [receivedArray valueForKey:@"Date"];
    lblCategory.text = [receivedArray valueForKey:@"CategoryName"];
    
    CGFloat expectedLabelSize = [self heightForText:trimmedDescription font:lblDescription.font withinWidth:screenSize.width -16];

    
    // Show for Category
    
    if ([[receivedArray valueForKey:@"Type"] isEqualToString:@"PHOTO"]) {
        imageView.contentMode =UIViewContentModeScaleAspectFit;
        [imageView setClipsToBounds:YES];
        imageView.frame = CGRectMake(8,lblSubmittedTime.bounds.origin.y + lblSubmittedTime.frame.size.height +80,screenSize.width-16,180);
        [scrollView addSubview:imageView];
        
         lblDescription.frame = CGRectMake(8,imageView.frame.origin.y + imageView.frame.size.height + 5,screenSize.width -16, expectedLabelSize);
            NSString * path = [receivedArray valueForKey:@"imagePath"];
        NSLog(@"path%@",path);
        NSLog(@"%@",[NSString stringWithFormat:@"%@/%@",[self applicationDocumentsDirectory],path.lastPathComponent]);
        //NSString *fullPath = [NSString stringWithFormat:@"%@/%@",[self applicationDocumentsDirectory],path.lastPathComponent];
        NSData * ImageData = [receivedArray valueForKey:@"transferImage"];
        UIImage * myImage = [UIImage imageWithData:ImageData];
        [imageView setImage:myImage];
         scrollView.contentSize = CGSizeMake(screenSize.width,lblDescription.bounds.origin.y+lblDescription.frame.size.height+430);
        
    }
    
    else if ([[receivedArray valueForKey:@"Type"] isEqualToString:@"VIDEO"]){
        imageView.frame = CGRectMake(8,lblSubmittedTime.bounds.origin.y + lblSubmittedTime.frame.size.height +80,screenSize.width-16,180);
        btnVideoPlay.frame = CGRectMake(8,lblSubmittedTime.bounds.origin.y + lblSubmittedTime.frame.size.height +80,screenSize.width-16,180);
        [scrollView addSubview:imageView];
        lblDescription.frame = CGRectMake(8,imageView.frame.origin.y + imageView.frame.size.height + 5,screenSize.width -16, expectedLabelSize);
        [scrollView addSubview:btnVideoPlay];
        [btnVideoPlay setImage:[UIImage imageNamed:@"play-icon@2x"] forState:UIControlStateNormal];
        [btnVideoPlay addTarget:self action:@selector(playVideo) forControlEvents:UIControlEventTouchUpInside];
        [imageView setHighlighted:YES];
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
        [imageView setImage:FrameImage];
       scrollView.contentSize = CGSizeMake(screenSize.width,lblDescription.bounds.origin.y+lblDescription.frame.size.height+430);
    }
    
    else if ([[receivedArray valueForKey:@"Type"] isEqualToString:@"TEXT"]) {
        lblDescription.frame = CGRectMake(8.0, lblSubmittedTime.bounds.origin.y + lblSubmittedTime.frame.size.height +100, 298.0, expectedLabelSize);
        scrollView.contentSize = CGSizeMake(screenSize.width,lblDescription.bounds.origin.y+lblDescription.frame.size.height+430);
        
    }
    else if ([[receivedArray valueForKey:@"Type"] isEqualToString:@"AUDIO"]) {
        imageView.frame = CGRectMake(8,lblSubmittedTime.bounds.origin.y + lblSubmittedTime.frame.size.height +80,screenSize.width-16,180);
        [scrollView addSubview:imageView];
        lblDescription.frame = CGRectMake(8,imageView.frame.origin.y + imageView.frame.size.height + 5,screenSize.width -16, expectedLabelSize);
        btnVideoPlay.frame = CGRectMake(8,lblSubmittedTime.bounds.origin.y + lblSubmittedTime.frame.size.height +80,screenSize.width-16,180);
        [btnVideoPlay setImage:[UIImage imageNamed:@"play-icon@2x"] forState:UIControlStateNormal];
        [scrollView addSubview:btnVideoPlay];
        [btnVideoPlay addTarget:self action:@selector(playAudio) forControlEvents:UIControlEventTouchUpInside];
        [imageView setHighlighted:YES];
        checkingAudio_Video = YES;
        audioUrl = [receivedArray valueForKey:@"AudioPath"];
       scrollView.contentSize = CGSizeMake(screenSize.width,lblDescription.bounds.origin.y+lblDescription.frame.size.height+430);
    }
}

- (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}


#pragma mark - IBActionBack

- (IBAction)btnBackTo_tapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//playing video on button click

-(void)playVideo {

    AVPlayer *player = [AVPlayer playerWithURL:globalVideoUrl];
    AVPlayerViewController *playerViewController = [AVPlayerViewController new];
    playerViewController.player = player;
    playerViewController.showsPlaybackControls=YES;
    [playerViewController.player play];//Used to Play On start
    [self presentViewController:playerViewController animated:YES completion:nil];

}



-(void)playAudio{

    if (checkingAudio_Video == YES) {
        //app.yourFileURL
        
            PlayRecordedAudio * playaudio = [[PlayRecordedAudio alloc] initWithNibName:@"PlayRecordedAudio" bundle:nil];
            app.yourFileURL =[NSURL fileURLWithPath:audioUrl];
            [self.navigationController pushViewController:playaudio animated:YES];
            
    }

}

// Calculate label Height according to Text

-(CGFloat)heightForText:(NSString*)text font:(UIFont*)font withinWidth:(CGFloat)width {
    CGSize size = [text sizeWithAttributes:@{NSFontAttributeName:font}];
    CGFloat area = size.height * size.width;
    CGFloat height = roundf(area / width);
    return ceilf(height / font.lineHeight) * font.lineHeight;
}

@end
