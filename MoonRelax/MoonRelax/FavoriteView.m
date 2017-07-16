//
//  FavoriteView.m
//  RelaxApp
//
//  Created by JoJo on 9/30/16.
//  Copyright © 2016 JoJo. All rights reserved.
//

#import "FavoriteView.h"
#import "Define.h"
#import "AHTagTableViewCell.h"
#import "FileHelper.h"
#import "UIAlertView+Blocks.h"
#import "AppDelegate.h"
#import "AppCommon.h"
static NSString *identifierSection1 = @"MyTableViewCell1";
@import FirebaseAnalytics;

@implementation FavoriteView

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    self.lbEdit.font = [UIFont fontWithName:@"Roboto-Regular" size:17];
    [self.tableControl registerNib:[UINib nibWithNibName:@"AHTagTableViewCell" bundle:nil] forCellReuseIdentifier:identifierSection1];
    self.tableControl.estimatedRowHeight = 60;
    self.tableControl.allowsSelectionDuringEditing = YES;
    self.vViewEdit.hidden = YES;
    //LAG
    self.lbTitle.text = str(kListFavorites);
    [self loadCahe];
}
-(void)loadCahe
{
    //read in cache
    NSString *strPath = [FileHelper pathForApplicationDataFile:FILE_FAVORITE_SAVE];
    NSArray *arrTmp = [NSArray arrayWithContentsOfFile:strPath];
    _arrMusic = [arrTmp mutableCopy];
    if (_arrMusic.count >0) {
        self.vViewEdit.hidden = NO;
    }
    else
    {
        self.vViewEdit.hidden = YES;
    }
    [self.tableControl reloadData];

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
    return _arrMusic.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AHTagTableViewCell *cell = nil;
    
    cell = (AHTagTableViewCell *)[self.tableControl dequeueReusableCellWithIdentifier:identifierSection1 forIndexPath:indexPath];
    
    NSDictionary *dicMusic = _arrMusic[indexPath.row];
    
    [cell fnSetDataWithDicMusic:dicMusic];
    [cell.label setCallback:^(NSDictionary *dicMusic)
     {
         AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
         [app shareSocial:dicMusic];
     }];
//    cell.btnSelect.tag=indexPath.row;
//    [cell.btnSelect addTarget:self action:@selector(selectCell:) forControlEvents:UIControlEventTouchUpInside];

    cell.backgroundColor=[UIColor clearColor];
    cell.tintColor = [UIColor blueColor];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //__weak FavoriteView *wself = self;
    NSDictionary *dicMusic = _arrMusic[indexPath.row];
    if (tableView.editing) {
        //favorite
        /*
        self.vAddFavorite = [[AddFavoriteView alloc] initWithClassName:NSStringFromClass([AddFavoriteView class])];
        [self.vAddFavorite addContraintSupview:self];
        self.vAddFavorite.modeType = MODE_EDIT;
        [self.vAddFavorite setCallback:^(NSDictionary *dicCategory)
         {
             [wself loadCahe];
         }];

        [self.vAddFavorite fnSetInfoFavorite:dicMusic];
         */
        

    }
    else
    {
        // [START custom_event_objc]
        [FIRAnalytics logEventWithName:@"selected_favoriste"
                            parameters:dicMusic];
        // [END custom_event_objc]
        //show ads
        areAdsRemoved = VERSION_PRO?1:[[NSUserDefaults standardUserDefaults] boolForKey:kTotalRemoveAdsProductIdentifier];
        if (areAdsRemoved) {
            if (_callback) {
                _callback(dicMusic);
                [self removeFromSuperview];
            }
        }
        else
        {
            if (![COMMON isReachableCheck]) {
                return ;
            }
            [UIAlertView showWithTitle:nil message:str(kWatchAdsAavorite)
                     cancelButtonTitle:str(kCancel)
                     otherButtonTitles:@[str(kuOK)]
                              tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                                  
                                  if (buttonIndex == 1) {
                                      AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
                                      [app startNewAds];
                                      [app setCallbackDismissAds:^()
                                       {
                                           if (_callback) {
                                               _callback(dicMusic);
                                               [self removeFromSuperview];
                                           }
                                       }];
                                      
                                  }
                              }];
        }

    }
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
        [_arrMusic removeObjectAtIndex:indexPath.row];
        //add code here for when you hit delete
        NSString *strPath = [FileHelper pathForApplicationDataFile:FILE_FAVORITE_SAVE];
        [_arrMusic writeToFile:strPath atomically:YES];
        if (_arrMusic.count==0) {
            [self editingTableViewAction:nil];
        }
        [self loadCahe];
    }
}
@end
