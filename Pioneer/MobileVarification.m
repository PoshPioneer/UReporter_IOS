//
//  MobileVarification.m
//  pioneer
//
//  Created by Ravi Phulara on 31/07/15.
//  Copyright (c) 2015 CYNOTECK. All rights reserved.
//

#import "MobileVarification.h"
#import "UploadView.h"
#import "Reachability.h"
#import "AppDelegate.h"
#import "KeyChainValteck.h"


@interface MobileVarification ()
{
    NSMutableData *responseData;
}

@end

@implementation MobileVarification
@synthesize txt_password,getData,getOTP,getTime;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    DLog(@"get Data===%@",getData);
    DLog(@"get OTP=== %@",getOTP);
    DLog(@"set time===%f",getTime);
    
    
}

-(void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:YES];
    
    // for registering the user's profile..... use method ""
   [self methodToRegisterUser];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)btn_Reset:(id)sender {
    
    txt_password.text= nil;
}

- (IBAction)btn_Submit:(id)sender {
    
    [self.view endEditing:YES];
    
    //get current time....
    NSDate *myDate = [NSDate date];
    NSTimeInterval getcurrentTime = [myDate timeIntervalSince1970];
    DLog(@"this is current time now===%f",getcurrentTime);

    // check time < 15 min..
    if(getcurrentTime - getTime >=900)
    {
        UIAlertView *alert = [[ UIAlertView alloc]initWithTitle:@"Message" message:@"OTP has been expired, try for new OTP" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
        
    }
    else{
        
        [self TimeLimit];
    }
    
}

-(void)TimeLimit
{
    // NSString *server = [[NSUserDefaults standardUserDefaults]stringForKey:@"connection_Internet"];
    
    if ([Utility connected] == YES) {
        
        if ([getOTP isEqualToString:txt_password.text])
        {
            [self methodToRegisterUser];
        }
        else if ([txt_password.text length]==0)
        {
            UIAlertView *alrt = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Please enter OTP code." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alrt show];
        }
        else{
            
            UIAlertView *alrt = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Entered OTP code is invalid, please enter valid OTP code" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alrt show];
        }
        
    }else{
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Message!" message:@"Internet connection is not available. Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
    }

}

- (IBAction)btn_Clickhare:(id)sender {
    
    [self.view endEditing:YES];
    // NSString *server = [[NSUserDefaults standardUserDefaults]stringForKey:@"connection_Internet"];
    
    if ([Utility connected] == YES) {
        
       // [self ServiceOTP];
        
    }
    else{
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Message!" message:@"Internet connection is not available. Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
    }
    
}

- (IBAction)btn_back:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view  endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (range.length==1) {
        return YES;
    }

    if (textField ==txt_password ) {
        
        if ([txt_password.text length]>=6) {
            return NO;
        }
        
    }
    return YES;
}

#pragma Mark Service For OTP

-(void)ServiceOTP{
    
    [self.view setUserInteractionEnabled:NO];
    spinner=[SpinnerView loadSpinnerIntoView:self.view];
    
    NSString * MobNo=[NSString stringWithFormat:@"%@",[[getData valueForKey:@"data"]valueForKey:@"Phone"]];
   
    //timesgroupcrapi  http://timesgroupcrapi.cloudapp.net/api/UserDet
    NSString* urlString = [NSString stringWithFormat:@"http://prngapi.cloudapp.net/api/OTP/GetOTP?MobileNo=%@&Source=%@",MobNo,@"Maharashtra"];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"GET"];
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    [connection start];
    
}


#pragma mark Login Service....

 -(void)methodToRegisterUser {
     
    [self.view setUserInteractionEnabled:NO];
    spinner=[SpinnerView loadSpinnerIntoView:self.view];
 
     NSError *error = nil;
     
     NSData *jsonData = [NSJSONSerialization dataWithJSONObject:getData
                         
                                                        options:kNilOptions
                                                          error:&error];
     //timesgroupcrapi  http://timesgroupcrapi.cloudapp.net/api/UserDet
     NSURL *url = [NSURL URLWithString:@"http://prngapi.cloudapp.net/api/UserDetails"];
     
     DLog(@"DICT IS===%@",getData);
     
     NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
     [request setHTTPMethod:@"POST"];
     [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
     [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
     [request setHTTPBody:jsonData];
     
     [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc]init]
                            completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                NSError *jsonError;
                                
                                DLog(@"data = %@",data);
                                DLog(@"response = %@",response);
                                DLog(@"error = %@",error);
                                
                                if (data==nil || response==nil) {
                                    
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        DLog(@"inside main thread!");
                                        DLog(@"An error occured: %@", jsonError);
                                        [self.view setUserInteractionEnabled:YES];
                                        [spinner removeSpinner];
                                    });
                                    
                                    
                                }else{

                                
                                id  json = [NSJSONSerialization JSONObjectWithData:data
                                                                           options:kNilOptions
                                                                             error:&jsonError];
                                DLog(@"json is for UserDetails== %@",json);
                                
                                
                                if ( error ==nil) {
                                    
                                if (json) {
                                    
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        DLog(@"inside main thread!");
                                        
                                        [self.view setUserInteractionEnabled:YES];
                                        [spinner removeSpinner];
                                        
                                        /////////////
                                        
                                        NSString *strCompare = [NSString stringWithFormat:@"%@",[[json valueForKey:@"data"] valueForKey:@"ErrorId"]];
                                        
                                        if ([strCompare isEqualToString:@"110"] || [strCompare isEqualToString:@"111"]) {
                                            
                                         //   NSString *userID_Default = [NSString stringWithFormat:@"%@",[[json valueForKey:@"header"] valueForKey:@"UserId"]];
                                          
                                            
                                            [[NSUserDefaults standardUserDefaults]setValue:[NSString stringWithFormat:@"%@",[[json valueForKey:@"header"] valueForKey:@"UserId"]] forKeyPath:@"userID_Default"];
                                            
                                            
                                            

                                            [[NSUserDefaults standardUserDefaults]setValue:strCompare forKeyPath:@"TimesOfIndiaRegistrationID"];
                                            [[NSUserDefaults standardUserDefaults]synchronize];
                                            
                                            
                                            
                                            DLog(@"id is = %@",[[NSUserDefaults standardUserDefaults]stringForKey:@"userID_Default"]);

                                            
                                            //////////////////////////////////////////////////
                                                //////////////////////////////////////////////////
                                            
                                            ///// for settting ....
                                            AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate ;
                                            NSString *  KEY_PASSWORD = @"com.toi.app.password";
                                            NSMutableDictionary *usernamepasswordKVPairs = [NSMutableDictionary dictionary];
                                            [usernamepasswordKVPairs setObject:[[getData valueForKey:@"data"] valueForKey:@"Email"] forKey:KEY_PASSWORD];
                                            [KeyChainValteck keyChainSaveKey:app.putValueToKeyChain data:usernamepasswordKVPairs];
                                            
                                            /// for setting ......
                                            
                                            // for getting ....
                                            NSString *  valueIs = [[KeyChainValteck keyChainLoadKey:app.putValueToKeyChain] valueForKey:KEY_PASSWORD];
                                            DLog(@"idfv is =====%@",valueIs);
                                            // for getting .....

                                             /////////////////////////////////////////////////
                                            /////////////////////////////////////////////////

                                            if ([strCompare isEqualToString:@"110"]) {
                                                
                                                //first time registration...
                                                
                                                successful_AlertShow = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Profile registered successfully" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                                [successful_AlertShow show];
                                                
                                                
                                            }else{
                                                // second time ......
                                                
                                                successful_AlertShow = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Your profile updated successfully" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                                [successful_AlertShow show];
                                                
                                                
                                                
                                            }
                                            
                                        }  /// end of correct condition to navigate ...
 
                                                                                
                                        //////////////
                                        
                                    });
                                }
                                    
                                } // error == nil check !!!end
                                else{
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        DLog(@"inside main thread!");
                                        DLog(@"An error occured: %@", jsonError);
                                        [self.view setUserInteractionEnabled:YES];
                                        [spinner removeSpinner];
                                    });
                                }
                                }
                            }];
 
 }

 

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    
    if (alertView == successful_AlertShow ) {
        
        CGSize size = [[UIScreen mainScreen]bounds].size;
        
        if (size.height==480) {
            
             UploadView *up=[[UploadView alloc]initWithNibName:@"UploadView3.5" bundle:nil];
             [self.navigationController pushViewController:up animated:YES];
            
        }else{
           
             UploadView *up=[[UploadView alloc]initWithNibName:@"UploadView" bundle:nil];
            [self.navigationController pushViewController:up animated:YES];
            
        }
        
    }
}


#pragma marks NSURLConnection delegate methods

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    DLog(@"error is %@",[error localizedDescription]);
    
    [self.view setUserInteractionEnabled:YES];
    [spinner removeSpinner];
    
    
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [responseData  appendData:data];
    
    
    
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    
    responseData = [[NSMutableData alloc]initWithLength:0];
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    [self.view setUserInteractionEnabled:YES];
    [spinner removeSpinner];
    
    // all the checks regarding otp, if it throws error or come some unusual response, or nil !
    NSError* error;
    id json = [NSJSONSerialization JSONObjectWithData:responseData
                                              options:kNilOptions
                                                error:&error];
    DLog(@"json O/p of OTP===%@",json);
    
    getOTP =[NSString stringWithFormat:@"%@",[[json valueForKey:@"data"] valueForKey:@"ErrorMessage"]];
    
    if (getOTP) {
        UIAlertView * getOtp_alrt = [[UIAlertView alloc]initWithTitle:@"Alert!" message:@"New OTP sent successfully" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [getOtp_alrt show];
    }
    else{
        
        // do nothing...
    }
    
    // for current time
    NSDate *myDate = [NSDate date];
    NSTimeInterval getcurrentTime = [myDate timeIntervalSince1970];
    DLog(@"this is current time now===%f",getcurrentTime);
    getTime = getcurrentTime;
    DLog(@"get time=====%f",getTime);
    
}


# pragma mark For Internet check.....

-(void)checkForInternetConnection{
    
    Reachability * reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    reach.reachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[NSUserDefaults standardUserDefaults]setValue:@"reachable" forKeyPath:@"connection_Internet"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            // internet is available!!!!
        });
    };
    
    reach.unreachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //   DLog(@"inside not reachable!");
            [[NSUserDefaults standardUserDefaults]setValue:@"not_reachable" forKeyPath:@"connection_Internet"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
        });
    };
    
    [reach startNotifier];
    
}

#pragma mark -- UITabBar Delegate




@end
