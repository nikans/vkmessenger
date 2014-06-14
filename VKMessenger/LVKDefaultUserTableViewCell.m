//
//  LVKDefaultUserTableViewCell.m
//  VKMessenger
//
//  Created by Eliah Nikans on 6/14/14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import "LVKDefaultUserTableViewCell.h"

@implementation LVKDefaultUserTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
