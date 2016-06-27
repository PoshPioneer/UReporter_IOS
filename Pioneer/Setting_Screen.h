//
//  Setting_Screen.h
//  pioneer
//
//  Created by Valeteck on 29/07/14.
//  Copyright (c) 2014 CYNOTECK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Setting_Screen : UIViewController<UITableViewDataSource,
UITableViewDelegate>{
    
     NSMutableArray *myData;
}


- (IBAction)back_Tapped:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *setting_Table_View;

@property (weak, nonatomic) IBOutlet UILabel *showTemperature;



@end
