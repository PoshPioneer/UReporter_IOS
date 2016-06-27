//
//  PrivacyPolicy.h
//  pioneer
//
//  Created by Valeteck on 31/07/14.
//  Copyright (c) 2014 CYNOTECK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PrivacyPolicy : UIViewController
- (IBAction)back_Tapped:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll_View;
@property (strong, nonatomic) IBOutlet UIView *bck_View;
- (IBAction)setting_Tapped:(id)sender;

@property (weak, nonatomic) IBOutlet UIWebView *web_View;


@property (weak, nonatomic) IBOutlet UILabel *showTemperature;

@end
