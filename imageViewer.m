//
//  imageViewer.m
//  TOIAPP
//
//  Created by Subodh Dharmwan on 27/11/15.
//  Copyright (c) 2015 CYNOTECK. All rights reserved.
//

#import "imageViewer.h"
#import "Submission.m"

@interface imageViewer ()

@end

@implementation imageViewer
@synthesize image;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    Submission *submission=[[Submission alloc]init];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
