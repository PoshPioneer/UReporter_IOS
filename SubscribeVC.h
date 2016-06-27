//
//  SubscribeVC.h
//  Pioneer
//
//  Created by Mohit Bisht on 29/04/16.
//  Copyright © 2016 CYNOTECK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpinnerView.h"

@interface SubscribeVC : UIViewController
{
    SpinnerView *spinner;
    SyncManager *sync;

}
@property (weak, nonatomic) IBOutlet UIWebView *webView;
- (IBAction)btn_backTapped:(id)sender;



@property (nonatomic,strong)NSString *web_Url;

@end
