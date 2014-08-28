//
//  SignUpProxy.m
//  MeetMeUp
//
//  Created by Tanya on 8/8/57 BE.
//  Copyright (c) 2557 ustwo.com.ty. All rights reserved.
//

#import "SignUpProxy.h"
#import "AlertViewCreator.h"
#import "MainViewController.h"
#import "KeychainItemWrapper.h"

@implementation SignUpProxy

//upload data user to server
- (void) signUpUserWithEmail:(NSString *)email username:(NSString *)username password:(NSString *)password photo:(UIImage *)photo andViewController:(UIViewController *)viewController andDeviceToken:(NSString *)deviceToken
{
    NSLog(@"token: %@", deviceToken);
    
    //set header string
    NSString *headerString = @"http://www.loadfree2u.net/meetmeup/";
 
    //create user image name
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd-hh-mm-ss-SSS"];
    NSString *dateString = [dateFormat stringFromDate:today];
    NSString *photoURLString = [NSString stringWithFormat:@"%@upload/%@.png", headerString, dateString];
    
    //set php object name for PHP post
    NSArray *formfields = [NSArray arrayWithObjects:@"email", @"username", @"password", @"photourl", @"devicetoken", nil];
    //set php object data for PHP post
    NSArray *formvalues = [NSArray arrayWithObjects:email, username, password, photoURLString, deviceToken, nil];
    //making formfields and form value into nsdictionary
    NSDictionary *textParams = [NSDictionary dictionaryWithObjects:formvalues forKeys:formfields];
    
    //set profile image name
    NSArray *imageParams = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%@.png", dateString], nil];
    
    //set up urlRequest
    NSString *urlString = [NSString stringWithFormat:@"%@meetmeup_userSignUp.php", headerString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    
    NSMutableData *body = [NSMutableData data];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    // add the image form fields
    if (photo == nil)
    {
        //do nothing
    }
    else
    {
        for (int i=0; i<[imageParams count]; i++) {
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: attachment; name=\"userfile\"; filename=\"%@\"\r\n", [imageParams objectAtIndex:i]] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[NSData dataWithData:UIImageJPEGRepresentation(photo, 90)]];
            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    
    // add the text form fields
    for (id key in textParams) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString:[textParams objectForKey:key]] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    // close the form
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // set request body
    [request setHTTPBody:body];
    
    // send the request (submit the form) and get the response
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *uploadResponseString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    NSLog(@"upload response: %@", uploadResponseString);
    
    AlertViewCreator *alertViewCreator = [[AlertViewCreator alloc] init];
    UIView *alertView = [[UIView alloc] init];
    
    if ([uploadResponseString intValue] == 1)
    {
        MainViewController *mainViewController = [viewController.storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
        mainViewController.signUpViewController = viewController;
        
        [viewController presentViewController:mainViewController animated:YES completion:nil];
        
        KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"loginData" accessGroup:nil];
        [keychain setObject:username forKey:(__bridge id)kSecAttrAccount];
        [keychain setObject:password forKey:(__bridge id)kSecValueData];
    }
    else if ([uploadResponseString intValue] == 2)
    {
        alertView = [alertViewCreator createAlertViewWithViewController:viewController andText:@"A user with that email already exists."];
        [viewController.view addSubview:alertView];
    }
    else if ([uploadResponseString intValue] == 3)
    {
        alertView = [alertViewCreator createAlertViewWithViewController:viewController andText:[NSString stringWithFormat:@"The username %@ is not available.", username]];
        [viewController.view addSubview:alertView];
    }
    else
    {
        alertView = [alertViewCreator createAlertViewWithViewController:viewController andText:@"There was an error. Please try again."];
        [viewController.view addSubview:alertView];
    }
}

@end
