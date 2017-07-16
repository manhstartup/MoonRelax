//
//  VolumeView.h
//  RelaxApp
//
//  Created by JoJo on 9/30/16.
//  Copyright © 2016 JoJo. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^VolumeItemCallback)(NSDictionary *itemMusic);

@interface VolumeItem : UIView
{
    NSMutableDictionary *dicMusic;
    NSTimer *timer;
}
@property (nonatomic, strong) IBOutlet UISlider *slider;
@property (nonatomic, strong) IBOutlet UILabel *titleFull;
@property (nonatomic, strong) IBOutlet UILabel *titleSub;
@property (nonatomic, strong) IBOutlet UIImageView *vBackGround;
@property (nonatomic, strong) IBOutlet UIButton *btnDecrease;
@property (nonatomic, strong) IBOutlet UIButton *btnIncrease;

@property (nonatomic,copy) VolumeItemCallback callback;
-(instancetype)initWithClassName:(NSString*)className;
-(void)showVolumeWithDicMusic:(NSDictionary*)dic;
-(void)addContraintSupview:(UIView*)viewSuper;
@end
