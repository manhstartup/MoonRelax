//
//  AHTagTableViewCell.m
//  AutomaticHeightTagTableViewCell
//
//  Created by WEI-JEN TU on 2016-07-16.
//  Copyright © 2016 Cold Yam. All rights reserved.
//

#import "AHTagTableViewCell.h"
#import "Define.h"
@implementation AHTagTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.title.font = [UIFont fontWithName:@"Roboto-Medium" size:13];
    self.title.textColor = UIColorFromRGB(COLOR_TEXT_ITEM);
    // Initialization code
    _dataSource = [NSMutableArray new];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)fnSetDataWithDicMusic:(NSDictionary*)dicMusic
{
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSString *userLanguage = @"en";
    if (language.length >=2) {
        userLanguage = [language substringToIndex:2];
    }
    userLanguage = [language substringToIndex:2];

    self.title.text = [dicMusic[@"name"] uppercaseString];
    _dataSource = [NSMutableArray new];

    NSArray *arrMusic = dicMusic[@"music"];
    for (NSDictionary *dicMusic in arrMusic) {
        AHTag *tag = [AHTag new];
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
        

        tag.title =strTitleShort;
        [_dataSource addObject:tag];
    }
    [self.label fnSetTags:_dataSource withDicMusic:dicMusic withScreen:FAVORITE_SCREEN_INFO];

}
@end
