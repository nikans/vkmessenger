//
//  LVKImageLoader.m
//  VKMessenger
//
//  Created by Eliah Nikans on 6/16/14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import "LVKImageLoader.h"

@implementation LVKImageLoader

+ (instancetype)sharedImageLoader
{
    static LVKImageLoader *loader = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        loader = [[LVKImageLoader alloc] init];
    });
    
    return loader;
}

- (UIImage *)imageManager:(SDWebImageManager *)imageManager
 transformDownloadedImage:(UIImage *)image
                  withURL:(NSURL *)imageURL
{
    // Place your image size here
    CGFloat width = 50.0f;
    CGFloat height = 50.0f;
    CGSize imageSize = CGSizeMake(width, height);
    
    UIGraphicsBeginImageContext(imageSize);
    [image drawInRect:CGRectMake(0, 0, width, height)];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
