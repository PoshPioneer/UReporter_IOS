//
//  submitCell.h
//  Pioneer
//
//  Created by Deepankar Parashar on 11/03/16.
//  Copyright © 2016 CYNOTECK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface submitCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *fullStoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *datelabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *testingtitle;


- (IBAction)deleteTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnReadMore;
@property (weak, nonatomic) IBOutlet UIImageView *ImageFromPath;

@property (weak, nonatomic) IBOutlet UILabel *lbl_type;

@property (weak, nonatomic) IBOutlet UIImageView *videoIcon;



@property (weak, nonatomic) IBOutlet UILabel *lblDateForTxt;
@property (weak, nonatomic) IBOutlet UILabel *lblTitleForTxt;
@property (weak, nonatomic) IBOutlet UILabel *lblFullStoryForTxt;




@end
