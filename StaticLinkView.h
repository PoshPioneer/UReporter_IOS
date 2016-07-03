//
//  StaticLinkView.h
//  Pioneer
//
//  Created by Deepankar Parashar on 04/04/16.
//  Copyright © 2016 CYNOTECK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpinnerView.h"

@interface StaticLinkView : UIViewController<UIWebViewDelegate>{
    
    SpinnerView *spinner;
}



@property(nonatomic,strong)NSString *staticlink;
@property(nonatomic) NSInteger previousMenuIndex;

@property(nonatomic,strong)IBOutlet UIWebView * webViewStatic;



@end
