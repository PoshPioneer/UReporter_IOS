//
//  PhotoGallery.h
//  Pioneer
//
//  Created by Deepankar Parashar on 05/04/16.
//  Copyright © 2016 CYNOTECK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpinnerView.h"
#import "iCarousel.h"

@interface PhotoGallery : UIViewController <iCarouselDataSource,iCarouselDelegate>{
    
    NSUInteger kNumberOfPages;
    NSMutableArray  *getImage_Array;
    SpinnerView *spinner;
    
}
//- (IBAction)back_Tapped:(id)sender;

@property(strong,nonatomic)NSDictionary * mediaDetailDict;
@property(strong,nonatomic)NSDictionary * gatheredDict;
@property (strong, nonatomic) IBOutlet UILabel *pageNumberLabel;
@property (nonatomic, retain) NSMutableString* resultString;


- (IBAction)shareBtn:(UIButton *)sender;
- (IBAction)closeBtn:(UIButton *)sender;


@end
