//
//  ShortcutScreenVC.m
//  Naturapass
//
//  Created by Giang on 5/31/16.
//  Copyright © 2016 Appsolute. All rights reserved.
//

#import "ShortcutScreenVC.h"
#import "Define.h"
#import "ShortcutCell.h"
#import<QuartzCore/QuartzCore.h>
static NSString *identifierSection1 = @"MyTableViewCell1";
#define kDefaultAnimationDuration 0.25f

@interface ShortcutScreenVC ()
{
    NSMutableArray *arrData;
    NSMutableArray *arrViewControl;
    BOOL allow_add;
}
@end

@implementation ShortcutScreenVC
#pragma mark - INIT

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self instance];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self instance];
    }
    return self;
}
-(instancetype)initWithEVC:(UIViewController*)vc
{
    self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] objectAtIndex:0] ;
    if (self) {
        _parentVC = vc;
    }
    return self;
}

-(void)instance
{
    [self.btnClose fnSetIcon:@"icon_plus"];
    self.btnClose.backgroundColor = UIColorFromRGB(COLOR_ICON_ACTIVE);
    [self.btnClose.layer setMasksToBounds:YES];
    self.btnClose.layer.cornerRadius = 0;

    // Do any additional setup after loading the view from its nib.
    arrData = [NSMutableArray new];
    arrViewControl = [NSMutableArray new];

    
    NSMutableDictionary *dic5 = [@{@"name":@" Search YouTube ",
                                   @"image":@"icon_search",
                                   @"screen": @(SHORTCUT_ACTION_SEARCH)} copy];

    NSMutableDictionary *dic4 = [@{@"name":@" Setting ",
                                   @"image":@"icon_setting",
                                   @"screen": @(SHORTCUT_ACTION_INFO)} copy];
    
    NSMutableDictionary *dic3 = [@{@"name":@" Timer ",
                                   @"image":@"icon_alarm_clock",
                                   @"screen": @(SHORTCUT_ACTION_TIMER)} copy];
    NSMutableDictionary *dic2 = [@{@"name":@" favorist ",
                                   @"image":@"icon_favorite",
                                   @"screen": @(SHORTCUT_ACTION_FAVORISTE)} copy];
    
    NSMutableDictionary *dic1 = [@{@"name":@" volume ",
                                   @"image":@"icon_volume",
                                   @"screen": @(SHORTCUT_ACTION_VOLUME)} copy];
    [arrData addObject:dic1];
    [arrData addObject:dic2];
    [arrData addObject:dic3];
    [arrData addObject:dic4];
    [arrData addObject:dic5];


}
-(void)fnAllowAdd:(BOOL)allowAdd
{
    allow_add = allowAdd;
    [self instance];
    [self addViewControl];
}
-(void)addContraintSupview:(UIView*)viewSuper
{
    UIView *view = self;
    self.translatesAutoresizingMaskIntoConstraints = NO;
    view.frame = viewSuper.frame;
    
    [viewSuper addSubview:view];
    
    [viewSuper addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[view]-(0)-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(view)]];
    
    [viewSuper addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[view]-(0)-|"
                                                                      options:0
                                                                      metrics:nil
                         
                                                                        views:NSDictionaryOfVariableBindings(view)]];
    [self instance];
    [self addViewControl];

}

-(void)awakeFromNib{
    [super awakeFromNib];
    self.animationDuration = kDefaultAnimationDuration;
    self.paddingView = 0.f;

    _btnClose.center = self.pointBtnShortcut;
}

-(IBAction)closeAction:(id)sender
{
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
//        CGAffineTransform transform = CGAffineTransformMakeRotation(-M_PI/2);
//        self.btnClose.transform = transform;
        
         self.btnClose.layer.transform = CATransform3DMakeRotation((180) * 45, 0, 0, 1);
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.1 animations:^{
            self.btnClose.transform = CGAffineTransformIdentity;
        }];
        
        //finish rotate:
        [self dismissButtons:0];
    }];
    
}

-(IBAction)selectAction:(id)sender
{
    int index = (int)[sender tag] - 4000;
    NSDictionary *dic = arrData[index];
    SHORTCUT_ACTION_TYPE shortcut = [dic[@"screen"] intValue];
    [self dismissButtons:shortcut];


}

-(void)addViewControl
{
    NSArray *viewsToRemove = [self subviews];
    for (UIView *v in viewsToRemove) {
        if ([v isKindOfClass:[ShortcutCell class]]) {
            [v removeFromSuperview];
        }
    }
    //
    for (int i = 0 ; i < arrData.count; i++) {
        NSDictionary *dic = arrData[i];
        ShortcutCell *view=[[[NSBundle mainBundle] loadNibNamed:@"ShortcutCell" owner:self options:nil] objectAtIndex:0];
        
        view.rightConstraint.constant = _constraintTraillingCloseButton.constant;
        
        
        view.tag=20000 + i;
        view.imageIcon.image =  [[UIImage imageNamed: dic[@"image"]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        view.imageIcon.tintColor = UIColorFromRGB(COLOR_ICON_ACTIVE);
        //FONT
        view.label1.text = dic[@"name"];
        view.backgroundColor=[UIColor clearColor];
        CGRect rect = view.frame;
        rect.size.height = 50;
        rect.size.width = self.frame.size.width;
        rect.origin = CGPointMake(0, 0);
        view.frame = rect;
        [arrViewControl addObject:view];
        view.btnSelect.tag = 4000 + i;
        [view.btnSelect addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:view];
    }
    
}
- (void)showButtons {
    
    NSArray *viewContainer = arrViewControl;
    
    self.userInteractionEnabled = NO;
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:_animationDuration];
    [CATransaction setCompletionBlock:^{
        isShow = NO;
        for (ShortcutCell *viewControl in arrViewControl) {
            viewControl.transform = CGAffineTransformIdentity;
        }
        self.userInteractionEnabled = YES;
    }];
    
    for (int i = 0; i < viewContainer.count; i++) {
        int index = (int)viewContainer.count - (i + 1);
        
        ShortcutCell *button = [viewContainer objectAtIndex:index];
        CGRect rect = button.frame;
        rect.size.height = 50;
        rect.size.width = self.frame.size.width;
        rect.origin = CGPointMake(0, 0);
        button.frame = rect;

        button.hidden = NO;
        
        // position animation
        CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
        
        CGPoint originPosition = CGPointZero;
        CGPoint finalPosition = CGPointZero;
        
        originPosition = CGPointMake(self.btnClose.frame.origin.x, self.btnClose.frame.origin.y);
        
        finalPosition = CGPointMake(self.frame.size.width/2,
                                    self.btnClose.frame.origin.y - self.paddingView - button.frame.size.height/2.f
                                    - ((button.frame.size.height + self.paddingView) * index));
        
        positionAnimation.duration = _animationDuration;
        positionAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        positionAnimation.fromValue = [NSValue valueWithCGPoint:originPosition];
        positionAnimation.toValue = [NSValue valueWithCGPoint:finalPosition];
        positionAnimation.beginTime = CACurrentMediaTime() + (_animationDuration/(float)viewContainer.count * (float)i);
        positionAnimation.fillMode = kCAFillModeForwards;
        positionAnimation.removedOnCompletion = NO;
        
        [button.layer addAnimation:positionAnimation forKey:@"positionAnimation"];
        
        button.layer.position = finalPosition;
        
        // scale animation
        CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        
        scaleAnimation.duration = _animationDuration;
        scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        scaleAnimation.fromValue = [NSNumber numberWithFloat:0.01f];
        scaleAnimation.toValue = [NSNumber numberWithFloat:1.f];
        scaleAnimation.beginTime = CACurrentMediaTime() + (_animationDuration/(float)viewContainer.count * (float)i) + 0.03f;
        scaleAnimation.fillMode = kCAFillModeForwards;
        scaleAnimation.removedOnCompletion = NO;
        
        [button.layer addAnimation:scaleAnimation forKey:@"scaleAnimation"];
        
        button.transform = CGAffineTransformMakeScale(0.01f, 0.01f);
    }
    [CATransaction commit];
    
}
- (void)dismissButtons:(SHORTCUT_ACTION_TYPE)shorcut {
    
    self.userInteractionEnabled = NO;
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:_animationDuration];
    [CATransaction setCompletionBlock:^{
        [self _finishCollapse:shorcut];
        
        for (ShortcutCell *viewControl in arrViewControl) {
            viewControl.transform = CGAffineTransformIdentity;
            viewControl.hidden = YES;
        }
        self.userInteractionEnabled = YES;
    }];
    
    int index = 0;
    for (int i = (int)arrViewControl.count - 1; i >= 0; i--) {
        ShortcutCell *button = [arrViewControl objectAtIndex:i];
        
        
        // scale animation
        CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        
        scaleAnimation.duration = _animationDuration;
        scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        scaleAnimation.fromValue = [NSNumber numberWithFloat:1.f];
        scaleAnimation.toValue = [NSNumber numberWithFloat:0.01f];
        scaleAnimation.beginTime = CACurrentMediaTime() + (_animationDuration/(float)arrViewControl.count * (float)index) + 0.03;
        scaleAnimation.fillMode = kCAFillModeForwards;
        scaleAnimation.removedOnCompletion = NO;
        
        [button.layer addAnimation:scaleAnimation forKey:@"scaleAnimation"];
        
        button.transform = CGAffineTransformMakeScale(1.f, 1.f);
        
        // position animation
        CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
        
        CGPoint originPosition = button.layer.position;
        CGPoint finalPosition = CGPointZero;
        finalPosition = CGPointMake(self.btnClose.frame.origin.x, self.btnClose.frame.origin.y);
        positionAnimation.duration = _animationDuration;
        positionAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        positionAnimation.fromValue = [NSValue valueWithCGPoint:originPosition];
        positionAnimation.toValue = [NSValue valueWithCGPoint:finalPosition];
        positionAnimation.beginTime = CACurrentMediaTime() + (_animationDuration/(float)arrViewControl.count * (float)index);
        positionAnimation.fillMode = kCAFillModeForwards;
        positionAnimation.removedOnCompletion = NO;
        
        [button.layer addAnimation:positionAnimation forKey:@"positionAnimation"];
        
        button.layer.position = originPosition;
        index++;
    }
    
    [CATransaction commit];
    
}
- (void)_finishCollapse:(SHORTCUT_ACTION_TYPE)shorcut {
    isShow = NO;
    [self hide:YES];
    if (_callback) {
        _callback(shorcut);
    }

}
-(void)hide:(BOOL)hidden
{
    self.hidden =hidden;
    if (!hidden && !isShow) {
        isShow = YES;
        [self showButtons];
    }
}
@end
