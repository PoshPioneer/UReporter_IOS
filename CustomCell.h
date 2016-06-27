//
//  CustomCell.h
//  Pioneer
//
//  Created by Deepankar Parashar on 15/02/16.
//  Copyright © 2016 CYNOTECK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *news_Image;
@property (weak, nonatomic) IBOutlet UILabel *newsTitle;

@property (weak, nonatomic) IBOutlet UILabel *newsPostTime;


// use this label when no image is there...
@property (weak, nonatomic) IBOutlet UILabel *newsTitleNoImage;

@end
