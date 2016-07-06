//
//  PrivacyPolicy.m
//  pioneer
//
//  Created by Valeteck on 31/07/14.
//  Copyright (c) 2014 CYNOTECK. All rights reserved.
//

#import "PrivacyPolicy.h"
#import "Setting_Screen.h"
#import "DataClass.h"


@interface PrivacyPolicy () {
    
    
    DataClass * objectDataClass;
    
}

@end

@implementation PrivacyPolicy
@synthesize scroll_View;
@synthesize bck_View;
@synthesize web_View;
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
    objectDataClass = [DataClass getInstance];
    
    
    NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"Privacy" ofType:@"html"] ;
    NSLog(@"htmlFile = %@",htmlFile);
    NSString* htmlString = [[NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil] copy];
    
    NSLog(@"htmlString = %@",htmlString);

    [web_View loadHTMLString:htmlString baseURL:nil];
    web_View.layer.cornerRadius=2.0;
    [web_View setBackgroundColor:[UIColor clearColor]];
    [web_View setBackgroundColor:[UIColor clearColor]];
    //[web_View setOpaque:NO];
    web_View.scrollView.layer.cornerRadius = 3.0;
    web_View.scrollView.layer.borderWidth = 0.15;
    web_View.scrollView.layer.borderColor=[UIColor grayColor].CGColor;


}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [webView.scrollView setContentSize: CGSizeMake(webView.frame.size.width, webView.scrollView.contentSize.height)];
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back_Tapped:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)setting_Tapped:(id)sender {
    
    Setting_Screen *setting=[[Setting_Screen alloc]initWithNibName:@"Setting_Screen" bundle:nil];
    [self.navigationController pushViewController:setting animated:YES];

    
}
@end
