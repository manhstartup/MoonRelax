//
//  MDTimerBackGround.h
//  RelaxApp
//
//  Created by JoJo on 10/6/16.
//  Copyright © 2016 JoJo. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^MDTimerBackGroundCallback)(NSDictionary *dicTimer);
typedef void (^TimerTickCallback)();

@interface MDTimerBackGround : NSObject
{
    NSTimer* timer;
}
@property (nonatomic,copy) MDTimerBackGroundCallback callback;
@property (nonatomic,copy) TimerTickCallback  callbackTimerTick;
+ (MDTimerBackGround *) sharedInstance;

@end
