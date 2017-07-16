//
//  TimerCell.h
//  RelaxApp
//
//  Created by Manh on 10/4/16.
//  Copyright © 2016 JoJo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimerCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UILabel *lbNameTimer;
@property (nonatomic, strong) IBOutlet UILabel *lbValueTimer;
@property (nonatomic, strong) IBOutlet UILabel *lbDescription;
@property (nonatomic, strong) IBOutlet UISwitch *swOnOff;

@end
