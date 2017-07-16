
//
//  NSDate+Extensions.m
//  demo
//
//  Created by Admin on 3/29/15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "NSDate+Extensions.h"
//Dates


@implementation NSDate (NSDateForNSString)

#pragma mark - Time ago

-(NSString *)timeAgo
{
    NSDate *now = [NSDate date];
    double deltaSeconds = fabs([self timeIntervalSinceDate:now]) - 5*60 - 20;
    //    double deltaSeconds = fabs([self timeIntervalSinceDate:now]);
    double deltaMinutes = deltaSeconds / 60.0f;
    if(deltaSeconds < 5) {
        return @"Just now";
    } else if(deltaSeconds < 60) {
        return [NSString stringWithFormat:@"%d seconds ago.", (int)deltaSeconds];
    } else if(deltaSeconds < 120) {
        return @"Last 1 minute ago";
    } else if (deltaMinutes < 60) {
        return [NSString stringWithFormat:@"Last %d minutes ago", (int)deltaMinutes];
    } else if (deltaMinutes < 120) {
        return @"Last 1 hours ago";
    } else if (deltaMinutes < (24 * 60)) {
        return [NSString stringWithFormat:@"Last %d hours ago", (int)floor(deltaMinutes/60)];
    } else if (deltaMinutes < (24 * 60 * 2)) {
        return @"Yesterday";
    } else if (deltaMinutes < (24 * 60 * 7)) {
        return [NSString stringWithFormat:@"Last %d days ago", (int)floor(deltaMinutes/(60 * 24))];
    } else if (deltaMinutes < (24 * 60 * 31)) {
        return [NSString stringWithFormat:@"ago %d week ago", (int)floor(deltaMinutes/(60 * 24 * 7))];
    } else if (deltaMinutes < (24 * 60 * 61)) {
        return @"Last 1 month ago";
    } else if (deltaMinutes < (24 * 60 * 365.25)) {
        return [NSString stringWithFormat:@"Last %d month ago", (int)floor(deltaMinutes/(60 * 24 * 30))];
    } else if (deltaMinutes < (24 * 60 * 731)) {
        return @"Last year ago";
    }
    return [NSString stringWithFormat: @"Last %d year ago" , (int)floor(deltaMinutes/(60 * 24 * 365))];
}

@end
