//
//  SubmitForReviewDetails.m
//  Pioneer
//
//  Created by Deepankar Parashar on 08/04/16.
//  Copyright © 2016 CYNOTECK. All rights reserved.
//

#import "SubmitForReviewDetails.h"
#import "AppDelegate.h"

@interface SubmitForReviewDetails (){
    
    AppDelegate * app;
    
}


@end

@implementation SubmitForReviewDetails
@synthesize ReviewDescrptionStr,ReviewTitleStr,reviewDescription,reviewTitle;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    app=(AppDelegate*)[[UIApplication sharedApplication]delegate];

    reviewTitle.text =app.Title;
    reviewDescription.textColor = [UIColor colorWithRed:65.0/255.0 green:65.0/255.0 blue:65.0/255.0 alpha:1.0];
    reviewDescription.text = app.Description;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)backButtonTapped:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end
