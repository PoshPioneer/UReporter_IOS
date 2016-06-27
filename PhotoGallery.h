//
//  PhotoGallery.h
//  Pioneer
//
//  Created by Deepankar Parashar on 05/04/16.
//  Copyright © 2016 CYNOTECK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpinnerView.h"

@interface PhotoGallery : UIViewController <UIScrollViewDelegate>{
    
    NSUInteger kNumberOfPages;
    NSMutableArray  *getImage_Array;
    SpinnerView *spinner;
    
}
- (IBAction)back_Tapped:(id)sender;

@property(strong,nonatomic)NSArray * transferedArray;

@property(strong,nonatomic)NSDictionary * gatheredDict;




@end
