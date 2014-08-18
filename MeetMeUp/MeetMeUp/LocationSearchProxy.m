//
//  LocationSearchProxy.m
//  MeetMeUp
//
//  Created by Tanya on 8/16/57 BE.
//  Copyright (c) 2557 ustwo.com.ty. All rights reserved.
//

#import "LocationSearchProxy.h"

@implementation LocationSearchProxy

- (void) searchLocationWithClientID:(NSString *)clientIDString andClientSecret:(NSString *)clientSecretString andSearchText:(NSString *)searchString andLatitude:(CGFloat)latitude andLongtitude:(CGFloat)longtitude andVersion:(NSString *)versionString andViewController:(UIViewController *)viewController
{
    if (latitude == 0.000000 || longtitude == 0.000000)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Could not fetch current location." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertView show];
    }
    else
    {
        __block NSMutableArray *searhLocationCompleteArray = [[NSMutableArray alloc] init];
        
        NSString *requestURL = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/search?ll=%f,%f&query=%@&client_id=%@&client_secret=%@&v=%@", latitude, longtitude, searchString, clientIDString, clientSecretString, versionString];
        NSLog(@"url: %@", requestURL);
        __block NSDictionary *searchLocationResultString;
        
        
        NSURLSession *session = [NSURLSession sharedSession];
        
        [[session dataTaskWithURL:[NSURL URLWithString:requestURL]
                completionHandler:^(NSData *data,
                                    NSURLResponse *response,
                                    NSError *error) {
                    searchLocationResultString = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                    //                NSLog(@"RESPONSE: %@", searchLocationResultString);
                    
                    
                    NSDictionary* jsonRawResponse = [NSJSONSerialization
                                                     JSONObjectWithData:data
                                                     options:kNilOptions
                                                     error:&error];
                    
                    //check if there is error or not
                    NSDictionary *codeResoponseDictionary = [jsonRawResponse objectForKey:@"meta"];
                    NSString *codeResponse = [codeResoponseDictionary objectForKey:@"code"];
                    
                    NSLog(@"code: %@", codeResponse);
                    
                    if ([codeResponse integerValue] == 400)
                    {
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"A required parameter was missing or a parameter was malformed." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                        [alertView show];
                    }
                    if ([codeResponse integerValue] == 401)
                    {
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Invalid access token." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                        [alertView show];
                    }
                    if ([codeResponse integerValue] == 404)
                    {
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"The request path does not exist." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                        [alertView show];
                    }
                    if ([codeResponse integerValue] == 403)
                    {
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"You are not allowed to see this information due to privacy restrictions or Rate limit for this hour exceeded." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                        [alertView show];
                    }
                    if ([codeResponse integerValue] == 200)
                    {
                        NSDictionary *responseDictionary = [jsonRawResponse objectForKey:@"response"];
                        
                        NSArray *venuesArray = [responseDictionary objectForKey:@"venues"];
                        
                        //for loop to get dictionary
                        for (int i = 0; i < [venuesArray count]; i++) {
                            
                            searchLocationResultString = [NSDictionary dictionaryWithObjectsAndKeys:
                                                          [[[venuesArray objectAtIndex:i] objectForKey:@"location"] objectForKey:@"lat"],
                                                          @"lat",
                                                          [[[venuesArray objectAtIndex:i] objectForKey:@"location"] objectForKey:@"lng"],
                                                          @"lng",
                                                          [[[venuesArray objectAtIndex:i] objectForKey:@"location"] objectForKey:@"country"],
                                                          @"country",
                                                          [[venuesArray objectAtIndex:i] objectForKey:@"name"],
                                                          @"name",
                                                          [[[venuesArray objectAtIndex:i] objectForKey:@"location"] objectForKey:@"city"],
                                                          @"city",
                                                          [[[venuesArray objectAtIndex:i] objectForKey:@"location"] objectForKey:@"address"],
                                                          @"address",
                                                          nil];
                            
                            [searhLocationCompleteArray addObject:searchLocationResultString];
                        }
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            if ([self.delegate respondsToSelector:@selector(searchProxy:retrievedSearchResults:)])
                            {
                                [self.delegate searchProxy:self retrievedSearchResults:searhLocationCompleteArray];
                            }
                        });
                    }
                    else
                    {
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Foursquare server is currently experiencing issues. We will be back ASAP." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                        [alertView show];
                    }
                    
                }] resume];
    }
}

@end
