//
//  NSString+StringSize.h
//  VKMessengerViews
//
//  Created by Eliah Nikans on 6/4/14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (StringSize)

-(CGSize)integralSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)maxSize;
-(CGSize)integralSizeWithFont:(UIFont *)font maxWidth:(CGFloat)maxWidth numberOfLines:(NSInteger)lines;

@end
