//
//  MobileVarification.h
//  pioneer
//
//  Created by Ravi Phulara on 31/07/15.
//  Copyright (c) 2015 CYNOTECK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpinnerView.h"

@interface MobileVarification : UIViewController <UITextFieldDelegate,UIAlertViewDelegate,UITabBarDelegate,UITabBarControllerDelegate>
{
    SpinnerView *spinner;
    UIAlertView *successful_AlertShow ;
    
}

//OutLet

@property (weak, nonatomic) IBOutlet UITextField *txt_password;
@property (nonatomic,strong) NSMutableDictionary *getData;
@property (nonatomic,strong) NSString *getOTP;
@property (nonatomic) float getTime;






//Action
- (IBAction)btn_Reset:(id)sender;
- (IBAction)btn_Submit:(id)sender;
- (IBAction)btn_Clickhare:(id)sender;
- (IBAction)btn_back:(id)sender;





@end
