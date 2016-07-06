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
    
UIPageControl *pageControl;
    
    CGSize screenSize;

    UILabel *lblDescription;
    UILabel *lblTime;
    UILabel *lblWriter;
    UIScrollView *scrollView;
    NSString *htmlString;
    iCarousel *icarousel;
    NSMutableArray *all_Image_urls;
    NSAttributedString *decodedString;

    NSDictionary *mediaDetailDict;
    
}

@end

@implementation ShowGalleryView
@synthesize transferedArray,gatheredDict;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    screenSize =[[UIScreen mainScreen]bounds].size;
    
    // ScrollView Initialization
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,60, screenSize.width,screenSize.height)];
    [self.view addSubview:scrollView];
    
    icarousel = [[iCarousel alloc]initWithFrame:CGRectMake(0, 80, screenSize.width, screenSize.height*.34)];
    [scrollView addSubview:icarousel];
        
    // Description Labe initialization
    lblDescription = [[UILabel alloc] init];
    [scrollView addSubview:lblDescription];
    [lblDescription setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
    lblDescription.numberOfLines = 0;
    lblDescription.textColor = [UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1];
    
    // Time Label
    lblTime = [[UILabel alloc] init];
    [scrollView addSubview:lblTime];
    [lblTime setFont:[UIFont fontWithName:@"ProximaNovaACond-Light" size:12.0]];
    lblTime.numberOfLines = 0;
    lblTime.textColor = [UIColor colorWithRed:162.0/255.0 green:162.0/255.0 blue:162.0/255.0 alpha:1];
    
    // Writer Label
    
    lblWriter = [[UILabel alloc]init];
    [scrollView addSubview:lblWriter];
    [lblWriter setFont:[UIFont fontWithName:@"ProximaNovaACond-Light" size:12.0]];
    lblWriter.numberOfLines = 0;
    lblWriter.textAlignment = NSTextAlignmentRight;
    lblWriter.textColor = [UIColor colorWithRed:162.0/255.0 green:162.0/255.0 blue:162.0/255.0 alpha:1];
    
    all_Image_urls = [[NSMutableArray alloc] init];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self loadImages];
    
    if ([[transferedArray valueForKey:@"Mediaitems"] count]==0) {
        // [[transferedArray objectAtIndex:0] valueForKey:@"Mediaitems"]

        
    } else{
        
        _pageNumberLabel.text = [NSString stringWithFormat:@"%d of %ld",1,[all_Image_urls count]];
    }
    
    
//    [self.view setUserInteractionEnabled:NO];
//      spinner=[SpinnerView loadSpinnerIntoView:self.view];
    
    
    
    icarousel.delegate=self;
    icarousel.dataSource =self;
    icarousel.pagingEnabled=YES;
    icarousel.type=iCarouselTypeLinear;
    icarousel.pagingEnabled = YES;
    
  //  [self.view addSubview:photo];
    

    
    
}



-(void) loadImages {
    
    getImage_Array = [NSMutableArray new];
    for (int i=0; i<[[[transferedArray objectAtIndex:0] valueForKey:@"Mediaitems"] count]; i++) {
    
    all_Image_urls = [[[transferedArray objectAtIndex:0] valueForKey:@"Mediaitems"]valueForKey:@"url"];
    }
    NSLog(@"all urls--%@",all_Image_urls);
    
  //  kNumberOfPages = all_Image_urls.count;
    
    
      //scrollView.backgroundColor=[UIColor redColor];
    // a page is the width of the scroll view
    //scrollView.showsHorizontalScrollIndicator = NO;
//    
//    pageControl.numberOfPages = kNumberOfPages;
//    pageControl.currentPage = 0;
//    
//    
//    //
//    
//    dispatch_async(dispatch_get_main_queue(), ^{
//    
//        for (int i = 0; i< kNumberOfPages; i++) {
//            
//            
//         // NSString *ImageURL = [all_Image_urls valueForKey:[NSString stringWithFormat:@"url%d",i+1]]; //self.getimageURl;
//           
//            NSString *ImageURL = [all_Image_urls objectAtIndex:i];
//            NSLog(@"image url -- %@",ImageURL);
//            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:ImageURL]];
//            //self.newsImage_ImgView.image = [UIImage imageWithData:imageData];
//            //converted_Image =imageData;
//            UIImage *tempImage = [UIImage imageWithData:imageData];
//            
//            [getImage_Array addObject:tempImage];
//        }
//        [self loadScrollViewWithPage:0];
//        [self loadScrollViewWithPage:1];
//   
//    });
    
    
    
    
}

#pragma mark - Carousel Delegates

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
    
    if (all_Image_urls.count==0) {
        return 1;
    }else{
        return all_Image_urls.count;
    }
    
    
}


- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(nullable UIView *)view{
    
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, (screenSize.height*34)/100)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, (screenSize.height*34)/100)];
    
    if ([[[transferedArray objectAtIndex:0] valueForKey:@"Mediaitems"] count]==0) {
        imageView.image=[UIImage imageNamed:@"PlaceHolder@2x.png"];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [imageView setClipsToBounds:YES];

        [tempView addSubview:imageView];
    }
    else{
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:[all_Image_urls objectAtIndex:index]]];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [imageView setClipsToBounds:YES];

        [tempView addSubview:imageView];
        
        NSLog(@"%ld",(long)index+1);
        
        htmlString =[[[transferedArray objectAtIndex:0]valueForKey:@"Mediaitems"][0]valueForKey:@"description"];
        
        decodedString = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute:@(NSUTF8StringEncoding)} documentAttributes:nil error:nil];
        
        lblDescription.text = [decodedString string];
        
        CGFloat expectedLabelSize = [self heightForText:[decodedString string] font:lblDescription.font withinWidth:screenSize.width -16];
        lblDescription.frame = CGRectMake(20,icarousel.frame.origin.y + icarousel.frame.size.height + 45,screenSize.width -40, expectedLabelSize);
      //  [lblDescription sizeToFit];
        lblWriter.text= [NSString stringWithFormat:@"%@",[[transferedArray objectAtIndex:0]valueForKey:@"author"]].uppercaseString;
        lblTime.text= [NSString stringWithFormat:@"%@",[[transferedArray objectAtIndex:0]valueForKey:@"pubDate"]].uppercaseString;
        lblWriter.frame = CGRectMake(screenSize.width-120, lblDescription.frame.size.height +  lblDescription.frame.origin.y + 5, 100, 60);
        lblTime.frame = CGRectMake(20, lblDescription.frame.size.height +  lblDescription.frame.origin.y + 5, 159, 60);

        scrollView.contentSize = CGSizeMake(screenSize.width, lblWriter.frame.size.height+ lblWriter.frame.origin.y + 60);
    }
    
    
    return tempView;
}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)objcarousel{
    int index = (int)objcarousel.currentItemIndex;
    _pageNumberLabel.text = [NSString stringWithFormat:@"%ld of %ld",(long)index+1,[all_Image_urls count]];
    NSLog(@"%d",index);
    
    htmlString =[[[transferedArray objectAtIndex:0]valueForKey:@"Mediaitems"][index]valueForKey:@"description"];
    
    decodedString = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute:@(NSUTF8StringEncoding)} documentAttributes:nil error:nil];
    lblDescription.text = [decodedString string];
   lblWriter.text= [NSString stringWithFormat:@"%@",[[transferedArray objectAtIndex:0]valueForKey:@"author"]].uppercaseString;
    
}


- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value{
    if(option == iCarouselOptionSpacing){
        return value*1.1;
    }
    return value;
}


//- (void)loadScrollViewWithPage:(int)page {
//    if (page < 0) return;
//    if (page >= kNumberOfPages) return;
//    
//    
//    
//    
//    UIImageView *imageView =[[UIImageView alloc] init];
//    //imageView.backgroundColor = [UIColor yellowColor];
//    // add the image view to the scroll view
//    CGRect frame = scrollView.frame;
//    frame.origin.x = frame.size.width * page;
//    frame.origin.y = 0;
//    imageView.frame = frame;
//    [scrollView addSubview:imageView];
//    imageView.contentMode  = UIViewContentModeScaleAspectFit;
//
//    imageView.image = getImage_Array[page];
//    
//        [self.view setUserInteractionEnabled:YES];
//        [spinner removeSpinner];
//    
//    //sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[testArray objectAtIndex:0]
//    
//}

//- (void)scrollViewDidScroll:(UIScrollView *)sender {
//    
//    // We don't want a "feedback loop" between the UIPageControl and the scroll delegate in
//    // which a scroll event generated from the user hitting the page control triggers updates from
//    // the delegate method. We use a boolean to disable the delegate logic when the page control is used.
//    
//    // Switch the indicator when more than 50% of the previous/next page is visible
//    CGFloat pageWidth = scrollView.frame.size.width;
//    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
//    pageControl.currentPage = page;
//    
//    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
//    
//    [self loadScrollViewWithPage:page - 1];
//    [self loadScrollViewWithPage:page];
//    [self loadScrollViewWithPage:page + 1];
//    
//    // A possible optimization would be to unload the views+controllers which are no longer visible
//}
//// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
//
//
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    
//    //pageControlUsed = NO;
//    
//    
//    
//    
//}


//#pragma mark --IBAction
//- (IBAction)backButtonTapped:(id)sender {
//
//
//    [self.navigationController popViewControllerAnimated:YES];
//    
//    
//}

# pragma mark - private methods
// Dynamic Height according to Text
-(CGFloat)heightForText:(NSString*)text font:(UIFont*)font withinWidth:(CGFloat)width {
    CGSize size = [text sizeWithAttributes:@{NSFontAttributeName:font}];
    CGFloat area = size.height * size.width;
    CGFloat height = roundf(area / width);
    return ceilf(height / font.lineHeight) * font.lineHeight;
}

- (IBAction)closeBtn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (IBAction)shareBtn:(id)sender {
    
    NSArray * activityItems = @[[NSString stringWithFormat:@"%@",[transferedArray valueForKey:@"Link"]]];
    NSArray * applicationActivities = nil;
    NSArray * excludeActivities = @[UIActivityTypeAssignToContact, UIActivityTypeCopyToPasteboard, UIActivityTypePostToWeibo, UIActivityTypePrint, UIActivityTypeMessage];
    
    UIActivityViewController * activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:applicationActivities];
    activityController.excludedActivityTypes = excludeActivities;
    
    [self presentViewController:activityController animated:YES completion:nil];
}
@end
