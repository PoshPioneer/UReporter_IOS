//
//  Info.h
//  pioneer
//
//  Created by Valeteck on 12/08/14.
//  Copyright (c) 2014 CYNOTECK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Info : UIViewController
- (IBAction)back_Tapped:(id)sender;
- (IBAction)setting_Tapped:(id)sender;

@property (weak, nonatomic) IBOutlet UITextView *txt_View;
@property (weak, nonatomic) IBOutlet UIWebView *web_View;
@end
