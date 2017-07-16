//
//  BaseVC.h
//  RelaxApp
//
//  Created by JoJo on 9/27/16.
//  Copyright © 2016 JoJo. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^callBack) (UIButton*);

@interface TabVC : UIView
@property (nonatomic, copy) callBack myCallBack;
@end
