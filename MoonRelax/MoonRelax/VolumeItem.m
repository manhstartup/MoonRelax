//
//  VolumeView.m
//  RelaxApp
//
//  Created by JoJo on 9/30/16.
//  Copyright © 2016 JoJo. All rights reserved.
//

#import "VolumeItem.h"
#import "Define.h"

@implementation VolumeItem

-(instancetype)initWithClassName:(NSString*)className
{
    self = [[[NSBundle mainBundle] loadNibNamed:className owner:self options:nil] objectAtIndex:0] ;
    if (self) {
    }
    return self;
}
-(void)awakeFromNib
{
    [super awakeFromNib];
    self.titleFull.font = [UIFont fontWithName:@"Roboto-Medium" size:14];
    self.titleFull.textColor = [UIColor blackColor];
    self.titleSub.font = [UIFont fontWithName:@"Roboto-Medium" size:11];
    self.titleSub.textColor = UIColorFromRGB(COLOR_TEXT_ITEM);
    [self.slider setMinimumTrackTintColor:UIColorFromRGB(COLOR_SLIDER_THUMB)];
    [self.slider setMaximumTrackTintColor:UIColorFromRGB(COLOR_SLIDER_MAX)];
    [self.slider setThumbImage:[UIImage imageNamed:@"Oval"] forState:UIControlStateNormal];
    [self.vBackGround setBackgroundColor:UIColorFromRGB(COLOR_VOLUME)];
    [self.vBackGround.layer setMasksToBounds:YES];
    self.vBackGround.layer.cornerRadius= 5;
    self.layer.shadowOffset = CGSizeMake(0, 2);
    self.layer.shadowRadius = 3;
    self.layer.shadowOpacity = 0.4;

    [self.btnDecrease setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.btnIncrease setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    dicMusic = [NSMutableDictionary new];
}
-(void)addContraintSupview:(UIView*)viewSuper
{
    UIView *view = self;
    self.translatesAutoresizingMaskIntoConstraints = NO;
    view.frame = viewSuper.frame;
    
    [viewSuper addSubview:view];
    [viewSuper addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(3)-[view]-(3)-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(view)]];
    [viewSuper addConstraint: [NSLayoutConstraint
                               constraintWithItem:view attribute:NSLayoutAttributeTop
                               relatedBy:NSLayoutRelationEqual
                               toItem:viewSuper
                               attribute:NSLayoutAttributeTop
                               multiplier:1.0 constant:3] ];
    [self someMethod];
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
    if (dicMusic) {
        [dicMusic setObject:@(volume) forKey:@"volume"];
        if (_callback) {
            _callback(dicMusic);
        }
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
    if (dicMusic) {
        [dicMusic setObject:@(volume) forKey:@"volume"];
        if (_callback) {
            _callback(dicMusic);
        }
    }
}

-(IBAction)dismissView:(id)sender
{
    [self removeFromSuperview];
}

- (IBAction)volumeSliderEdittingDidBegin:(id)sender
{
    [timer invalidate];
    timer = nil;

    UISlider *slider = (UISlider*)sender;
    float volume =  slider.value;
    if (dicMusic) {
        [dicMusic setObject:@(volume) forKey:@"volume"];
        if (_callback) {
            _callback(dicMusic);
        }
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
-(void)showVolumeWithDicMusic:(NSDictionary*)dic
{
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSString *userLanguage = @"en";
    if (language.length >=2) {
        userLanguage = [language substringToIndex:2];
    }
    userLanguage = [language substringToIndex:2];

    [timer invalidate];
    timer = nil;
    timer = [NSTimer scheduledTimerWithTimeInterval: 5.0
                                                  target: self
                                                selector:@selector(dismissView:)
                                                userInfo: nil repeats:NO];
    dicMusic = [dic mutableCopy];
    NSString *strFullName;
    if ([dicMusic[@"titleFull"] isKindOfClass:[NSDictionary class]]) {
        
        if (dicMusic[@"titleFull"][userLanguage]) {
            strFullName = dicMusic[@"titleFull"][userLanguage];
        }
        else
        {
            strFullName = dicMusic[@"titleFull"][@"en"];

        }
    }
    else
    {
        strFullName = dicMusic[@"titleFull"];
    }
    self.titleFull.text = strFullName;
    
    NSString *strTitleShort;
    if ([dicMusic[@"titleShort"] isKindOfClass:[NSDictionary class]]) {
        
        if (dicMusic[@"titleShort"][userLanguage]) {
            strTitleShort = dicMusic[@"titleShort"][userLanguage];
        }
        else
        {
            strTitleShort = dicMusic[@"titleShort"][@"en"];
            
        }
    }
    else
    {
        strTitleShort = dicMusic[@"titleShort"];
    }
    NSString *strTitleOther;
    if ([dicMusic[@"titleOther"] isKindOfClass:[NSDictionary class]]) {
        
        if (dicMusic[@"titleOther"][userLanguage]) {
            strTitleOther = dicMusic[@"titleOther"][userLanguage];
        }
        else
        {
            strTitleOther = dicMusic[@"titleOther"][@"en"];
            
        }
    }
    else
    {
        strTitleOther = dicMusic[@"titleOther"];
    }
    if (strTitleOther.length > 0) {
        strTitleOther = [NSString stringWithFormat:@", %@",strTitleOther];
    }
    self.titleSub.text = [NSString stringWithFormat:@"%@ %@",strTitleShort,strTitleOther];
    [self.slider setValue:[dic[@"volume"] floatValue]];

}
//MARK: - PAN
-(void) someMethod {
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [panRecognizer setMinimumNumberOfTouches:1];
    [panRecognizer setMaximumNumberOfTouches:1];
    [self addGestureRecognizer:panRecognizer];
}

- (void)handlePan:(UIPanGestureRecognizer *)recognizer
{
    
    CGPoint translation = [recognizer translationInView:self];
    BOOL isVerticalPan = fabs(translation.y) > fabs(translation.x); // BOOL property
    if (isVerticalPan) {
        recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
                                             recognizer.view.center.y + translation.y);
        [recognizer setTranslation:CGPointMake(0, 0) inView:self];
        
    }
    if (recognizer.state == UIGestureRecognizerStateEnded) {
            self.hidden = YES;
    }

}
@end
