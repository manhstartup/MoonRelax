//
//  CreaterTimer.h
//  RelaxApp
//
//  Created by Manh on 10/4/16.
//  Copyright © 2016 JoJo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Define.h"
#import "BaseView.h"
#import "MCPercentageDoughnutView.h"

@interface SettingUpdate : BaseView
{
//    BOOL areUnlockPro;
    BOOL areAdsRemoved;
    
}
@property (nonatomic, strong) IBOutlet UIButton *btnCancel;
@property (nonatomic, strong) IBOutlet UIImageView *blurredBgImage;
@property (strong, nonatomic) IBOutlet MCPercentageDoughnutView *percentageDoughnut;
@property (nonatomic, strong) IBOutlet UIView *viewProgress;
@property (strong, nonatomic) IBOutlet UILabel *lbDownload;

@end
