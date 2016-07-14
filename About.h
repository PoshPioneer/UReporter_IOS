//
//  About.h
//  pioneer
//
//  Created by Valeteck on 31/07/14.
//  Copyright (c) 2014 CYNOTECK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface About : UIViewController
- (IBAction)back_Tapped:(id)sender;
- (IBAction)setting_Tapped:(id)sender;

- (IBAction)link_Tapped:(id)sender;
@property (weak, nonatomic) IBOutlet UIWebView *web_View;



@property (weak, nonatomic) IBOutlet UILabel *showTemperature;

@end
