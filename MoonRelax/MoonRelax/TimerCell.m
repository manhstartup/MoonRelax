//
//  TimerCell.m
//  RelaxApp
//
//  Created by Manh on 10/4/16.
//  Copyright © 2016 JoJo. All rights reserved.
//

#import "TimerCell.h"
#import "Define.h"
@implementation TimerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.lbNameTimer.font = [UIFont fontWithName:@"Roboto-Regular" size:13];
    self.lbValueTimer.font = [UIFont fontWithName:@"Roboto-Regular" size:24];
    self.lbDescription.font = [UIFont fontWithName:@"Roboto-Regular" size:10];
    self.lbNameTimer.textColor = UIColorFromRGB(COLOR_TEXT_ITEM);
    self.lbValueTimer.textColor = [UIColor blackColor];
    self.lbDescription.textColor = UIColorFromRGB(COLOR_TEXT_ITEM);

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
