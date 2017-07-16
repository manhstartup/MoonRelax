//
//  CreaterTimer.m
//  RelaxApp
//
//  Created by Manh on 10/4/16.
//  Copyright © 2016 JoJo. All rights reserved.
//

#import "SettingCredit.h"
#import "Define.h"
#import "FileHelper.h"
#import "SettingHeaderCell.h"
#import "SettingContentCell.h"

static NSString *identifierSC1 = @"identifierSC1";
static NSString *identifierSC2 = @"identifierSC2";
@interface SettingCredit ()
{
    NSMutableArray * arrData;

}
@property (strong, nonatomic) IBOutlet UITableView *tableControl;

@end

@implementation SettingCredit

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.lbTitle.text               = str(kCredit);
    [self.tableControl registerNib:[UINib nibWithNibName:@"SettingHeaderCell" bundle:nil] forCellReuseIdentifier:identifierSC1];
    [self.tableControl registerNib:[UINib nibWithNibName:@"SettingContentCell" bundle:nil] forCellReuseIdentifier:identifierSC2];
    self.tableControl.estimatedRowHeight = 44;
    arrData = [NSMutableArray new];

    self.imgBackGround.backgroundColor = UIColorFromRGB(COLOR_BACKGROUND_FAVORITE);
    [self fnSetData];
    [self.tableControl reloadData];
}
-(void)setCallback:(SettingCreditCallback)callback
{
    _callback = callback;
}
-(void)dismissKeyboard {
    [self endEditing:YES];
}

-(IBAction)closeAction:(id)sender
{
    if (_callback) {
        _callback();
    }
    [self removeFromSuperview];
}
-(void)fnSetData
{
    NSMutableDictionary *dic1 = [@{@"name": str(kGiveSpecialThanksTo),
                                   @"type": @(SETTING_CELL_HEADER)} copy];
    
    NSMutableDictionary *dic2 = [@{@"name": @"Nguyen Ngoc Anh singer"} copy];
    NSMutableDictionary *dic3 = [@{@"name": @"Manh Le : iOS development"} copy];
    NSMutableDictionary *dic8 = [@{@"name": @"Kevin Xu: Chinese translate"} copy];

    NSMutableDictionary *dic4 = [@{@"name": str(kCredit),
                                   @"type": @(SETTING_CELL_HEADER)} copy];
    
    NSMutableString *strName = [NSMutableString new];
    /*
    [strName appendString:@"Li Yang"];
    [strName appendString:@"\nunsplash.com/photos/_vPCiuXL2HE"];
    [strName appendString:@"\n\nGriffin Keller"];
    [strName appendString:@"\nunsplash.com/photos/7oS_26cb1Wo"];
    [strName appendString:@"\n\nJiri Sifalda"];
    [strName appendString:@"\nunsplash.com/photos/ITjiVXcwVng"];
    [strName appendString:@"\n\nJamie Street"];
    [strName appendString:@"\nunsplash.com/photos/3IEZsaXmzzs"];
    [strName appendString:@"\n\nNasa"];
    [strName appendString:@"\nunsplash.com/photos/Q1p7bh3SHj8"];
    [strName appendString:@"\n\nThomas Griesbeck"];
    [strName appendString:@"\nunsplash.com/photos/BS-Uxe8wU5Y"];
    [strName appendString:@"\n\nAlberto Restifo"];
    [strName appendString:@"\nunsplash.com/photos/wpMQWrjwPLs"];
    [strName appendString:@"\n\nVicentiu Solomon"];
    [strName appendString:@"\nunsplash.com/photos/In5drpv_lml"];
     */
    [strName appendString:@"photos from unsplash.com and pexels.com"];

    NSMutableDictionary *dic5 = [@{@"name":strName} copy];
    
    NSMutableDictionary *dic6 = [@{@"name": str(kOpenSource),
                                   @"type": @(SETTING_CELL_HEADER)} copy];
    
    NSMutableDictionary *dic7 = [@{@"name":@"IDZAQAudioPlayer\nAFNetworking\nSSZipArchive\nSDWebImage"} copy];
    [arrData addObject:dic1];
    [arrData addObject:dic2];
    [arrData addObject:dic3];
    [arrData addObject:dic8];
    [arrData addObject:dic4];
    [arrData addObject:dic5];
    [arrData addObject:dic6];
    [arrData addObject:dic7];


}
#pragma mark - TABLEVIEW
//section Mes...Mes_groupes
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}


//    You should be using a different reuseIdentifier for each of the two sections, since they are fundamentally differently styled cells.

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = arrData[indexPath.row];
    
    if ([dic[@"type"] integerValue] == SETTING_CELL_HEADER) {
        
        SettingHeaderCell *cell = nil;
        
        cell = (SettingHeaderCell *)[self.tableControl dequeueReusableCellWithIdentifier:identifierSC1 forIndexPath:indexPath];
        
        //FONT
        cell.lbTitle.text = dic[@"name"];
        [cell.lbTitle setTextAlignment:NSTextAlignmentLeft];
        cell.backgroundColor=[UIColor whiteColor];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return cell;
        
    }
    else
    {
        SettingContentCell *cell = nil;
        
        cell = (SettingContentCell *)[self.tableControl dequeueReusableCellWithIdentifier:identifierSC2 forIndexPath:indexPath];
        cell.lbDescription.textColor = UIColorFromRGB(COLOR_TEXT_ITEM);
        cell.imgArrow.hidden = YES;
        cell.lbDescription.text = @"";
        cell.imgArrow.hidden = YES;
        //FONT
        cell.lbTitle.text = dic[@"name"];
        cell.backgroundColor=[UIColor whiteColor];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

@end
