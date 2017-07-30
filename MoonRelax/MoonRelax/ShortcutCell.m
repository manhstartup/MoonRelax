//
//  ShortcutCell.m
//  Naturapass
//
//  Created by Manh on 5/31/16.
//  Copyright © 2016 Appsolute. All rights reserved.
//

#import "ShortcutCell.h"
@implementation ShortcutCell

- (void)awakeFromNib {
    [super awakeFromNib];

    // Initialization code
    [self.label1.layer setMasksToBounds:YES];
    self.label1.layer.cornerRadius= 4;
    self.label1.layer.borderWidth =0;
    
    [self.imageBackGround.layer setMasksToBounds:YES];
    self.imageBackGround.layer.cornerRadius= 20;
    self.imageBackGround.backgroundColor = [UIColor whiteColor];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.contentView layoutIfNeeded];
//    self.label1.preferredMaxLayoutWidth = CGRectGetWidth(self.label1.frame);
}

@end
