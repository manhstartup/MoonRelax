//
//  CreaterTimer.m
//  RelaxApp
//
//  Created by Manh on 10/4/16.
//  Copyright © 2016 JoJo. All rights reserved.
//

#import "CreaterTimer.h"
#import "Define.h"
#import "FileHelper.h"
@interface CreaterTimer ()
{
    NSArray *_arrCategory;
    NSDictionary *dicChooseCategory;
    int statusPlay;
}
@end

@implementation CreaterTimer

- (void)viewDidLoad {
    [super viewDidLoad];
    self.lbAdd.font = [UIFont fontWithName:@"Roboto-Regular" size:17];
    self.lbDescription.font = [UIFont fontWithName:@"Roboto-Regular" size:10];
    self.tfTitle.font = [UIFont fontWithName:@"Roboto-Regular" size:18];
    self.lbPlay.font = [UIFont fontWithName:@"Roboto-Regular" size:17];
    self.lbPause.font = [UIFont fontWithName:@"Roboto-Regular" size:17];
    self.lbChooseTimer.font = [UIFont fontWithName:@"Roboto-Regular" size:13];
    self.lbPlayFavorite.font = [UIFont fontWithName:@"Roboto-Regular" size:13];
    //LAG
    self.lbTitle.text = str(kTimer);
    self.lbAdd.text = str(kAdd);
    self.lbPause.text = str(kPause);
    self.lbPlay.text = str(kPlaying);
    self.lbChooseTimer.text =str(kuCHOOSETIMER);
    self.lbPlayFavorite.text = str(kuPLAYWITHFAVORITE);

    
    self.imgBackGround.backgroundColor = UIColorFromAlpha(COLOR_NAVIGATION_HOME, 0.8);
    // read cache favorite
    NSString *strPath = [FileHelper pathForApplicationDataFile:FILE_FAVORITE_SAVE];
    NSArray *arrTmp = [NSArray arrayWithContentsOfFile:strPath];
    _arrCategory = arrTmp;
    _timeToSetOff.backgroundColor = [UIColor whiteColor];
    if (_timerType == TIMER_COUNTDOWN) {
        _timeToSetOff.datePickerMode =UIDatePickerModeCountDownTimer;
        self.lbDescription.text =str(kCountDown);
    }
    else
    {
        _timeToSetOff.datePickerMode =UIDatePickerModeTime;
        self.lbDescription.text = str(kClock);
        
    }
//    [_timeToSetOff setValue:[UIColor whiteColor] forKey:@"textColor"];
//    [_timeToSetOff setValue:@(0.8) forKey:@"alpha"];
    [self.tfTitle setValue:[[UIColor whiteColor] colorWithAlphaComponent:0.5]
                    forKeyPath:@"_placeholderLabel.textColor"];
    self.tfTitle.placeholder = str(kTypeAnything);
    self.imgCheckPause.hidden = YES;
    self.imgCheckPlaying.hidden = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dismissKeyboard {
    [self.view endEditing:YES];
}
-(void)setCallback:(CreaterTimerCallback)callback
{
    _callback =callback;
}
-(IBAction)statusAction:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    if (btn.tag == 11) {
        statusPlay = 2;
        self.imgCheckPlaying.hidden = NO;
        self.imgCheckPause.hidden = YES;
    }
    else
    {
        statusPlay = 1;
        self.imgCheckPlaying.hidden = YES;
        self.imgCheckPause.hidden = NO;
    }
}
-(IBAction)closeAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}
-(IBAction)saveAction:(id)sender
{
    if (_tfTitle.text.length > 0) {
        if (statusPlay <= 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NAME_APP
                                                            message:str(kChoosesPause)
                                                           delegate:self
                                                  cancelButtonTitle:str(kuOK)
                                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
        if (_typeMode == MODE_CREATE) {
           int rowPickerView = (int)[_pickerFavorite selectedRowInComponent:0];
            dicChooseCategory = _arrCategory[rowPickerView];
            //read in cache
            NSString *strPath = [FileHelper pathForApplicationDataFile:FILE_TIMER_SAVE];
            NSArray *arrTmp = [NSArray arrayWithContentsOfFile:strPath];
            
            NSDictionary *lastTimer = [arrTmp lastObject];
            int _id = [lastTimer[@"id"] intValue] + 1;
            NSDictionary *dic = @{@"id": @(_id),
                                  @"name": _tfTitle.text,
                                  @"enabled": @(0),
                                  @"description":_timerType == TIMER_COUNTDOWN? @"Countdown":@"Clock",
                                  @"timer": _timeToSetOff.date,
                                  @"type": @(_timerType),
                                  @"id_favorite":dicChooseCategory[@"id"]?dicChooseCategory[@"id"]:@"",
                                  @"isplay": statusPlay==2?@(1):@(0)
                                  };
            NSMutableArray *arrSave = [NSMutableArray new];
            if (arrTmp) {
                [arrSave addObjectsFromArray:arrTmp];
            }
            [arrSave addObject:dic];
            //save cache
            [arrSave writeToFile:strPath atomically:YES];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:str(kCongratulations)
                                                            message:str(kTimeCreatedSucessful)
                                                           delegate:self
                                                  cancelButtonTitle:str(kuOK)
                                                  otherButtonTitles:nil];
            [alert show];
            [self closeAction:nil];
            if (_callback) {
                _callback();
            }
            

        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NAME_APP
                                                        message:str(kEnterName)
                                                       delegate:self
                                              cancelButtonTitle:str(kuOK)
                                              otherButtonTitles:nil];
        [alert show];

    }
}
//MARK: - PICKER VIEW DELEGATE
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    
    return _arrCategory.count;
}
- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSDictionary *dicFavo = _arrCategory[row];
    return [NSString stringWithFormat:@"%@",dicFavo[@"name"]];
}
-(void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
 }

@end
