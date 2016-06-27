//
//  CCKFNavDrawer.h
//  CCKFNavDrawer
//
//  Created by calvin on 23/1/14.
//  Copyright (c) 2014年 com.calvin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CCKFNavDrawerDelegate <NSObject>
@required
- (void)CCKFNavDrawerSelection:(NSInteger)selectionIndex;
- (void)StaticMenuItems:(NSInteger)indexValue;
@end

@interface CCKFNavDrawer : UINavigationController<UIGestureRecognizerDelegate, UITableViewDataSource, UITableViewDelegate>{
    
    
    NSMutableArray*  arrayForBool;
    NSMutableArray * sectionTitleArray;

}

@property (nonatomic, strong) UIPanGestureRecognizer *pan_gr;
@property (weak, nonatomic)id<CCKFNavDrawerDelegate> CCKFNavDrawerDelegate;

- (void)drawerToggle:(int)myCheck;


@end
