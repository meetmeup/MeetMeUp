//
//  ViewToImageConverter.m
//  MeetMeUp
//
//  Created by Tanya on 8/8/14.
//  Copyright (c) 2014 ustwo.com.ty. All rights reserved.
//

#import "ViewToImageConverter.h"

@implementation ViewToImageConverter

- (UIImage *) imageWithView:(FBProfilePictureView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

@end
