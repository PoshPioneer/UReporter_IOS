//
//  DetailsViewController.h
//  Pioneer
//
//  Created by Deepankar Parashar on 16/02/16.
//  Copyright © 2016 CYNOTECK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpinnerView.h"


@interface DetailsViewController : UIViewController <UIScrollViewDelegate,UIPageViewControllerDataSource,UIPageViewControllerDelegate,UITabBarControllerDelegate,UITabBarDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate> {
    
    SpinnerView *spinner;
    NSUInteger kNumberOfPages;
    NSMutableArray  *getImage_Array;
    
}

- (IBAction)back_tapped:(id)sender;


- (void)pageChanged ;

@property(strong,nonatomic) NSString * shareLink;
@property (strong, nonatomic) UIPageViewController *pageController;

@property  int LocalIndex;

@property(strong,nonatomic) NSDictionary * getImageURls_Dict;
@property(strong,nonatomic)NSArray * getImageURls_Array;



@property(weak,nonatomic) NSString *getDescriptionString;
@property(weak,nonatomic) NSString * getNewsTitle;



@property (weak, nonatomic) IBOutlet UIWebView *description_webview;
@property(weak,nonatomic) NSString *getimageURl;
@property (weak, nonatomic) IBOutlet UILabel *showTemperature;

@property(strong,nonatomic)NSMutableArray *allDataArray;
@property(weak,nonatomic)NSArray *dataArray;
@property(weak,nonatomic)UICollectionView *collectionView;


//.....

@property (weak, nonatomic) IBOutlet UITabBar *tabBarController;
@property(nonatomic,strong)UIImage *mainImage;


@end
