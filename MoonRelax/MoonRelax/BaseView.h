//
//  BaseView.h
//  RelaxApp
//
//  Created by JoJo on 9/30/16.
//  Copyright © 2016 JoJo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseView : UIView
-(instancetype)initWithClassName:(NSString*)className;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contraintBottom;
@property (weak, nonatomic)  UIViewController *parent;
@property (strong, nonatomic) IBOutlet UIImageView *imgHeader;
@property (strong, nonatomic) IBOutlet UIImageView *imgBackGround;
@property (strong, nonatomic) IBOutlet UILabel *lbTitle;

-(void)addContraintSupview:(UIView*)viewSuper;
//-(void)hide:(BOOL)hidden;
//-(void)setup;
-(void)dismissView;
@end
