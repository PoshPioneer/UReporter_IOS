//
//  VideoPlayer.m
//  Pioneer
//
//  Created by Deepankar Parashar on 07/04/16.
//  Copyright © 2016 CYNOTECK. All rights reserved.
//

#import "VideoPlayer.h"
#import "SubscribeVC.h"
@interface VideoPlayer (){
    
    MPMoviePlayerController* moviePlayerController;
    
    
}

@end

@implementation VideoPlayer
@synthesize gatheredVideoURl;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    DataClass *obj = [DataClass getInstance];
    
    if (obj.globalCounter == 0 )
    {
        if ([[NSUserDefaults standardUserDefaults] valueForKey:@"subscribeStatus"] == nil) {
            
            
            
            UIAlertController *  alert  = [UIAlertController alertControllerWithTitle:@"" message:@"You've read all the free articles for this month." preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Subscribe" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                
                //do something when click button
                
                SubscribeVC *subscribeObj = [[SubscribeVC alloc] initWithNibName:@"SubscribeVC" bundle:nil];
                [self.navigationController pushViewController:subscribeObj animated:YES];
                
                
            }];
            [alert addAction:okAction];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                
                [self.navigationController popViewControllerAnimated:YES];
                
                //do something when click button
            }];
            [alert addAction:cancelAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }

    // Do any additional setup after loading the view from its nib.
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    NSLog(@"gatherede video url--%@",gatheredVideoURl);
    
    NSString * mediaURL= [[[gatheredVideoURl valueForKey:@"Mediaitems"] objectAtIndex:0] valueForKey:@"url"] ;
    
    
    
    NSURL *fileURL = [NSURL URLWithString:mediaURL];
    
    moviePlayerController = [[MPMoviePlayerController alloc] initWithContentURL:fileURL];
    [moviePlayerController.view setFrame:CGRectMake(0, 100, 320, 270)];
    [self.view addSubview:moviePlayerController.view];
    moviePlayerController.fullscreen = YES;
    [moviePlayerController play];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)btn_backTapped:(id)sender {
    
    NSArray *array = [self.navigationController viewControllers];
    
    NSLog(@"Photo gallery from array is :  %@",array);
    
    [moviePlayerController stop];
    [self.navigationController popToViewController:[array objectAtIndex:1] animated:NO];
    
}
@end
