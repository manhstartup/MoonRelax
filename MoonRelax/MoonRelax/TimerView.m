//
//  TimerView.m
//  RelaxApp
//
//  Created by JoJo on 9/30/16.
//  Copyright © 2016 JoJo. All rights reserved.
//

#import "TimerView.h"
#import "Define.h"
#import "TimerCell.h"
#import "CreaterTimer.h"
#import "FileHelper.h"
#import "AppDelegate.h"
#import "MDTimerBackGround.h"
#import "UIAlertView+Blocks.h"
#import "AppCommon.h"
static NSString *identifierSection1 = @"MyTableViewCell1";

@implementation TimerView

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.lbEdit.font = [UIFont fontWithName:@"Roboto-Regular" size:17];
    self.lbTitle.text = str(kTimer);
    self.lbEdit.text = str(kEdit);

    [self.tableControl registerNib:[UINib nibWithNibName:@"TimerCell" bundle:nil] forCellReuseIdentifier:identifierSection1];
    self.tableControl.estimatedRowHeight = 60;
    self.tableControl.allowsSelectionDuringEditing = YES;
    self.vViewEdit.hidden = YES;
    [self loadCache];
    __weak TimerView *wself = self;
    //timer
    MDTimerBackGround *timerBackGround = [MDTimerBackGround sharedInstance];
    [timerBackGround setCallback:^(NSDictionary *dicTimer)
     {
         
     }];
    [timerBackGround setCallbackTimerTick:^(NSDate *date)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             if (!self.tableControl.editing) {
                 [wself loadCache];
             }
         });
     }];
}
-(void)loadCache
{
    //read in cache
    NSString *strPath = [FileHelper pathForApplicationDataFile:FILE_TIMER_SAVE];
    NSArray *arrTmp = [NSArray arrayWithContentsOfFile:strPath];
    _dataSource = [NSMutableArray new];
    if (arrTmp.count > 0) {
        [_dataSource addObjectsFromArray:arrTmp];
        self.vViewEdit.hidden = NO;
    }
    else
    {
        self.vViewEdit.hidden = YES;
    }

    for (UITableViewCell *cell in [self.tableControl visibleCells]) {
        NSIndexPath *indexPath = [self.tableControl indexPathForCell:cell];
        if(_dataSource.count > indexPath.row)
        {
            [self configureCell:cell forRowAtIndexPath:indexPath];
        }
    }
}
-(IBAction)addTimerAction:(id)sender
{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:str(kChooseTimerType) message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:str(kCancel) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        // Cancel button tappped do nothing.
        
        
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:str(kCountDown) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self createrTimerWithType:TIMER_COUNTDOWN];
    }]];

    [actionSheet addAction:[UIAlertAction actionWithTitle:str(kClock) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [self createrTimerWithType:TIMER_CLOCK];
        
    }]];
    [self.parent presentViewController:actionSheet animated:YES completion:nil];
}
-(void)createrTimerWithType:(TIMER_TYPE)type
{
    __weak TimerView *wself =self;
    CreaterTimer *viewController1 = [[CreaterTimer alloc] initWithNibName:@"CreaterTimer" bundle:nil];
    viewController1.timerType = type;
    viewController1.typeMode = MODE_CREATE;
    [viewController1 setCallback:^()
     {
         [wself loadCache];
         [self.tableControl reloadData];
     }];
    [self.parent presentViewController:viewController1 animated:YES completion:^{
    }];

}
-(IBAction)editingTableViewAction:(id)sender
{
    [self.tableControl setEditing: !self.tableControl.editing animated: YES];
    if (self.tableControl.editing) {
        self.lbEdit.text = str(kDone);
    }
    else
    {
        self.lbEdit.text = str(kEdit);
    }
}
//section Mes...Mes_groupes
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
    
}
- (void)configureCell:(UITableViewCell *)cellTmp forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cellTmp isKindOfClass:[TimerCell class]])
    {
        TimerCell *cell = (TimerCell *)cellTmp;
    NSDictionary *dic = _dataSource[indexPath.row];
    cell.lbNameTimer.text = dic[@"name"];
    int countdown = [dic[@"countdown"] intValue];
    if (countdown >0) {
        NSDate *date = [self setCountDownTime:countdown];
        cell.lbValueTimer.text = [self convertDateToString:date withType:[dic[@"type"] intValue]];
    }
    else
    {
        cell.lbValueTimer.text = [self convertDateToString:dic[@"timer"] withType:[dic[@"type"] intValue]];
    }
        cell.lbDescription.text = str(dic[@"description"]) ;
    
    [cell.swOnOff setOn:[dic[@"enabled"] boolValue]];
    [cell.swOnOff addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
    cell.swOnOff.tag = indexPath.row + 100;
    
    cell.backgroundColor=[UIColor clearColor];
    cell.tintColor = [UIColor blueColor];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TimerCell *cell = (TimerCell *)[self.tableControl dequeueReusableCellWithIdentifier:identifierSection1 forIndexPath:indexPath];
    [self configureCell:cell forRowAtIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}


- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        [_dataSource removeObjectAtIndex:indexPath.row];
        NSString *strPath = [FileHelper pathForApplicationDataFile:FILE_TIMER_SAVE];
        [_dataSource writeToFile:strPath atomically:YES];
        if (_dataSource.count == 0) {
            [self editingTableViewAction:nil];
        }
        [self loadCache];
        [self.tableControl reloadData];
    }
}
-(NSString*)convertDateToString:(NSDate*)date withType:(TIMER_TYPE)type
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if (type == TIMER_COUNTDOWN) {
        [formatter setDateFormat:@"HH:mm:ss"];
    }
    else
    {
        [formatter setDateFormat:@"HH:mm a"];
    }
    
    NSString *stringFromDate = [formatter stringFromDate:date];
    return stringFromDate;
}
-(NSDate*)convertStringToDate:(NSString*)dateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:dateString];
    return date;
}
//MARK: -ACTION
- (void)switchValueChanged:(id)sender
{
    areAdsRemoved = VERSION_PRO?1:[[NSUserDefaults standardUserDefaults] boolForKey:kTotalRemoveAdsProductIdentifier];
    if (areAdsRemoved) {
        NSString *strPath = [FileHelper pathForApplicationDataFile:FILE_TIMER_SAVE];
        
        UISwitch *sv = (UISwitch*)sender;
        int index = (int)sv.tag - 100;
        NSMutableDictionary *dic = [_dataSource[index]mutableCopy];
        [dic setObject:@(![dic[@"enabled"] boolValue]) forKey:@"enabled"];
        if ([dic[@"enabled"] boolValue]) {
            int countdown = [self convertSecondsFromString:[self convertDateToString:dic[@"timer"] withType:[dic[@"type"] intValue]]];
            [dic setObject:@(countdown) forKey:@"countdown"];
            //show ads
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFCATION_SHOW_ADS object:nil];
        }
        [_dataSource replaceObjectAtIndex:index withObject:dic];
        [_dataSource writeToFile:strPath atomically:YES];
        [self.tableControl reloadData];
        
    }
    else
    {
        if (![COMMON isReachableCheck]) {
            return ;
        }
        //show ads
        [UIAlertView showWithTitle:str(kWatchOneAdvertisement) message:str(kWatchAdsEnableTimer)
                 cancelButtonTitle:str(kCancel)
                 otherButtonTitles:@[str(kuOK)]
                          tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                              
                              if (buttonIndex == 1) {
                                  AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
                                  [app startNewAds];
                                  [app setCallbackDismissAds:^()
                                   {
                                       NSString *strPath = [FileHelper pathForApplicationDataFile:FILE_TIMER_SAVE];
                                       
                                       UISwitch *sv = (UISwitch*)sender;
                                       int index = (int)sv.tag - 100;
                                       NSMutableDictionary *dic = [_dataSource[index]mutableCopy];
                                       [dic setObject:@(![dic[@"enabled"] boolValue]) forKey:@"enabled"];
                                       if ([dic[@"enabled"] boolValue]) {
                                           int countdown = [self convertSecondsFromString:[self convertDateToString:dic[@"timer"] withType:[dic[@"type"] intValue]]];
                                           [dic setObject:@(countdown) forKey:@"countdown"];
                                           //show ads
                                           [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFCATION_SHOW_ADS object:nil];
                                       }
                                       [_dataSource replaceObjectAtIndex:index withObject:dic];
                                       [_dataSource writeToFile:strPath atomically:YES];
                                       [self.tableControl reloadData];
                                       
                                   }];
                              }
                          }];
    }
    
}
-(int)convertSecondsFromString:(NSString*)strTimer
{
    NSArray *arrTimer = [strTimer componentsSeparatedByString:@":"];
    if (arrTimer.count >2) {
        int hours = [arrTimer[0] intValue];
        int minutes = [arrTimer[1] intValue];
        int seconds = [arrTimer[2] intValue];
        return (hours*60*60 + minutes*60 + seconds);
    }
    else
    {
        return 0;
    }
}
- (NSDate*)setCountDownTime:(NSTimeInterval)time{
    
    NSInteger ti = (NSInteger)time;
    NSInteger seconds = ti % 60;
    NSInteger minutes = (ti / 60) % 60;
    NSInteger hours = (ti / 3600);
    NSString *strDate = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", (long)hours, (long)minutes, (long)seconds];
   return [self convertStringToDate: strDate];
}
@end
