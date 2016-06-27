//
//  temperatureViewController.h
//  Pioneer
//
//  Created by Deepankar Parashar on 22/02/16.
//  Copyright © 2016 CYNOTECK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpinnerView.h"

@interface temperatureViewController : UIViewController <UIWebViewDelegate,NSURLConnectionDataDelegate> {
    
    
    SpinnerView *spinner;
    NSMutableData *_responseData;
    
}


@property (weak, nonatomic) IBOutlet UIWebView *Temperature_webView;

- (IBAction)backButtonTap:(id)sender;

@end
