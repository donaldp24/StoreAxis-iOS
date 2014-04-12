//
//  TabViewController.m
//  StoreAxis
//
//  Created by Donald Pae on 4/9/14.
//  Copyright (c) 2014 damy. All rights reserved.
//

#import "TabViewController.h"

static TabViewController *_tabSharedInstance = nil;

@interface TabViewController ()

@end

@implementation TabViewController

+ (TabViewController *)sharedInstance
{
    return _tabSharedInstance;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.delegate = self;
    
    UIImage *tabBarBackground = [UIImage imageNamed:@"bottombar"];
    [[UITabBar appearance] setBackgroundImage:tabBarBackground];
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    
    _tabSharedInstance = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    //
}


- (void)selectItem:(int)index
{
    [self setSelectedIndex:index];
}

@end
