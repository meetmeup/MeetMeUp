//
//  ReachabilityCheckHelper.m
//  MeetMeUp
//
//  Created by Tanya on 8/21/14.
//  Copyright (c) 2014 ustwo.com.ty. All rights reserved.
//

#import "ReachabilityCheckHelper.h"
#import "Reachability.h"
#import <SystemConfiguration/SystemConfiguration.h>


@implementation ReachabilityCheckHelper

- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}

@end
