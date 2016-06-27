//
//  VideoPlayer.h
//  Pioneer
//
//  Created by Deepankar Parashar on 07/04/16.
//  Copyright © 2016 CYNOTECK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>



@interface VideoPlayer : UIViewController

@property(strong,nonatomic)NSMutableArray* gatheredVideoURl;

- (IBAction)btn_backTapped:(id)sender;

@end
