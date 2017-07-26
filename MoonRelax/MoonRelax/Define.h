//
//  Define.h
//  RelaxApp
//
//  Created by JoJo on 10/1/16.
//  Copyright © 2016 JoJo. All rights reserved.
//

#ifndef Define_h
#define Define_h
//test
//#define BASE_URL @"https://data.relafapp.com/data-examples/data/"
//#define BASE_IMAGE_URL @"https://data.relafapp.com/data-examples/data/img/"
//#define pwd_Unzip @"0000" //d41d8cd98f00b204e9800998ecf8427e

//#define BASE_URL @"https://dev.relafapp.com/product/"
//#define BASE_IMAGE_URL @"https://dev.relafapp.com/product/img/"
//#define pwd_Unzip @"d41d8cd98f00b204e9800998ecf8427e" //d41d8cd98f00b204e9800998ecf8427e

//
#define BASE_URL @"https://data.relafapp.com/product/"
#define BASE_IMAGE_URL @"https://data.relafapp.com/product/img/"
#define pwd_Unzip @"d41d8cd98f00b204e9800998ecf8427e"
#define VERSION_PRO 1
#define APP_ID_BUNDLE @"com.relaf.pro"
#define NAME_APP @"RelaF"
#define schemeName @"relaf"

#define BITLY_ACCESSTOKEN @"29ea51a80802fd5fcc8f6ac9ed5145d90b2db48a"
#define BITLY_API_KEY @"R_d75fbe9cea5844b280ac4858a9793c1d"
#define BITLY_NAME @"relafapp"


#define strRatingAppStore @"THANKYOU_FORRATING"
#define strNewVertionAvailale @"strNewVertionAvailale"
#define COLOR_SLIDER_THUMB 0x9A6FE9
#define COLOR_SLIDER_MAX 0xC7C7C7
#define COLOR_VOLUME_TOTAL_SLIDER_THUMB 0x50E3C2

#define COLOR_NAVIGATION_HOME 0x9A6FE9
#define COLOR_PAGE_ACTIVE 0x9013FE
#define COLOR_VOLUME 0xFFFFFF
#define COLOR_BACKGROUND_FAVORITE 0xFFFFFF
#define COLOR_NAVIGATION_FAVORITE 0x000000
#define COLOR_ADDFAVORITE_TAGS 0x9A6FE9
#define COLOR_VIEWFAVORITE_TAGS 0xDDDDDD
#define COLOR_BELING_MODE 0x000000
#define COLOR_PROGRESS 0x3023AE
#define COLOR_PROGRESS_HOZI 0xC86DD7

#define COLOR_SOUND_ITEM 0x9A6FE9
#define COLOR_TABBAR_BOTTOM 0xF8F8F8
#define COLOR_TEXT_ITEM 0x8D8D8D
#define COLOR_TEXT_SETTING 0x4A4A4A

#define COLOR_PAGECONTROL_TINT 0x7C7C7C
#define COLOR_PAGECONTROL_CURRENT 0xEBEBEB
#define COLOR_WELCOME_SCREEN 0x9770ED
#define COLOR_WELCOME_SCREEN_PAGECONTROL_TINT 0xAB8DF0
#define COLOR_WELCOME_SCREEN_PAGECONTROL_CURRENT 0xFFFFFF
#define COLOR_WELCOME_SCREEN_DESC 0xD0BEF6

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define UIColorFromAlpha(rgbValue , a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:((float)(a))]

//
#define strTitle_app @"Title_app"
#define FILE_FAVORITE_SAVE @"FAVORITE.save"
#define FILE_TIMER_SAVE @"TIMER.save"
#define FILE_CATEGORY_SAVE @"CATEGORY.save"
#define FILE_BLACKLIST_CATEGORY_SAVE @"BACLIST_CATEGORY.save"
#define FILE_HISTORY_VOLUME_SAVE @"HISTORY_VOLUME.save"
#define FILE_HISTORY_SHOW_ADS_SAVE @"HISTORY_SHOW_ADS.save"
#define FILE_MANAGER_DOWNLOAD_SAVE @"MANAGER_DOWNLOAD.save"

#define NOTIFCATION_TIMER @"NOTIFICATION_TIMER"
#define NOTIFCATION_CATEGORY @"NOTIFCATION_CATEGORY"
#define NOTIFCATION_HIDE_ADS @"NOTIFCATION_HIDE_ADS"
#define NOTIFCATION_SHOW_ADS @"SHOW_ADS"
#define FIREBASE_INTERSTITIAL_UnitID @""//@"ca-app-pub-1671106005232686/3358212851"
#define FIREBASE_BANNER_UnitID @""//@"ca-app-pub-1671106005232686/9265145652"
#define FIREBASE_APP_ID @""//@"ca-app-pub-1671106005232686~9963149658"
#define REVMOB_ID @""//@"581b77b688e696b311e2fd3d"

#define FILE_IAP_SAVE @"IAP"
#define kTotalRemoveAdsProductIdentifier @""//@"com.relaf.free.removeads"
#define root_ipa_free @""//@"com.relaf.free."
#define root_ipa_pro @""//@"com.relaf.pro."

#define DEFAULT_VOLUME 0.5


#define show_welcome_screen @"show_welcome_screen"

#define IS_IPHONE_4 (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)480) < DBL_EPSILON)
#define IS_IPHONE_5 (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)568) < DBL_EPSILON)
#define IS_IPHONE_6 (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)667) < DBL_EPSILON)
#define IS_IPHONE_6_PLUS (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)736) < DBL_EPSILON)

typedef enum
{
    GESTURE_TAP = 1,
    GESTURE_LONG,
    
}GESTURE_TYPE;
typedef enum
{
    TIMER_COUNTDOWN = 1,
    TIMER_CLOCK,
    
}TIMER_TYPE;
typedef enum
{
    MODE_CREATE = 1,
    MODE_EDIT,
    MODE_INFO
    
}MODE_TYPE;
typedef enum
{
    FAVORITE_SCREEN_ADD = 0,
    FAVORITE_SCREEN_INFO,
}FAVORITE_SCREEN;
typedef enum
{
    BUTTON_RANDOM = 1,
    BUTTON_PLAYING,
    BUTTON_PAUSE,
    BUTTON_BACK_HOME,
    BUTTON_VOLUME,
    BUTTON_FAVORITE,
    BUTTON_TIMER,
    BUTTON_SETTING
    
}HOME_BUTTON_TYPE;
typedef enum
{
    SETTING_CELL_HEADER = 1,
    SETTING_CELL_NON_ARROW,
    SETTING_CELL_COPYRIGHT,
    SETTING_CELL_CHECK_NOW,
    SETTING_CELL_CHECK_REMOVE_ADS,
    SETTING_CELL_CHECK_NO_ADS,
    SETTING_CELL_CHECK_DOWLOAD,
    SETTING_CELL_CHECK_PURCHASED,
    SETTING_CELL_CHECK_MAILTO,
    SETTING_CELL_CHECK_TWITTER,
    SETTING_CELL_CHECK_FANPAGE,
    SETTING_CELL_CHECK_ABOUT,
    SETTING_CELL_CHECK_CREDIT,
    SETTING_CELL_CHECK_VERTION,
    SETTING_CELL_CHECK_PRIVACY,
    SETTING_CELL_SHARE_SOCIAL,
    SETTING_CELL_HELP_TRANSLATE,
}SETTING_CELL_TYPE;

//LANGUAG
#define str(originalString) NSLocalizedString(originalString, @"")
#define kCancel @"kCancel"
#define kAddToFavorites @"kAddToFavorites"
#define kWriteSomething @"kWriteSomething"
#define kSave @"kSave"
#define kInfoToFavorites @"kInfoToFavorites"
#define kEditToTavorites @"kEditToTavorites"
#define kSuccess @"kSuccess"
#define kuOK @"kuOK"
#define kEnterName @"kEnterName"
#define kTimer @"kTimer"
#define kAdd @"kAdd"
#define kPause @"kPause"
#define kPlaying @"kPlaying"
#define kuCHOOSETIMER @"kuCHOOSETIMER"
#define kuPLAYWITHFAVORITE @"kuPLAYWITHFAVORITE"
#define kChoosesPause @"kChoosesPause"
#define kListFavorites @"kListFavorites"
#define kDone @"kDone"
#define kEdit @"kEdit"
#define kWatchAdsAavorite @"kWatchAdsAavorite"
#define kuVOLUME @"kuVOLUME"
#define kuFAVORITE @"kuFAVORITE"
#define kuTIMER @"kuTIMER"
#define kuSETTING @"kuSETTING"
#define kWatchAnAdsToGetThisSound @"kWatchAnAdsToGetThisSound"
#define kAnotherUpdating @"kAnotherUpdating"
#define kAbout @"kAbout"
#define kCredit @"kCredit"
#define kDownloading @"kDownloading"
#define kDoYouWantUpdate @"kDoYouWantUpdate"
#define kByClickingOKYouPermit @"kByClickingOKYouPermit"
#define kClickUpdate @"kClickUpdate"
#define kWatchAdsTime @"kWatchAdsTime"
#define kBadNetwork @"kBadNetwork"
#define kYouLikeApp @"kYouLikeApp"
#define kCheckUpdate @"kCheckUpdate"
#define kLestTalk @"kLestTalk"
#define kConnectWithUs @"kConnectWithUs"
#define kPrivacy @"kPrivacy"
#define kProFeatured @"kProFeatured"
#define kCheckNow @"kCheckNow"
#define kRemoveAds @"kRemoveAds"
#define kUnlockPro @"kUnlockPro"
#define kSendFeedback @"kSendFeedback"
#define kVersion @"kVersion"
#define kWatchAdsEnableTimer @"kWatchAdsEnableTimer"
#define kCopyRight @"kCopyRight"
#define kUpdate    @"kUpdate"
#define kBuy        @"kBuy"

#define kCountDown @"kCountDown"
#define kClock @"kClock"
#define kChooseTimerType       @"kChooseTimerType"
#define kOOPS @"kOOPS"
#define kNeedConnect @"kNeedConnect"
#define kPremium @"kPremium"
#define kPremiumVersionNoAds @"kPremiumVersionNoAds"
#define kManagement @"kManagement"
#define kManagementDownloaded @"kManagementDownloaded"
#define kRestorePurchased @"kRestorePurchased"
#define kMailTo @"kMailTo"
#define kOurTwitter @"kOurTwitter"
#define kOurFanpage @"kOurFanpage"
#define kGiveSpecialThanksTo @"kGiveSpecialThanksTo"
#define kOpenSource @"kOpenSource"
#define kWatchOneAdvertisement @"kWatchOneAdvertisement"
#define kFavoCreatedSucessful @"kFavoCreatedSucessful"
#define kTimeCreatedSucessful @"kTimeCreatedSucessful"
#define kCongratulations @"kCongratulations"
#define kPleaseConnectInternet @"kPleaseConnectInternet"
#define kPleaseKeepCalm @"kPleaseKeepCalm"
#define kTellUsWhatYouThink @"kTellUsWhatYouThink"
#define kMessageRate @"kMessageRate"
#define kSetting @"kSetting"
#define kTypeAnything @"kTypeAnything"
#define kSureDelete @"kSureDelete"
#define kMessageShareSocial @"kMessageShareSocial"
#define kHelpTranslate @"kHelpTranslate"
#define kMissingSounds @"kMissingSounds"



#define kWSName1 @"kWSName1"
#define kWSName2 @"kWSName2"
#define kWSName3 @"kWSName3"
#define kWSName4 @"kWSName4"
#define kWSDesc1 @"kWSDesc1"
#define kWSDesc2 @"kWSDesc2"
#define kWSDesc3 @"kWSDesc3"
#define kWSDesc4 @"kWSDesc4"

#endif /* Define_h */
