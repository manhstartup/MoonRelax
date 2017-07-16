//
//  AHTagsLabel.h
//  AutomaticHeightTagTableViewCell
//
//  Created by WEI-JEN TU on 2016-07-16.
//  Copyright © 2016 Cold Yam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AHTag.h"
typedef void (^AHTagsLabelCallback)(NSDictionary *dicMusic);

@interface AHTagsLabel : UILabel
@property (nonatomic, strong) NSArray *tags;
@property (nonatomic, strong) NSDictionary *dicMusic;
- (void)fnSetTags:(NSArray*)tags withDicMusic:(NSDictionary*)dicMusic withScreen:(int)screen;
@property (nonatomic,copy) AHTagsLabelCallback callback;

@end
