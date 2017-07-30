//
//  HomeVC.h
//  RelaxApp
//
//  Created by JoJo on 9/27/16.
//  Copyright © 2016 JoJo. All rights reserved.
//

//#import <AVFoundation/AVFoundation.h>
#import "FavoriteView.h"
#import "TimerView.h"
#import "SettingView.h"
#import "VolumeView.h"
#import "VolumeItem.h"
#import "AFHTTPSessionManager.h"
#import "AddFavoriteView.h"
#import "ASProgressPopUpView.h"
#import "TabVC.h"
#import <OGVKit/OGVKit.h>
#import "MDButtonIcon.h"
#import "ShortcutScreenVC.h"
@class RBVolumeButtons;
@class GADBannerView;
@interface HomeVC : UIViewController<AVAudioPlayerDelegate, OGVPlayerDelegate>
{
    AFURLSessionManager *manager;
    AFHTTPSessionManager *managerCategory;

}
@property (nonatomic, strong) NSDictionary *dicChooseCategory;
@property (nonatomic, strong) IBOutlet UIView *vNavHome;
@property (nonatomic, strong) IBOutlet UIView *vTabVC;
@property (nonatomic, strong) TabVC *vTabbar;
@property (nonatomic, strong) IBOutlet UIView *vContrainer;
@property (nonatomic, strong) IBOutlet UIImageView *imgBackGround;
@property (nonatomic, strong) IBOutlet UIPageControl *pageControl;
@property (nonatomic, strong) IBOutlet UIScrollView *scroll_View;
@property (nonatomic, strong) IBOutlet UILabel *titleCategory;
@property (nonatomic, strong) IBOutlet UIImageView *imgSingle;

@property (nonatomic, strong) IBOutlet UIButton *btnAddfavorite;
@property (nonatomic, strong) IBOutlet UIImageView *imgAddfavorite;

@property (nonatomic, strong) IBOutlet UIButton *btnclearAll;
@property (nonatomic, strong) IBOutlet UIImageView *imgclearAll;

//VOLUME
@property (nonatomic, strong) IBOutlet UILabel *lbVolume;
@property (nonatomic, strong) IBOutlet UIImageView *imgVolume;
@property (nonatomic, strong) IBOutlet UIImageView *imgVolumeActive;

//FAVORITE
@property (nonatomic, strong) IBOutlet UILabel *lbFavorite;
@property (nonatomic, strong) IBOutlet UIImageView *imgFavorite;
@property (nonatomic, strong) IBOutlet UIImageView *imgFavoriteActive;

//HOME
//TIMER
@property (nonatomic, strong) IBOutlet UILabel *lbTimer;
@property (nonatomic, strong) IBOutlet UIImageView *imgTimer;
@property (nonatomic, strong) IBOutlet UIImageView *imgTimerActive;
@property (nonatomic, strong) IBOutlet UIImageView *imgBackgroundNavigation;

//SETTING
@property (nonatomic, strong) IBOutlet UILabel *lbSetting;
@property (nonatomic, strong) IBOutlet UIImageView *imgSetting;
@property (nonatomic, strong) IBOutlet UIImageView *imgSettingActive;
@property (nonatomic, retain) UIView *volumeView;

//
@property (nonatomic, strong) IBOutlet MDButtonIcon *btnPlus;
@property (nonatomic, strong) IBOutlet MDButtonIcon *btnPlayer;
@property (nonatomic, strong) IBOutlet ShortcutScreenVC *viewShortCutScreen;


@property (weak, nonatomic) IBOutlet ASProgressPopUpView *progressView1;
@property(nonatomic, weak) IBOutlet GADBannerView *bannerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contraintBottomvTab;

@property (nonatomic, strong) IBOutlet UIImageView *imagBack;
@property (nonatomic, strong) IBOutlet UIImageView *imgNext;

@property (nonatomic, strong)  FavoriteView *vFavorite;
@property (nonatomic, strong)  AddFavoriteView *vAddFavorite;

@property (nonatomic, strong)  SettingView *vSetting;
@property (nonatomic, strong)  TimerView *vTimer;
@property (nonatomic, strong)  VolumeView *vVolumeTotal;
@property (nonatomic, strong)  VolumeItem *vVolumeItem;
@property(nonatomic,assign) HOME_BUTTON_TYPE buttonType;
@property(nonatomic,assign) HOME_BUTTON_TYPE buttonBefor;
-(void)loadCache;
-(void)fnGetMusicFromParam:(NSString*)param;
@end
