         //
//  ViewController.m
//  pioneer
//
//  Created by CYNOTECK on 7/25/14.
//  Copyright (c) 2014 CYNOTECK. All rights reserved.
//

#import "ViewController.h"
#import "UploadView.h"
#import "KeyChainValteck.h"
#import "AppDelegate.h"
#import "IQActionSheetPickerView.h"
#import "LoginView.h"

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface ViewController ()<SyncDelegate>
{
    SyncManager *sync;
}

@end

@implementation ViewController

@synthesize txt_Email,txt_First_Name,txt_Last_Name,txt_Phone;
@synthesize messageDisplayForAlert;
@synthesize switch_LocationEnable;
@synthesize submit_Outlet;
@synthesize scrollView,addViewOnScrollView;
@synthesize txt_Age,txt_adderss,txt_Occupation,txt_LanguageSpoken,txt_Education,txt_Special_Interests;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    sync = [[SyncManager alloc] init];
    sync.delegate = self;

    txt_Phone.delegate =self;
    txt_Email.delegate =self;
    
    txt_Email.layer.borderWidth =0.5f;
    txt_Phone.layer.borderWidth =0.5f;
    txt_Email.layer.borderColor = [UIColor colorWithRed:197.0f/255.0f green:197.0f/255.0f blue:198.0f/255.0f alpha:1.0].CGColor;
    txt_Phone.layer.borderColor =[UIColor colorWithRed:197.0f/255.0f green:197.0f/255.0f blue:198.0f/255.0f alpha:1.0].CGColor;
    
    [[self navigationController] setNavigationBarHidden:YES animated:YES];

    UIView *statusBarView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 20)];
    statusBarView.backgroundColor  =  [UIColor colorWithRed:20.0f/255.0f green:20.0f/255.0f blue:20.0f/255.0f alpha:1.0];
    UIViewController *vc = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    [vc.view addSubview:statusBarView];
    
    check_Uncheck_Bool=YES;
    
}

-(void)ShowViewContent
{
    
    self.navigationController.navigationBarHidden=YES;
    self.scrollView.frame=CGRectMake(0, 86, 320, 700);
    self.scrollView.contentSize = CGSizeMake(320,1290);
    [scrollView setBackgroundColor:[UIColor clearColor]];
    scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    scrollView.clipsToBounds = YES;
    scrollView.scrollEnabled = YES;
    [self.view addSubview:self.scrollView];
    [scrollView addSubview:addViewOnScrollView];
    scrollView.userInteractionEnabled=YES;
    scrollView.exclusiveTouch=YES;

}



-(void)viewWillAppear:(BOOL)animated
{
    
    ///// Dismiss KeyBord touch of View
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [scrollView addGestureRecognizer:tapGesture];

    
    
    AppDelegate *app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    NSString *  KEY_PASSWORD = @"com.toi.app.password"; //"appleDevelopment"
    NSString *  idfv_Local = [[KeyChainValteck keyChainLoadKey:app.putValueToKeyChain] valueForKey:KEY_PASSWORD];
    NSLog(@"saved key  is =====%@",idfv_Local);
    
    if ([idfv_Local length]==0)
    {
        NSLog(@"keychain is nil for all.");
        
//        if ([[[UIDevice currentDevice] systemVersion] floatValue] > 9.2 )
//        {
//            
//            [self alertMessage:@"Warning"  message:@"This app is not compatible with the OS version on your device."];
//            
//        }

        if ([Utility connected] == NO)
        {
            // Internet connection is not available !! so show alert
            
            [self alertMessage:@"Alert!" message:@"Internet connection is not available. Please try again."];
        }
        
    }
    else
    {
        
        
        NSLog(@"keychain is not null");
        CGSize size = [[UIScreen mainScreen]bounds].size;
        
        if (size.height==480)
        {
            
            UploadView *up=[[UploadView alloc]initWithNibName:@"UploadView3.5" bundle:nil];
            [self.navigationController pushViewController:up animated:NO];
            
            
        }
        else
        {
            
            UploadView *up=[[UploadView alloc]initWithNibName:@"UploadView" bundle:nil];
            [self.navigationController pushViewController:up animated:NO];
            
        }

        
        
        /*
        
        
        NSString* urlString = [NSString stringWithFormat:@"http://prngapi.cloudapp.net/api/UserDetails?deviceId=&source=&token=%@",[GlobalStuff generateToken]];
        NSLog(@"URL===%@",urlString);
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
          NSLog(@"JSON: %@", responseObject);
          NSDictionary *json = [Utility cleanJsonToObject:responseObject];
            
            if (json)
            {
                
                
                
                if ([[NSString stringWithFormat:@"%@",[[json valueForKey:@"data"]valueForKey:@"RegisteredwithSyncronex"]] isEqualToString:@"0"])
                {
                    
                    NSLog(@"keychain is not null");
                    CGSize size = [[UIScreen mainScreen]bounds].size;
                    
                    if (size.height==480)
                    {
                        
                        UploadView *up=[[UploadView alloc]initWithNibName:@"UploadView3.5" bundle:nil];
                        [self.navigationController pushViewController:up animated:NO];
                        
                        
                    }
                    else
                    {
                        
                        UploadView *up=[[UploadView alloc]initWithNibName:@"UploadView" bundle:nil];
                        [self.navigationController pushViewController:up animated:NO];
                        
                    }

                    
                }
                else
                {
                    [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"subscribeStatus"];
                    LoginView *loginView=[[LoginView alloc]initWithNibName:@"LoginView" bundle:nil];
                    [self.navigationController pushViewController:loginView animated:NO];
                    
                }
         
        
        
                NSString *userID_Default = [NSString stringWithFormat:@"%@",[[json valueForKey:@"header"] valueForKey:@"UserId"]];
                [[NSUserDefaults standardUserDefaults]setValue:userID_Default forKeyPath:@"userID_Default"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                
               
         
        
                
                
            }
         
            
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            
           
        }];
        
        */
    }
}


-(void)viewDidAppear:(BOOL)animated
{
    [self addPadding];
    [self addingPaddingToEmail];

}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    
    return YES;
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


- (void)didReceiveMemoryWarning
{
   
    [super didReceiveMemoryWarning];
    
}


-(void)addPadding
{
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    txt_Phone.leftView = paddingView;
    txt_Phone.leftViewMode = UITextFieldViewModeAlways;

}

-(void)addingPaddingToEmail
{
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    txt_Email.leftView = paddingView;
    txt_Email.leftViewMode = UITextFieldViewModeAlways;
}


- (void)dismissControls
{
    [self.view  endEditing:YES]; //may be not required
    
}

#pragma mark ################ Reset Tapped ############################

- (IBAction)Reset_Tapped:(id)sender
{
    
 
    
    txt_First_Name.text=nil;
    txt_Last_Name.text=nil;
    txt_Email.text=nil;
    txt_Phone.text=nil;
    txt_Age.text = nil;
    txt_Gender.text = nil;
    txt_adderss.text = nil;
    txt_MaritalStatus.text = nil;
    txt_Occupation.text = nil;
    txt_LanguageSpoken.text = nil;
    txt_Education.text = nil;
    txt_MaritalStatus.text = nil;
    txt_Special_Interests.text = nil;

    
}


#pragma mark ################ Submit Tapped ############################

- (IBAction)submit_Tapped:(id)sender
{
    
    [self.view endEditing:YES];
   
    if ([Utility connected] == YES)
    {
        [self checkSubmitDetails];
           
    }
    else
    {
           
        [self alertMessage:@"Alert" message:@"Internet connection is not available. Please try again."];
        
    }
}

-(void)checkSubmitDetails
{
    // just putting to skip the validation so calling method here..
    //===================== IF validation is required use this commented part ========================
    
    if([txt_Email.text length]==0 || [txt_Phone.text length]==0 || [txt_Phone.text length]!=10 )
    {

        if ([txt_Email.text length]==0)
        {
            messageDisplayForAlert= @"Please enter an email id";
        }
        else if ([txt_Phone.text length]==0)
        {
            messageDisplayForAlert= @"Please enter a mobile number";
        }
        
        else if([txt_Phone.text length]!=10)
        {
            messageDisplayForAlert = @"Please enter a valid mobile number";
        }
        
        [self alertMessage:@"Alert" message:messageDisplayForAlert];


    }
    else if (![self validateEmail:txt_Email.text])
    {
        messageDisplayForAlert=@"Please enter a valid email id";
        [self alertMessage:@"Alert" message:messageDisplayForAlert];
    }
    else
    {
        [self callMethodForLoginService]; // call method  on registration.
        
    }
 
}

- (BOOL) validateEmail: (NSString *) checkString
{
//    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";
//    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
//    return [emailTest evaluateWithObject:candidate];
        BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
        NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
        NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
        NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        return [emailTest evaluateWithObject:checkString];
}


-(void)callMethodForLoginService
{

    [self.view setUserInteractionEnabled:NO];
    spinner=[SpinnerView loadSpinnerIntoView:self.view];

    NSMutableDictionary *finalDictionary = [NSMutableDictionary dictionary];
    NSMutableDictionary *headerDict = [NSMutableDictionary dictionary];
    NSMutableDictionary *dictionaryTemp = [NSMutableDictionary dictionary];
    
    [headerDict setValue:@"" forKey:@"DeviceId"];  // THIS WILL CHANGE & WILL USE "idfv" txt_Email.text
    [headerDict setValue:@"0" forKey:@"UserId"];
    [headerDict setValue:@"" forKey:@"Source"];

    [dictionaryTemp setValue:@"" forKey:@"FirstName"];
    [dictionaryTemp setValue:txt_Email.text forKey:@"Email"];
    [dictionaryTemp setValue:txt_Phone.text forKey:@"Phone"];
    [dictionaryTemp setValue:@"" forKey:@"LastName"];
    
    // Adding New Data on Service..
    [dictionaryTemp setValue:@"" forKey:@"Age"];
    [dictionaryTemp setValue:@"" forKey:@"Gender"];
    [dictionaryTemp setValue:@"" forKey:@"Address"];
    
    [dictionaryTemp setValue:@"" forKey:@"Qualification"];
    [dictionaryTemp setValue:@""  forKey:@"MaritalStatus"];
    [dictionaryTemp setValue:@"" forKey:@"SpecialInterests"];
    [dictionaryTemp setValue:@"" forKey:@"LanguagesSpoken"];
    [dictionaryTemp setValue:@"" forKey:@"Occupation"];
    // END..
    
    if (check_Uncheck_Bool)
    {
        [dictionaryTemp setValue:@"true" forKey:@"IsLocationEnabled"];
        [dictionaryTemp setValue:[[NSUserDefaults standardUserDefaults]stringForKey:@"address_Default"] forKey:@"LocationDetails"];
        
    }
    else
    {
        [dictionaryTemp setValue:@"false" forKey:@"IsLocationEnabled"];
    }

    [finalDictionary setObject:headerDict forKey:@"header"];
    [finalDictionary setValue:dictionaryTemp forKey:@"data"];

    
    NSString* urlString = [NSString stringWithFormat:@"http://prngapi.cloudapp.net/api/UserDetails?token=%@",[GlobalStuff generateToken]];
    
    NSLog(@"while registration data sent is = %@",finalDictionary);
 
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.view setUserInteractionEnabled:NO];
        spinner=[SpinnerView loadSpinnerIntoView:self.view];
        
    });
    
    [sync serviceCall:urlString withParams:finalDictionary]; // service called
    
}


#pragma mark Web Service Delegate

-(void)syncSuccess:(id) responseObject
{
    
    NSLog(@"%@",responseObject);
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.view setUserInteractionEnabled:YES];
        [spinner removeSpinner];

    });

    
    NSString *strCompare = [NSString stringWithFormat:@"%@",[[responseObject valueForKey:@"data"] valueForKey:@"ErrorId"]];
    NSString *message = [NSString stringWithFormat:@"%@",[[responseObject valueForKey:@"data"] valueForKey:@"ErrorMessage"]];

    if ([strCompare isEqualToString:@"110"] || [strCompare isEqualToString:@"111"])
    {

        [[NSUserDefaults standardUserDefaults]setValue:[NSString stringWithFormat:@"%@",[[responseObject valueForKey:@"header"] valueForKey:@"UserId"]] forKeyPath:@"userID_Default"];

        [[NSUserDefaults standardUserDefaults]setValue:strCompare forKeyPath:@"TimesOfIndiaRegistrationID"];
        [[NSUserDefaults standardUserDefaults]synchronize];

        NSLog(@"id is = %@",[[NSUserDefaults standardUserDefaults]stringForKey:@"userID_Default"]);
        // set keychain value

        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        NSMutableDictionary *usernamepasswordKVPairs = [NSMutableDictionary dictionary];
        [usernamepasswordKVPairs setObject:app.FinalKeyChainValue forKey:@"com.toi.app.password"];
        [KeyChainValteck keyChainSaveKey:app.putValueToKeyChain data:usernamepasswordKVPairs];
    
        CGSize size = [[UIScreen mainScreen]bounds].size;
        
        if (size.height==480)
        {

            UploadView *upload = [[UploadView alloc]initWithNibName:@"UploadView3.5" bundle:nil];
            [self.navigationController pushViewController:upload animated:YES];
            
        }
        else
        {
            UploadView *upload = [[UploadView alloc]initWithNibName:@"UploadView" bundle:nil];
            [self.navigationController pushViewController:upload animated:YES];
        }
        
    }
    else
    {
        [self alertMessage:@"Alert" message:message];
    }
    
}

-(void)syncFailure:(NSError*) error
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.view setUserInteractionEnabled:YES];
        [spinner removeSpinner];
        
    });

    [self alertMessage:@"Message" message:[error localizedDescription]];;
}


- (IBAction)enableStateChanged:(id)sender
{
    if (switch_LocationEnable.on)
    {
        check_Uncheck_Bool=YES;
        
    }
    else
    {
        check_Uncheck_Bool=NO;
        
    }

    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
   // NSLog(@"range is =====%i",range.length);
    
    if (range.length==1)
    {
        return YES;
    }
    
    if (textField ==txt_Phone )
    {
        
        if ([txt_Phone.text length]>=10)
        {
            return NO;
        }
        
    }
    if (textField == txt_Age)
    {
        if ([txt_Age.text length]>=2)
        {
            return NO;
        }
    }
    if(textField == txt_First_Name)
    {
        NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
        
        if ([txt_First_Name.text length]>=15)
        {
            return NO;
        }
        else
        {
            return [string isEqualToString:filtered];
        }
        
    }
    
    
    
    if(textField == txt_Last_Name)
    {
        NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
        if([txt_Last_Name.text length]>=15)
        {
            return NO;
            
        }
        else
        {
            return [string isEqualToString:filtered];
        }
    }
    if (textField==txt_LanguageSpoken)
    {
        NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz, "] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
        if([txt_LanguageSpoken.text length]>=100)
        {
            
            return NO;
        }
        else
        {
            return [string isEqualToString:filtered];
        }
    }
    if (textField==txt_Occupation)
    {
        NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz, "] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
        
        return [string isEqualToString:filtered];
    }
    if(textField==txt_Special_Interests)
    {
    
        NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZ,abcdefghijklmnopqrstuvwxyz "] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
        if([txt_Special_Interests.text length]>=250)
        {
            return NO;
        }
        else
        {
            return [string isEqualToString:filtered];
        }
    }
    if (textField==txt_Education)
    {
        NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZ,abcdefghijklmnopqrstuvwxyz "] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
        if([txt_Education.text length]>=50)
        {
            return NO;
        }
        else
        {
            return [string isEqualToString:filtered];
        }
    }
    if (textField == txt_adderss)
    {
        if ([txt_adderss.text length]>=400)
        {
            return NO;
        }
    }
    
    if (textField == txt_Email)
    {
        if ([txt_Email.text length]>=150)
        {
            return NO;
        }
    }
    
    return YES;
    
}

-(void)doneClicked:(UIBarButtonItem*)button
{
    [self.view endEditing:YES];

}

// method to hide keyboard when user taps on a scrollview
-(void)hideKeyboard
{
    [self.view  endEditing:YES];
    
}

@end
