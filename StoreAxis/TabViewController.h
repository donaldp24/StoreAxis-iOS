//
//  TabViewController.h
//  StoreAxis
//
//  Created by Donald Pae on 4/9/14.
//  Copyright (c) 2014 damy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabViewController : UITabBarController<UITabBarControllerDelegate>

+ (TabViewController *)sharedInstance;
- (void) selectItem:(int)index;

@end
