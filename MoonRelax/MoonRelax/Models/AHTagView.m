//
//  AHTagView.m
//  AutomaticHeightTagTableViewCell
//
//  Created by WEI-JEN TU on 2016-07-16.
//  Copyright © 2016 Cold Yam. All rights reserved.
//

#import "AHTagView.h"
#import "Define.h"
@implementation AHTagView {
    UILabel *_label;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setupViews];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setupViews {
    
    _label = [UILabel new];
    _label.textColor = [UIColor blackColor];
    _label.translatesAutoresizingMaskIntoConstraints = NO;
    _label.layer.cornerRadius = 15;
    _label.layer.masksToBounds = YES;
    _label.font = [UIFont fontWithName:@"Roboto-Regular" size:13];
    [self addSubview:_label];
    _imgBackGround = [UIImageView new];
    [self addSubview:_imgBackGround];
    [self setupConstraints];
}

- (void)setupConstraints {
    NSMutableArray<NSLayoutConstraint *> *constraints = [NSMutableArray new];
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-6.0-[_label]-6.0-|"
                                                                             options:NSLayoutFormatDirectionLeadingToTrailing
                                                                             metrics:nil
                                                                               views:@{@"_label": _label}]];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:_label
                                                        attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                           toItem:nil
                                                        attribute:NSLayoutAttributeHeight
                                                       multiplier:1.0
                                                         constant:30.0]];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:_label
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeTop
                                                       multiplier:1.0
                                                         constant:8.0]];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self
                                                        attribute:NSLayoutAttributeBottom
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:_label
                                                        attribute:NSLayoutAttributeBottom
                                                       multiplier:1.0
                                                         constant:8.0]];
    
    //
    
    _imgBackGround.translatesAutoresizingMaskIntoConstraints = NO;
    UIView *view =  (UIView*)_imgBackGround;
    [self addConstraint: [NSLayoutConstraint constraintWithItem:view
                                 attribute:NSLayoutAttributeCenterX
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self
                                 attribute:NSLayoutAttributeCenterX
                                multiplier:1.f constant:0.f]];
    
    [self addConstraint: [NSLayoutConstraint constraintWithItem:view
                                                      attribute:NSLayoutAttributeCenterY
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self
                                                      attribute:NSLayoutAttributeCenterY
                                                     multiplier:1.f constant:0.f]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute 
                                                    multiplier:1.0 
                                                      constant:30]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1.0
                                                      constant:30]];

    [NSLayoutConstraint activateConstraints:constraints];
}

#pragma mark - Getter

- (UIImage *)image {
    UIGraphicsBeginImageContextWithOptions(self.frame.size, YES, 0.0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
