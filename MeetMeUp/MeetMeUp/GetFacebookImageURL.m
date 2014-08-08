//
//  GetFacebookImageURL.m
//  MeetMeUp
//
//  Created by Tanya on 8/8/14.
//  Copyright (c) 2014 ustwo.com.ty. All rights reserved.
//

#import "GetFacebookImageURL.h"

@implementation GetFacebookImageURL

- (NSMutableData *) getFacebookProfileImageFromUerID:(NSString *)idString
{
    NSMutableData *imageData = [[NSMutableData alloc] init]; // the image will be loaded in here
    NSString *urlString = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large", idString];
    NSLog(@"URL: %@", urlString);
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
                            cachePolicy:NSURLRequestUseProtocolCachePolicy
                        timeoutInterval:2];
    
    // Run request asynchronously
    NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:urlRequest
                                                                     delegate:self];
    if (!urlConnection)
        NSLog(@"Failed to download picture");
#warning dont forget else
    
    NSLog(@"image data: %@", imageData);

    return imageData;
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"DID RE %@", data);
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
}

@end
