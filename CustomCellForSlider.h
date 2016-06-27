//
//  CustomCellForSlider.h
//  AnythingYouWant
//
//  Created by Subodh Dharmwan on 09/03/15.
//  Copyright (c) 2015 Cynoteck. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCellForSlider : UITableViewCell


@property (weak, nonatomic) IBOutlet UISwitch *btn_switchOutlet;
- (IBAction)btn_switchSwitching:(id)sender;


@property (weak, nonatomic) IBOutlet UILabel *lbl_cellItemName;
@property (weak, nonatomic) IBOutlet UIImageView *img_SliderProfile;
@property (weak, nonatomic) IBOutlet UIImageView *img_InnerImage;
@property (weak, nonatomic) IBOutlet UILabel *lbl_SliderUserName;
@property (weak, nonatomic) IBOutlet UIImageView *img_Icon;
@property (weak, nonatomic) IBOutlet UILabel *lbl_saperaterLineAfterUserName;
@property (weak, nonatomic) IBOutlet UILabel *lbl_saperaterLineAfterLightUserName;
@property (weak, nonatomic) IBOutlet UILabel *lbl_saperaterLineAfterPaymentDarkGray;
@property (weak, nonatomic) IBOutlet UILabel *lbl_saperaterLineAfterPaymentLightGray;
@property (weak, nonatomic) IBOutlet UILabel *lbl_blueColorForTap;
@property (weak, nonatomic) IBOutlet UILabel *lbl_separatorLine;

@property (weak, nonatomic) IBOutlet UILabel *lblTesting;

@property (weak, nonatomic) IBOutlet UIButton *btnExpand;
@property (weak, nonatomic) IBOutlet UILabel *lblTopSeparatorLine;

@end
