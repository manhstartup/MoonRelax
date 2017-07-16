//
//  WSItemView.h
//  RelaxApp
//
//  Created by JoJo on 11/20/16.
//  Copyright © 2016 JoJo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"
#import "Define.h"
@interface WSItemView : BaseView
@property (strong, nonatomic) IBOutlet UILabel *lbName;
@property (strong, nonatomic) IBOutlet UILabel *lbDescription;
@property (strong, nonatomic) IBOutlet UIImageView *imgWS;
@property (strong, nonatomic)  NSDictionary *dicWS;
-(void)fnSetData:(NSDictionary*)dic;
@end
