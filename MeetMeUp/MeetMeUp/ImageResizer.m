//
//  ImageResizer.m
//  MeetMeUp
//
//  Created by Tanya on 8/12/14.
//  Copyright (c) 2014 ustwo.com.ty. All rights reserved.
//

#import "ImageResizer.h"

@implementation ImageResizer

- (UIImage *)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
