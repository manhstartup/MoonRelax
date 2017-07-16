//
//  VolumeView.m
//  RelaxApp
//
//  Created by JoJo on 9/30/16.
//  Copyright © 2016 JoJo. All rights reserved.
//

#import "VolumeView.h"
#import "Define.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
@implementation VolumeView

-(instancetype)initWithClassName:(NSString*)className
{
    self = [[[NSBundle mainBundle] loadNibNamed:className owner:self options:nil] objectAtIndex:0] ;
    if (self) {
    }
    return self;
}
-(void)setup
{
    float vol = [[MPMusicPlayerController applicationMusicPlayer] volume];
    [self.slider setValue:vol];
    
}
-(void)awakeFromNib
{
    [super awakeFromNib];
    [self.btnDecrease setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.btnIncrease setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.vline.backgroundColor = UIColorFromRGB(COLOR_VOLUME_TOTAL_SLIDER_THUMB);
    [self.slider setMinimumTrackTintColor:UIColorFromRGB(COLOR_VOLUME_TOTAL_SLIDER_THUMB)];
    [self.slider setMaximumTrackTintColor:UIColorFromRGB(COLOR_SLIDER_MAX)];
    [self.slider setThumbImage:[UIImage imageNamed:@"Oval"] forState:UIControlStateNormal];
    [self.vBackGround setBackgroundColor:UIColorFromRGB(COLOR_TABBAR_BOTTOM)];

}
-(void)addContraintSupview:(UIView*)viewSuper
{
    UIView *view = self;
    self.translatesAutoresizingMaskIntoConstraints = NO;
    view.frame = viewSuper.frame;
    
    [viewSuper addSubview:view];
    
    [viewSuper addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[view(50)]-(85)-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(view)]];
    
    [viewSuper addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[view]-(0)-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(view)]];
    float vol = [[MPMusicPlayerController applicationMusicPlayer] volume];
    [self.slider setValue:vol];
}
-(void)showVolume:(BOOL)show
{
    self.hidden = !show;
    [timer invalidate];
    timer = nil;
    timer = [NSTimer scheduledTimerWithTimeInterval: 5.0
                                             target: self
                                           selector:@selector(dismissView:)
                                           userInfo: nil repeats:NO];
    float vol = [[MPMusicPlayerController applicationMusicPlayer] volume];
    [self.slider setValue:vol];

}
-(void)setCallbackDismiss:(DismissCallback)callbackDismiss
{
    _callbackDismiss = callbackDismiss;
}
-(IBAction)decreaseAction:(id)sender
{
    [timer invalidate];
    timer = nil;

    float volume =  self.slider.value - 0.1;
    if (volume < 0) {
        volume = 0;
    }
    [self.slider setValue:volume];
    [[MPMusicPlayerController applicationMusicPlayer] setVolume:volume];
    if (_callback) {
        _callback();
    }
}
-(IBAction)increaseAction:(id)sender
{
    [timer invalidate];
    timer = nil;
    timer = [NSTimer scheduledTimerWithTimeInterval: 5.0
                                             target: self
                                           selector:@selector(dismissView:)
                                           userInfo: nil repeats:NO];

    float volume =  self.slider.value + 0.1;
    if (volume > 1) {
        volume = 1;
    }
    [self.slider setValue:volume];
    [[MPMusicPlayerController applicationMusicPlayer] setVolume:volume];
    if (_callback) {
        _callback();
    }
}

-(IBAction)dismissView:(id)sender
{
    self.hidden = YES;
    if (_callbackDismiss) {
        _callbackDismiss();
    }
}
- (IBAction)volumeSliderEdittingDidBegin:(id)sender
{
    [timer invalidate];
    timer = nil;
    timer = [NSTimer scheduledTimerWithTimeInterval: 5.0
                                             target: self
                                           selector:@selector(dismissView:)
                                           userInfo: nil repeats:NO];

    UISlider *slider = (UISlider*)sender;
    float volume =  slider.value;
    [[MPMusicPlayerController applicationMusicPlayer] setVolume:volume];
    if (_callback) {
        _callback();
    }

}
- (IBAction)volumeSliderEdittingDidEnd:(id)sender
{
    [timer invalidate];
    timer = nil;
    timer = [NSTimer scheduledTimerWithTimeInterval: 5.0
                                             target: self
                                           selector:@selector(dismissView:)
                                           userInfo: nil repeats:NO];
}

@end
