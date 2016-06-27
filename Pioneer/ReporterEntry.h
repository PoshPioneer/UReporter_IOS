//
//  ReporterEntry.h
//  pioneer
//
//  Created by Subodh Dharmwan on 25/11/15.
//  Copyright (c) 2015 CYNOTECK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReporterEntry : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblCatgory;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblFullStory;
@property (strong, nonatomic) IBOutlet UILabel *lblType;
@property (strong, nonatomic) IBOutlet UILabel *lblDate;
@property (strong, nonatomic) IBOutlet UILabel *lblTime;

@property (strong, nonatomic) IBOutlet UIButton *btnDelete;
@property (strong, nonatomic) IBOutlet UIButton *btnReadMore;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UILabel *lbl_type;
@property (weak, nonatomic) IBOutlet UIImageView *onlyVideoIcon;



@end
