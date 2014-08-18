//
//  AppDelegate.h
//  MeetMeUp
//
//  Created by Tanya on 8/5/14.
//  Copyright (c) 2014 ustwo.com.ty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    CLLocationManager *locationManager;
}

@property (strong, nonatomic) UIWindow *window;


@end
