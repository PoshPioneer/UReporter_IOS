//
//  StaticLinkView.m
//  Pioneer
//
//  Created by Deepankar Parashar on 04/04/16.
//  Copyright © 2016 CYNOTECK. All rights reserved.
//

#import "StaticLinkView.h"
#import "DataClass.h"

@interface StaticLinkView () {
    
    DataClass * objectDataClass;
    bool checklodeView;
}

@end

@implementation StaticLinkView
@synthesize staticlink,webViewStatic;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    webViewStatic.delegate  = self;
    objectDataClass =[DataClass getInstance];
    
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    checklodeView=NO;
    DLog(@"static link --%@",staticlink);
    //if ([Utility connected] == YES) {
        
        NSURL *url = [NSURL URLWithString:staticlink];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy
                                         timeoutInterval:300];
        [webViewStatic loadRequest:request];


}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)webViewDidStartLoad:(UIWebView *)webView {
    DLog(@"start");
    if (!checklodeView) {
        
        checklodeView=YES;
        //[self.view setUserInteractionEnabled:NO];
        spinner=[SpinnerView loadSpinnerIntoView:self.view];
        

    }else{
        
        
    }
    
        
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    
    DLog(@"finish");
    if (checklodeView) {
        
        [self.view setUserInteractionEnabled:YES];
        [spinner removeSpinner];
        
        
    }else{
        
    
    }


}
-(void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];

    [self.view setUserInteractionEnabled:YES];
    [spinner removeSpinner];
    
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    DLog(@"Error for WEBVIEW: %@", [error description]);
    
    [self.view setUserInteractionEnabled:YES];
    [spinner removeSpinner];
    
    
}
-(IBAction)back_Tapped:(id)sender{
    
    NSArray *array = [self.navigationController viewControllers];
    
    DLog(@"Photo content from array is :  %@",array);
    
    objectDataClass.globalStaticCheck =YES;
    DLog(objectDataClass.globalStaticCheck ? @"Yes" : @"No");
    [self.view setUserInteractionEnabled:YES];
    [spinner removeSpinner];

    if(self.previousMenuIndex >= 0) {
        objectDataClass.sectionIndex = self.previousMenuIndex;
    }
    
    [self.navigationController popToViewController:[array objectAtIndex:1] animated:YES];
    
    
}


@end
