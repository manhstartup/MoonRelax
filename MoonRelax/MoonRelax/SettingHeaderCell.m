//
//  SettingHeaderCell.m
//  RelaxApp
//
//  Created by JoJo on 11/20/16.
//  Copyright © 2016 JoJo. All rights reserved.
//

#import "SettingHeaderCell.h"
#import "Define.h"
@implementation SettingHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.lbTitle.font = [UIFont fontWithName:@"Roboto-Regular" size:17];
    self.lbTitle.textColor = UIColorFromRGB(COLOR_TEXT_ITEM);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
