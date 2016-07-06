//
//  SubmitForReview.h
//  Pioneer
//
//  Created by Deepankar Parashar on 11/03/16.
//  Copyright © 2016 CYNOTECK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface SubmitForReview : UIViewController <UITableViewDataSource,UITableViewDelegate,UITabBarControllerDelegate,UITabBarDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>



#pragma mark --IBOutlet

@property (weak, nonatomic) IBOutlet UILabel *showTemperature;

@property(strong,nonatomic) NSMutableDictionary  * collectedDict;

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property(nonatomic,strong)UIImage *mainImage;




@property (weak, nonatomic) IBOutlet UITabBar *tabBarController;

#pragma mark --IBAction.

- (IBAction)backButtonClicked:(id)sender;




@end
