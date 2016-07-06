//
//  UploadVideoView.h
//  pioneer
//
//  Created by CYNOTECK on 7/25/14.
//  Copyright (c) 2014 CYNOTECK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <MediaPlayer/MediaPlayer.h>
#import "PICircularProgressView.h"
#import "IQDropDownTextField.h"

@interface UploadVideoView : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UITextViewDelegate,NSURLSessionTaskDelegate,UIAlertViewDelegate,UITabBarControllerDelegate,UITabBarDelegate>{
    
    CGFloat animatedDistance;
    BOOL  isPickerTapped;
    UIAlertView *without_Address;
    UIAlertView *with_Address;
    UIAlertView *goBackAlert;
    UIAlertView *try_AgainInternet_Check;
    CAGradientLayer *layer;
    BOOL isBrowserTapped;
    
    IBOutlet IQDropDownTextField *lbl_output_category;
    
    NSTimer *timerCheck ;
    BOOL isCameraClicked;
    
       
}

@property(nonatomic,strong)NSString* fileNameforVideo;
@property(nonatomic,strong)NSURL * ReceivedURl;
@property(nonatomic,strong)NSString * receivedPath;    // for receiving path..


@property (weak, nonatomic) IBOutlet UIImageView *videoDataImage;

// added on 11 april
@property(nonatomic,strong)UIImage *mainImage;

@property (weak, nonatomic) IBOutlet UIButton *browseGalleryOutlet;

- (IBAction)browseGalleryButton:(id)sender;

@property(nonatomic,strong)NSString *with_Address_Optional_Written;


@property(nonatomic,strong)NSMutableDictionary *videoDataDictionary;
@property(nonatomic,assign)int isItFirstService;

@property(nonatomic,strong)NSString * responseDataForRestOfTheDetailService;

@property(strong)NSString *alert_Message;

- (IBAction)back_Tapped:(id)sender;

// these property is using the camera view in application
@property (strong, nonatomic) MPMoviePlayerController *videoController;
@property (strong, nonatomic) NSURL *videoURL;


- (IBAction)reset_Tapped:(id)sender;
- (IBAction)upload_Tapped:(id)sender;



@property (weak, nonatomic) IBOutlet UISegmentedControl *segment_Outlet;
- (IBAction)segmentController_Handler:(id)sender;
//- (IBAction)btn_Selected_new_Category_Tapped:(id)sender;
- (IBAction)cut_Selected_FileTapped:(id)sender;


////////////////for moving up and down.....
@property(nonatomic,strong)NSString *address_Location;

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

//////////////////// for moving up and down.....

// For the capture location or not  pop up outlet.........start 
@property (strong, nonatomic) IBOutlet UIView *CaptureOnLocation_View;

@property (weak, nonatomic) IBOutlet UITextField *location_Txt;
- (IBAction)Location_Submitt_Tapped:(id)sender;


/// these are for when locaton is disable

@property (weak, nonatomic) IBOutlet UILabel *current_Location_lbl;
- (IBAction)current_Location_Submitt_Tapped:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *current_Location_View;

/// these are the view for the error views and proerty

- (IBAction)tryagain_Tapped:(id)sender;
- (IBAction)SuccessfullySubmitted_Tapped:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *successfull_View;

@property (strong, nonatomic) IBOutlet UIView *tryagain_View;
- (IBAction)setting_Tapped:(id)sender;

@property (strong, nonatomic) IBOutlet PICircularProgressView *circular_Progress_View;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@property(nonatomic,strong)NSString *written_Address;
@property (weak, nonatomic) IBOutlet UIButton *startVideoRecording;
- (IBAction)startVideoRecordingTapped:(id)sender;

/////////////////////////
////////////////////////////////////////
@property (weak, nonatomic) IBOutlet UIImageView *img_ForSuccess_Unsuccess;
@property (strong, nonatomic) IBOutlet UIView *view_ForSuccess_Unsuccess;

@property (weak, nonatomic) IBOutlet UIButton *ok_For_Success_Outlet;

@property(nonatomic,assign)BOOL handleView ;
@property(nonatomic,assign)BOOL cutboolValue ;

// TAB BAR OUTLETS
@property (weak, nonatomic) IBOutlet UITabBar *tabBarController;
@property (weak, nonatomic) IBOutlet UITabBarItem *photoTabBar;
@property (weak, nonatomic) IBOutlet UITabBarItem *videoTabBar;
@property (weak, nonatomic) IBOutlet UITabBarItem *audioTabBar;
@property (weak, nonatomic) IBOutlet UITabBarItem *textTabBar;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView_Video;


@property (weak, nonatomic) IBOutlet UILabel *showTemperature;

@property (weak, nonatomic) IBOutlet UIView *selectedView;

@property (weak, nonatomic) IBOutlet UIButton *submitForReview;
@property (strong,nonatomic)NSMutableArray * tempArray;

- (IBAction)submitForReview:(id)sender;

@property (nonatomic,strong)UIImage *thumbImageForView;

@end
