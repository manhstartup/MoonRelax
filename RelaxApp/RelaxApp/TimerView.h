//
//  TimerView.h
//  RelaxApp
//
//  Created by JoJo on 9/30/16.
//  Copyright © 2016 JoJo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"
@interface TimerView : BaseView<UIActionSheetDelegate>
{
    NSMutableArray *_dataSource;
    BOOL areAdsRemoved;
}
@property (nonatomic, strong) IBOutlet UIView *vViewNav;
@property (nonatomic, strong) IBOutlet UIView *vContent;
@property (strong, nonatomic) IBOutlet UITableView *tableControl;
@property (strong, nonatomic) IBOutlet UILabel *lbEdit;
@property (nonatomic, strong) IBOutlet UIView *vViewEdit;

@end
