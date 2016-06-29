//
//  SharingView.m
//  Pioneer
//
//  Created by Deepankar Parashar on 18/03/16.
//  Copyright © 2016 CYNOTECK. All rights reserved.
//

#import "SharingView.h"
#import <Social/Social.h>

@interface SharingView ()

@end

@implementation SharingView
@synthesize sharingLink;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {

    DLog(@"copied link url --%@",sharingLink);
    
}


- (IBAction)backTapped:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)facebookSharing:(id)sender {
    
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        //[controller setInitialText:@"First post from my iPhone app"];
        [controller addURL:[NSURL URLWithString:sharingLink]];
        [self presentViewController:controller animated:YES completion:Nil];
        
    }
    
}

- (IBAction)twitterSharing:(id)sender {

    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
       // [tweetSheet setInitialText:@"Great fun"];
        
        [tweetSheet addURL:[NSURL URLWithString:sharingLink]];
        
        [self presentViewController:tweetSheet animated:YES completion:nil];
        
        
    }
    



}


- (IBAction)contactUsTapped:(id)sender {
    
    NSString *link = sharingLink;
    NSString *emailTitle = @"Test Email";
    // Email
    NSString *messageBody = [NSString stringWithFormat:@"<a href=%@></a>",link];
                             // @"http://www.google.com";

    
    
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:@""];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    //[mc setMessageBody:messageBody isHTML:YES];
    [mc setMessageBody:[NSString stringWithFormat:@"<p><font size=\"2\" face=\"Helvetica\"><a href=%@></br>%@</br></a></br></font></p>",link,sharingLink] isHTML:YES];
    [mc setToRecipients:toRecipents];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
    
    
    
    
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            DLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            DLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            DLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            DLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];

    
}




@end
