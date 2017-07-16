//
//  AppCommon.h
//  Arcatime
//
//  Created by ocsdeveloper12 on 16/07/13.
//  Copyright (c) 2013 ocsdeveloper12. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "Reachability.h"
#import "AppDelegate.h"

@interface AppCommon : UIViewController<UIApplicationDelegate> {
}

+(AppCommon *) common;
//Reachability
-(BOOL) isReachableCheck;
-(BOOL) isReachable;

@end

extern AppCommon *SharedCommon;
#define COMMON (SharedCommon? SharedCommon:[AppCommon common])

