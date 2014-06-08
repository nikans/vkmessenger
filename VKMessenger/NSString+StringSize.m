//
//  NSString+StringSize.m
//  VKMessengerViews
//
//  Created by Eliah Nikans on 6/4/14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import "NSString+StringSize.h"

@implementation NSString (StringSize)

-(CGSize)integralSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)maxSize
{
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    CGRect rect = CGRectIntegral([self boundingRectWithSize:maxSize options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:attributes context:nil]);
    return rect.size;
}

-(CGSize)integralSizeWithFont:(UIFont *)font maxWidth:(CGFloat)maxWidth numberOfLines:(NSInteger)lines
{
    if (lines == 0) {
        lines = 1;
    }
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    CGFloat height = font.lineHeight * lines;
    CGSize maxsize = CGSizeMake(maxWidth, height);
    CGRect rect = CGRectIntegral([self boundingRectWithSize:maxsize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading attributes:attributes context:nil]);
    return rect.size;
}

@end
