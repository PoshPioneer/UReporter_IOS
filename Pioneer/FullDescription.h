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


// Actions
- (IBAction)btnBackTo_tapped:(id)sender;

// Outlets 
@property (weak, nonatomic) IBOutlet UILabel *showTemperature;
@property(strong,nonatomic)NSDictionary * receivedArray;




@end
