//
//  ShowGalleryView.m
//  Pioneer
//
//  Created by Deepankar Parashar on 16/03/16.
//  Copyright © 2016 CYNOTECK. All rights reserved.
//

#import "ShowGalleryView.h"
#import <UIImageView+WebCache.h>


@interface ShowGalleryView () {
    
     UIScrollView *scrollView;
UIPageControl *pageControl;
    

}

@end

@implementation ShowGalleryView
@synthesize transferedArray,gatheredDict;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated {
    
    NSLog(@"trnasfer array --%@",transferedArray);
    NSLog(@"images url --%@",gatheredDict);
    
    UIImageView * photo = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 64.0, 300.0, 400.0)];
    photo.contentMode  = UIViewContentModeScaleAspectFit;
  //  [photo sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[transferedArray objectAtIndex:0] valueForKey:@"media:content"]]]];
  // [photo sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[gatheredDict valueForKey:@"url2"]]]];
    
    
    [self.view setUserInteractionEnabled:NO];
      spinner=[SpinnerView loadSpinnerIntoView:self.view];
    
    
    [self loadImages];
    
  //  [self.view addSubview:photo];
    

    
    
}



-(void) loadImages {
    
    
    
    getImage_Array = [NSMutableArray new];
    
    // NSLog(@"description after navigating --%@",self.getDescriptionString);
    
    NSMutableArray *all_Image_urls = [[[transferedArray objectAtIndex:0] valueForKey:@"Mediaitems"]valueForKey:@"url"];
    NSLog(@"all urls--%@",all_Image_urls);
    
   // NSArray *allKeys =[gatheredDict allKeys];
    kNumberOfPages = all_Image_urls.count;
    
    
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 66,320,400)];//(0,0,320,460)
    [self.view addSubview:scrollView];
      //scrollView.backgroundColor=[UIColor redColor];
    // a page is the width of the scroll view
    scrollView.pagingEnabled = YES;
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * kNumberOfPages, scrollView.frame.size.height);
    //scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.scrollsToTop = NO;
    scrollView.delegate = self;
    
    pageControl.numberOfPages = kNumberOfPages;
    pageControl.currentPage = 0;
    
    
    //
    
    dispatch_async(dispatch_get_main_queue(), ^{
    
        for (int i = 0; i< kNumberOfPages; i++) {
            
            
         // NSString *ImageURL = [all_Image_urls valueForKey:[NSString stringWithFormat:@"url%d",i+1]]; //self.getimageURl;
           
            NSString *ImageURL = [all_Image_urls objectAtIndex:i];
            NSLog(@"image url -- %@",ImageURL);
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:ImageURL]];
            //self.newsImage_ImgView.image = [UIImage imageWithData:imageData];
            //converted_Image =imageData;
            UIImage *tempImage = [UIImage imageWithData:imageData];
            
            [getImage_Array addObject:tempImage];
        }
        [self loadScrollViewWithPage:0];
        [self loadScrollViewWithPage:1];
   
    });
                   
    
    
    
}


- (void)loadScrollViewWithPage:(int)page {
    if (page < 0) return;
    if (page >= kNumberOfPages) return;
    
    
    
    
    UIImageView *imageView =[[UIImageView alloc] init];
    //imageView.backgroundColor = [UIColor yellowColor];
    // add the image view to the scroll view
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    imageView.frame = frame;
    [scrollView addSubview:imageView];
    imageView.contentMode  = UIViewContentModeScaleAspectFit;

    imageView.image = getImage_Array[page];
    
        [self.view setUserInteractionEnabled:YES];
        [spinner removeSpinner];
    
    //sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[testArray objectAtIndex:0]
    
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    
    // We don't want a "feedback loop" between the UIPageControl and the scroll delegate in
    // which a scroll event generated from the user hitting the page control triggers updates from
    // the delegate method. We use a boolean to disable the delegate logic when the page control is used.
    
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
    
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
    // A possible optimization would be to unload the views+controllers which are no longer visible
}
// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    //pageControlUsed = NO;
    
    
    
    
}


#pragma mark --IBAction
- (IBAction)backButtonTapped:(id)sender {
    
//    NSArray * viewsList =[self.navigationController viewControllers];
//    
//    NSLog(@"views list --%@",viewsList);
//    [self.navigationController popToViewController:[viewsList objectAtIndex:1] animated:YES];

    [self.navigationController popViewControllerAnimated:YES];
    
    
}


@end
