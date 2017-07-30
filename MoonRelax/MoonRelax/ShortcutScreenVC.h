//
//  ShortcutScreenVC.h
//  Naturapass
//
//  Created by Giang on 5/31/16.
//  Copyright © 2016 Appsolute. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Define.h"
#import "MDButtonIcon.h"

typedef void (^ShortcutScreenCallback)(SHORTCUT_ACTION_TYPE type);
@interface ShortcutScreenVC : UIView
{
    BOOL isShow;
    
}
@property (assign) CGPoint pointBtnShortcut;

@property (nonatomic,copy) ShortcutScreenCallback callback;
@property (nonatomic,strong) IBOutlet UITableView *tableControl;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraintHeightTable;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraintBottomCloseButton;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraintTraillingCloseButton;

@property (nonatomic) float animationDuration;
@property (nonatomic,strong) IBOutlet MDButtonIcon *btnClose;
@property (nonatomic) float paddingView;
@property (nonatomic, strong) UIViewController *parentVC;
-(instancetype)initWithEVC:(UIViewController*)vc;
-(void)addContraintSupview:(UIView*)viewSuper;
-(void)hide:(BOOL)hidden;
-(void)fnAllowAdd:(BOOL)allowAdd;
@end
