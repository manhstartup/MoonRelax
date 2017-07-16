//
//  SettingView.m
//  RelaxApp
//
//  Created by JoJo on 9/30/16.
//  Copyright © 2016 JoJo. All rights reserved.
//

#import "SettingView.h"
#import "Define.h"
#import <Social/Social.h>
#import <MessageUI/MessageUI.h>
#import "SettingAbout.h"
#import "SettingUpdate.h"
#import "NSDate+Extensions.h"
#import "FileHelper.h"
#import "Define.h"
#import "UIImage+ImageEffects.h"
#import "SettingCredit.h"
#import "AppDelegate.h"
#import "RageIAPHelper.h"
#import "AppCommon.h"
#import "UIAlertView+Blocks.h"
#import "SettingHeaderCell.h"
#import "SettingContentCell.h"
#import "SettingMD.h"
#import "SettingShareSocialCell.h"
static NSString *identifierSection1 = @"MyTableViewCell1";
static NSString *identifierSection2= @"MyTableViewCell2";
static NSString *identifierSection3= @"MyTableViewCell3";

@interface SettingView () <MFMailComposeViewControllerDelegate>
{
//    BOOL areUnlockPro;
    BOOL areAdsRemoved;
    NSArray *_products;
    NSMutableArray * arrData;

}
@property (strong, nonatomic) IBOutlet UITableView *tableControl;
@end
@implementation SettingView

-(void)awakeFromNib
{
    [super awakeFromNib];
    arrData = [NSMutableArray new];
    [self fnSetData];
    [self.tableControl registerNib:[UINib nibWithNibName:@"SettingHeaderCell" bundle:nil] forCellReuseIdentifier:identifierSection1];
    [self.tableControl registerNib:[UINib nibWithNibName:@"SettingContentCell" bundle:nil] forCellReuseIdentifier:identifierSection2];
    [self.tableControl registerNib:[UINib nibWithNibName:@"SettingShareSocialCell" bundle:nil] forCellReuseIdentifier:identifierSection3];

    self.tableControl.estimatedRowHeight = 44;
    self.lbShare.font = [UIFont fontWithName:@"Roboto-Light" size:20];
    self.lbShare.text = str(kYouLikeApp);
    self.lbTitle.text =  str(kSetting);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(caculatorTimeAgo) name: NOTIFCATION_CATEGORY object:nil];
    areAdsRemoved = VERSION_PRO?1:[[NSUserDefaults standardUserDefaults] boolForKey:kTotalRemoveAdsProductIdentifier];
//    areUnlockPro = [[NSUserDefaults standardUserDefaults] boolForKey:kUnlockProProductIdentifier];
//    _unlockPro.on = areUnlockPro;
    [self caculatorTimeAgo];
    [self.tableControl reloadData];
}
-(void)caculatorTimeAgo
{
    NSString *strPath = [FileHelper pathForApplicationDataFile:FILE_CATEGORY_SAVE];
    NSDictionary *dicTmp = [NSDictionary dictionaryWithContentsOfFile:strPath];
    if (dicTmp) {
        NSDate * inputDates = dicTmp[@"date"];
        for (int i = 0; i < arrData.count; i++) {
            NSMutableDictionary *dic = [arrData[i] mutableCopy];
            if ([dic[@"type"] integerValue] == SETTING_CELL_CHECK_NOW) {
                [dic setObject:[inputDates timeAgo]?[inputDates timeAgo]:@"" forKey:@"desc"];
                [arrData replaceObjectAtIndex:i withObject:dic];
                [self.tableControl reloadData];
                break;
            }

        }
    }

}
- (IBAction)shareAction:(id)sender {
    NSString *strLink = @"";
    if (VERSION_PRO) {
        strLink = @"https://goo.gl/ZbwJP8";
    }
    else
    {
        strLink = @"https://goo.gl/TsNxXP";
    }
    NSString * message = [NSString stringWithFormat:@"%@ %@",str(kMessageShareSocial),@"https://goo.gl/TsNxXP"] ;
    
//    UIImage * image = [UIImage imageNamed:@"icon"];
    
    NSArray * shareItems = @[message];
    
    UIActivityViewController * avc = [[UIActivityViewController alloc] initWithActivityItems:shareItems applicationActivities:nil];
    
    [self.parent presentViewController:avc animated:YES completion:nil];
    
}
//MARK: -FACEBOOK
- (IBAction)shareFacebookAction:(id)sender {
    
    // Facebook
    [self openUrl:@"http://fb.com/relafapp"];


}
-(void) openUrlInBrowser:(NSString *) url
{
    if (url.length > 0) {
        NSURL *linkUrl = [NSURL URLWithString:url];
        [[UIApplication sharedApplication] openURL:linkUrl];
    }
}
-(void) openUrl:(NSString *) urlString
{
    
    //check if facebook app exists
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fb://"]]) {
        
        // Facebook app installed
        NSArray *tokens = [urlString componentsSeparatedByString:@"/"];
        NSString *profileName = [tokens lastObject];
        
        //call graph api
        NSURL *apiUrl = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@",profileName]];
        NSData *apiResponse = [NSData dataWithContentsOfURL:apiUrl];
        if(!apiResponse)
        {
            [self openUrlInBrowser:urlString];
            return;
        }
        NSError *error = nil;
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:apiResponse options:NSJSONReadingMutableContainers error:&error];
        
        //check for parse error
        if (error == nil) {
            
            NSString *profileId = [jsonDict objectForKey:@"id"];
            
            if (profileId.length > 0) {//make sure id key is actually available
                NSURL *fbUrl = [NSURL URLWithString:[NSString stringWithFormat:@"fb://profile/%@",profileId]];
                [[UIApplication sharedApplication] openURL:fbUrl];
            }
            else{
                                [self openUrlInBrowser:urlString];
            }
            
        }
        else{//parse error occured
                        [self openUrlInBrowser:urlString];
        }
        
    }
    else{//facebook app not installed
                [self openUrlInBrowser:urlString];
    }
    
}

- (IBAction)shareTwitterAction:(id)sender {
    //twitter
    NSString *urlString = @"https://twitter.com/relafapp";
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter://"]])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    }
    else
    {
        [self openUrlInBrowser:urlString];
    }

}
- (IBAction)showEmail:(id)sender {
    // Email Subject
    NSString *emailTitle = @"";
    // Email Content
    NSString *messageBody = @"";
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:@"support@relafapp.com"];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    
    // Present mail view controller on screen
    if(mc)
    {
        [self.parent presentViewController:mc animated:YES completion:NULL];
    }
    
}
-(IBAction)aboutAction:(id)sender
{
    self.hidden = YES;
    SettingAbout *viewController1 = [[SettingAbout alloc] initWithClassName:NSStringFromClass([SettingAbout class])];
    [viewController1 addContraintSupview:self.parent.view];
    [viewController1 setCallback:^(){self.hidden = NO;}];
}
-(IBAction)updateAction:(id)sender
{
    if (![COMMON isReachableCheck]) {
        return;
    }

    SettingUpdate *viewController1 = [[SettingUpdate alloc] initWithClassName:NSStringFromClass([SettingUpdate class])];
    [viewController1 addContraintSupview:self.parent.view];
    viewController1.blurredBgImage.image = [self blurWithImageEffects:[self takeSnapshotOfView:self.parent.view]];

}
-(IBAction)creditAction:(id)sender
{
    
    self.hidden = YES;
    SettingCredit *viewController1 = [[SettingCredit alloc] initWithClassName:NSStringFromClass([SettingCredit class])];
    [viewController1 addContraintSupview:self.parent.view];
    [viewController1 setCallback:^(){self.hidden = NO;}];
}
-(IBAction)managerDownloadAction:(id)sender
{
    
    self.hidden = YES;
    SettingMD *viewController1 = [[SettingMD alloc] initWithClassName:NSStringFromClass([SettingMD class])];
    [viewController1 addContraintSupview:self.parent.view];
    [viewController1 setCallback:^(){self.hidden = NO;}];
}
-(IBAction)privacyAction:(id)sender
{
    [self openUrlInBrowser:@"https://www.relafapp.com/privacy.html"];

}
-(IBAction)helpTranslate:(id)sender
{
    [self openUrlInBrowser:@"http://relafapp.oneskyapp.com/collaboration/"];
    
}
-(IBAction)premiumVersionNoAds:(id)sender
{
    [self openUrlInBrowser:@"https://itunes.apple.com/us/app/relax-in-fantasy-live-less/id1167034842?mt=8"];
    
}
- (IBAction)switchUnlockProValueChanged:(id)sender
{
//    UISwitch *sw = (UISwitch*)sender;
//    if (areUnlockPro) {
//        sw.on = areUnlockPro;
//        return;
//    }
//    else
//    {
//        AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//        _products = app.arrAIP;
//        
//        NSString * productIdentifier = kUnlockProProductIdentifier;
//        [_products enumerateObjectsUsingBlock:^(SKProduct * product, NSUInteger idx, BOOL *stop) {
//            if ([product.productIdentifier isEqualToString:productIdentifier]) {
//                [[RageIAPHelper sharedInstance] buyProduct:product];
//                *stop = YES;
//            }
//        }];
//    }
}
- (IBAction)switchRemoveAdsProValueChanged:(id)sender
{
    UISwitch *sw = (UISwitch*)sender;
    if (areAdsRemoved || ![COMMON isReachableCheck]) {
        sw.on = areAdsRemoved;
        return;
    }
    else
    {
        NSString * productIdentifier = kTotalRemoveAdsProductIdentifier;
        [[RageIAPHelper sharedInstance] addProdcutPurchase:productIdentifier];
        AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        _products = app.arrAIP;
        if (_products.count > 0) {
            [_products enumerateObjectsUsingBlock:^(SKProduct * product, NSUInteger idx, BOOL *stop) {
                if ([product.productIdentifier isEqualToString:productIdentifier]) {
                    [[RageIAPHelper sharedInstance] buyProduct:product];
                    [self removeAds];
                    *stop = YES;
                }
                else
                {
                    [self reloadIAP];
                    
                }
            }];
        }
        else
        {
            [self reloadIAP];
        }
    }
}
-(void)removeAdsAction
{
    if (areAdsRemoved || ![COMMON isReachableCheck]) {
        return;
    }
    else
    {
        NSString * productIdentifier = kTotalRemoveAdsProductIdentifier;
        [[RageIAPHelper sharedInstance] addProdcutPurchase:productIdentifier];
        AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        _products = app.arrAIP;
        if (_products.count > 0) {
            [_products enumerateObjectsUsingBlock:^(SKProduct * product, NSUInteger idx, BOOL *stop) {
                if ([product.productIdentifier isEqualToString:productIdentifier]) {
                    [[RageIAPHelper sharedInstance] buyProduct:product];
                    [self removeAds];
                    *stop = YES;
                }
                else
                {
                    [self reloadIAP];
                    
                }
            }];
        }
        else
        {
            [self reloadIAP];
        }
    }

}
- (void)reloadIAP {
    NSString * productIdentifier = kTotalRemoveAdsProductIdentifier;
    [[RageIAPHelper sharedInstance] addProdcutPurchase:productIdentifier];

    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app reloadIAP];
    [app setCallbackAIP:^()
     {
         _products = app.arrAIP;
         [_products enumerateObjectsUsingBlock:^(SKProduct * product, NSUInteger idx, BOOL *stop) {
             if ([product.productIdentifier isEqualToString:productIdentifier]) {
                 [[RageIAPHelper sharedInstance] buyProduct:product];
                 [self removeAds];
                 *stop = YES;
             }
         }];

     }];
}

- (void)restoreTapped:(id)sender {
    [[RageIAPHelper sharedInstance] restoreCompletedTransactions];
}
-(void)removeAds
{
    [[RageIAPHelper sharedInstance] productPurchasedValidate:^(BOOL success, NSString *proIdentifier) {
        if ([proIdentifier isEqualToString:kTotalRemoveAdsProductIdentifier]) {
            [self doRemoveAds];
        }
    }];
}

- (void)doRemoveAds{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kTotalRemoveAdsProductIdentifier];
    areAdsRemoved = [[NSUserDefaults standardUserDefaults] boolForKey:kTotalRemoveAdsProductIdentifier];
    [[NSUserDefaults standardUserDefaults] synchronize];
//    areUnlockPro = [[NSUserDefaults standardUserDefaults] boolForKey:kUnlockProProductIdentifier];
    
//    _unlockPro.on = areUnlockPro;

    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFCATION_HIDE_ADS object:nil];

    
}
- (UIImage *)takeSnapshotOfView:(UIView *)view
{
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, [[UIScreen mainScreen] scale]);
    } else {
        UIGraphicsBeginImageContext(view.frame.size);
    }
    [view.layer renderInContext: UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
- (UIImage *)blurWithImageEffects:(UIImage *)image
{
    return [image applyBlurWithRadius:30 tintColor:[UIColor colorWithWhite:0 alpha:0.2] saturationDeltaFactor:1.5 maskImage:nil];
}
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self.parent dismissViewControllerAnimated:YES completion:NULL];
}
-(void)fnSetData
{

    NSMutableDictionary *dic1 = [@{@"name": str(kCheckUpdate),
                                   @"type": @(SETTING_CELL_HEADER)} copy];

    NSMutableDictionary *dic2 = [@{@"name": str(kCheckNow),
                                   @"desc":@"",
                                   @"type": @(SETTING_CELL_CHECK_NOW)} copy];
    //Preminum
    NSMutableDictionary *dic3 = [@{@"name": str(kPremium),
                                   @"type": @(SETTING_CELL_HEADER)} copy];
    NSMutableDictionary *dic4 = [@{@"name": str(kRemoveAds),
                                   @"desc":@"$2.99",
                                   @"type": @(SETTING_CELL_CHECK_REMOVE_ADS)} copy];
    NSMutableDictionary *dic5 = [@{@"name": str(kPremiumVersionNoAds),
                                   @"type": @(SETTING_CELL_CHECK_NO_ADS)} copy];
    //management
    NSMutableDictionary *dic6 = [@{@"name": str(kManagement),
                                   @"type": @(SETTING_CELL_HEADER)} copy];

    NSMutableDictionary *dic7 = [@{@"name": str(kManagementDownloaded),
                                   @"type": @(SETTING_CELL_CHECK_DOWLOAD)} copy];
    NSMutableDictionary *dic8 = [@{@"name": str(kRestorePurchased),
                                   @"type": @(SETTING_CELL_CHECK_PURCHASED)} copy];
    //let talk with us
    NSMutableDictionary *dic9 = [@{@"name": str(kLestTalk),
                                   @"type": @(SETTING_CELL_HEADER)} copy];
    NSMutableDictionary *dic10 = [@{@"name": str(kMailTo),
                                   @"desc":@"support@relafapp.com",
                                   @"type": @(SETTING_CELL_CHECK_MAILTO)} copy];
    NSMutableDictionary *dic11 = [@{@"name": str(kOurTwitter),
                                   @"desc":@"@relafapp",
                                   @"type": @(SETTING_CELL_CHECK_TWITTER)} copy];
    NSMutableDictionary *dic12 = [@{@"name": str(kOurFanpage),
                                    @"desc":@"http://fb.com/relafapp",
                                    @"type": @(SETTING_CELL_CHECK_FANPAGE)} copy];
    NSMutableDictionary *dic20 = [@{@"name": str(kHelpTranslate),
                                    @"desc":@"http://relafapp.oneskyapp.com/collaboration/",
                                    @"type": @(SETTING_CELL_HELP_TRANSLATE)} copy];

    
//About
    NSMutableDictionary *dic13 = [@{@"name":str(kAbout),
                                   @"type": @(SETTING_CELL_HEADER)} copy];
    NSMutableDictionary *dic14 = [@{@"name": str(kAbout),
                                   @"type": @(SETTING_CELL_CHECK_ABOUT)} copy];
    NSMutableDictionary *dic15 = [@{@"name": str(kCredit),
                                   @"type": @(SETTING_CELL_CHECK_CREDIT)} copy];
    NSString *strVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSMutableDictionary *dic16 = [@{@"name": str(kVersion),
                                    @"desc":strVersion?strVersion:@"",
                                   @"type": @(SETTING_CELL_CHECK_VERTION)} copy];

    NSMutableDictionary *dic17 = [@{@"name": str(kPrivacy),
                                   @"type": @(SETTING_CELL_CHECK_PRIVACY)} copy];
//copy right
    NSMutableDictionary *dic18 = [@{@"name": str(kCopyRight),
                                    @"type": @(SETTING_CELL_COPYRIGHT)} copy];
    NSMutableDictionary *dic19 = [@{@"name": str(kYouLikeApp),
                                   @"type": @(SETTING_CELL_SHARE_SOCIAL)} copy];
    [arrData addObject:dic19];
    [arrData addObject:dic1];
    [arrData addObject:dic2];
    if (!VERSION_PRO) {
        [arrData addObject:dic3];
        [arrData addObject:dic4];
        [arrData addObject:dic5];
    }
    [arrData addObject:dic6];
    [arrData addObject:dic7];
//    [arrData addObject:dic8];
    [arrData addObject:dic9];
    [arrData addObject:dic10];
    [arrData addObject:dic11];
    [arrData addObject:dic12];
    [arrData addObject:dic20];
    [arrData addObject:dic13];
    [arrData addObject:dic14];
    [arrData addObject:dic15];
    [arrData addObject:dic16];
    [arrData addObject:dic17];
    [arrData addObject:dic18];
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

    if ([dic[@"type"] integerValue] == SETTING_CELL_HEADER || [dic[@"type"] integerValue] == SETTING_CELL_COPYRIGHT) {

        SettingHeaderCell *cell = nil;
        
        cell = (SettingHeaderCell *)[self.tableControl dequeueReusableCellWithIdentifier:identifierSection1 forIndexPath:indexPath];
        
        //FONT
        cell.lbTitle.text = dic[@"name"];
        if ([dic[@"type"] integerValue] == SETTING_CELL_COPYRIGHT) {
            [cell.lbTitle setTextAlignment:NSTextAlignmentCenter];
        }
        else
        {
            [cell.lbTitle setTextAlignment:NSTextAlignmentLeft];
        }
        cell.backgroundColor=[UIColor whiteColor];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return cell;

    }
    else if ([dic[@"type"] integerValue] == SETTING_CELL_SHARE_SOCIAL) {
        
        SettingShareSocialCell *cell = nil;
        
        cell = (SettingShareSocialCell *)[self.tableControl dequeueReusableCellWithIdentifier:identifierSection3 forIndexPath:indexPath];
        
        //FONT
        cell.lbTitle.text = dic[@"name"];
        [cell.btnShare addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.backgroundColor=[UIColor whiteColor];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return cell;
        
    }
    else
    {
        SettingContentCell *cell = nil;
        
        cell = (SettingContentCell *)[self.tableControl dequeueReusableCellWithIdentifier:identifierSection2 forIndexPath:indexPath];
        cell.lbDescription.textColor = UIColorFromRGB(COLOR_TEXT_ITEM);
        cell.imgArrow.hidden = YES;
        cell.lbDescription.text = @"";
        cell.backgroundColor=[UIColor whiteColor];
        switch ([dic[@"type"] integerValue]) {
            case SETTING_CELL_CHECK_NOW:
            case SETTING_CELL_CHECK_MAILTO:
            case SETTING_CELL_CHECK_TWITTER:
            case SETTING_CELL_CHECK_FANPAGE:
            case SETTING_CELL_CHECK_VERTION:
            case SETTING_CELL_HELP_TRANSLATE:

            {
                cell.lbDescription.text = dic[@"desc"];

            }
                break;
            case SETTING_CELL_CHECK_REMOVE_ADS:
            {
                cell.lbDescription.textColor = UIColorFromRGB(COLOR_NAVIGATION_HOME);
                if (areAdsRemoved) {
                    cell.lbDescription.text = @"";
                    cell.backgroundColor = UIColorFromRGB(COLOR_NAVIGATION_HOME);
                }
                else
                {
                    cell.lbDescription.text = dic[@"desc"];
                }

            }
                break;
            case SETTING_CELL_CHECK_NO_ADS:
            {
                cell.imgArrow.hidden = NO;
            }
                break;
            case SETTING_CELL_CHECK_DOWLOAD:
            case   SETTING_CELL_CHECK_ABOUT:
            case  SETTING_CELL_CHECK_CREDIT:
            case SETTING_CELL_CHECK_PRIVACY:
            {
                cell.imgArrow.hidden = NO;
            }
                break;
            case SETTING_CELL_CHECK_PURCHASED:
            {
                cell.imgArrow.hidden = NO;
            }
                break;

            default:
                break;
        }

        //FONT
        cell.lbTitle.text = dic[@"name"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return cell;

    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary*dic = arrData[indexPath.row];
    switch ([dic[@"type"] integerValue]) {
        case SETTING_CELL_CHECK_NOW:
        {
            [self updateAction:nil];
        }
            break;
        case SETTING_CELL_CHECK_REMOVE_ADS:
        {
            [self removeAdsAction];
        }
            break;
        case SETTING_CELL_CHECK_MAILTO:
        {
            [self showEmail:nil];
        }
            break;
        case SETTING_CELL_CHECK_TWITTER:
        {
            [self shareTwitterAction:nil];
        }
            break;
        case SETTING_CELL_CHECK_FANPAGE:
        {
            [self shareFacebookAction:nil];
        }
            break;
        case SETTING_CELL_CHECK_ABOUT:
        {
            [self aboutAction:nil];
        }
            break;
        case SETTING_CELL_CHECK_CREDIT:
        {
            [self creditAction:nil];
        }
            break;

        case SETTING_CELL_CHECK_PRIVACY:
        {
            [self privacyAction:nil];
        }
            break;
        case SETTING_CELL_CHECK_DOWLOAD:
        {
            [self managerDownloadAction:nil];
        }
            break;
        case SETTING_CELL_HELP_TRANSLATE:
        {
            [self helpTranslate:nil];
        }
            break;
        case SETTING_CELL_CHECK_NO_ADS:
        {
            [self premiumVersionNoAds:nil];
        }
            break;
        
        default:
            break;
    }
    
}
@end
