//
//  loginView.m
//  Pioneer
//
//  Created by Deepankar Parashar on 21/04/16.
//  Copyright © 2016 CYNOTECK. All rights reserved.
//

#import "LoginView.h"
#import "Base64.h"
#import "UploadView.h"
#import "SpinnerView.h"
#import "SubscribeVC.h"
@interface LoginView () {
    
    SyncManager *sync;
    NSMutableData *responseDataLogin;
    
}

@end

@implementation LoginView

@synthesize usernameTxt,passwordTxt;



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self changeBorderForTextField];
    
    
    UIView *statusBarView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 20)];
    statusBarView.backgroundColor  =  [UIColor whiteColor]; //[UIColor colorWithRed:20.0f/255.0f green:20.0f/255.0f blue:20.0f/255.0f alpha:1.0];
    [self.view addSubview:statusBarView];
    
    //UIViewController *vc = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    //[vc.view addSubview:statusBarView];

    
    
}



-(void)changeBorderForTextField{
    
    usernameTxt.layer.borderWidth =0.6f;
    passwordTxt.layer.borderWidth =0.6f;
    
    usernameTxt.layer.borderColor =[UIColor colorWithRed:197.0f/255.0f green:197.0f/255.0f blue:198.0f/255.0f alpha:1.0] .CGColor;
    passwordTxt.layer.borderColor=[UIColor colorWithRed:197.0f/255.0f green:197.0f/255.0f blue:198.0f/255.0f alpha:1.0] .CGColor;
    
}

// show alert
-(void) alertMessage : (NSString *)title message:(NSString *) message
{
    
    UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * doNothingAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * alert ){
        
        
    }];
    [errorAlert addAction:doNothingAction];
    [self presentViewController:errorAlert  animated:YES completion:nil];
    
}



- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





- (IBAction)loginButtonTapped:(id)sender {
    
    
    if ([Utility connected] == YES){
        
        NSString *trimmedUsername = [usernameTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSString *trimmedPassword = [passwordTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        if ([trimmedUsername isEqualToString:@""]) {
            
            [self alertShow:@"Please enter username"];
        }
        else if ([trimmedPassword isEqualToString:@""]){
            [self alertShow:@"Please enter password"];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.view setUserInteractionEnabled:NO];
                spinner=[SpinnerView loadSpinnerIntoView:self.view];
                
            });
            
            
            NSString *authStr = [NSString stringWithFormat:@"%@:%@", trimmedUsername, trimmedPassword];
            DLog(@"authStr is %@",authStr);
            NSData *authData = [authStr dataUsingEncoding:NSASCIIStringEncoding];
            NSString *authValue = [NSString stringWithFormat:@"Basic %@", [Base64 base64forData:authData]];
            DLog(@"auth value--%@",authValue);
            
            // Development.
//            NSString* urlString = [NSString stringWithFormat:@"https://syncaccess-demo-posh.stage.syncronex.com/demo/posh/api/svcs/subscribers/%@?format=JSON",trimmedUsername];
            
            
            // Production.
            NSString* urlString = [NSString stringWithFormat:@"https://syncaccess-png-sv.stage.syncronex.com/png/sv/api/svcs/subscribers/%@?format=JSON",trimmedUsername];

            
            // https://syncaccess-png-sv.stage.syncronex.com/png/sv/api/svcs/subscribers/%@?format=JSON
            
            
            DLog(@" url for login  --%@",urlString);
            
            
            
            PHHTTPSessionManager *manager = [PHHTTPSessionManager manager];
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            [manager.requestSerializer setValue:authValue forHTTPHeaderField:@"Authorization"];
            
            [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
             {
                 DLog(@"JSON: %@", responseObject);
                 NSDictionary *json = [Utility cleanJsonToObject:responseObject];
                 
                 
                 
                 [self.view setUserInteractionEnabled:YES];
                 [spinner removeSpinner];
                 
                 if(json)
                 {
                     
                     [[NSNotificationCenter defaultCenter]postNotificationName:@"RefreshUploadeView" object:nil];
                     
                     
                     [[NSUserDefaults standardUserDefaults] setObject:[json valueForKey:@"userName"] forKey:@"userName"];
                     [[NSUserDefaults standardUserDefaults] synchronize];
                     [self dismissViewControllerAnimated:YES completion:nil];
                     
                     
                 }
                 else
                 {
                     
                     UIAlertController * errorAlert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Not found data from server." preferredStyle:UIAlertControllerStyleAlert];
                     UIAlertAction * errorAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * alert){
                     }];
                     
                     [errorAlert addAction:errorAction];
                     [self presentViewController:errorAlert animated:YES completion:nil];
                     
                     
                     
                 }
                 
                 
             } failure:^(NSURLSessionTask *operation, NSError *error) {
                 DLog(@"Error: %@", error);
                 
                 [self.view setUserInteractionEnabled:YES];
                 [spinner removeSpinner];
                 
                 NSString * message ;
                 
                 if ([error.localizedDescription isEqualToString:@"Request failed: unauthorized (401)"]) {
                     
                    message = @"Please enter valid credentials";
                     
                 }
                 else{
                     
                     message =error.localizedDescription;
                 
                 }
                 
                 UIAlertController * errorAlert = [UIAlertController alertControllerWithTitle:@"Alert" message:message preferredStyle:UIAlertControllerStyleAlert];
                 UIAlertAction * errorAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * alert){
                 }];
                 
                 [errorAlert addAction:errorAction];
                 [self presentViewController:errorAlert animated:YES completion:nil];
                 
             }];
        }

        
    }else{
        
        UIAlertController * errorAlert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Internet connection is not available. Please try again." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * errorAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * alert){
        }];
        
        [errorAlert addAction:errorAction];
        [self presentViewController:errorAlert animated:YES completion:nil];

        
    }
    
}


-(void)alertShow:(NSString *)message{

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Message" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ok];
    
    [self presentViewController:alertController animated:YES completion:nil];

}

+ (NSString*)base64forData:(NSData*)theData {
    
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];
    
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    NSInteger i;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {  value |= (0xFF & input[j]);  }  }  NSInteger theIndex = (i / 3) * 4;  output[theIndex + 0] = table[(value >> 18) & 0x3F];
        output[theIndex + 1] = table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6) & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0) & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}



- (IBAction)backButtonTapped:(id)sender {
    
  //  exit(0);
    
   // [self dismissViewControllerAnimated:YES completion:nil];
    
}


- (IBAction)RegisterButtonTapped:(id)sender {
    
    if ([Utility connected] == YES){
        
        SubscribeVC *object=[[SubscribeVC alloc]initWithNibName:@"SubscribeVC" bundle:nil];
        
        //Development.
       // object.web_Url=@"https://syncaccess-demo-posh.stage.syncronex.com/demo/posh/account/register";
        
        
        //Production
        object.web_Url=@"https://syncaccess-png-sv.stage.syncronex.com/png/sv/account/register";

        [self presentViewController:object animated:YES completion:nil];

        
    }
    else{
        
        UIAlertController * errorAlert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Internet connection is not available. Please try again." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * errorAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * alert){
        }];
        
        [errorAlert addAction:errorAction];
        [self presentViewController:errorAlert animated:YES completion:nil];

        
    }
    
}


- (IBAction)forgotPasswordButtonTapped:(id)sender {
    
    if ([Utility connected] == YES){
        
        
        SubscribeVC *object=[[SubscribeVC alloc]initWithNibName:@"SubscribeVC" bundle:nil];
        
        //Development
        //object.web_Url=@"https://syncaccess-demo-posh.stage.syncronex.com/Demo/Posh/Account/ResetPassword";
        
        // Production.
        object.web_Url=@"https://syncaccess-png-sv.stage.syncronex.com/png/sv/Account/ResetPassword";

        [self presentViewController:object animated:YES completion:nil];

        
    }else{
        
        UIAlertController * errorAlert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Internet connection is not available. Please try again." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * errorAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * alert){
        }];
        
        [errorAlert addAction:errorAction];
        [self presentViewController:errorAlert animated:YES completion:nil];
    }
}


- (IBAction)closeButtonTapped:(id)sender {
    
    passwordTxt.text=nil;
    usernameTxt.text=nil;

    //[self dismissViewControllerAnimated:YES completion:nil];

    
}

@end
