//
//  ChildView.h
//  Pioneer
//
//  Created by Deepankar Parashar on 16/03/16.
//  Copyright © 2016 CYNOTECK. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ASStarRatingView;

@interface ChildView : UIViewController
{
    ASStarRatingView * ratingView;
}
@property (assign, nonatomic) NSInteger index;

@property(strong,nonatomic)NSArray * testArray ;


@property NSUInteger * pageIndex;



@property(strong,nonatomic)NSString * collectedDescription;
@property(strong,nonatomic)NSString * collectedTitle;

- (IBAction)backTapped:(id)sender;

@property(strong,nonatomic) NSDictionary * completeURLs;
@property(strong,nonatomic)NSArray* completeURls_Array;


@end
