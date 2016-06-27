//
//  SubmitForReviewDetails.h
//  Pioneer
//
//  Created by Deepankar Parashar on 08/04/16.
//  Copyright © 2016 CYNOTECK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubmitForReviewDetails : UIViewController

#pragma mark -- Property

@property(nonatomic,strong)NSString* ReviewTitleStr;
@property(nonatomic,strong)NSString* ReviewDescrptionStr;



#pragma mark---
#pragma mark-- IBOutlets

@property (weak, nonatomic) IBOutlet UILabel *reviewTitle;


@property (weak, nonatomic) IBOutlet UITextView *reviewDescription;



#pragma mark--
#pragma mark -- IBActions



- (IBAction)backButtonTapped:(id)sender;

@end
