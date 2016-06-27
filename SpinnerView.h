//
//  SpinnerView.h
//  Garagisti
//
//  Created by Mohit Bisht on 12/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
@interface SpinnerView : UIView
{
    
}
+(SpinnerView *)loadSpinnerIntoView:(UIView *)superView;
-(void)removeSpinner;
	
@end
