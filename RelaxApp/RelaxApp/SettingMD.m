//
//  CreaterTimer.m
//  RelaxApp
//
//  Created by Manh on 10/4/16.
//  Copyright © 2016 JoJo. All rights reserved.
//

#import "SettingMD.h"
#import "Define.h"
#import "FileHelper.h"
#import "SettingHeaderCell.h"
#import "SettingContentCell.h"
#import "UIAlertView+Blocks.h"
static NSString *identifierMD1 = @"identifierMD1";
static NSString *identifierMD2 = @"identifierMD2";

@interface SettingMD ()
{
    NSMutableArray * arrCategory;
    NSMutableArray * arrData;

}
@property (strong, nonatomic) IBOutlet UITableView *tableControl;

@end

@implementation SettingMD

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.lbEdit.font = [UIFont fontWithName:@"Roboto-Regular" size:17];
    self.imgBackGround.backgroundColor = UIColorFromRGB(COLOR_BACKGROUND_FAVORITE);
    [self.tableControl registerNib:[UINib nibWithNibName:@"SettingHeaderCell" bundle:nil] forCellReuseIdentifier:identifierMD1];
    [self.tableControl registerNib:[UINib nibWithNibName:@"SettingContentCell" bundle:nil] forCellReuseIdentifier:identifierMD2];
    self.tableControl.estimatedRowHeight = 44;
    arrData = [NSMutableArray new];
    arrCategory = [NSMutableArray new];
    self.lbTitle.text = @"Management";
//    NSMutableDictionary *dic1 = [@{@"name": @"Management downloaded",
//                                   @"type": @(SETTING_CELL_HEADER)} copy];
//    [arrData addObject:dic1];
    [self loadCache];
    [self.tableControl reloadData];



}
-(void)loadCache
{
    NSString *strPath = [FileHelper pathForApplicationDataFile:FILE_CATEGORY_SAVE];
    NSDictionary *dicTmp = [NSDictionary dictionaryWithContentsOfFile:strPath];
    if (dicTmp) {
        [arrCategory removeAllObjects];
        //check exist in blacklist
        NSString *strPathBlackList = [FileHelper pathForApplicationDataFile:FILE_BLACKLIST_CATEGORY_SAVE];
        NSArray *arrBL = [NSArray arrayWithContentsOfFile:strPathBlackList];
        
        NSString *strManagerDownload = [FileHelper pathForApplicationDataFile:FILE_MANAGER_DOWNLOAD_SAVE];
        NSArray *arrMD = [NSArray arrayWithContentsOfFile:strManagerDownload];

        NSMutableArray *arrFull = [NSMutableArray new];
        [arrFull addObjectsFromArray:arrBL];
        [arrFull addObjectsFromArray:arrMD];
        NSArray *arrTmp = dicTmp[@"category"];
        for (NSDictionary *dic in arrTmp) {
            if (![arrFull containsObject:dic[@"id"]]) {
                NSString *path = [self getFullPathWithFileName:dic[@"path"]];
                NSFileManager *fileManager = [[NSFileManager alloc] init];
                BOOL isDir;
                BOOL exists = [fileManager fileExistsAtPath:path isDirectory:&isDir];
                if (dic[@"sounds"] && exists) {
                    [arrCategory addObject:dic];
                }
            }
        }
    }
    [arrData addObjectsFromArray:arrCategory];
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
#pragma mark - TABLEVIEW
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
        
        cell = (SettingHeaderCell *)[self.tableControl dequeueReusableCellWithIdentifier:identifierMD1 forIndexPath:indexPath];
        
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
        
        cell = (SettingContentCell *)[self.tableControl dequeueReusableCellWithIdentifier:identifierMD2 forIndexPath:indexPath];
        cell.lbDescription.textColor = UIColorFromRGB(COLOR_TEXT_ITEM);
        cell.imgArrow.hidden = YES;
        cell.lbDescription.text = @"";
        cell.imgArrow.hidden = NO;
        //FONT
        NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
        NSString *userLanguage = @"en";
        if (language.length >=2) {
            userLanguage = [language substringToIndex:2];
        }
        userLanguage = [language substringToIndex:2];

        NSString *strName;
        if ([dic[@"name"] isKindOfClass:[NSDictionary class]]) {
            
            if (dic[@"name"][userLanguage]) {
                strName = dic[@"name"][userLanguage];
            }
            else
            {
                strName = dic[@"name"][@"en"];
                
            }
        }
        else
        {
            strName = dic[@"name"];
        }
        
        cell.lbTitle.text = strName;
        cell.backgroundColor=[UIColor whiteColor];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
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
        [UIAlertView showWithTitle:nil message:str(kSureDelete)
                 cancelButtonTitle:str(kCancel)
                 otherButtonTitles:@[str(kuOK)]
                          tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                              
                              if (buttonIndex == 1) {
                                  //OK button handler
                                  NSDictionary*dic = arrData[indexPath.row];
                                  if (!([dic[@"type"] integerValue] == SETTING_CELL_HEADER)) {
                                      NSString *path = [self getFullPathWithFileName:dic[@"path"]];
                                      NSFileManager *fileManager = [[NSFileManager alloc] init];
                                      BOOL isDir;
                                      BOOL exists = [fileManager fileExistsAtPath:path isDirectory:&isDir];
                                      if (exists) {
                                          
                                          NSError *error;
                                          BOOL success = [fileManager removeItemAtPath:path error:&error];
                                          BOOL success2 = [fileManager removeItemAtPath:[NSString stringWithFormat:@"%@.zip",path] error:&error];
                                          
                                          if (!(success && success2)) {
                                              NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
                                              
                                          }
                                          
                                      }
                                      NSString *strPath = [FileHelper pathForApplicationDataFile:FILE_MANAGER_DOWNLOAD_SAVE];
                                      NSArray *blackList = [ NSArray arrayWithContentsOfFile:strPath];
                                      NSMutableArray *arrTmp = [NSMutableArray arrayWithArray:blackList];
                                      [arrTmp addObject:dic[@"id"]];
                                      [arrTmp writeToFile:strPath atomically:YES];
                                      [arrData removeObjectAtIndex:indexPath.row];
                                      [self.tableControl reloadData];
                                      
                                      [UIAlertView showWithTitle:nil message:str(kSuccess)
                                               cancelButtonTitle:str(kuOK)
                                               otherButtonTitles:nil
                                                        tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                                                        }];
                                      [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFCATION_CATEGORY object:nil];
                                      
                                  }
                              }
                              else
                              {
                                  //Cancel button handler
                                  
                              }
                          }];


    }
}

-(NSString*)getFullPathWithFileName:(NSString*)fileName
{
    NSArray       *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString  *documentsDirectory = [paths objectAtIndex:0];
    NSString *archivePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    return archivePath;
}
@end
