//
//  CreaterTimer.h
//  RelaxApp
//
//  Created by Manh on 10/4/16.
//  Copyright © 2016 JoJo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Define.h"
typedef void (^CreaterTimerCallback)();
@interface CreaterTimer : UIViewController
@property (nonatomic, strong) IBOutlet UIView *vViewNav;
@property (nonatomic, strong) IBOutlet UIView *vContent;
@property (nonatomic, strong) IBOutlet UITextField *tfTitle;
@property (nonatomic, strong) IBOutlet UIDatePicker *timeToSetOff;
@property (nonatomic, strong) IBOutlet UIPickerView *pickerFavorite;
@property (nonatomic, strong) IBOutlet UIImageView *imgCheckPause;
@property (nonatomic, strong) IBOutlet UIImageView *imgCheckPlaying;
@property (strong, nonatomic) IBOutlet UILabel *lbAdd;
@property (strong, nonatomic) IBOutlet UILabel *lbTitle;
@property (strong, nonatomic) IBOutlet UILabel *lbDescription;
@property (strong, nonatomic) IBOutlet UILabel *lbPlay;
@property (strong, nonatomic) IBOutlet UILabel *lbPause;
@property (strong, nonatomic) IBOutlet UILabel *lbChooseTimer;
@property (strong, nonatomic) IBOutlet UILabel *lbPlayFavorite;
@property (strong, nonatomic) IBOutlet UIImageView *imgBackGround;

@property (nonatomic,copy) CreaterTimerCallback callback;

@property(nonatomic,assign) MODE_TYPE typeMode;
@property(assign) TIMER_TYPE timerType;
@end
