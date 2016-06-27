//
//  UploadTextView.h
//  pioneer
//
//  Created by amit bahuguna on 7/30/14.
//  Copyright (c) 2014 CYNOTECK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <MediaPlayer/MediaPlayer.h>
#import "IQDropDownTextField.h"
#import "AppDelegate.h"
#import "PICircularProgressView.h"


@interface UploadTextView : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UITextViewDelegate,UIAlertViewDelegate,UITabBarControllerDelegate,UITabBarDelegate>
{
    CGFloat animatedDistance;
    UIAlertView *without_Address;
    UIAlertView *with_Address,*goBackAlert,*try_AgainInternet_Check;

    CAGradientLayer *layer;

    IBOutlet IQDropDownTextField *lbl_output_category;
    
    NSTimer *timerCheck ;
    AppDelegate *app;
    BOOL isPickerTapped;
     BOOL isCameraClicked;
}

- (IBAction)back_Tapped:(id)sender;

- (IBAction)reset_Tapped:(id)sender;
- (IBAction)upload_Tapped:(id)sender;
@property(nonatomic,strong)UIImage *mainImage;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment_Outlet;
- (IBAction)segmentController_Handler:(id)sender;
- (IBAction)btn_Selected_new_Category_Tapped:(id)sender;
- (IBAction)cut_Selected_FileTapped:(id)sender;


@property (strong, nonatomic) IBOutlet PICircularProgressView *circular_Progress_View;
@property(nonatomic,strong)NSString *with_Address_Optional_Written;

@property(nonatomic,strong)NSString *written_Address;
////////////////for moving up and down.....

@property (weak, nonatomic) IBOutlet UITextField *txt_Title;
@property (weak, nonatomic) IBOutlet UITextView *txt_View;
@property (weak, nonatomic) IBOutlet UIButton *cut_Sec;
@property (weak, nonatomic) IBOutlet UILabel *lbl_selected_File_Outlet;
@property (weak, nonatomic) IBOutlet UIImageView *img_View_Selected_File_Outlet;
@property (weak, nonatomic) IBOutlet UILabel *lbl_finalPicker_Selected;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Select_new_Category;
@property (weak, nonatomic) IBOutlet UIButton *btn_Selected_new_Category_Outlet;
//@property (weak, nonatomic) IBOutlet UILabel *lbl_output_category;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Title;
@property (weak, nonatomic) IBOutlet UILabel *lbl_AddStory_Outlet;
@property (weak, nonatomic) IBOutlet UIButton *btn_Upload_Outlet;
@property (weak, nonatomic) IBOutlet UIButton *btn_Reset_Outlet;
@property (weak, nonatomic) IBOutlet UIImageView *image_AddStory_Outlet;
@property (weak, nonatomic) IBOutlet UIImageView *image_Title_Outlet;
@property (weak, nonatomic) IBOutlet UIImageView *image_Select_NewCategory;

@property(nonatomic,strong)NSMutableDictionary *textDataDictionary;


- (IBAction)setting_Tappeed:(id)sender;
/////////////////////////
////////////////////////////////////////
@property (weak, nonatomic) IBOutlet UIImageView *img_ForSuccess_Unsuccess;
@property (strong, nonatomic) IBOutlet UIView *view_ForSuccess_Unsuccess;

@property (weak, nonatomic) IBOutlet UIButton *ok_For_Success_Outlet;

// TAB BAR OUTLETS
@property (weak, nonatomic) IBOutlet UITabBar *tabBarController;
@property (weak, nonatomic) IBOutlet UITabBarItem *photoTabBar;
@property (weak, nonatomic) IBOutlet UITabBarItem *videoTabBar;
@property (weak, nonatomic) IBOutlet UITabBarItem *audioTabBar;
@property (weak, nonatomic) IBOutlet UITabBarItem *textTabBar;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView_Text;

@property (weak, nonatomic) IBOutlet UILabel *showTemperature;
@property (weak, nonatomic) IBOutlet UIImageView *image_txtView;

@property (weak, nonatomic) IBOutlet UIView *selectedView;

@property(strong,nonatomic) NSMutableArray * tempArray;


- (IBAction)submitForReviewButton:(id)sender;



@end
