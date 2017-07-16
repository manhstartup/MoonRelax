//
//  FavoriteView.h
//  RelaxApp
//
//  Created by JoJo on 9/30/16.
//  Copyright © 2016 JoJo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"
#import "AddFavoriteView.h"
typedef void (^FavoriteViewCallback)(NSDictionary *dicCategory);

@interface FavoriteView : BaseView
{
    NSMutableArray *_arrMusic;
    BOOL areAdsRemoved;

}
@property (nonatomic, strong) IBOutlet UIView *vViewNav;
@property (nonatomic, strong) IBOutlet UIView *vContent;
@property (strong, nonatomic) IBOutlet UITableView *tableControl;
@property (nonatomic,copy) FavoriteViewCallback callback;
@property (nonatomic, strong)  AddFavoriteView *vAddFavorite;
@property (strong, nonatomic) IBOutlet UILabel *lbEdit;
@property (strong, nonatomic) IBOutlet UIImageView *imgBelingMode;
@property (nonatomic, strong) IBOutlet UIView *vViewEdit;

@end
