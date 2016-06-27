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
    
    UIScrollView *scrollView;
    UIPageControl *pageControl;
    
}

@end

@implementation PhotoGallery
@synthesize transferedArray,gatheredDict;



- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    DataClass *obj = [DataClass getInstance];
    
    if (obj.globalCounter == 0 )
    {
        if ([[NSUserDefaults standardUserDefaults] valueForKey:@"subscribeStatus"] == nil) {
            
            
            
            UIAlertController *  alert  = [UIAlertController alertControllerWithTitle:@"" message:@"You've read all the free articles for this month." preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Subscribe" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                
                //do something when click button
                
                SubscribeVC *subscribeObj = [[SubscribeVC alloc] initWithNibName:@"SubscribeVC" bundle:nil];
                [self.navigationController pushViewController:subscribeObj animated:YES];
                
                
            }];
            [alert addAction:okAction];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                
                [self.navigationController popViewControllerAnimated:YES];
                
                //do something when click button
            }];
            [alert addAction:cancelAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
    

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    
   // NSLog(@"trnasfer array --%@",transferedArray);
   // NSLog(@"images url --%@",gatheredDict);
//    
//    UIImageView * photo = [[UIImageView alloc] initWithFrame:CGRectMake(10.0, 65.0, 300.0, 400.0)];
//    photo.contentMode  = UIViewContentModeScaleAspectFit;
//    //  [photo sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[transferedArray objectAtIndex:0] valueForKey:@"media:content"]]]];
    // [photo sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[gatheredDict valueForKey:@"url2"]]]];
    
   // NSArray * tempArray = [transferedArray valueForKey:@"Mediaitems"];
  //  NSLog(@"temp array--%lu",(unsigned long)[tempArray count]);
 
    
    [self loadImages];
    
}
-(void) loadImages {
    
    
    [self.view setUserInteractionEnabled:NO];
    spinner=[SpinnerView loadSpinnerIntoView:self.view];
    getImage_Array = [NSMutableArray new];
    
    // NSLog(@"description after navigating --%@",self.getDescriptionString);
    
    NSMutableArray *all_Image_urls = [[transferedArray valueForKey:@"Mediaitems"]valueForKey:@"url"];
    NSLog(@"all urls--%@",all_Image_urls);
    
    if (all_Image_urls.count==0) {
        
        kNumberOfPages = 1;
        
    }else{
        
        kNumberOfPages = all_Image_urls.count;

        
    }
    
    // NSArray *allKeys =[gatheredDict allKeys];
    
    
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64,320,400)];//(0,0,320,460)
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
        
        
        if ([Utility connected] == YES) {
            
            for (int i = 0; i< kNumberOfPages; i++) {
                
                
                // NSString *ImageURL = [all_Image_urls valueForKey:[NSString stringWithFormat:@"url%d",i+1]]; //self.getimageURl;
                
                
                if (all_Image_urls.count==0) {
                    
                    UIImage *tempImage = [UIImage imageNamed:@"PlaceHolder@2x.png"];
                    
                    [getImage_Array addObject:tempImage];

                    
                }else{
                    
                    NSString *ImageURL = [all_Image_urls objectAtIndex:i];
                    NSLog(@"image url -- %@",ImageURL);

                    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:ImageURL]];
                    //self.newsImage_ImgView.image = [UIImage imageWithData:imageData];
                    //converted_Image =imageData;
                    UIImage *tempImage = [UIImage imageWithData:imageData];
                    
                    [getImage_Array addObject:tempImage];

                    
                }
                
            }

            
        }else{
            
            
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Internet connection is not available. Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            [alert show];
            

        }
        [self loadScrollViewWithPage:0];
        [self loadScrollViewWithPage:1];
        
    });
    
    
    
    
}

- (void)loadScrollViewWithPage:(int)page {
    if (page < 0) return;
    if (page >= kNumberOfPages) return;
    
    
    if ([Utility connected] == YES) {
        
        
        
        UIImageView *imageView =[[UIImageView alloc] init];
        //imageView.backgroundColor = [UIColor yellowColor];
        // add the image view to the scroll view
        CGRect frame = scrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        imageView.frame = frame;
        
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        [scrollView addSubview:imageView];
        
        imageView.image = getImage_Array[page];
        
        
    }else{
        
        /* UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Message!" message:@"Internet connection is not available. Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
         [alert show];
         */
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert!" message:@"Internet connection is not available. Please try again." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * doNothingAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * alert ){
            
            
        }];
        [alert addAction:doNothingAction];
        [self presentViewController:alert  animated:YES completion:nil];
    }

    
    
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
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    //pageControlUsed = NO;
    
    
    
    
}

- (IBAction)back_Tapped:(id)sender {
    
    NSArray *array = [self.navigationController viewControllers];
    
    NSLog(@"Photo gallery from array is :  %@",array);
    
    [self.navigationController popToViewController:[array objectAtIndex:1] animated:NO];
    
}


@end
