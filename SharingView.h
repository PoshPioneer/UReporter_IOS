//
//  SharingView.h
//  Pioneer
//
//  Created by Deepankar Parashar on 18/03/16.
//  Copyright © 2016 CYNOTECK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>



@interface SharingView : UIViewController  <MFMailComposeViewControllerDelegate>

@property(strong,nonatomic)NSString * sharingLink;

@end
