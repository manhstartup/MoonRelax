//
//  SettingShareSocialCell.m
//  RelaxApp
//
//  Created by JoJo on 11/24/16.
//  Copyright © 2016 JoJo. All rights reserved.
//

#import "SettingShareSocialCell.h"

@implementation SettingShareSocialCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.lbTitle.font = [UIFont fontWithName:@"Roboto-Light" size:20];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
