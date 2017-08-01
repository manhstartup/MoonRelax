//
//  MDButtonPlus.m
//  Naturapass
//
//  Created by JoJo on 6/8/17.
//  Copyright © 2017 Appsolute. All rights reserved.
//

#import "MDButtonIcon.h"

@implementation MDButtonIcon

-(instancetype)initWithFrame:(CGRect)frame
{
    self =[super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}
- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    
    [self.layer setMasksToBounds:YES];
    self.layer.cornerRadius= self.frame.size.width/2;

    imgIcon = [[UIImageView alloc] init];
    imgIcon.frame = CGRectMake(0, 0, 20, 20);
    imgIcon.contentMode =  UIViewContentModeScaleAspectFit;
    [self addContraintSupview:imgIcon withSuperView:self];
    
}
-(void)fnSetIcon:(NSString*)strNameIcon
{
    imgIcon.image = [UIImage imageNamed:strNameIcon];
}
-(void)fnSetIcon:(NSString *)strNameIcon withTintColor:(UIColor*)color
{
    imgIcon.image = [[UIImage imageNamed:strNameIcon] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    imgIcon.tintColor = color;
}
-(void)addContraintSupview:(UIView*)view withSuperView:(UIView*)viewSuper
{
    view.translatesAutoresizingMaskIntoConstraints = NO;
    
    [viewSuper addSubview:view];
    
    [viewSuper addConstraint:[NSLayoutConstraint
                            constraintWithItem:view
                            attribute:NSLayoutAttributeWidth
                            relatedBy:NSLayoutRelationEqual
                            toItem:viewSuper
                            attribute:NSLayoutAttributeWidth
                            multiplier:0.4
                            constant:0]];
    [viewSuper addConstraint:[NSLayoutConstraint
                              constraintWithItem:view
                              attribute:NSLayoutAttributeWidth
                              relatedBy:NSLayoutRelationEqual
                              toItem:view
                              attribute:NSLayoutAttributeHeight
                              multiplier:1
                              constant:0]];
    
    [viewSuper addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:viewSuper
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1
                                                           constant:0]];
    [viewSuper addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:viewSuper
                                                          attribute:NSLayoutAttributeCenterY
                                                         multiplier:1
                                                           constant:0]];
}


@end
