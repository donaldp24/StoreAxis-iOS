//
//  BeaconViewController.m
//  StoreAxis
//
//  Created by Donald Pae on 4/9/14.
//  Copyright (c) 2014 damy. All rights reserved.
//

#import "BeaconViewController.h"

enum BeaconDistance {
    BeaconDistanceNone = -1,
    BeaconDistanceNear = 0,
    BeaconDistanceCloser = 1,
    BeaconDistanceFar = 2
    };

@interface BeaconViewController () {
    UIImage *imgNearFlashing;
    UIImage *imgFarFlashing;
    UIImage *imgCloserFlahsing;
    UIImage *imgNearNormal;
    UIImage *imgFarNormal;
    UIImage *imgCloserNormal;
    
    int nNumIndex;
    int nRssi;
    
    NSTimer *timer;
}

@property (nonatomic, strong) IBOutlet UIImageView *imgViewGood;

@property (nonatomic, strong) IBOutlet UIImageView *imgViewFar;
@property (nonatomic, strong) IBOutlet UIImageView *imgViewCloser;
@property (nonatomic, strong) IBOutlet UIImageView *imgViewNear;

@property (strong, nonatomic) CLBeaconRegion *beaconRegion;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation BeaconViewController

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
    
    imgNearFlashing = [UIImage imageNamed:@"locate_near_flashing"];
    imgNearNormal = [UIImage imageNamed:@"locate_near_normal"];
    imgFarFlashing = [UIImage imageNamed:@"locate_far_flashing"];
    imgFarNormal = [UIImage imageNamed:@"locate_far_normal"];
    imgCloserFlahsing = [UIImage imageNamed:@"locate_closer_flashing"];
    imgCloserNormal = [UIImage imageNamed:@"locate_closer_normal"];
    
    
    
    nNumIndex = 0;
    nRssi = 0;
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self initRegion];
}

- (void)viewWillAppear:(BOOL)animated
{
    nNumIndex = 0;
    nRssi = 0;
    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerProc:) userInfo:nil repeats:YES];
    
    [self resetFlashing];
    
    if (self.curData != nil)
    {
        self.imgViewGood.image = [UIImage imageNamed:self.curData.imgPath];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    if (timer)
    {
        [timer invalidate];
        timer = nil;
    }
     [self.locationManager stopRangingBeaconsInRegion:self.beaconRegion];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initRegion {
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0"];
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid
                                                           identifier:@"com.matthew.beaconRegion"];
    self.beaconRegion.notifyEntryStateOnDisplay = NO; //Used for Monitoring
    self.beaconRegion.notifyOnEntry = YES; //Used for Monitoring
    self.beaconRegion.notifyOnExit = YES; //Used for Monitoring
}


- (IBAction)onBackClicked:(id)sender
{
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)timerProc:(NSTimer*)timer
{
    [self setFlashing:[self getDistanceWithRSSI:nRssi]];
}

- (int) getDistanceWithRSSI:(int) rssi
{
    if (rssi == 0)
        return BeaconDistanceFar;
    if (rssi < -90)
        return BeaconDistanceFar;
    if (rssi < -70)
        return BeaconDistanceCloser;
    return BeaconDistanceNear;
}

- (void)resetFlashing
{
    [self.imgViewFar setImage:imgFarNormal];
    [self.imgViewCloser setImage:imgCloserNormal];
    [self.imgViewNear setImage:imgNearNormal];
}

- (void)setFlashing:(int)nIndex
{
    
        [self resetFlashing];
    
    //if (nIndex == BeaconDistanceNone)
    //{
        //
    //}
    //else
    if (nIndex == BeaconDistanceNear)
    {
        if (nNumIndex % 2 == 0) {
            [self.imgViewNear setImage:imgNearNormal];
        } else {
            [self.imgViewNear setImage:imgNearFlashing];
        }
    }
    else if (nIndex == BeaconDistanceCloser)
    {
        if (nNumIndex % 2 == 0) {
            [self.imgViewCloser setImage:imgCloserNormal];
        } else {
            [self.imgViewCloser setImage:imgCloserFlahsing];
        }
    }
    else if (nIndex == BeaconDistanceFar)
    {
        if (nNumIndex % 2 == 0) {
            [self.imgViewFar setImage:imgFarNormal];
        }else{
            [self.imgViewFar setImage:imgFarFlashing];
        }
    }
    nNumIndex++;
}

#pragma mark - Location Manager delegate
- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
}

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    [self.locationManager stopRangingBeaconsInRegion:self.beaconRegion];
}

-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
    CLBeacon *beacon;// = [[CLBeacon alloc] init];
    beacon = [beacons lastObject];
   /*
    self.beaconFoundLabel.text = @"Yes";
    self.proximityUUIDLabel.text = beacon.proximityUUID.UUIDString;
    self.majorLabel.text = [NSString stringWithFormat:@"%@", beacon.major];
    self.minorLabel.text = [NSString stringWithFormat:@"%@", beacon.minor];
    self.accuracyLabel.text = [NSString stringWithFormat:@"%f", beacon.accuracy];
    if (beacon.proximity == CLProximityUnknown) {
        self.distanceLabel.text = @"Unknown Proximity";
    } else if (beacon.proximity == CLProximityImmediate) {
        self.distanceLabel.text = @"Immediate";
    } else if (beacon.proximity == CLProximityNear) {
        self.distanceLabel.text = @"Near";
    } else if (beacon.proximity == CLProximityFar) {
        self.distanceLabel.text = @"Far";
    }
    self.rssiLabel.text = [NSString stringWithFormat:@"%i", beacon.rssi];
    */
    
    nRssi = beacon.rssi;
}

@end
