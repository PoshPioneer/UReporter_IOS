//
//  ShowGalleryView.h
//  Pioneer
//
//  Created by Deepankar Parashar on 16/03/16.
//  Copyright © 2016 CYNOTECK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpinnerView.h"
#import "iCarousel.h"


@interface ShowGalleryView : UIViewController <UIScrollViewDelegate,iCarouselDataSource,iCarouselDelegate>{
    
    NSUInteger kNumberOfPages;
    NSMutableArray  *getImage_Array;
    SpinnerView *spinner;
}

@property (weak, nonatomic) IBOutlet UILabel *pageNumberLabel;

@property(strong,nonatomic)NSArray * transferedArray;

@property(strong,nonatomic)NSDictionary * gatheredDict;
- (IBAction)closeBtn:(id)sender;
- (IBAction)shareBtn:(id)sender;

@end
