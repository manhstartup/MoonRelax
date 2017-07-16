//
//  CreaterTimer.m
//  RelaxApp
//
//  Created by Manh on 10/4/16.
//  Copyright © 2016 JoJo. All rights reserved.
//

#import "SettingAbout.h"
#import "Define.h"
#import "FileHelper.h"
@interface SettingAbout ()
{

}
@end

@implementation SettingAbout

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.imgBackGround.backgroundColor = UIColorFromRGB(COLOR_BACKGROUND_FAVORITE);
    self.lbTitle.text               = str(kAbout);

}
-(void)setCallback:(SettingAboutCallback)callback
{
    _callback = callback;
}
-(void)dismissKeyboard {
    [self endEditing:YES];
}

-(IBAction)closeAction:(id)sender
{
    if (_callback) {
        _callback();
    }
    [self removeFromSuperview];
}
@end
