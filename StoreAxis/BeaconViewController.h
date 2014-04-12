//
//  BeaconViewController.h
//  StoreAxis
//
//  Created by Donald Pae on 4/9/14.
//  Copyright (c) 2014 damy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STData.h"
#import <CoreLocation/CoreLocation.h>

@interface BeaconViewController : UIViewController <CLLocationManagerDelegate>

@property (nonatomic, retain) STOptionData *curData;

- (IBAction)onBackClicked:(id)sender;

@end
