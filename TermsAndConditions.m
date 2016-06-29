//
//  TermsAndConditions.m
//  Pioneer
//
//  Created by Deepankar Parashar on 12/04/16.
//  Copyright © 2016 CYNOTECK. All rights reserved.
//

#import "TermsAndConditions.h"

@interface TermsAndConditions ()

@end

@implementation TermsAndConditions
@synthesize web_view;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    web_view.scrollView.scrollEnabled=YES;
    
    //aboutus.html
    NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"TermsOfService" ofType:@"html"];
    NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
    [web_view loadHTMLString:htmlString baseURL:nil];
    web_view.layer.cornerRadius=2.0;
    [web_view setBackgroundColor:[UIColor clearColor]];
    //[web_View setOpaque:NO];
    web_view.scrollView.layer.cornerRadius = 3.0;
    web_view.scrollView.layer.borderWidth = 0.15;
    web_view.scrollView.layer.borderColor=[UIColor grayColor].CGColor;


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)backButtonTapped:(id)sender  {
    
    
    NSArray *array = [self.navigationController viewControllers];
    
    DLog(@" Text content from array is :  %@",array);
    
    [self.navigationController popToViewController:[array  objectAtIndex:1] animated:NO];
    
    
}


@end
