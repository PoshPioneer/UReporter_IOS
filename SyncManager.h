//
//  SyncManager.h
//  Petofy
//
//  Created by Mohit Bisht on 10/02/16.
//  Copyright © 2016 Cynoteck. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SyncDelegate<NSObject>

-(void)syncSuccess:(id) responseObject;
-(void)syncFailure:(NSError*) error;

@end
@interface SyncManager : UIViewController

-(void) serviceCall:(NSString*)url withParams:(NSDictionary*) params;
-(void) putServiceCall:(NSString*)url withParams:(NSDictionary*) params;
-(void) getServiceCall:(NSString*)url withParams:(NSDictionary*) params;

@property (nonatomic, weak) id <SyncDelegate> delegate;

@end
