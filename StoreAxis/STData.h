//
//  STData.h
//  StoreAxis
//
//  Created by Donald Pae on 4/9/14.
//  Copyright (c) 2014 damy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STOptionData : NSObject

@property (nonatomic, retain) NSString *imgPath;
@property (nonatomic, retain) NSString *display;
@property (nonatomic, retain) NSString *storeNumber;
@property (nonatomic, retain) NSString *trackingNumber;
@property (nonatomic) int height;
@property (nonatomic) int width;
@property (nonatomic) int length;
@property (nonatomic) int actualWeight;
@property (nonatomic) int pieces;
@property (nonatomic, retain) NSString *status;
@property (nonatomic, retain) NSString *statusDetail;
@property (nonatomic, retain) NSString *strUUID;

@end
