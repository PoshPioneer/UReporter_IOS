//
//  loginView.h
//  Pioneer
//
//  Created by Deepankar Parashar on 21/04/16.
//  Copyright © 2016 CYNOTECK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpinnerView.h"
#import "CustomTextField.h"
@interface LoginView : UIViewController{

    SpinnerView *spinner;

}

@property (weak, nonatomic) IBOutlet CustomTextField *usernameTxt;

@property (weak, nonatomic) IBOutlet CustomTextField *passwordTxt;

- (IBAction)closeButtonTapped:(id)sender;


- (IBAction)loginButtonTapped:(id)sender;

@end
