//
//  PhotoGallery.m
//  Pioneer
//
//  Created by Deepankar Parashar on 05/04/16.
//  Copyright © 2016 CYNOTECK. All rights reserved.
//

#import "PhotoGallery.h"
#import <UIImageView+WebCache.h>
#import "SubscribeVC.h"

@interface PhotoGallery (){
    
    UIPageControl *pageControl;
    NSMutableArray *all_Image_urls;
    
    NSAttributedString *decodedString;
    CGSize screenSize;
    
    
    
    UILabel *lblDescription;
    UILabel *lblTime;
    UILabel *lblWriter;
    UIScrollView *scrollView;
    iCarousel *icarousel;
    NSString *htmlString;


}

@end
@implementation PhotoGallery
@synthesize mediaDetailDict,gatheredDict;

- (void)viewDidLoad {
    [super viewDidLoad];
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
   // [self.view setBackgroundColor: [self colorWithHexString:@"FFFFFF"]]
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
    
    // Image Url Array
    all_Image_urls = [[NSMutableArray alloc] init];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];

    [self loadImages];
    
    if ([[mediaDetailDict valueForKey:@"Mediaitems"] count]==0) {
        
    } else{
         _pageNumberLabel.text = [NSString stringWithFormat:@"%d of %ld",1,[all_Image_urls count]];
    }
    
    
    // Call carousel delegates
    icarousel.delegate=self;
    icarousel.dataSource =self;
    icarousel.pagingEnabled=YES;
    icarousel.type=iCarouselTypeLinear;
    icarousel.pagingEnabled = YES;
    
}


-(void) loadImages {
        getImage_Array = [NSMutableArray new];
        for (int i=0; i<[[mediaDetailDict valueForKey:@"Mediaitems"] count]; i++) {
        [all_Image_urls addObject:[[mediaDetailDict valueForKey:@"Mediaitems"][i]valueForKey:@"url"]];
    }
    
   
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
    
    if ([[mediaDetailDict valueForKey:@"Mediaitems"] count]==0) {
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
        
        // _pageNumberLabel.text = [NSString stringWithFormat:@"%ld of %ld",(long)index+1,[all_Image_urls count]];
        
        htmlString = [[mediaDetailDict valueForKey:@"Mediaitems"][0]valueForKey:@"description"];
        NSLog(@"Media Item %@",mediaDetailDict);
        
        decodedString = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute:@(NSUTF8StringEncoding)} documentAttributes:nil error:nil];
        
        lblDescription.text = [decodedString string];
        
        CGFloat expectedLabelSize = [self heightForText:[decodedString string] font:lblDescription.font withinWidth:screenSize.width -40];
        lblDescription.frame = CGRectMake(20,icarousel.frame.origin.y + icarousel.frame.size.height + 45,screenSize.width -40, expectedLabelSize);
        [lblDescription sizeToFit];
        lblWriter.text = [NSString stringWithFormat:@"%@",[[mediaDetailDict valueForKey:@"Mediaitems"][0] valueForKey:@"credit"]].uppercaseString;
        lblTime.text=[NSString stringWithFormat:@"%@",[mediaDetailDict valueForKey:@"pubDate"]].uppercaseString;
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
    
    htmlString = [[mediaDetailDict valueForKey:@"Mediaitems"][index]valueForKey:@"description"];
    
    decodedString = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute:@(NSUTF8StringEncoding)} documentAttributes:nil error:nil];
        lblDescription.text = [decodedString string];
    lblWriter.text = [NSString stringWithFormat:@"%@",[[mediaDetailDict valueForKey:@"Mediaitems"][index] valueForKey:@"credit"]].uppercaseString;
    
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value{
    if(option == iCarouselOptionSpacing){
        return value*1.1;
    }
    return value;
}


#pragma mark - IBActions

- (IBAction)shareBtn:(UIButton *)sender {
    NSArray * activityItems = @[[NSString stringWithFormat:@"%@",[mediaDetailDict valueForKey:@"Link"]]];
    NSArray * applicationActivities = nil;
    NSArray * excludeActivities = @[UIActivityTypeAssignToContact, UIActivityTypeCopyToPasteboard, UIActivityTypePostToWeibo, UIActivityTypePrint, UIActivityTypeMessage];
    
    UIActivityViewController * activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:applicationActivities];
    activityController.excludedActivityTypes = excludeActivities;
    
    [self presentViewController:activityController animated:YES completion:nil];
    
    
}

- (IBAction)closeBtn:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

# pragma mark - private methods
// Dynamic Height according to Text
-(CGFloat)heightForText:(NSString*)text font:(UIFont*)font withinWidth:(CGFloat)width {
    CGSize size = [text sizeWithAttributes:@{NSFontAttributeName:font}];
    CGFloat area = size.height * size.width;
    CGFloat height = roundf(area / width);
    return ceilf(height / font.lineHeight) * font.lineHeight;
}





@end
