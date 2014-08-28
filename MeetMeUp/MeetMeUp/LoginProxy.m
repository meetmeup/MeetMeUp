//
//  LoginProxy.m
//  MeetMeUp
//
//  Created by Tanya on 8/5/14.
//  Copyright (c) 2014 ustwo.com.ty. All rights reserved.
//

#import "LoginProxy.h"
#import "AlertViewCreator.h"
#import "MainViewController.h"
#import "KeychainItemWrapper.h"

@implementation LoginProxy

- (void) loginWithUsername:(NSString *)username andPassword:(NSString *)password andViewController:(UIViewController *)viewController andDeviceToken:(NSString *)deviceToken
{
    NSString *strURL = [NSString stringWithFormat:@"http://www.loadfree2u.net/meetmeup/meetmeup_userLogin.php?username=%@&password=%@&devicetoken=%@",username, password, deviceToken];
    NSData *dataURL = [NSData dataWithContentsOfURL:[NSURL URLWithString:strURL]];
    NSString *responseString = [[NSString alloc] initWithData:dataURL encoding:NSUTF8StringEncoding];
    NSLog(@"string result: %@", responseString);
    
    if ([responseString intValue] == 1)
    {
        MainViewController *mainViewController = [viewController.storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
        [viewController presentViewController:mainViewController animated:YES completion:nil];
        
        KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"loginData" accessGroup:nil];
        [keychain setObject:username forKey:(__bridge id)kSecAttrAccount];
        [keychain setObject:password forKey:(__bridge id)kSecValueData];
        
    }
    else if ([responseString intValue] == 0)
    {
        UIView *alertView = [[UIView alloc] init];
        AlertViewCreator *alertViewCreator = [[AlertViewCreator alloc] init];
        alertView = [alertViewCreator createAlertViewWithViewController:viewController andText:@"Invalid username or password."];
    }
    else
    {
        UIView *alertView = [[UIView alloc] init];
        AlertViewCreator *alertViewCreator = [[AlertViewCreator alloc] init];
        alertView = [alertViewCreator createAlertViewWithViewController:viewController andText:@"There was an error. Please try again."];
    }
}

@end
