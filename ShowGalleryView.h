//
//  ShowGalleryView.h
//  Pioneer
//
//  Created by Deepankar Parashar on 16/03/16.
//  Copyright © 2016 CYNOTECK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpinnerView.h"

@interface ShowGalleryView : UIViewController <UIScrollViewDelegate>{
    
    NSUInteger kNumberOfPages;
    NSMutableArray  *getImage_Array;
    SpinnerView *spinner;
}


@property(strong,nonatomic)NSArray * transferedArray;

@property(strong,nonatomic)NSDictionary * gatheredDict;

@end
