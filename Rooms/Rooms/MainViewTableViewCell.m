//
//  MainViewTableViewCell.m
//  Rooms
//
//  Created by Cass Pangell on 8/14/14.
//  Copyright (c) 2014 mondolabs. All rights reserved.
//

#import "MainViewTableViewCell.h"


@implementation MainViewTableViewCell

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
