//
//  UploadPhoto.h
//  pioneer
//
//  Created by Valeteck on 29/07/14.
//  Copyright (c) 2014 CYNOTECK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "PICircularProgressView.h"
#import "IQDropDownTextField.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface UploadPhoto : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UITextViewDelegate,NSURLSessionTaskDelegate,UIAlertViewDelegate,UITabBarControllerDelegate,UITabBarDelegate>{
    
    CGFloat animatedDistance;
    BOOL isCameraClicked;
    
    BOOL isPickerTapped;
    UIAlertView *without_Address,*goBackAlert;
    UIAlertView *with_Address;
    CAGradientLayer *layer;
    UIAlertView *try_AgainInternet_Check;
    BOOL shouldHideStatusBar;

   //IBOutlet IQDropDownTextField *lbl_output_category;

    NSTimer *timerCheck ;
    
}

@property BOOL navigateValue;
@property(nonatomic,strong)NSString * transferFileURl;
@property (weak, nonatomic) IBOutlet UIImageView *capturedImage;
@property(nonatomic,strong)NSString * transferPhotoUniqueName;
@property(nonatomic,strong)NSMutableDictionary *photoDataDictionary;
@property(nonatomic,strong)IBOutlet IQDropDownTextField *lbl_output_category ;
@property(nonatomic,assign)int isItFirstService;
@property(nonatomic,strong)NSString * responseDataForRestOfTheDetailService;

@property(strong)NSString *alert_Message;
@property(nonatomic,strong)UIImage *mainImage;
@property(nonatomic,strong)NSData * transferedImageData;
@property(nonatomic,strong)NSData *transferImageData;

@property (strong, nonatomic) IBOutlet UISegmentedControl *segment_Outlet;
- (IBAction)segmentController_Handler:(id)sender;

- (IBAction)reset_Tapped:(id)sender;
- (IBAction)upload_Tapped:(id)sender;

//- (IBAction)btn_Selected_new_Category_Tapped:(id)sender;
- (IBAction)cut_Selected_FileTapped:(id)sender;



@property(nonatomic,strong)NSString *written_Address;
@property(nonatomic,strong)NSString *with_Address_Optional_Written;

////////////////for moving up and down.....

@property (strong, nonatomic) IBOutlet UITextField *txt_Title;
@property (strong, nonatomic) IBOutlet UITextView *txt_View;
@property (strong, nonatomic) IBOutlet UIButton *cut_Sec;
@property (strong, nonatomic) IBOutlet UILabel *lbl_selected_File_Outlet;
@property (strong, nonatomic) IBOutlet UIImageView *img_View_Selected_File_Outlet;
@property (strong, nonatomic) IBOutlet UILabel *lbl_finalPicker_Selected;
@property (strong, nonatomic) IBOutlet UILabel *lbl_Select_new_Category;
@property (strong, nonatomic) IBOutlet UIButton *btn_Selected_new_Category_Outlet;
//@property (weak, nonatomic) IBOutlet UILabel *lbl_output_category;
@property (strong, nonatomic) IBOutlet UILabel *lbl_Title;
@property (strong, nonatomic) IBOutlet UILabel *lbl_AddStory_Outlet;
@property (strong, nonatomic) IBOutlet UIButton *btn_Upload_Outlet;
@property (strong, nonatomic) IBOutlet UIButton *btn_Reset_Outlet;
@property (strong, nonatomic) IBOutlet UIImageView *image_AddStory_Outlet;
@property (strong, nonatomic) IBOutlet UIImageView *image_Title_Outlet;
@property (strong, nonatomic) IBOutlet UIImageView *image_Select_NewCategory;
- (IBAction)btnTakeAPhotoTapped:(id)sender;
- (IBAction)btnBrowserGalleryTapped:(id)sender;


//////////////////// for moving up and down.....


- (IBAction)setting_Tapped:(id)sender;

@property (strong, nonatomic) IBOutlet UIProgressView *progressView;

@property (strong, nonatomic) IBOutlet PICircularProgressView *circular_Progress_View;

////////////////////////////////////////
@property (strong, nonatomic) IBOutlet UIImageView *img_ForSuccess_Unsuccess;
@property (strong, nonatomic) IBOutlet UIView *view_ForSuccess_Unsuccess;

@property (strong, nonatomic) IBOutlet UIButton *ok_For_Success_Outlet;

@property (weak, nonatomic) IBOutlet UIView *view_forunsuccess;

@property(nonatomic,assign)BOOL handleView ;
@property(nonatomic,assign)BOOL cutboolValue ;


// TAB BAR OUTLETS
@property (weak, nonatomic) IBOutlet UITabBar *tabBarController;
@property (weak, nonatomic) IBOutlet UITabBarItem *photoTabBar;
@property (weak, nonatomic) IBOutlet UITabBarItem *videoTabBar;
@property (weak, nonatomic) IBOutlet UITabBarItem *audioTabBar;
@property (weak, nonatomic) IBOutlet UITabBarItem *textTabBar;
@property (weak, nonatomic) IBOutlet UIButton *takeAPhotoTapped;
@property (weak, nonatomic) IBOutlet UIButton *browseGalleryTapped;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView_Photo;


@property (weak, nonatomic) IBOutlet UILabel *showTemperature;
@property (weak, nonatomic) IBOutlet UIView *selectedView;

@property (weak, nonatomic) IBOutlet UIButton *submitForReview_Outlet;
@property (strong,nonatomic)NSMutableArray * tempArray;


- (IBAction)submitForReview:(id)sender;


@end
