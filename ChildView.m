//
//  ChildView.m
//  Pioneer
//
//  Created by Deepankar Parashar on 16/03/16.
//  Copyright © 2016 CYNOTECK. All rights reserved.
//

#import "ChildView.h"
#import "DataClass.h"
#import <UIImageView+WebCache.h>
#import "ShowGalleryView.h"
#import "SharingView.h"
#import "ASStarRatingView.h"
#import "DBController.h"

@interface ChildView () <UITextViewDelegate,SyncDelegate>{

    
    DataClass *objectDataClass;
    NSArray * tempArray;
    UIButton * openGallery;
    UIButton * sharing;
    NSString * sharedLink;
    UILabel * counterOFPages; // for showing the indication of pages.
    NSMutableData *responseData; //for getting response.
    NSString * guid;// for getting the guid of each .
    NSString* allMediaString ;
    NSAttributedString *attributedString;
    
    //
    
    UIScrollView *srlView;
    UILabel *lblDescription;
    UIImageView *imgMedia;
    UIButton * likeButton ;// Like button
    UIButton *disLikeButton; // Dislike button.
    CGSize screenSize;

    UILabel *lblAuthorName;
    UILabel *lblTitle;

    UIImageView *imgGradient;
    SyncManager *sync;
    
    UILabel *lblTime;
    UILabel *lblCategory;
    LikeDetail *obj;
    NSMutableArray * allMediaItemsArray;
}

@end

@implementation ChildView

@synthesize pageIndex,completeURLs,completeURls_Array;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        // Custom initialization
    }
    
    return self;
    
}

    



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
   obj = [LikeDetail new];

    screenSize =[[UIScreen mainScreen] bounds].size;
    // Do any additional setup after loading the view from its nib.
    
    
    sync = [[SyncManager alloc] init];
    sync.delegate = self;
    
    // initialize scroll view
    
    srlView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0, screenSize.width,screenSize.height-50)];
    [self.view addSubview:srlView];
   
    // initialize description label

    lblDescription = [[UILabel alloc] init];
    [srlView addSubview:lblDescription];
    [lblDescription setFont:[UIFont fontWithName:@"PTSerif-Regular" size:14.0]];
    //[lblDescription setFont:[UIFont fontWithName:@"Roboto-Bold" size:14.0]];
    lblDescription.numberOfLines = 0;
    lblDescription.textColor = [UIColor colorWithRed:69.0/255.0 green:69.0/255.0 blue:69.0/255.0 alpha:1];
    lblDescription.textAlignment=NSTextAlignmentLeft;
    lblDescription.lineBreakMode = NSLineBreakByWordWrapping;
    // initialize like button

    likeButton = [[UIButton alloc]init];
    [srlView addSubview:likeButton];
    [likeButton setExclusiveTouch:YES];
  
    // initialize dislike button

    disLikeButton = [[UIButton alloc]init];
    [srlView addSubview:disLikeButton];
    [disLikeButton setExclusiveTouch:YES];

    
    // initialize image media

    imgMedia = [[UIImageView alloc] init];
    
    
    imgGradient = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Gradient-02@2x.png"]];
    imgGradient.contentMode = UIViewContentModeScaleToFill;
    // initialize author label
    
    lblAuthorName = [[UILabel alloc] init];
    [srlView addSubview:lblAuthorName];
    lblAuthorName.textColor = [UIColor blackColor];
    [lblAuthorName setBackgroundColor:[UIColor clearColor]];
    [lblAuthorName setFont:[UIFont fontWithName:@"Roboto-Regular" size:15.0]];
    lblAuthorName.lineBreakMode = NSLineBreakByWordWrapping;
    
    // initialize title label
    
    lblTitle = [[UILabel alloc] init];
    
    lblTitle.numberOfLines = 2;
    lblTitle.adjustsFontSizeToFitWidth = YES;
    lblTitle.lineBreakMode = NSLineBreakByWordWrapping;
    [lblTitle setBackgroundColor:[UIColor clearColor]];
   [lblTitle setFont:[UIFont fontWithName:@"Roboto-Regular" size:19.0]];
    lblTitle.textColor = [UIColor colorWithRed:69.0/255.0 green:69.0/255.0 blue:69.0/255.0 alpha:1];


    
    // initialize time label
    
    lblTime = [[UILabel alloc]init];
    lblTime.adjustsFontSizeToFitWidth = YES;
    lblTime.lineBreakMode = NSLineBreakByWordWrapping;
    [lblTime setBackgroundColor:[UIColor clearColor]];
    [lblTime setFont:[UIFont fontWithName:@"ProximaNovaACond-Light" size:12.0]];
    lblTime.textColor = [UIColor colorWithRed:183.0/255.0 green:183.0/255.0 blue:183.0/255.0 alpha:1];

    
    
    // initialize time label
    
    lblCategory = [[UILabel alloc]init];
    lblCategory.adjustsFontSizeToFitWidth = YES;
    lblCategory.lineBreakMode = NSLineBreakByWordWrapping;
    [lblCategory setBackgroundColor:[UIColor clearColor]];
    [lblCategory setFont:[UIFont fontWithName:@"ProximaNovaACond-Light" size:12.0]];
    lblCategory.textColor = [UIColor colorWithRed:183.0/255.0 green:183.0/255.0 blue:183.0/255.0 alpha:1];
    lblCategory.textAlignment = NSTextAlignmentRight;

    
    objectDataClass = [DataClass getInstance];
    DLog(@"all data from array--%@",self.testArray);
    DLog(@"%lu",self.testArray.count);
  
    
    openGallery = [[UIButton alloc] init];
    counterOFPages = [[UILabel alloc] init];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)manageDB
{
//    DLog(@"global index in child view--%ld",(long)pageIndex);
//    DLog(@"all urls in childview--%@",completeURLs);
//    DLog(@"all url in array --%@",self.completeURls_Array);
    NSString *feedID = [self.testArray objectAtIndex:(long)pageIndex][@"guid"];
    NSArray * arrDB = [DBController getSingleLike_Info:feedID];
    if(arrDB.count >0)  {
        
        
        
        obj = arrDB[0];
        
        NSString *strStatus = obj.status;
        if ([strStatus isEqualToString:@"0"])
        {
            [likeButton setBackgroundImage:[UIImage imageNamed:@"ThumbsUpDisabled@2x.png"] forState:UIControlStateNormal];
            [likeButton addTarget:self action:@selector(likeButtonTapped) forControlEvents:UIControlEventTouchUpInside];
            likeButton.showsTouchWhenHighlighted =TRUE;
            
            [disLikeButton setBackgroundImage:[UIImage imageNamed:@"ThumbsDownDisabled@2x.png"] forState:UIControlStateNormal];
            [disLikeButton addTarget:self action:@selector(dislikeService) forControlEvents:UIControlEventTouchUpInside];
            disLikeButton.showsTouchWhenHighlighted =TRUE;
        }
        else if ([strStatus isEqualToString:@"1"])
        {
            [likeButton setUserInteractionEnabled:NO];
            [likeButton setBackgroundImage:[UIImage imageNamed:@"ThumbsUp_new@2x.png"] forState:UIControlStateNormal];//
            likeButton.showsTouchWhenHighlighted =TRUE;
            
            [disLikeButton setBackgroundImage:[UIImage imageNamed:@"ThumbsDownDisabled@2x.png"] forState:UIControlStateNormal];
            [disLikeButton addTarget:self action:@selector(dislikeService) forControlEvents:UIControlEventTouchUpInside];
            disLikeButton.showsTouchWhenHighlighted =TRUE;
            [disLikeButton setUserInteractionEnabled:YES];

        }
        else if ([strStatus isEqualToString:@"2"])
        {
            
            [likeButton setBackgroundImage:[UIImage imageNamed:@"ThumbsUpDisabled@2x.png"] forState:UIControlStateNormal];
            [likeButton addTarget:self action:@selector(likeButtonTapped) forControlEvents:UIControlEventTouchUpInside];
            likeButton.showsTouchWhenHighlighted =TRUE;
            [likeButton setUserInteractionEnabled:YES];

            [disLikeButton setBackgroundImage:[UIImage imageNamed:@"ThumbsDown_new@2x.png"] forState:UIControlStateNormal];//
            disLikeButton.showsTouchWhenHighlighted =TRUE;
            [disLikeButton setUserInteractionEnabled:NO];

        }
    }
    else
    {
        [likeButton setBackgroundImage:[UIImage imageNamed:@"ThumbsUpDisabled@2x.png"] forState:UIControlStateNormal];
        [likeButton addTarget:self action:@selector(likeButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        likeButton.showsTouchWhenHighlighted =TRUE;
        
        [disLikeButton setBackgroundImage:[UIImage imageNamed:@"ThumbsDownDisabled@2x.png"] forState:UIControlStateNormal];
        [disLikeButton addTarget:self action:@selector(dislikeService) forControlEvents:UIControlEventTouchUpInside];
        disLikeButton.showsTouchWhenHighlighted =TRUE;
    }

}

-(CGFloat)heightForText:(NSString*)text font:(UIFont*)font withinWidth:(CGFloat)width {
    CGSize size = [text sizeWithAttributes:@{NSFontAttributeName:font}];
    CGFloat area = size.height * size.width;
    CGFloat height = roundf(area / width);
    return ceilf(height / font.lineHeight) * font.lineHeight;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self manageDB];
  
    allMediaItemsArray =[[NSMutableArray alloc]init];
    allMediaItemsArray = [[self.testArray objectAtIndex:(long)pageIndex] valueForKey:@"Mediaitems"];
    DLog(@"all media count--%lu",(unsigned long)[allMediaItemsArray count]);
    NSString* textOnCounter = [NSString stringWithFormat:@"1/%lu",(unsigned long)allMediaItemsArray.count];
    counterOFPages.text = textOnCounter;
    
    if ([allMediaItemsArray count]>0 ){
        
        NSString* tempURl =[[allMediaItemsArray objectAtIndex:0] valueForKey:@"url"];
        allMediaString =tempURl;
    }
   
    NSString *htmlString = [[self.testArray objectAtIndex:(long)pageIndex]valueForKey:@"Description"] ;
    attributedString = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute:@(NSUTF8StringEncoding)} documentAttributes:nil error:nil];
  
    
    NSString *trimmedDescription =  [[attributedString string] stringByTrimmingCharactersInSet:
                                     [NSCharacterSet whitespaceCharacterSet]];

    DLog(@"trimmedDescription == %@",trimmedDescription);
    
    lblDescription.text = trimmedDescription;
    
    lblAuthorName.text = [[[self.testArray objectAtIndex:(long)pageIndex] valueForKey:@"author"] stringByTrimmingCharactersInSet:
                            [NSCharacterSet whitespaceCharacterSet]];

    lblTitle.text = [[[self.testArray objectAtIndex:(long)pageIndex]valueForKey:@"Title"] stringByTrimmingCharactersInSet:
                     [NSCharacterSet whitespaceCharacterSet]];
    lblTitle.frame = CGRectMake(25,25,screenSize.width-50,60);
    [srlView addSubview:lblTitle];
    
    lblTime.frame =CGRectMake(25, lblTitle.frame.origin.y + lblTitle.frame.size.height + 0, 100, 35);
    [srlView addSubview:lblTime];

    lblTime.text = [NSString stringWithFormat:@"%@",[[[self.testArray objectAtIndex:(long)pageIndex] valueForKey:@"pubDate"] uppercaseString]];
    
    lblCategory.frame =CGRectMake(screenSize.width - 100, lblTitle.frame.origin.y + lblTitle.frame.size.height + 0, 75, 35);
    [srlView addSubview:lblCategory];
    lblCategory.text = [NSString stringWithFormat:@"%@",[[[self.testArray objectAtIndex:(long)pageIndex] valueForKey:@"category"] uppercaseString]];
    [lblCategory.text uppercaseString];
    
    if ([allMediaString length] ==0)
    {
       
        
       // lblAuthorName.frame = CGRectMake(8,lblTitle.frame.origin.y + lblTitle.frame.size.height + 13,screenSize.width-16,20);

        lblDescription.numberOfLines = 0; // allows label to have as many lines as needed
        
        CGFloat expectedLabelSize = [self heightForText:trimmedDescription font:lblDescription.font withinWidth:screenSize.width -50];
                                    
        NSLog(@"height = %f",expectedLabelSize);
       // lblDescription.frame = CGRectMake(8,lblAuthorName.frame.origin.y + lblAuthorName.frame.size.height + 5,screenSize.width -16, expectedLabelSize);
         lblDescription.frame = CGRectMake(25,lblTime.frame.origin.y + lblTime.frame.size.height + 10,screenSize.width - 50, expectedLabelSize);//25
        [lblDescription sizeToFit];
        
        likeButton.frame = CGRectMake(70, lblDescription.frame.size.height +  lblDescription.frame.origin.y + 25, (screenSize.width*0.15), (screenSize.height*0.088));
        disLikeButton.frame=  CGRectMake(screenSize.width - 70 - likeButton.frame.size.width, lblDescription.frame.size.height +  lblDescription.frame.origin.y + 25, (screenSize.width*0.15), (screenSize.height*0.088));
        srlView.contentSize = CGSizeMake(screenSize.width, likeButton.frame.size.height+ likeButton.frame.origin.y + 100);
        
        
    }
    else
    {
       
        CGRect aRect = CGRectMake(0,lblTime.frame.origin.y + lblTime.frame.size.height + 10, screenSize.width,220);
        [imgMedia setFrame:aRect];
        imgMedia.contentMode = UIViewContentModeScaleAspectFill;
        [imgMedia setClipsToBounds:YES];
        [srlView addSubview:imgMedia];
        
        
        NSArray * convertingURLToImage =[[[self.testArray objectAtIndex:(long)pageIndex] valueForKey:@"Mediaitems"] objectAtIndex:0];
        NSString * tempURl = [convertingURLToImage valueForKey:@"url"];
        [imgMedia sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",tempURl]]];
       
        imgGradient.frame = CGRectMake(0, lblTime.frame.origin.y + lblTime.frame.size.height + 25, imgMedia.frame.size.width,  imgMedia.frame.size.height);
        [imgMedia addSubview:imgGradient];
        
        openGallery.frame = aRect;
        [srlView addSubview:openGallery];
        
        [openGallery addTarget:self action:@selector(openGallery) forControlEvents:UIControlEventTouchUpInside];
        
        
       // lblTitle.frame=CGRectMake(8, imgMedia.frame.size.height-55, screenSize.width-16,55);
       // [imgMedia addSubview:lblTitle];
        //lblTitle.textColor = [UIColor whiteColor];
        
        
       
       
        
        
//        lblAuthorName.frame= CGRectMake(8, imgMedia.frame.origin.y + imgMedia.frame.size.height + 10,screenSize.width-16,20);

        
        lblDescription.numberOfLines = 0; // allows label to have as many lines as needed
        DLog(@"Label's frame is: %@", NSStringFromCGRect(lblDescription.frame));
        
        
        CGFloat expectedLabelSize = [self heightForText:trimmedDescription font:lblDescription.font withinWidth:screenSize.width -50];
        
        DLog(@"height = %f",expectedLabelSize);
        lblDescription.frame = CGRectMake(25,imgMedia.frame.origin.y + imgMedia.frame.size.height +25,screenSize.width -50, expectedLabelSize);
        [lblDescription sizeToFit];
        

        
        tempArray = [[NSArray alloc] initWithObjects:[self.testArray objectAtIndex:(long)pageIndex], nil];
        
        
        DLog(@"Author name=== %@",[[self.testArray objectAtIndex:(long)pageIndex] valueForKey:@"author"]);
        
        
        likeButton.frame = CGRectMake(70, lblDescription.frame.size.height +  lblDescription.frame.origin.y + 25, (screenSize.width*0.15), (screenSize.height*0.088));
        disLikeButton.frame=  CGRectMake(screenSize.width - 70 - likeButton.frame.size.width, lblDescription.frame.size.height +  lblDescription.frame.origin.y + 25, (screenSize.width*0.15), (screenSize.height*0.088));
        srlView.contentSize = CGSizeMake(screenSize.width,  likeButton.frame.size.height+ likeButton.frame.origin.y  + 100);

        counterOFPages.frame = CGRectMake(10, 10, 50, 50);
        [imgMedia addSubview:counterOFPages];
  
    }
    
   
    
}


-(void)sharingLink {
    DLog(@"testing sharing ");
     sharedLink = [[self.testArray objectAtIndex:(long)pageIndex] valueForKey:@"link"];
    DLog(@"shared link --%@",sharedLink);
    SharingView * shareIt = [[SharingView alloc] initWithNibName:@"SharingView" bundle:nil];
    shareIt.sharingLink = sharedLink;
    [self.navigationController pushViewController:shareIt animated:YES];
}

- (CGFloat)textViewHeightForAttributedText:(NSAttributedString *)text andWidth:(CGFloat)width
{
    UITextView *textView = [[UITextView alloc] init];
    [textView setAttributedText:text];
    CGSize size = [textView sizeThatFits:CGSizeMake(width, FLT_MAX)];
    DLog(@"Height foe textview =  %f",size.height);
    return size.height;
}




//calling like button service.
-(void)likeButtonTapped
{
    
    
    guid =[[self.testArray objectAtIndex:(long)pageIndex] valueForKey:@"guid"] ;
    
    LikeDetail *likeObj = [LikeDetail new];
    likeObj.feedID = guid;
    likeObj.status = @"1";
    likeObj.subCategory = objectDataClass.globalSubCategory;
    
    
    BOOL updateFlag = [DBController updateLike_Info:likeObj];
    DLog(@"%i",updateFlag);
    
    
    DLog(@"global index in child view--%ld",(long)pageIndex);

    DLog(@"like button tapped");
    
  
    [self manageDB];
    
   
    
    NSMutableDictionary* finalDictionary = [NSMutableDictionary dictionary];
    
    
    DLog(@"data and header for otp verify is = %@",finalDictionary);
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%@/ThumbsUp?Guid=%@",kBaseURL,kAPI,kRssFeed, guid];
    NSString * encodedString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

    
    [sync putServiceCall:encodedString withParams:nil];
    

}

//calling dislike button service.

-(void)dislikeService{
    
    
    DLog(@"dislike button tapped");
    
    
    guid =[[self.testArray objectAtIndex:(long)pageIndex] valueForKey:@"guid"];
    
    LikeDetail *likeObj = [LikeDetail new];
    likeObj.feedID = guid;
    likeObj.status = @"2";
    likeObj.subCategory = objectDataClass.globalSubCategory;

    
    BOOL updateFlag = [DBController updateLike_Info:likeObj];
    DLog(@"%i",updateFlag);
    
    
    
    [self manageDB];
    
    NSMutableDictionary* finalDictionary = [NSMutableDictionary dictionary];
    
    
    DLog(@"data and header for otp verify is = %@",finalDictionary);
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%@/ThumbsDown?Guid=%@",kBaseURL, kAPI,kRssFeed,guid];
    NSString * encodedString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

    [sync putServiceCall:encodedString withParams:nil];

    
}


#pragma mark Web Service Delegate

-(void)syncSuccess:(id)responseObject
{
    
    DLog(@"%@",responseObject);
    if (responseObject) {
        
        int checkStatus = [[responseObject valueForKey:@"Status"] intValue];
        
        if (checkStatus == 1) {
            
            
            
        }
        else
        {
//            UIAlertController * errorAlert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"There seems to be some issues with dislike feature.Please try again." preferredStyle:UIAlertControllerStyleAlert];
//            UIAlertAction * errorAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * alert){
//            }];
//            
//            [errorAlert addAction:errorAction];
//            [self presentViewController:errorAlert animated:YES completion:nil];
        }
        
    }
    
    
    
}

-(void)syncFailure:(NSError*) error
{
    
    //  [self alertMessage:@"Message" message:[error localizedDescription]];;
    
}

#pragma mark --Open Gallery

-(void)openGallery {
    
    ShowGalleryView * gallery = [[ShowGalleryView alloc] initWithNibName:@"ShowGalleryView" bundle:nil];
    
    gallery.transferedArray = [tempArray copy];
    gallery.gatheredDict = completeURLs;
    
    [self presentViewController:gallery animated:YES completion:nil];
    //[self.navigationController pushViewController:gallery animated:YES];
    

}

- (IBAction)backTapped:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end
