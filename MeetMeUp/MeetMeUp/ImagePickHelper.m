//
//  ImagePickHelper.m
//  MeetMeUp
//
//  Created by Tanya on 8/8/57 BE.
//  Copyright (c) 2557 ustwo.com.ty. All rights reserved.
//

#import "ImagePickHelper.h"

@interface ImagePickHelper ()
{
    UIImage *image;
}

@end

@implementation ImagePickHelper

- (UIImage *) getImageFromLibrayFromViewController:(UIViewController *)viewController
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [viewController presentViewController:imagePicker animated:YES completion:^{
    }];
    
    if ([self respondsToSelector:@selector(imagePickerController:didFinishPickingMediaWithInfo:)])
    {
        return image;
    }
    else
    {
        NSLog(@"not yet");
    }
    UIImage *imageRandom = [UIImage imageNamed:@"SignUp_EmailPass.png"];
    return imageRandom;
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
    UIImage *imageSelected = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    ////////////////// **CROP IMAGE TO DESIRED SIZE ** ///////////////////////
    CGSize itemSize = CGSizeMake(340, 340); // give any size you want to give
    UIGraphicsBeginImageContext(itemSize);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [imageSelected drawInRect:imageRect];
    imageSelected = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //////////////////////////////////////////////////////////////////////////
    
    image = imageSelected;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

@end
