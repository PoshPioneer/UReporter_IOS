//
//  FullDescription.h
//  pioneer
//
//  Created by Subodh Dharmwan on 02/12/15.
//  Copyright (c) 2015 CYNOTECK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>


@interface FullDescription : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UITextView *txtDescription;

- (IBAction)btnBackTo_tapped:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *showTemperature;

@property (weak, nonatomic) IBOutlet UIImageView *testing_Imageview;

@property(strong,nonatomic)NSDictionary * receivedArray;


@property (weak, nonatomic) IBOutlet UILabel *lbl_Time;
@property (weak, nonatomic) IBOutlet UILabel *lbl_CategoryType;

@property (weak, nonatomic) IBOutlet UIButton *videoPlayIcon;
- (IBAction)videoPlayClicked:(id)sender;




@end
