//
//  WSItemView.m
//  RelaxApp
//
//  Created by JoJo on 11/20/16.
//  Copyright © 2016 JoJo. All rights reserved.
//

#import "WSItemView.h"

@implementation WSItemView
-(void)awakeFromNib
{
    [super awakeFromNib];
    self.lbName.font = [UIFont fontWithName:@"Roboto-Regular" size:17];
    self.lbName.textColor = [UIColor whiteColor];
    self.lbDescription.font = [UIFont fontWithName:@"Roboto-Regular" size:14];
    self.lbDescription.textColor = UIColorFromRGB(COLOR_WELCOME_SCREEN_DESC);
}
-(void)fnSetData:(NSDictionary*)dic
{
    _dicWS =dic;
    self.lbName.text = _dicWS[@"name"];
    self.lbDescription.text = _dicWS[@"desc"];
    self.imgWS.image = [UIImage imageNamed:_dicWS[@"image"]];
}
@end
