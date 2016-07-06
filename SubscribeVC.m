//
//  SubscribeVC.m
//  Pioneer
//
//  Created by Mohit Bisht on 29/04/16.
//  Copyright © 2016 CYNOTECK. All rights reserved.
//

#import "SubscribeVC.h"
#import "GlobalStuff.h"
@interface SubscribeVC ()<SyncDelegate>

@end

@implementation SubscribeVC
@synthesize web_Url;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIView *statusBarView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 20)];
    statusBarView.backgroundColor  =  [UIColor blackColor];
    [self.view addSubview:statusBarView];
    
    //set the constraints to auto-resize
    statusBarView.translatesAutoresizingMaskIntoConstraints = NO;
    [statusBarView.superview addConstraint:[NSLayoutConstraint constraintWithItem:statusBarView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:statusBarView.superview attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
    [statusBarView.superview addConstraint:[NSLayoutConstraint constraintWithItem:statusBarView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:statusBarView.superview attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0]];
    [statusBarView.superview addConstraint:[NSLayoutConstraint constraintWithItem:statusBarView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:statusBarView.superview attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0]];
    [statusBarView.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[statusBarView(==20)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(statusBarView)]];
    [statusBarView.superview setNeedsUpdateConstraints];
    

    // Do any additional setup after loading the view from its nib.
    if (web_Url) {
        
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:web_Url]]];

        
    }else{
        
        
        // Build the url and loadRequest
        NSString *urlString = [[NSUserDefaults standardUserDefaults] valueForKey:@"registerUrl"];
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
        
        sync = [[SyncManager alloc] init];
        sync.delegate = self;
        /*
         {"header":{},
         "body":{}}
         */
        
        
        NSMutableDictionary *json= [[NSMutableDictionary alloc] init];
        NSMutableDictionary *header= [[NSMutableDictionary alloc] init];
        NSMutableDictionary *body= [[NSMutableDictionary alloc] init];
        [json setObject:body forKey:@"body"];
        [json setObject:header forKey:@"header"];
        
        NSLog(@"%@",json);
        
                
        
        [sync putServiceCall:[NSString stringWithFormat:@"%@%@/%@/Syncronexuser?token=%@",kBaseURL,kAPI,kUserDetails,[GlobalStuff generateToken]] withParams:json]; // call webservice

    
    }
    

}
- (IBAction)btn_backTapped:(id)sender {
    
    if (web_Url) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }else{
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
#pragma mark - web view delegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    // [loadingView setHidden:YES];
    [spinner removeSpinner];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    //[loadingView setHidden:NO];
    
    if ([Utility connected] == YES){

    
    spinner=[SpinnerView loadSpinnerIntoView:self.view];
    
        
        
    }else {
        
        
        UIAlertController * errorAlert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Internet connection is not available. Please try again." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * errorAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * alert){
        }];
        
        [errorAlert addAction:errorAction];
        [self presentViewController:errorAlert animated:YES completion:nil];

        
    }
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if ([Utility connected] == YES){
        
        // Nothing......
        
        
    }else {
        
        
        UIAlertController * errorAlert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Internet connection is not available. Please try again." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * errorAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * alert){
        }];
        
        [errorAlert addAction:errorAction];
        [self presentViewController:errorAlert animated:YES completion:nil];
        
        
    }

   
    
    [spinner removeSpinner];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - webservice delegate methods

-(void)syncSuccess:(id) responseObject {
    
    NSLog(@"%@",responseObject);
    [[NSUserDefaults standardUserDefaults] setValue:[responseObject valueForKey:@"Status"] forKey:@"subscribeStatus"];
    
}

-(void)syncFailure:(NSError*) error {
    //display Error
  
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
