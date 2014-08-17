//
//  AppDelegate.m
//  MeetMeUp
//
//  Created by Tanya on 8/5/14.
//  Copyright (c) 2014 ustwo.com.ty. All rights reserved.
//

#import <FacebookSDK/FacebookSDK.h>

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [FBLoginView class];
    [FBProfilePictureView class];
    
    //get user location: lat and long
    locationManager = [[CLLocationManager alloc] init];
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    [locationManager startUpdatingLocation];
    
    //check if app run first time (Login purposes)
    BOOL isRunMoreThanOnce = [[NSUserDefaults standardUserDefaults] boolForKey:@"isRunMoreThanOnce"];
    //check if user is logged in
    BOOL isLoggedIn = [[NSUserDefaults standardUserDefaults] boolForKey:@"isLoggedIn"];
    
    if (!isRunMoreThanOnce)
    {
        //make app knows its not first time
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isRunMoreThanOnce"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSLog(@"isFirstTime");
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
        UIViewController *LoginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [self.window setRootViewController:LoginViewController];
        
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.window.rootViewController = LoginViewController;
        [self.window makeKeyAndVisible];
        
        
    }
    else if (isRunMoreThanOnce)
    {
        NSLog(@"IsNotFirstTime");
        //user not first time
        
        if(!isLoggedIn)
        {
            NSLog(@"isNotLoggedIn");
            //user never logged in
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
            UIViewController *LoginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
            [self.window setRootViewController:LoginViewController];
            
            self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
            self.window.rootViewController = LoginViewController;
            [self.window makeKeyAndVisible];
        }
        else if (isLoggedIn)
        {
            NSLog(@"isLoggedIn");
            //user logged in before
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
            UIViewController *MainViewController = [storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
            [self.window setRootViewController:MainViewController];
            
            self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
            self.window.rootViewController = MainViewController;
            [self.window makeKeyAndVisible];
        }
    }
    
    
    
    return YES;
}


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    // Call FBAppCall's handleOpenURL:sourceApplication to handle Facebook app responses
    BOOL wasHandled = [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
    
    // You can add your app-specific url handling code here if needed
    
    return wasHandled;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
