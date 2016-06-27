//
//  ReporterEntry.m
//  pioneer
//
//  Created by Subodh Dharmwan on 25/11/15.
//  Copyright (c) 2015 CYNOTECK. All rights reserved.
//

#import "ReporterEntry.h"
#import "FullDescription.h"

@implementation ReporterEntry
@synthesize lblCatgory;
@synthesize lblDate;
@synthesize lblFullStory;
@synthesize btnDelete;
@synthesize lblTime;
@synthesize lblTitle;
@synthesize lblType;
@synthesize btnReadMore;
@synthesize imageView;



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
