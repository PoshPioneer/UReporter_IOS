//
//  EditProfile.h
//  pioneer
//
//  Created by Valeteck on 31/07/14.
//  Copyright (c) 2014 CYNOTECK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpinnerView.h"
#import <CoreLocation/CoreLocation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "IQDropDownTextField.h"

@interface EditProfile : UIViewController<UIImagePickerControllerDelegate,UITextFieldDelegate,CLLocationManagerDelegate,UIAlertViewDelegate,UIScrollViewDelegate>{
    
    SpinnerView *spinner;
    CGFloat animatedDistance;
    BOOL  check_Uncheck_Bool;
    CLLocationManager *locationManager;
    UIAlertView *goBackAlert;
    UIAlertView * finalAlert;
    
    int checkReset;
    
    IBOutlet IQDropDownTextField *txt_Gender;
    IBOutlet IQDropDownTextField *txt_MaritalStatus;

    UIAlertView *alert_Internet ;
    NSString *old_Phone;
       
}

///////////////////// reset local var ......

@property(nonatomic,strong)NSString *reset_FirstName;
@property(nonatomic,strong)NSString *reset_LastName;
@property(nonatomic,strong)NSString *reset_Phone;
@property(nonatomic,strong)NSString *reset_Email;
@property(nonatomic,strong)NSString *reset_Age;
@property(nonatomic,strong)NSString *reset_Gender;
@property(nonatomic,strong)NSString *reset_adderss;
@property(nonatomic,strong)NSString *reset_MaritalStatus;
@property(nonatomic,strong)NSString *reset_Occupation;
@property(nonatomic,strong)NSString *reset_LanguageSpoken;
@property(nonatomic,strong)NSString *reset_Education;
@property(nonatomic,strong)NSString *reset_Special_Interests;

@property (nonatomic,strong)NSString *reset_radiopolitical;
@property(nonatomic,strong)NSString * reset_radioprosecution;


@property(nonatomic,assign)NSInteger reset_IsLocationEnable;



@property(nonatomic,assign)NSInteger reset_CompareValeForlocationEnable;


///////////////////// reset local var ......



- (IBAction)back_Tapped:(id)sender;


@property(nonatomic,assign)int checkServiceType;
@property(nonatomic,strong)NSString *messageDisplayForAlert;


///////////////Outlet for text fileds ...

@property (weak, nonatomic) IBOutlet UITextField *txt_First_Name;
@property (weak, nonatomic) IBOutlet UITextField *txt_Last_Name;

@property (weak, nonatomic) IBOutlet UITextField *txt_Email;
@property (weak, nonatomic) IBOutlet UITextField *txt_Phone;

// New Outlets july 2015

@property (weak, nonatomic) IBOutlet UITextField *txt_Age;
//@property (weak, nonatomic) IBOutlet UITextField *txt_Gender;
@property (weak, nonatomic) IBOutlet UITextField *txt_adderss;
//@property (weak, nonatomic) IBOutlet UITextField *txt_MaritalStatus;
@property (weak, nonatomic) IBOutlet UITextField *txt_Occupation;
@property (weak, nonatomic) IBOutlet UITextField *txt_LanguageSpoken;
@property (weak, nonatomic) IBOutlet UITextField *txt_Education;
@property (weak, nonatomic) IBOutlet UITextField *txt_Special_Interests;

@property (weak, nonatomic) IBOutlet UIButton *Outlet_PoliticalGroupYes;
@property (weak, nonatomic) IBOutlet UIButton *Outlet_PoliticalGroupNO;

@property (weak, nonatomic) IBOutlet UIButton *Outlet_ProsecutionYes;
@property (weak, nonatomic) IBOutlet UIButton *Outlet_ProsecutionNO;



///////////////Outlet for text fileds ...


////////////Actions......

- (IBAction)Reset_Tapped:(id)sender;

- (IBAction)submit_Tapped:(id)sender;

// New Action  july 2015..

- (IBAction)btn_PoliticalGroupYes:(id)sender;
- (IBAction)btn_PoliticalGroupNo:(id)sender;
- (IBAction)btn_ProsecutionYes:(id)sender;
- (IBAction)btn_ProsecutionNo:(id)sender;


///////////Actions......



///////////// handling switch with outlet and action with value changed  ///////////////

- (IBAction)enableStateChanged:(id)sender;

@property (weak, nonatomic) IBOutlet UISwitch *switch_LocationEnable;

///////////// handling switch with outlet and action with value changed  ///////////////

// Updated Outlets.. 31 july 2015

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *addViewOnScrollView;
@property (weak, nonatomic) IBOutlet UILabel *showTemperature;




@end
