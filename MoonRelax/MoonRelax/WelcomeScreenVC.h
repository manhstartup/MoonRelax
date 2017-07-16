//
//  WelcomeScreenVC.h
//  RelaxApp
//
//  Created by JoJo on 11/20/16.
//  Copyright © 2016 JoJo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WelcomeScreenVC : UIViewController
@property (nonatomic, strong) IBOutlet UIScrollView *scroll_View;
@property (nonatomic, strong) IBOutlet UIPageControl *pageControl;
@property (nonatomic, strong) IBOutlet UIButton *btnNext;
@property (nonatomic, strong) IBOutlet UIButton *btnSkip;
@property (nonatomic, strong) IBOutlet UILabel *lbTitle;
@property (strong, nonatomic) IBOutlet UIImageView *imgBackGround;

@end
