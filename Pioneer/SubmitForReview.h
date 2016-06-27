//
//  SubmitForReview.h
//  Pioneer
//
//  Created by Deepankar Parashar on 11/03/16.
//  Copyright © 2016 CYNOTECK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface SubmitForReview : UIViewController <UITableViewDataSource,UITableViewDelegate>



#pragma mark --IBOutlet

@property (weak, nonatomic) IBOutlet UILabel *showTemperature;

@property(strong,nonatomic) NSMutableDictionary  * collectedDict;

@property (weak, nonatomic) IBOutlet UITableView *tableview;






#pragma mark --IBAction.

- (IBAction)backButtonClicked:(id)sender;




@end
