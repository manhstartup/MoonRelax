//
//  MDTimerBackGround.m
//  RelaxApp
//
//  Created by JoJo on 10/6/16.
//  Copyright © 2016 JoJo. All rights reserved.
//

#import "MDTimerBackGround.h"
#import "FileHelper.h"
#import "Define.h"
static MDTimerBackGround *sharedInstance = nil;

@implementation MDTimerBackGround
+ (MDTimerBackGround *) sharedInstance
{
    static dispatch_once_t once = 0;
    
    dispatch_once(&once, ^{sharedInstance = [[self alloc] init];});
    return sharedInstance;
}
-(id)init
{
    if (self = [super init]) {
        [self timerBackGround];
        return self;
    }
    
    return nil;
}



-(void)setCallback:(MDTimerBackGroundCallback)callback
{
    _callback = callback;
}
-(void)setCallbackTimerTick:(TimerTickCallback)callbackTimerTick
{
    _callbackTimerTick = callbackTimerTick;
}
-(void)timerBackGround
{
    [self stopTimerBackGround];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        //How often to update the clock labels
        timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(myTimerAction) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
        [[NSRunLoop currentRunLoop] run];
    });
    
    
}
-(void)stopTimerBackGround
{
    [timer invalidate];
    timer = nil;
}
-(void)myTimerAction
{
    NSDate *date = [NSDate date];
    NSString *strCurrentDate = [self convertDateToString:date];
    NSString *strPath = [FileHelper pathForApplicationDataFile:FILE_TIMER_SAVE];
    NSArray *arrTmp = [NSArray arrayWithContentsOfFile:strPath];
    if (arrTmp.count> 0) {
        NSMutableArray *arrSave = [arrTmp mutableCopy];
        for (int i = 0; i < arrSave.count; i++) {
            NSDictionary *dicTimer = arrSave[i];
            if ([dicTimer[@"enabled"] boolValue]) {
                if ([dicTimer[@"type"] intValue] == TIMER_CLOCK) {
                    NSString *strTimer = [self convertDateToString:dicTimer[@"timer"]];
                    if ([self checkDateEqualDate:strCurrentDate withTimer:strTimer]) {
                        if (_callback) {
                            _callback(dicTimer);
                        }
                    }
                }
                else
                {
                    int countDown = [dicTimer[@"countdown"] intValue];
                    if (countDown == 0) {
                        if (_callback) {
                            _callback(dicTimer);
                        }
                        NSMutableDictionary *dicTmp = [dicTimer mutableCopy];
                        [dicTmp setObject:@(0) forKey:@"enabled"];
                        [arrSave replaceObjectAtIndex:i withObject:dicTmp];
                    }
                    else
                    {
                        countDown -= 1;
                        NSMutableDictionary *dicTmp = [dicTimer mutableCopy];
                        [dicTmp setObject:@(countDown) forKey:@"countdown"];
                        [arrSave replaceObjectAtIndex:i withObject:dicTmp];
                    }
                    [arrSave writeToFile:strPath atomically:YES];
                    
                }
            }
        }
        
    }
    if (_callbackTimerTick) {
        _callbackTimerTick(nil);
    }
}

-(NSDate*)convertStringToDate:(NSString*)dateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    
    NSDate *date = [dateFormatter dateFromString:dateString];
    return date;
}
-(NSString*)convertDateToString:(NSDate*)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss"];
    NSString *stringFromDate = [formatter stringFromDate:date];
    return stringFromDate;
}
-(BOOL)checkDateEqualDate:(NSString*)time1 withTimer:(NSString*)time2
{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss"];
    
    NSDate *date1= [formatter dateFromString:time1];
    NSDate *date2 = [formatter dateFromString:time2];
    
    NSComparisonResult result = [date1 compare:date2];
    if(result == NSOrderedSame)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
@end
