//
//  Submission.h
//  pioneer
//
//  Created by Subodh Dharmwan on 25/11/15.
//  Copyright (c) 2015 CYNOTECK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuickLook/QuickLook.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

@interface Submission : UIViewController < UITableViewDelegate,UITableViewDataSource, QLPreviewControllerDelegate, QLPreviewControllerDataSource,UIDocumentInteractionControllerDelegate,AVAudioPlayerDelegate,UIAlertViewDelegate,UITabBarControllerDelegate,UITabBarDelegate>{
    
    AVAudioPlayer *audioPlayer;
    MPMoviePlayerController *moviePlayer;
    
    
}
@property (strong, nonatomic) IBOutlet UITableView *myTable;

@property (weak, nonatomic) IBOutlet UILabel *lblMeassage;

- (IBAction)btnBackTapped:(UIButton *)sender;
@property (nonatomic,strong) MPMoviePlayerController* mc;
@property (weak, nonatomic) IBOutlet UILabel *showTemperature;






// tab bar....
@property (weak, nonatomic) IBOutlet UITabBar *tabBarController;
@property(nonatomic,strong)UIImage *mainImage;


@end
