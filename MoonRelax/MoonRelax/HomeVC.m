//
//  HomeVC.m
//  RelaxApp
//
//  Created by JoJo on 9/27/16.
//  Copyright © 2016 JoJo. All rights reserved.
//

#import "HomeVC.h"
#import "CollectionVC.h"
#import "SSZipArchive.h"
#import "IDZTrace.h"
#import "IDZOggVorbisFileDecoder.h"
#import "DownLoadCategory.h"
#import "FileHelper.h"
#import "Define.h"
#import "AppDelegate.h"
#import <MediaPlayer/MediaPlayer.h>
#import "UIAlertView+Blocks.h"
#import "RageIAPHelper.h"
#import "AppCommon.h"
#import <RevMobAds/RevMobAds.h>
@import GoogleMobileAds;
@interface HomeVC ()<UIScrollViewDelegate,AVAudioSessionDelegate,GADInterstitialDelegate,GADBannerViewDelegate>
{
    NSMutableArray                  *arrCategory;
    NSMutableArray                  *arrPlayList;
    NSMutableArray                  *arrColection;
    NSMutableArray *arrTotal;
    int iNumberCollection;
    BOOL areAdsRemoved;
    BOOL isAdsMob;
}
@property (nonatomic, strong) RevMobBannerView *bannerViewRevMobAds;

@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //LAG
    self.lbVolume.text = str(kuVOLUME);
    self.lbFavorite.text = str(kuFAVORITE);
    self.lbTimer.text = str(kuTIMER);
    self.lbSetting.text = str(kuSETTING);

    [self showAds];
    self.imgBackgroundNavigation.backgroundColor = UIColorFromRGB(COLOR_NAVIGATION_HOME);
    self.imgBackGround.backgroundColor = [UIColor whiteColor];
    self.vTabVC.backgroundColor = UIColorFromRGB(COLOR_TABBAR_BOTTOM);
    self.vTabVC.layer.shadowOffset = CGSizeMake(0, -2);
    self.vTabVC.layer.shadowRadius = 3;
    self.vTabVC.layer.shadowOpacity = 0.4;

    self.navigationController.navigationBar.hidden = YES;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.progressView1.popUpViewAnimatedColors = @[UIColorFromRGB(COLOR_PROGRESS_HOZI), UIColorFromRGB(COLOR_PROGRESS_HOZI), UIColorFromRGB(COLOR_PROGRESS_HOZI)];
    self.progressView1.hidden = YES;
    self.vNavHome.hidden = NO;
    self.titleCategory.font = [UIFont fontWithName:@"Roboto-Regular" size:17];
    self.lbVolume.font = [UIFont fontWithName:@"Roboto-Regular" size:8];
    self.lbFavorite.font = [UIFont fontWithName:@"Roboto-Regular" size:8];
    self.lbTimer.font = [UIFont fontWithName:@"Roboto-Regular" size:8];
    self.lbSetting.font = [UIFont fontWithName:@"Roboto-Regular" size:8];
    //
    self.imagBack.hidden = YES;
    self.imgNext.hidden = YES;
    self.pageControl.tintColor = UIColorFromRGB(COLOR_PAGECONTROL_TINT);
    self.pageControl.currentPageIndicatorTintColor = UIColorFromRGB(COLOR_PAGECONTROL_CURRENT);

//    [self randomBackGround];
    arrCategory  = [NSMutableArray new];
    arrPlayList = [NSMutableArray new];
    arrColection = [NSMutableArray new];
    self.scroll_View.delegate = self;
    self.imgSingle.hidden = YES;
    [self fnSetButtonNavigation];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timerNotification:) name: NOTIFCATION_TIMER object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUpdate) name: NOTIFCATION_CATEGORY object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideAdsAction) name: NOTIFCATION_HIDE_ADS object:nil];
    
    //default button type
    self.buttonType = BUTTON_RANDOM;
    [self fnSetButtonBottom];
    //volume
    [self addSubViewVolumeTotal];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback
                                           error:nil];
    [[AVAudioSession sharedInstance] setActive:YES
                                         error:nil];
    [[AVAudioSession sharedInstance] addObserver:self
                                      forKeyPath:@"outputVolume"
                                         options:0
                                         context:nil];
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
    //hide view volume system
    CGRect frame = CGRectMake(-1000, -1000, 0, 0);
    self.volumeView = [[MPVolumeView alloc] initWithFrame:frame];
    [self.view addSubview: self.volumeView];
    
    [self loadCache];
    
}
-(void)viewWillDisappear:(BOOL)animated {
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder]; [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([keyPath isEqual:@"outputVolume"]) {
        [self.vVolumeTotal showVolume:YES];
    }
}
- (BOOL)prefersStatusBarHidden {
    return NO;
}
-(void)refreshUpdate
{
    UIButton *btn = [UIButton new];
    btn.tag = 12;
    _buttonType = BUTTON_SETTING;
    [self tabBottomVCAction:btn];
    
    [self loadCache];
    
}

//MARK: - NETWORK
-(void)loadCache
{
    
    if (![COMMON isReachableCheck]) {
    }
    
    NSString *strPath = [FileHelper pathForApplicationDataFile:FILE_CATEGORY_SAVE];
    NSDictionary *dicTmp = [NSDictionary dictionaryWithContentsOfFile:strPath];
    if (dicTmp) {
        [arrCategory removeAllObjects];
        //check exist in blacklist
        NSString *strPathMD = [FileHelper pathForApplicationDataFile:FILE_MANAGER_DOWNLOAD_SAVE];
        NSArray *arrMD = [NSArray arrayWithContentsOfFile:strPathMD];

        NSString *strPathBlackList = [FileHelper pathForApplicationDataFile:FILE_BLACKLIST_CATEGORY_SAVE];
        NSArray *arrBlackList = [NSArray arrayWithContentsOfFile:strPathBlackList];
        NSMutableArray *arrFull = [NSMutableArray new];
        [arrFull addObjectsFromArray:arrMD];
        [arrFull addObjectsFromArray:arrBlackList];
        
        NSArray *arrTmp = dicTmp[@"category"];
        for (NSDictionary *dic in arrTmp) {
            if (![arrFull containsObject:dic[@"id"]]) {
                [arrCategory addObject:dic];
            }
        }
        [self caculatorSubScrollview];
    }
    else
    {
        if ([COMMON isReachableCheck]) {
            [self getCategory];
        }
    }
    
}
-(void)showAds
{
    // Replace this ad unit ID with your own ad unit ID.
    areAdsRemoved = VERSION_PRO?1:[[NSUserDefaults standardUserDefaults] boolForKey:kTotalRemoveAdsProductIdentifier];
    if (areAdsRemoved) {
        [self hideAdsAction];
    }
    else
    {
        self.bannerView.adUnitID = FIREBASE_BANNER_UnitID;
        self.bannerView.rootViewController = self;
        self.bannerView.delegate = self;
        GADRequest *request = [GADRequest request];
        //        request.testDevices = @[@"39a7131f0ddf6c07dd8e764042b786e2edb0d7d5",
        //                                @"f1b375470fbe578bbaffd54c92170f5b91554f56",
        //                                @"492e5fc39e75b5d1015b03ea3e6979997f72442d",
        //                                @"73761a8a7e4f7e45547af96fe009872e67598cb2",
        //                                @"ba1e422fb34ca93c161b25b78371d4bf64a9bd08"];
        // Requests test ads on devices you specify. Your test device ID is printed to the console when
        // an ad request is made. GADBannerView automatically returns test ads when running on a
        [self.bannerView loadRequest:request];
        
    }
    //
}
//MARK: -  Rev MobAds
-(void)showRevMobAds
{
    [RevMobAds startSessionWithAppID:REVMOB_ID
                  withSuccessHandler:^{
                      [self showBannerWithCustomFrame];
                  } andFailHandler:^(NSError *error) {
                      //For now we don't need this
                      isAdsMob = NO;
                  }];
}
- (void)showBannerWithCustomFrame {
    self.bannerViewRevMobAds = [[RevMobAds session] bannerView];
    [self.bannerViewRevMobAds loadWithSuccessHandler:^(RevMobBannerView *bannerV) {
        if (isAdsMob) {
            return;
        }
        //If you're using delegates, please notice that this method won't call the revmobBannerDidDisplay delegate
        CGFloat width = self.view.bounds.size.width;
        CGFloat height = self.view.bounds.size.height;
        bannerV.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        bannerV.frame = CGRectMake(0, height - 50, width, 50);
        [self.view addSubview:bannerV];
        [self displayAds:YES];
    } andLoadFailHandler:^(RevMobBannerView *banner, NSError *error) {
        //Banner failed to load
        isAdsMob = NO;
    } onClickHandler:^(RevMobBannerView *banner) {
        //Banner was clicked
        isAdsMob = NO;
    }];
}
- (void)hideCustomBanner {
    [self.bannerViewRevMobAds removeFromSuperview];
}
-(void)getCategory
{
    __weak HomeVC *wself = self;
    managerCategory = [AFHTTPSessionManager manager];
    [managerCategory GET:[NSString stringWithFormat:@"%@%@",BASE_URL,@"data.json"] parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        if ([responseObject[@"categories"] isKindOfClass:[NSArray class]]) {
            //free
            [arrCategory removeAllObjects];
            //check exist in blacklist
            NSString *strPathMD = [FileHelper pathForApplicationDataFile:FILE_MANAGER_DOWNLOAD_SAVE];
            NSArray *arrMD = [NSArray arrayWithContentsOfFile:strPathMD];
            
            NSString *strPathBlackList = [FileHelper pathForApplicationDataFile:FILE_BLACKLIST_CATEGORY_SAVE];
            NSArray *arrBlackList = [NSArray arrayWithContentsOfFile:strPathBlackList];
            NSMutableArray *arrFull = [NSMutableArray new];
            [arrFull addObjectsFromArray:arrMD];
            [arrFull addObjectsFromArray:arrBlackList];
            
            NSMutableArray *arrTmp = [NSMutableArray new];
            for (NSDictionary *dic in responseObject[@"categories"]) {
                if (![arrFull containsObject:dic[@"id"]]) {
                    [arrTmp addObject:dic];
                }
                
            }
            [arrCategory addObjectsFromArray:arrTmp];
            [wself caculatorSubScrollview];
            NSString *strPath = [FileHelper pathForApplicationDataFile:FILE_CATEGORY_SAVE];
            if (arrCategory.count > 0) {
                NSDate *date = [NSDate date];
                NSDictionary *dicTmp = @{@"category": arrCategory,@"date":date};
                [dicTmp writeToFile:strPath atomically:YES];
            }
            
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}
//MARK: - TIMER PLAY
- (void)timerNotification:(NSNotification *)notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        // code here
        NSDictionary *dicTimer = (NSDictionary*)[notification object];
        if ([dicTimer[@"isplay"] boolValue]) {
            NSString *strPath = [FileHelper pathForApplicationDataFile:FILE_FAVORITE_SAVE];
            NSArray *arrTmp = [NSArray arrayWithContentsOfFile:strPath];
            NSString *strFavoriteID = dicTimer[@"id_favorite"];
            if ([strFavoriteID intValue] > 0) {
                for (NSDictionary *dicFavorite in arrTmp) {
                    if ([dicFavorite[@"id"] intValue] == [strFavoriteID intValue]) {
                        //playing
                        self.dicChooseCategory = dicFavorite;
                        NSArray *chooseMusic = self.dicChooseCategory[@"music"];
                        [self fnPlayerFromFavorite:chooseMusic];
                        break;
                    }
                    
                }
                if (arrPlayList.count > 0) {
                    _buttonType = BUTTON_PLAYING;
                }
                [self fnSetButtonBottom];
            }
            
        }
        else
        {
            //pause
            if (arrPlayList.count > 0) {
                if (_buttonType == BUTTON_PLAYING) {
                _buttonType = BUTTON_PAUSE;
                }
                for (int i = 0; i < arrPlayList.count; i ++) {
                    NSDictionary *musicItem = arrPlayList[i];
                    IDZAQAudioPlayer *player  = musicItem[@"player"];
                    [player pause];
                }
                
            }
        }
        
    });
}


//MARK: - VOLUME
-(IBAction)volumeAction:(id)sender
{
    [self.vVolumeTotal showVolume:self.vVolumeTotal.hidden];
    if (!self.vVolumeTotal.hidden) {
        self.lbVolume.textColor = UIColorFromRGB(COLOR_PAGE_ACTIVE);
        self.imgVolume.hidden = YES;
        self.imgVolumeActive.hidden = NO;
        
    }
    else
    {
        self.lbVolume.textColor = UIColorFromRGB(COLOR_TEXT_ITEM);
        self.imgVolume.hidden = NO;
        self.imgVolumeActive.hidden = YES;
        
    }
}

-(void) addSubViewVolumeTotal
{
    __weak HomeVC *wself = self;
    [self.vVolumeTotal removeFromSuperview];
    
    self.vVolumeTotal = [[VolumeView alloc] initWithClassName:NSStringFromClass([VolumeView class])];
    [self.vVolumeTotal setup];
    [self addVolumeTotalContraintSupview: self.vVolumeTotal];
    [self.vVolumeTotal setCallback:^()
     {
         [wself changeVolumeTotal];
         
     }];
    [self.vVolumeTotal setCallbackDismiss:^()
     {
         if (!wself.vVolumeTotal.hidden) {
             wself.lbVolume.textColor = UIColorFromRGB(COLOR_PAGE_ACTIVE);
             wself.imgVolume.hidden = YES;
             wself.imgVolumeActive.hidden = NO;
             
         }
         else
         {
             wself.lbVolume.textColor = UIColorFromRGB(COLOR_TEXT_ITEM);
             wself.imgVolume.hidden = NO;
             wself.imgVolumeActive.hidden = YES;
             
         }
     }];
    self.vVolumeTotal.hidden = YES;
}
-(void)addVolumeTotalContraintSupview:(UIView*)view
{
    UIView *viewSuper = self.view;
    UIView *viewBottom  = self.vTabVC;
    view.translatesAutoresizingMaskIntoConstraints = NO;
    view.frame = viewSuper.frame;
    
    [viewSuper addSubview:view];
    [viewSuper addConstraint: [NSLayoutConstraint
                               constraintWithItem:view attribute:NSLayoutAttributeBottom
                               relatedBy:NSLayoutRelationEqual
                               toItem:viewBottom
                               attribute:NSLayoutAttributeTop
                               multiplier:1.0 constant:0] ];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute: NSLayoutAttributeNotAnAttribute
                                                    multiplier:1
                                                      constant:50]];
    [viewSuper addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[view]-(0)-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(view)]];
}
-(void)changeVolumeTotal
{
    for (int i = 0; i < arrPlayList.count; i++) {
        NSDictionary *musicItem = arrPlayList[i];
        IDZAQAudioPlayer *player  = musicItem[@"player"];
        [player setVolume:[musicItem[@"music"][@"volume"] floatValue]];
    }
}
-(void) addSubViewVolumeItemWithDicMusic:(NSDictionary*)dicMusic withCategory:(NSDictionary *)dicCategory
{
    __weak HomeVC *wself = self;
    [self.vVolumeItem removeFromSuperview];
    self.vVolumeItem = [[VolumeItem alloc] initWithClassName:NSStringFromClass([VolumeItem class])];
    [self.vVolumeItem addContraintSupview:self.vContrainer];
    [self.vVolumeItem showVolumeWithDicMusic:dicMusic];
    [self.vVolumeItem setCallback:^(NSDictionary *dicMusic)
     {
         [wself updateDataMusic:dicMusic withCategory:dicCategory];
         [wself saveVolume:dicMusic withCategory:dicCategory];
     }];
    
}
-(void)saveVolume:(NSDictionary*)dic withCategory:(NSDictionary *)category
{
    //save volume
    NSString *strID = [NSString stringWithFormat:@"%@%@",category[@"id"],dic[@"id"]];

    NSString *strPathVolume = [FileHelper pathForApplicationDataFile:FILE_HISTORY_VOLUME_SAVE];
    NSArray *arrVolume = [NSArray arrayWithContentsOfFile:strPathVolume];
    NSMutableArray *arrMulVolme = [NSMutableArray arrayWithArray:arrVolume];
    
    BOOL isSetVolume = NO;
    if (arrVolume.count > 0) {
        for (int i = 0; i <arrVolume.count; i++) {
            NSMutableDictionary *dicVolume = [NSMutableDictionary dictionaryWithDictionary:arrVolume[i]];
            NSString *strVolumeID = dicVolume[@"id"];
            if ([strVolumeID isEqualToString: strID] ) {
                if (dic[@"volume"]) {
                    [dicVolume setObject:dic[@"volume"] forKey:@"volume"];
                    [arrMulVolme replaceObjectAtIndex:i withObject:dicVolume];
                }
                isSetVolume = YES;
                break;
            }
        }
    }
    if (!isSetVolume) {
        [arrMulVolme addObject:@{@"id": strID,@"volume": dic[@"volume"]}];
    }
    [arrMulVolme writeToFile:strPathVolume atomically:YES];
    
}


//MARK: - CLEAR ALL
-(IBAction)clearAll:(id)sender
{
    _dicChooseCategory = nil;
    [self fnClearAllSounds];
    [self fnSetButtonNavigation];
    _buttonType = BUTTON_RANDOM;
    [self fnSetButtonBottom];
}
-(void)fnClearAllSounds
{
    [self fnSetButtonNavigation];
    for (int i = 0; i< arrCategory.count; i++) {
        NSMutableDictionary *dicCategory = [arrCategory[i] mutableCopy];
        NSMutableArray *arrSounds = [dicCategory[@"sounds"] mutableCopy];
        for (int j = 0; j <arrSounds.count; j++) {
            NSMutableDictionary *dicSound = [arrSounds[j] mutableCopy];
            [dicSound setObject:@(0) forKey:@"active"];
            [arrSounds replaceObjectAtIndex:j withObject:dicSound];
            [dicCategory setObject:arrSounds forKey:@"sounds"];
            [arrCategory replaceObjectAtIndex:i withObject:dicCategory];
            [self setupPlayerWithMusicItem:dicSound withCategory:dicCategory];
        }
    }
    [self caculatorSubScrollview];
    
}
//MARK: - FAVORITE
-(IBAction)addFavoriteAction:(id)sender
{
    if (_dicChooseCategory) {
        // show info Favotite
        //favorite
        self.vAddFavorite = [[AddFavoriteView alloc] initWithClassName:NSStringFromClass([AddFavoriteView class])];
        [self.vAddFavorite addContraintSupview:self.view];
        self.vAddFavorite.modeType = MODE_INFO;
        [self.vAddFavorite fnSetInfoFavorite:_dicChooseCategory];
        
    }
    else
    {
        NSMutableArray *arrChoose = [NSMutableArray new];
        for (int i = 0; i< arrCategory.count; i++) {
            NSMutableArray *arrSounds = [arrCategory[i][@"sounds"] mutableCopy];
            for (int j = 0; j <arrSounds.count; j++) {
                NSMutableDictionary *dicSound = [arrSounds[j] mutableCopy];
                if ([dicSound[@"active"] boolValue] == YES) {
                    [arrChoose addObject:dicSound];
                }
            }
        }
        //favorite
        self.vAddFavorite = [[AddFavoriteView alloc] initWithClassName:NSStringFromClass([AddFavoriteView class])];
        [self.vAddFavorite addContraintSupview:self.view];
        self.vAddFavorite.modeType = MODE_CREATE;
        [self.vAddFavorite fnSetDataMusic:arrChoose];
        
    }
}
-(void)fnPlayerFromFavorite:(NSArray*)chooseFavotite
{
    //clear befor
    [self fnClearAllSounds];
    //set list choose from favorite
    for (NSDictionary *dichChoose in chooseFavotite) {
        
        for (int i = 0; i< arrCategory.count; i++) {
            NSMutableDictionary *dicCategory = [arrCategory[i] mutableCopy];
            if ([dicCategory[@"id"] intValue] == [dichChoose[@"category_id"] intValue]) {
                NSMutableArray *arrSounds = [dicCategory[@"sounds"] mutableCopy];
                for (int j = 0; j <arrSounds.count; j++) {
                    NSMutableDictionary *dicSound = [arrSounds[j] mutableCopy];
                    if ([dicSound[@"id"] intValue] == [dichChoose[@"id"] intValue]) {
                        [dicSound setObject:dichChoose[@"volume"] forKey:@"volume"];
                        [dicSound setObject:dichChoose[@"active"] forKey:@"active"];
                        [dicSound setObject:dicCategory[@"id"] forKey:@"category_id"];
                        
                        //show music
                        [arrSounds replaceObjectAtIndex:j withObject:dicSound];
                        [dicCategory setObject:arrSounds forKey:@"sounds"];
                        [arrCategory replaceObjectAtIndex:i withObject:dicCategory];
                        [self setupPlayerWithMusicItem:dicSound withCategory:dicCategory];
                        break;
                        
                    }
                }

            }
        }
    }
    
    [self caculatorSubScrollview];
    [self fnSetButtonNavigation];
    
}
//MARK: - PLAYER
-(void)updateDataMusic:(NSDictionary*)dicMusic withCategory:(NSDictionary *)category
{
    
    for (int i = 0; i< arrCategory.count; i++) {
        
        NSMutableDictionary *dicCategory = [arrCategory[i] mutableCopy];
        if ([dicCategory[@"id"] intValue] == [category[@"id"] intValue]) {
            NSMutableArray *arrSounds = [dicCategory[@"sounds"] mutableCopy];
            for (int j = 0; j <arrSounds.count; j++) {
                NSMutableDictionary *dicSound = [NSMutableDictionary dictionaryWithDictionary:arrSounds[j]];
                if (dicSound[@"id"] == dicMusic[@"id"]) {
                    [arrSounds replaceObjectAtIndex:j withObject:dicMusic];
                    [dicCategory setObject:arrSounds forKey:@"sounds"];
                    [arrCategory replaceObjectAtIndex:i withObject:dicCategory];
                }
                else
                {
                    if (![dicCategory[@"manyselect"] boolValue]) {
                        [dicSound setObject:@(0) forKey:@"active"];
                        [arrSounds replaceObjectAtIndex:j withObject:dicSound];
                        [dicCategory setObject:arrSounds forKey:@"sounds"];
                        [arrCategory replaceObjectAtIndex:i withObject:dicCategory];
                    }
                }
            }
            
        }
    }
    [self setupPlayerWithMusicItem:dicMusic withCategory:category];
    [self caculatorSubScrollview];
    
}
-(void)checkMusicActive
{
    for (int i = 0; i< arrCategory.count; i++) {
        
        NSMutableDictionary *dicCategory = [arrCategory[i] mutableCopy];
        NSMutableArray *arrSounds = [dicCategory[@"sounds"] mutableCopy];
        for (int j = 0; j <arrSounds.count; j++) {
            NSMutableDictionary *dicSound = [NSMutableDictionary dictionaryWithDictionary:arrSounds[j]];
            for (int k = 0; k < arrPlayList.count; k ++) {
                NSDictionary *musicItem = arrPlayList[k];
                if ([dicSound[@"id"] intValue] == [musicItem[@"music"][@"id"] intValue]&&
                    [dicCategory[@"id"]intValue]== [musicItem[@"category_id"] intValue]) {
                    [dicSound setObject:@(1) forKey:@"active"];
                    [arrSounds replaceObjectAtIndex:j withObject:dicSound];
                    [dicCategory setObject:arrSounds forKey:@"sounds"];
                    [arrCategory replaceObjectAtIndex:i withObject:dicCategory];
                    break;
                }
                
            }
        }
        
    }
}
-(void)setupPlayerWithMusicItem:(NSDictionary*)dicMusic withCategory:(NSDictionary *)category
{
    for (int i = 0; i < arrPlayList.count; i++) {
        NSDictionary *musicItem = arrPlayList[i];
        if ([category[@"id"]intValue]== [musicItem[@"category_id"] intValue]) {
            if (![category[@"manyselect"] boolValue]) {
                IDZAQAudioPlayer *player  = musicItem[@"player"];
                [player stop];
                [arrPlayList removeObjectAtIndex:i];
            }
            else
            {
                if ([dicMusic[@"id"] intValue] == [musicItem[@"music"][@"id"] intValue]) {
                    IDZAQAudioPlayer *player  = musicItem[@"player"];
                    [player stop];
                    [arrPlayList removeObjectAtIndex:i];
                    break;
                }
            }
        }
        
    }
    if ([dicMusic[@"active"] boolValue]) {
        NSString *category_name = category[@"path"];;
        if (category_name.length ==0) {
            return;
        }
        
        NSString *path = [self getFullPathWithFileName:[NSString stringWithFormat:@"%@/sound/%@",category_name,dicMusic[@"sound"]]];
        NSError* error = nil;
        NSURL* url = [NSURL fileURLWithPath:path];
        
        IDZOggVorbisFileDecoder* decoder = [[IDZOggVorbisFileDecoder alloc] initWithContentsOfURL:url error:&error];
        NSLog(@"Ogg Vorbis file duration is %g", decoder.duration);
        IDZAQAudioPlayer *player = [[IDZAQAudioPlayer alloc] initWithDecoder:decoder error:nil];
        [player setVolume:[dicMusic[@"volume"] floatValue]];
        if(!player)
        {
            NSLog(@"Error creating player: %@", error);
        }
        player.delegate = self;
        [player prepareToPlay];
        
        NSMutableDictionary *dic = [NSMutableDictionary new];
        [dic setObject:player forKey:@"player"];
        [dic setObject:dicMusic forKey:@"music"];
        [dic setObject:category[@"id"] forKey:@"category_id"];
        [arrPlayList addObject:dic];
        
    }
    [self performSelector:@selector(playMusic) withObject:nil afterDelay:0.04];
    
}
-(void)playMusic
{
    for (NSDictionary *dicMusic in arrPlayList) {
        IDZAQAudioPlayer *player  = dicMusic[@"player"];
        [player play];
    }
}
-(NSString*)getFullPathWithFileName:(NSString*)fileName
{
    NSArray       *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString  *documentsDirectory = [paths objectAtIndex:0];
    NSString *archivePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    return archivePath;
}
#pragma mark - IDZAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(id<IDZAudioPlayer>)player successfully:(BOOL)flag
{
    NSLog(@"%s successfully=%@", __PRETTY_FUNCTION__, flag ? @"YES"  : @"NO");
}

- (void)audioPlayerDecodeErrorDidOccur:(id<IDZAudioPlayer>)player error:(NSError *)error
{
    NSLog(@"%s error=%@", __PRETTY_FUNCTION__, error);
}
//MARK: -CLICK ITEM MUSIC
-(void)clickItemAction:(NSDictionary *)dicMusic dicCategory:(NSDictionary *)dicCategory isLongTap:( BOOL )isLongTap
{
    if (isLongTap) {
        if ([dicMusic[@"active"] boolValue]) {
            //show music
            [self addSubViewVolumeItemWithDicMusic:dicMusic withCategory:dicCategory];
        }
    }
    else
    {
        
        _dicChooseCategory = nil;
        NSMutableDictionary *dic = [dicMusic mutableCopy];
        NSString *strID = [NSString stringWithFormat:@"%@%@",dicCategory[@"id"],dic[@"id"]];
        if ([dic[@"active"] boolValue]) {
            [dic setObject:@(0) forKey:@"active"];
        }
        else
        {
            [dic setObject:@(1) forKey:@"active"];
            [dic setObject:dicCategory[@"id"] forKey:@"category_id"];
            //save volume
            NSString *strPathVolume = [FileHelper pathForApplicationDataFile:FILE_HISTORY_VOLUME_SAVE];
            NSArray *arr = [NSArray arrayWithContentsOfFile:strPathVolume];
            NSMutableArray *arrMulVolme = [NSMutableArray arrayWithArray:arr];
            
            BOOL isSetVolume = NO;
            if (arrMulVolme.count > 0) {
                for (int i = 0; i <arrMulVolme.count; i++) {
                    NSMutableDictionary *dicVolume = [NSMutableDictionary dictionaryWithDictionary:arrMulVolme[i]];
                    NSString *strVolumeID = dicVolume[@"id"];
                    if ([strVolumeID isEqualToString: strID] ) {
                        if (dicVolume[@"volume"]) {
                            [dic setObject:dicVolume[@"volume"] forKey:@"volume"];
                        }
                        else
                        {
                            [dic setObject:@(DEFAULT_VOLUME) forKey:@"volume"];
                            [dicVolume setObject:@(DEFAULT_VOLUME) forKey:@"volume"];
                            [arrMulVolme replaceObjectAtIndex:i withObject:dicVolume];
                        }
                        isSetVolume = YES;
                        break;
                    }
                }
            }
            
            if (!isSetVolume) {
                [dic setObject:@(DEFAULT_VOLUME) forKey:@"volume"];
                [arrMulVolme addObject:@{@"id": strID,@"volume": @(DEFAULT_VOLUME)}];
            }
            [arrMulVolme writeToFile:strPathVolume atomically:YES];
            //show music
            [self addSubViewVolumeItemWithDicMusic:dic withCategory:dicCategory];
            
            
        }
        [self updateDataMusic:dic withCategory:dicCategory];
        [self fnSetButtonNavigation];
        if (arrPlayList.count > 0) {
            _buttonType = BUTTON_PLAYING;
        }
        else
        {
            _buttonType = BUTTON_RANDOM;
            
        }
        [self fnSetButtonBottom];
    }
    
    
}
-(BOOL)checkPassOneDaye:(NSDate*)date
{
    NSDate *current= [NSDate date];
    NSDate *yesterday = [current dateByAddingTimeInterval: -86400.0];
    NSComparisonResult result = [yesterday compare:date];
    if(result == NSOrderedDescending)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
//MARK: - SCROLL VIEW
-(void)caculatorSubScrollview
{
    [self checkMusicActive];
    //update frame scroll view
    //    CGRect rect = rectScroll;
    //    rect.size.height = rect.size.height + self.contraintBottomvTab.constant;
    //    self.scroll_View.frame = rect;
    //
    
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSString *userLanguage = @"en";
    if (language.length >=2) {
        userLanguage = [language substringToIndex:2];
    }
    userLanguage = [language substringToIndex:2];
    
    int deltal = 9;
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    if( screenHeight < screenWidth ){
        screenHeight = screenWidth;
    }
    
    if ( screenHeight >= 667){
        deltal = 12;
    }else {
        deltal = 9;
    }
    
    __weak HomeVC *wself = self;
    iNumberCollection = 0;
    
    //remove subview scroll news
    for (UIView *view in self.scroll_View.subviews) {
        [view removeFromSuperview];
    }
    [arrColection removeAllObjects];
    
    float delta = CGRectGetWidth(self.scroll_View.frame);
    //caculator number page
    arrTotal = [NSMutableArray new];
    //set active
    //
    for (int j=0; j < arrCategory.count; j++) {
        NSArray *arrItem = arrCategory[j][@"sounds"];
        for (int i = 0; i <arrItem.count; i = i + deltal) {
            NSMutableDictionary *dicCategory = [arrCategory[j] mutableCopy];
            [dicCategory removeObjectForKey:@"sounds"];
            NSArray *arrTmp;
            if (i + deltal <= arrItem.count - 1) {
                //set active
                arrTmp = [arrItem subarrayWithRange:NSMakeRange(i, deltal)];
            }
            else
            {
                arrTmp = [arrItem subarrayWithRange:NSMakeRange(i, arrItem.count - i)];
            }
            
            //
            [dicCategory setObject:arrTmp forKey:@"sounds"];
            [arrTotal addObject:dicCategory];
        }
        if (arrItem.count == 0) {
            NSMutableDictionary *dicCategory = [arrCategory[j] mutableCopy];
            [dicCategory removeObjectForKey:@"sounds"];
            [arrTotal addObject:dicCategory];
        }
    }
    //add scroll view
    iNumberCollection = iNumberCollection + (int)arrTotal.count;
    int i = 0;
    for (NSDictionary *dicCategory in arrTotal) {
        UIView *v =[UIView new];
        v.frame = CGRectMake( i*delta, 0 , delta , CGRectGetHeight(self.scroll_View.frame));
        [self.scroll_View addSubview:v];
        CollectionVC *collection = [[CollectionVC alloc] initWithEVC];
        [collection addContraintSupview:v];
        [collection updateDataMusic:dicCategory];
        [collection setCallback:^(NSDictionary *dicMusic,NSDictionary *dicCategory, BOOL isLongTap)
         {
             if ([dicMusic[@"ads"] boolValue]) {
                 if (![COMMON isReachableCheck]) {
                     return ;
                 }
                 //show ads
                 [UIAlertView showWithTitle:str(kWatchOneAdvertisement) message:str(kWatchAnAdsToGetThisSound)
                          cancelButtonTitle:str(kCancel)
                          otherButtonTitles:@[str(kuOK)]
                                   tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                                       
                                       if (buttonIndex == 1) {
                                           //show ads
                                           AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
                                           [app startNewAds];
                                           [app setCallbackDismissAds:^()
                                            {
                                                //check exist in blacklist
                                                NSString *strPathShowAds = [FileHelper pathForApplicationDataFile:FILE_HISTORY_SHOW_ADS_SAVE];
                                                NSDictionary *dicLoadCache = [NSDictionary dictionaryWithContentsOfFile:strPathShowAds];
                                                NSMutableDictionary *dicShowAds = [NSMutableDictionary dictionaryWithDictionary:dicLoadCache];
                                                
                                                NSString *strID = [NSString stringWithFormat:@"%@%@",dicCategory[@"id"],dicMusic[@"id"]];
                                                if (dicShowAds[strID]) {
                                                    NSDate *dateShowAds = dicShowAds[strID];
                                                    if ([self checkPassOneDaye:dateShowAds]) {
                                                        [dicShowAds removeObjectForKey:strID];
                                                        [dicShowAds writeToFile:strPathShowAds atomically:YES];
                                                    }
                                                }
                                                else
                                                {
                                                    [dicShowAds setObject:[NSDate date] forKey:strID];
                                                    [dicShowAds writeToFile:strPathShowAds atomically:YES];
                                                    
                                                }
                                                
                                                [wself clickItemAction:dicMusic dicCategory:dicCategory isLongTap:isLongTap];
                                            }];
                                           
                                       }
                                   }];
             }
             else
             {
                 //nomarl
                 [wself clickItemAction:dicMusic dicCategory:dicCategory isLongTap:isLongTap];
             }
             
         }];
        [collection setCallbackCategory:^(NSDictionary *dicCategory, BOOL isDownLoad)
         {
             if (!isDownLoad) {
                 for (int i = 0; i < arrCategory.count; i++) {
                     NSMutableDictionary *dicTmp = [NSMutableDictionary dictionaryWithDictionary:arrCategory[i]];
                     if ([dicTmp[@"id"] intValue] == [dicCategory[@"id"] intValue]) {
                         //
                         [arrCategory removeObjectAtIndex:i];
                         [wself caculatorSubScrollview];
                     }
                 }
             }
             else
             {
                 if (self.progressView1.hidden == NO) {
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:str(kPleaseKeepCalm)
                                                                     message:str(kAnotherUpdating)
                                                                    delegate:self
                                                           cancelButtonTitle:str(kuOK)
                                                           otherButtonTitles:nil];
                     [alert show];
                     return;
                 }
                 [wself downloadSoundWithCategory:dicCategory];
             }
             
         }];
        [arrColection addObject:collection];
        i++;
    }
    
    [self.scroll_View setContentSize:CGSizeMake(iNumberCollection*delta, CGRectGetHeight(self.scroll_View.frame))];
    [self.scroll_View setPagingEnabled:YES];
    self.pageControl.numberOfPages = iNumberCollection;
    //set title
    CGFloat pageWidth = CGRectGetWidth(self.scroll_View.frame);
    CGFloat currentPage = floor((self.scroll_View.contentOffset.x-pageWidth/2)/pageWidth)+1;
    // Change the indicator
    self.pageControl.currentPage = (int) currentPage;
    if (iNumberCollection > 0) {
        if (currentPage == 0) {
            self.imagBack.hidden = YES;
            self.imgNext.hidden = NO;

        }
        else if (currentPage == iNumberCollection -1)
        {
            self.imagBack.hidden = NO;
            self.imgNext.hidden = YES;

        }
        else
        {
            self.imagBack.hidden = NO;
            self.imgNext.hidden = NO;

        }
    }
    else
    {
        self.imagBack.hidden = YES;
        self.imgNext.hidden = YES;

    }
    if (currentPage < arrTotal.count) {
        NSString *strName;
        if ([arrTotal[(int)currentPage][@"name"] isKindOfClass:[NSDictionary class]]) {
            
            if (arrTotal[(int)currentPage][@"name"][userLanguage]) {
                strName = arrTotal[(int)currentPage][@"name"][userLanguage];
            }
            else
            {
                strName = arrTotal[(int)currentPage][@"name"][@"en"];
                
            }
        }
        else
        {
            strName = arrTotal[(int)currentPage][@"name"];
        }
        
        self.titleCategory.text = strName;
        self.imgSingle.hidden = [arrTotal[(int)currentPage][@"manyselect"] boolValue];
        
    }
    
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //set ramdom background
//    [self randomBackGround];
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSString *userLanguage = @"en";
    if (language.length >=2) {
        userLanguage = [language substringToIndex:2];
    }
    userLanguage = [language substringToIndex:2];
    
    CGFloat pageWidth = CGRectGetWidth(scrollView.frame);
    CGFloat currentPage = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1;
    // Change the indicator
    self.pageControl.currentPage = (int) currentPage;
    if (iNumberCollection > 0) {
        if (currentPage == 0) {
            self.imagBack.hidden = YES;
            self.imgNext.hidden = NO;
            
        }
        else if (currentPage == iNumberCollection -1)
        {
            self.imagBack.hidden = NO;
            self.imgNext.hidden = YES;
            
        }
        else
        {
            self.imagBack.hidden = NO;
            self.imgNext.hidden = NO;
            
        }
    }
    else
    {
        self.imagBack.hidden = YES;
        self.imgNext.hidden = YES;
        
    }

    if (currentPage < arrTotal.count) {
        NSString *strName;
        if ([arrTotal[(int)currentPage][@"name"] isKindOfClass:[NSDictionary class]]) {
            
            if (arrTotal[(int)currentPage][@"name"][userLanguage]) {
                strName = arrTotal[(int)currentPage][@"name"][userLanguage];
            }
            else
            {
                strName = arrTotal[(int)currentPage][@"name"][@"en"];
                
            }
        }
        else
        {
            strName = arrTotal[(int)currentPage][@"name"];
        }
        
        self.titleCategory.text = strName;
        self.imgSingle.hidden = [arrTotal[(int)currentPage][@"manyselect"] boolValue];
    }
    
}
-(void)downloadSoundWithCategory:(NSDictionary*)dicCategory
{
    
    __weak HomeVC *wself = self;
    
    self.progressView1.hidden = NO;
    [self.progressView1 setProgress:0 animated:YES];
    DownLoadCategory *download = [DownLoadCategory sharedInstance];
    [download fnListMusicWithCategory:@[dicCategory]];
    [download setCallback:^(NSDictionary *dicItemCategory)
     {
         [wself caculatorSubScrollview];
         dispatch_async(dispatch_get_main_queue(), ^{
             [self.progressView1 setProgress:0 animated:YES];
             self.progressView1.hidden = YES;
         });
     }];
    [download setCallbackProgess:^(float progress)
     {
         dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self.progressView1 setProgress:progress animated:YES];
                 
             });
         });
         
     }];
}
//MARK: ACTION

-(IBAction)tabBottomVCAction:(id)sender
{
    [self.vFavorite dismissView];
    [self.vAddFavorite dismissView];
    [self.vTimer dismissView];
    [self.vSetting dismissView];
    [self.vVolumeTotal showVolume:NO];
    [self.vVolumeItem removeFromSuperview];
    self.vNavHome.hidden = NO;
    UIButton *btn = (UIButton*)sender;
    switch (btn.tag - 10) {
        case 1:
        {
            //favorite
            [self addSubViewFavorite];
            _buttonType = BUTTON_FAVORITE;
            self.vNavHome.hidden = YES;
            
        }
            break;
        case 2:
        {
            
            if (_buttonType == BUTTON_VOLUME || _buttonType == BUTTON_FAVORITE || _buttonType == BUTTON_TIMER || _buttonType == BUTTON_SETTING) {
                //get state befor
                if (arrPlayList.count > 0) {
                    NSDictionary *musicItem = arrPlayList[0];
                    IDZAQAudioPlayer *player  = musicItem[@"player"];
                    if (player.state == IDZAudioPlayerStatePlaying) {
                        _buttonType = BUTTON_PLAYING;
                    }
                    else
                    {
                        _buttonType = BUTTON_PAUSE;
                    }
                }
                else
                {
                    _buttonType = BUTTON_RANDOM;
                }
                
            }
            else
            {
                if (_buttonType == BUTTON_PLAYING) {
                    if (arrPlayList.count > 0) {
                        _buttonType = BUTTON_PAUSE;
                        for (int i = 0; i < arrPlayList.count; i ++) {
                            NSDictionary *musicItem = arrPlayList[i];
                            IDZAQAudioPlayer *player  = musicItem[@"player"];
                            [player pause];
                        }
                    }
                    else
                    {
                        _buttonType = BUTTON_RANDOM;
                        
                    }
                }
                else if (_buttonType == BUTTON_PAUSE)
                {
                    if (arrPlayList.count > 0) {
                        _buttonType = BUTTON_PLAYING;
                        for (int i = 0; i < arrPlayList.count; i ++) {
                            NSDictionary *musicItem = arrPlayList[i];
                            IDZAQAudioPlayer *player  = musicItem[@"player"];
                            [player play];
                        }
                    }
                    else
                    {
                        _buttonType = BUTTON_RANDOM;
                        
                    }
                }
                else if (_buttonType == BUTTON_RANDOM)
                {
                    [self randomPlayList];
                }
            }
            
        }
            break;
        case 3:
        {
            //timer
            [self addSubViewTimer];
            _buttonType = BUTTON_TIMER;
            self.vNavHome.hidden = YES;
            
            
        }
            break;
        case 4:
        {
            //setting
            [self addSubViewSetting];
            _buttonType = BUTTON_SETTING;
            self.vNavHome.hidden = YES;
            
            
        }
            break;
        default:
            break;
    }
    [self fnSetButtonBottom];
}

-(void) addSubViewFavorite
{
    __weak HomeVC *wself = self;
    self.vFavorite = [[FavoriteView alloc] initWithClassName:NSStringFromClass([FavoriteView class])];
    self.vFavorite.parent = self;
    [self.vFavorite addContraintSupview:self.vContrainer];
    [self.vFavorite setCallback:^(NSDictionary *dicCateogry)
     {
         wself.dicChooseCategory = dicCateogry;
         NSArray *chooseMusic = wself.dicChooseCategory[@"music"];
         [wself fnPlayerFromFavorite:chooseMusic];
         _buttonType = BUTTON_PLAYING;
         [wself fnSetButtonBottom];
     }];
}
-(void) addSubViewTimer
{
    self.vTimer = [[TimerView alloc] initWithClassName:NSStringFromClass([TimerView class])];
    self.vTimer.parent = self;
    [self.vTimer addContraintSupview:self.vContrainer];
}
-(void) addSubViewSetting
{
    self.vSetting = [[SettingView alloc] initWithClassName:NSStringFromClass([SettingView class])];
    self.vSetting.parent = self;
    [self.vSetting addContraintSupview:self.vContrainer];
}
//MARK: - STATUS BUTTON
-(void)fnSetButtonNavigation
{
    if (arrPlayList.count == 0) {
        _btnAddfavorite.hidden = YES;
        _imgAddfavorite.hidden = YES;
        //
        _btnclearAll.hidden = YES;
        _imgclearAll.hidden = YES;
    }
    else
    {
        if (_dicChooseCategory) {
            _imgAddfavorite.image = [UIImage imageNamed:@"infofavorite"];
        }
        else
        {
            _imgAddfavorite.image = [UIImage imageNamed:@"addtofavorite"];
        }
        _btnAddfavorite.hidden = NO;
        _imgAddfavorite.hidden = NO;
        _btnclearAll.hidden = NO;
        _imgclearAll.hidden = NO;
        
    }
}
-(void)fnSetButtonBottom
{
    //volume
    self.lbVolume.textColor = UIColorFromRGB(COLOR_TEXT_ITEM);
    self.imgVolume.hidden = NO;
    self.imgVolumeActive.hidden = YES;
    //favorite
    self.lbFavorite.textColor = UIColorFromRGB(COLOR_TEXT_ITEM);
    self.imgFavorite.hidden = NO;
    self.imgFavoriteActive.hidden = YES;
    
    //home
    self.imgHome.image = [UIImage imageNamed:@"backtohome"];
    
    //timer
    self.lbTimer.textColor = UIColorFromRGB(COLOR_TEXT_ITEM);
    self.imgTimer.hidden = NO;
    self.imgTimerActive.hidden = YES;
    
    //setting
    self.lbSetting.textColor = UIColorFromRGB(COLOR_TEXT_ITEM);
    self.imgSetting.hidden = NO;
    self.imgSettingActive.hidden = YES;
    
    if (_buttonType == BUTTON_VOLUME) {
    }
    switch (_buttonType) {
        case BUTTON_VOLUME:
        {
            self.lbVolume.textColor = UIColorFromRGB(COLOR_PAGE_ACTIVE);
            self.imgVolume.hidden = YES;
            self.imgVolumeActive.hidden = NO;
        }
            break;
        case BUTTON_FAVORITE:
        {
            self.lbFavorite.textColor = UIColorFromRGB(COLOR_PAGE_ACTIVE);
            self.imgFavorite.hidden = YES;
            self.imgFavoriteActive.hidden = NO;
        }
            break;
        case BUTTON_RANDOM:
        {
            self.imgHome.image = [UIImage imageNamed:@"playradom"];
        }
            break;
        case BUTTON_BACK_HOME:
        {
            self.imgHome.image = [UIImage imageNamed:@"backtohome"];
        }
            break;
        case BUTTON_PAUSE:
        {
            self.imgHome.image = [UIImage imageNamed:@"pause"];
        }
            break;
        case BUTTON_PLAYING:
        {
            self.imgHome.image = [UIImage imageNamed:@"playing"];
        }
            break;
        case BUTTON_TIMER:
        {
            self.lbTimer.textColor = UIColorFromRGB(COLOR_PAGE_ACTIVE);
            self.imgTimer.hidden = YES;
            self.imgTimerActive.hidden = NO;
        }
            break;
        case BUTTON_SETTING:
        {
            self.lbSetting.textColor = UIColorFromRGB(COLOR_PAGE_ACTIVE);
            self.imgSetting.hidden = YES;
            self.imgSettingActive.hidden = NO;
        }
            break;
    }
}
-(void)randomPlayList
{
    NSString *strPath = [FileHelper pathForApplicationDataFile:FILE_FAVORITE_SAVE];
    NSArray *arrTmp = [NSArray arrayWithContentsOfFile:strPath];
    if (arrTmp.count > 0) {
        int random = arc4random() % (arrTmp.count);
        NSDictionary *dicFavorite = arrTmp[random];
        self.dicChooseCategory = dicFavorite;
        NSArray *chooseMusic = self.dicChooseCategory[@"music"];
        [self fnPlayerFromFavorite:chooseMusic];
        _buttonType = BUTTON_PLAYING;
        [self fnSetButtonBottom];
    }
    
}
//MARK: - AVSection delegate
- (void)beginInterruption /* something has caused your audio session to be interrupted */
{
    
}
/* the interruption is over */
- (void)endInterruptionWithFlags:(NSUInteger)flags  /* Currently the only flag is AVAudioSessionInterruptionFlags_ShouldResume. */
{
    
}
- (void)endInterruption /* endInterruptionWithFlags: will be called instead if implemented. */
{
    
}
/* notification for input become available or unavailable */
- (void)inputIsAvailableChanged:(BOOL)isInputAvailable
{
    
}
- (BOOL)canBecomeFirstResponder
{
    return YES;
}
- (void) remoteControlReceivedWithEvent: (UIEvent *) receivedEvent {
    
    if (receivedEvent.type == UIEventTypeRemoteControl) {
        
        switch (receivedEvent.subtype) {
            case UIEventSubtypeRemoteControlPlay:
            {
                UIButton *btn = [UIButton new];
                btn.tag = 12;
                _buttonType = BUTTON_PAUSE;
                [self tabBottomVCAction:btn];
            }
                break;
                
            case UIEventSubtypeRemoteControlPause:
            {
                UIButton *btn = [UIButton new];
                btn.tag = 12;
                _buttonType = BUTTON_PLAYING;
                [self tabBottomVCAction:btn];
                
            }
                break;
                
            case UIEventSubtypeRemoteControlPreviousTrack:
                break;
                
            case UIEventSubtypeRemoteControlNextTrack:
                break;
                
            default:
                break;
        }
    }
}
//MARK: - DELEGATE ADS
-(void)hideAdsAction
{
    for (UIView *subview in [self.view subviews]) {
        if([subview isKindOfClass:[GADBannerView class]]) {
            [subview removeFromSuperview];
        }
    }
    for (UIView *subview in [self.view subviews]) {
        if([subview isKindOfClass:[RevMobBannerView class]]) {
            [subview removeFromSuperview];
        }
    }
    
    [self displayAds:NO];
}
-(void)displayAds:(BOOL)areDisplay
{
    if (areDisplay) {
        self.contraintBottomvTab.constant = 50;
    }
    else
    {
        self.contraintBottomvTab.constant = 0;
    }
    [UIView animateWithDuration:0.1
                          delay:0.1
                        options: 0
                     animations:^
     {
         [self.view layoutIfNeeded]; // Called on parent view
     }
                     completion:^(BOOL finished)
     {
         
         [self caculatorSubScrollview];
         
     }];
    
}
- (void)adViewDidReceiveAd:(GADBannerView *)bannerView
{
    isAdsMob = YES;
    [self displayAds:YES];
    [self hideCustomBanner];

}

/// Tells the delegate that an ad request failed. The failure is normally due to network
/// connectivity or ad availablility (i.e., no fill).
- (void)adView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(GADRequestError *)error
{
    isAdsMob = NO;
    [self performSelector:@selector(showRevMobAds) withObject:nil afterDelay:2.0];
}

#pragma mark Click-Time Lifecycle Notifications

/// Tells the delegate that a full screen view will be presented in response to the user clicking on
/// an ad. The delegate may want to pause animations and time sensitive interactions.
- (void)adViewWillPresentScreen:(GADBannerView *)bannerView
{
    
}

/// Tells the delegate that the full screen view will be dismissed.
- (void)adViewWillDismissScreen:(GADBannerView *)bannerView
{
    
}

/// Tells the delegate that the full screen view has been dismissed. The delegate should restart
/// anything paused while handling adViewWillPresentScreen:.
- (void)adViewDidDismissScreen:(GADBannerView *)bannerView
{
    
}

/// Tells the delegate that the user click will open another app, backgrounding the current
/// application. The standard UIApplicationDelegate methods, like applicationDidEnterBackground:,
/// are called immediately before this method is called.
- (void)adViewWillLeaveApplication:(GADBannerView *)bannerView
{
    
}
//MARK: -Random backgroun
-(void)randomBackGround
{
    NSMutableArray *arrBackGround = [NSMutableArray new];
    [arrBackGround addObject:@"Home1"];
    [arrBackGround addObject:@"Home2"];
    [arrBackGround addObject:@"Home3"];
    [arrBackGround addObject:@"Home4"];
    [arrBackGround addObject:@"Home5"];

    int min = 0; //Get the current text from your minimum and maximum textfields.
    int max = (int) arrBackGround.count;
    int randNum = 0;
    if (arrBackGround.count > 1) {
        randNum = arc4random() % (max - min) + min;
    }
    
    [self.imgBackGround setAlpha:1.0f];
    
    //fade in
    [UIView animateWithDuration:2.0f animations:^{
        
        [self.imgBackGround setAlpha:0.5f];
        
    } completion:^(BOOL finished) {
        self.imgBackGround.image = [UIImage imageNamed:arrBackGround[randNum]];
        //fade out
        [UIView animateWithDuration:2.0f animations:^{
            
            [self.imgBackGround setAlpha:1.0f];
            
        } completion:nil];
        
    }];
}
//MARK: - play music from link web
-(void)fnGetMusicFromParam:(NSString*)param
{
    //clear befor
    [self fnClearAllSounds];
    //check exist in blacklist
    NSString *strPathBlackList = [FileHelper pathForApplicationDataFile:FILE_BLACKLIST_CATEGORY_SAVE];
    NSArray *arrBL = [NSArray arrayWithContentsOfFile:strPathBlackList];
    
    NSString *strManagerDownload = [FileHelper pathForApplicationDataFile:FILE_MANAGER_DOWNLOAD_SAVE];
    NSArray *arrMD = [NSArray arrayWithContentsOfFile:strManagerDownload];
    
    NSMutableArray *arrFull = [NSMutableArray new];
    [arrFull addObjectsFromArray:arrBL];
    [arrFull addObjectsFromArray:arrMD];

    //1=2,0.5&1=4,0.5&1=5,0.5&1=6,0.5&1=7,0.5&1=8,0.5&1=9,0.5&1=10,0.5&1=11,0.5
    int count = 0;
    NSArray *arrParam = [param componentsSeparatedByString:@"&"];
    for (NSString *strItem in arrParam) {
        NSArray *arrItemMusic = [strItem componentsSeparatedByString:@"="];
        NSString *category_id = arrItemMusic[0];
        NSString *music_id = [arrItemMusic[1] componentsSeparatedByString:@","][0];
        NSString *volume = [arrItemMusic[1] componentsSeparatedByString:@","][1];
        
        for (int i = 0; i< arrCategory.count; i++) {
            NSMutableDictionary *dicCategory = [arrCategory[i] mutableCopy];
            if (![arrFull containsObject:dicCategory[@"id"]]) {
                
                NSString *path = [self getFullPathWithFileName:dicCategory[@"path"]];
                NSFileManager *fileManager = [[NSFileManager alloc] init];
                BOOL isDir;
                BOOL exists = [fileManager fileExistsAtPath:path isDirectory:&isDir];
                
                if (dicCategory[@"sounds"] && exists) {
                    if ([dicCategory[@"id"] intValue] == [category_id intValue]) {
                        NSMutableArray *arrSounds = [dicCategory[@"sounds"] mutableCopy];
                        for (int j = 0; j <arrSounds.count; j++) {
                            NSMutableDictionary *dicSound = [arrSounds[j] mutableCopy];
                            if ([dicSound[@"id"] intValue] == [music_id intValue]) {
                                [dicSound setObject:@([volume floatValue]) forKey:@"volume"];
                                [dicSound setObject:@(1) forKey:@"active"];
                                [dicSound setObject:dicCategory[@"id"] forKey:@"category_id"];
                                
                                //show music
                                [arrSounds replaceObjectAtIndex:j withObject:dicSound];
                                [dicCategory setObject:arrSounds forKey:@"sounds"];
                                [arrCategory replaceObjectAtIndex:i withObject:dicCategory];
                                [self setupPlayerWithMusicItem:dicSound withCategory:dicCategory];
                                count++;
                                break;
                                
                            }
                        }
                        
                    }
                }
            }

        }
        
        
    }
    if (count >0) {
        [self caculatorSubScrollview];
        [self fnSetButtonNavigation];
        if (!(_buttonType == BUTTON_VOLUME || _buttonType == BUTTON_FAVORITE || _buttonType == BUTTON_TIMER || _buttonType == BUTTON_SETTING)) {
            _buttonType = BUTTON_PLAYING;
        }
        [self fnSetButtonBottom];
    }
    if (count < arrParam.count) {
        [UIAlertView showWithTitle:nil message:str(kMissingSounds)
                 cancelButtonTitle:str(kuOK)
                 otherButtonTitles:nil
                          tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                          }];
    }

}
@end
