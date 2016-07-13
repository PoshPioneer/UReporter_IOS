//
//  UploadAudioView.h
//  pioneer
//
//  Created by amit bahuguna on 7/29/14.
//  Copyright (c) 2014 CYNOTECK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <MediaPlayer/MediaPlayer.h>
#import "PICircularProgressView.h"
#import "IQDropDownTextField.h"


@interface UploadAudioView : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UITextViewDelegate,NSURLSessionTaskDelegate,UIAlertViewDelegate,UITabBarControllerDelegate,UITabBarDelegate>
{
    CGFloat animatedDistance;
    BOOL finalCheckForServiceBool;
    
    UIAlertView *without_Address, *try_AgainInternet_Check;
    UIAlertView *with_Address;
    UIAlertView *goBackAlert;
    CAGradientLayer *layer;
    BOOL isCameraClicked;
    
    BOOL isPickerTapped;
   
    
     IBOutlet IQDropDownTextField *lbl_output_category;
    
     NSTimer *timerCheck ;
}

@property(nonatomic,strong)UIImage *mainImage;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property(nonatomic,assign)BOOL isPickerTapped;
@property(nonatomic,assign)int isItFirstService;
@property(nonatomic,strong)NSMutableDictionary *audioDataDictionary;

@property(nonatomic,strong)NSString * responseDataForRestOfTheDetailService;

// these property is using the camera view in application
@property(nonatomic,strong)NSString *with_Address_Optional_Written;

@property (strong, nonatomic) MPMoviePlayerController *videoController;
@property (strong, nonatomic) NSURL *videoURL;


/*
 // outlets ....
*/

@property (weak, nonatomic) IBOutlet UIButton *capture_Audio_Outlet;
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

/*
 // actions ....
 */

- (IBAction)reset_Tapped:(id)sender;
- (IBAction)upload_Tapped:(id)sender;
//- (IBAction)btn_Selected_new_Category_Tapped:(id)sender;
- (IBAction)cut_Selected_FileTapped:(id)sender;
- (IBAction)back_Tapped:(id)sender;
- (IBAction)capture_audio_tapped:(id)sender;
- (IBAction)setting_Tapped:(id)sender;

- (IBAction)PlayAudioButton:(id)sender;
@property (strong, nonatomic) IBOutlet PICircularProgressView *circular_Progress_View;


@property(nonatomic,strong)NSString *written_Address;

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

@property (weak, nonatomic) IBOutlet UILabel *showTemperature;
@property (weak, nonatomic) IBOutlet UIView *selectedView;
@property (strong,nonatomic)NSMutableArray * tempArray;


@property (weak, nonatomic) IBOutlet UIButton *submitForreview_outlet;

- (IBAction)submitForReview:(id)sender;

@end
