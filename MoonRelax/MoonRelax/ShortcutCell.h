//
//  ShortcutCell.h
//  Naturapass
//
//  Created by Manh on 5/31/16.
//  Copyright © 2016 Appsolute. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppCommon.h"

@interface ShortcutCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageIcon;
@property (weak, nonatomic) IBOutlet UIImageView *imageBackGround;

@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UIButton *btnSelect;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightConstraint;

@end
