//
//  AddFavoriteView.m
//  RelaxApp
//
//  Created by JoJo on 10/4/16.
//  Copyright © 2016 JoJo. All rights reserved.
//

#import "AddFavoriteView.h"
#import "FileHelper.h"
@implementation AddFavoriteView

-(void)awakeFromNib
{
    [super awakeFromNib];
    //LAG
    self.lbCancel.text = str(kCancel);
    self.lbTitle.text = str(kAddToFavorites);
    self.tfTitle.placeholder = str(kWriteSomething);
    [self.btnSave setTitle:str(kSave) forState:UIControlStateNormal];

    self.lbCancel.font = [UIFont fontWithName:@"Roboto-Regular" size:17];
    self.btnSave.titleLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:20];
    [self.vContent.layer setMasksToBounds:YES];
    self.vContent.layer.cornerRadius= 5.0;
    [self.btnSave.layer setMasksToBounds:YES];
    self.btnSave.layer.cornerRadius= 5.0;
    self.imgBG.backgroundColor = UIColorFromAlpha(COLOR_NAVIGATION_HOME, 0.8);
        
    _dataSource = [NSMutableArray new];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self addGestureRecognizer:tap];

}
-(void)dismissKeyboard {
    [self endEditing:YES];
}
-(void)fnSetInfoFavorite:(NSDictionary*)dicFavorite
{
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSString *userLanguage = @"en";
    if (language.length >=2) {
        userLanguage = [language substringToIndex:2];
    }
    userLanguage = [language substringToIndex:2];

    _dicFavorite = dicFavorite;
    if (_modeType == MODE_INFO) {
        _tfTitle.enabled = NO;
        _btnSave.hidden = YES;
        self.lbTitle.text =str(kInfoToFavorites);
    }
    else
    {
        self.lbTitle.text = str(kEditToTavorites);
    }
    _tfTitle.text = dicFavorite[@"name"];
    
    _dataSource = [NSMutableArray new];
    
    _dataMusic = dicFavorite[@"music"];
    for (NSDictionary *dicMusic in _dataMusic) {
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
    [self.label fnSetTags:_dataSource withDicMusic:dicFavorite withScreen:FAVORITE_SCREEN_ADD] ;

}
-(void)fnSetDataMusic:(NSArray*)arr
{
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSString *userLanguage = @"en";
    if (language.length >=2) {
        userLanguage = [language substringToIndex:2];
    }
    userLanguage = [language substringToIndex:2];

    self.lbTitle.text = str(kAddToFavorites);
    _dataSource = [NSMutableArray new];

    _dataMusic = arr;
    for (NSDictionary *dicMusic in arr) {
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
    [self.label fnSetTags:_dataSource withDicMusic:nil withScreen:FAVORITE_SCREEN_ADD] ;
}
-(IBAction)saveAction:(id)sender
{
    if (_tfTitle.text.length > 0) {
        if (_modeType == MODE_EDIT) {
            NSString *strPath = [FileHelper pathForApplicationDataFile:FILE_FAVORITE_SAVE];
            NSArray *arrTmp = [NSArray arrayWithContentsOfFile:strPath];
            NSMutableArray *arrSave = [NSMutableArray new];
            if (arrTmp) {
                [arrSave addObjectsFromArray:arrTmp];
            }
            
            for (int i = 0 ; i< arrSave.count; i++) {
                if ([_dicFavorite[@"id"] intValue] == [arrSave[i][@"id"]intValue]) {
                    NSDictionary *dicSave = @{@"id":_dicFavorite[@"id"],@"name": [_tfTitle.text uppercaseString],@"music": _dicFavorite[@"music"]};
                    [arrSave replaceObjectAtIndex:i withObject:dicSave];
                    [arrSave writeToFile:strPath atomically:YES];
                    [self removeFromSuperview];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:str(kCongratulations)
                                                                    message:str(kFavoCreatedSucessful)
                                                                   delegate:self
                                                          cancelButtonTitle:str(kuOK)
                                                          otherButtonTitles:nil];
                    [alert show];
                    if (_callback) {
                        _callback(dicSave);
                    }
                    break;
                }
            }
        }
        else
        {
            //read in cache
            NSString *strPath = [FileHelper pathForApplicationDataFile:FILE_FAVORITE_SAVE];
            NSArray *arrTmp = [NSArray arrayWithContentsOfFile:strPath];
            NSDictionary *lastFavorite = [arrTmp lastObject];
            int _id = [lastFavorite[@"id"] intValue] + 1;
            NSDictionary *dicSave = @{@"id":@(_id),@"name": _tfTitle.text,@"music": _dataMusic};
            
            NSMutableArray *arrSave = [NSMutableArray new];
            if (arrTmp) {
                [arrSave addObjectsFromArray:arrTmp];
            }
            [arrSave addObject:dicSave];
            //save cache
            [arrSave writeToFile:strPath atomically:YES];
            [self removeFromSuperview];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:str(kCongratulations)
                                                            message:str(kFavoCreatedSucessful)
                                                           delegate:self
                                                  cancelButtonTitle:str(kuOK)
                                                  otherButtonTitles:nil];
            [alert show];

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
-(IBAction)cancelAction:(id)sender
{
    self.hidden = YES;
}
-(void)setCallback:(AddFavoriteViewCallback)callback
{
    _callback = callback;
}
@end
