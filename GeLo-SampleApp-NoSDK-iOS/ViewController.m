//
//  ViewController.m
//  GeLo-SampleApp-NoSDK-iOS
//
//  Created by Zach Dennis on 5/23/14.
//  Copyright (c) 2014 GeLo Inc. All rights reserved.
//

#import "ViewController.h"

// The Gelo iBeacon Profile UUID
#define kGeLoProfileUUID "11E44F09-4EC4-407E-9203-CF57A50FBCE0"

@interface ViewController ()
@property CLLocationManager *locationManager;
@property CLBeaconRegion *beaconRegion;
@property BOOL isRanging;

// The nearest beacon
@property CLBeacon *nearestBeacon;

// The RSSI of the nearest beacon
@property NSInteger nearestRSSI;

// A identifer used to compare CLBeacon(s)
@property NSUInteger nearestBeaconIdentifier;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestAlwaysAuthorization];
    self.isRanging = NO;

    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@kGeLoProfileUUID];
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:@"com.gelosite"];
}

- (IBAction)toggleRange:(id)sender {
    if(self.isRanging){
        [self.locationManager stopRangingBeaconsInRegion:self.beaconRegion];
        self.isRanging = NO;
        self.rangeButton.title = @"Start ranging";
    } else {
        [self.locationManager startMonitoringForRegion:self.beaconRegion];
        self.isRanging = YES;
        self.rangeButton.title = @"Stop ranging";
    }
}


# pragma mark CLLocationManagerDelegate

- (void) locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region
{
    [self.locationManager requestStateForRegion:self.beaconRegion];
}

- (void) locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
  switch (state) {
    case CLRegionStateInside:
      [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
      break;
    case CLRegionStateOutside:
    case CLRegionStateUnknown:
    default:
      NSLog(@"Region unknown");
  }
}

- (void) locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    NSUInteger beaconIdentifier;
    for(CLBeacon *beacon in beacons){
        // create a identifier for the major|minor that we can use to compare beacons
        beaconIdentifier = (beacon.major.unsignedIntegerValue << 16) | (beacon.minor.unsignedIntegerValue);

        // ignore beacons whose RSSI we're not sure of
        if(beacon.rssi != 0){
            if(!self.nearestBeacon || beacon.rssi >= self.nearestRSSI){
                self.nearestBeacon = beacon;
                self.nearestBeaconIdentifier = beaconIdentifier;
            }

            if(self.nearestBeaconIdentifier == beaconIdentifier){
                self.nearestRSSI = beacon.rssi;
            }
        }
    }

    self.uuidLabel.text = self.nearestBeacon.proximityUUID.UUIDString;
    self.majorLabel.text = self.nearestBeacon.major.stringValue;
    self.minorLabel.text = self.nearestBeacon.minor.stringValue;
}

@end
