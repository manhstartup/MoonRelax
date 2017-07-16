//
//  BaseView.m
//  RelaxApp
//
//  Created by JoJo on 9/30/16.
//  Copyright © 2016 JoJo. All rights reserved.
//

#import "BaseView.h"
#import "Define.h"
@implementation BaseView
-(instancetype)initWithClassName:(NSString*)className
{
    self = [[[NSBundle mainBundle] loadNibNamed:className owner:self options:nil] objectAtIndex:0] ;
    if (self) {
        [self instance];
    }
    return self;
}
-(void)setParent:(UIViewController *)parent
{
    _parent = parent;
}
-(void)instance
{
    if (self.imgHeader) {
        self.imgHeader.backgroundColor = UIColorFromAlpha(COLOR_NAVIGATION_HOME, 1);
    }
    if(self.imgBackGround)
    {
        self.imgBackGround.backgroundColor = UIColorFromRGB(COLOR_BACKGROUND_FAVORITE);

    }
    if (self.lbTitle) {
        self.lbTitle.font = [UIFont fontWithName:@"Roboto-Regular" size:17];
    }
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
}
#pragma mark - CONFIG

-(void)dismissView
{
    [self removeFromSuperview];
}
//-(void)hide:(BOOL)hidden
//{
//    
//    if (hidden) {
//        _contraintBottom.constant = self.frame.size.height;
//        [UIView animateWithDuration:0.5
//                              delay:0.1
//                            options: 0
//                         animations:^
//         {
//             [self layoutIfNeeded]; // Called on parent view
//         }
//                         completion:^(BOOL finished)
//         {
//             
//             NSLog(@"HIDE");
//             self.hidden = hidden;
//         }];
//    }
//    else
//    {
//        self.hidden = hidden;
//        _contraintBottom.constant = 0;
//        [UIView animateWithDuration:0.5
//                              delay:0.1
//                            options: 0
//                         animations:^
//         {
//             [self layoutIfNeeded]; // Called on parent view
//         }
//                         completion:^(BOOL finished)
//         {
//             
//             NSLog(@"SHOW");
//         }];
//    }
//    
//}
//-(void)setup
//{
//    self.hidden = YES;
//    _contraintBottom.constant = self.frame.size.height;
//}
@end
