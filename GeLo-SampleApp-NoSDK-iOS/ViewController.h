//
//  ViewController.h
//  GeLo-SampleApp-NoSDK-iOS
//
//  Created by Zach Dennis on 5/23/14.
//  Copyright (c) 2014 GeLo Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController<CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *uuidLabel;
@property (weak, nonatomic) IBOutlet UILabel *majorLabel;
@property (weak, nonatomic) IBOutlet UILabel *minorLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rangeButton;
- (IBAction)toggleRange:(id)sender;
@end
