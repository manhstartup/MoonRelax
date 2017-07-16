//
//  AddFavoriteView.h
//  RelaxApp
//
//  Created by JoJo on 10/4/16.
//  Copyright © 2016 JoJo. All rights reserved.
//

#import "BaseView.h"
#import "AHTagsLabel.h"
#import "Define.h"
typedef void (^AddFavoriteViewCallback)(NSDictionary *dicCategory);

@interface AddFavoriteView : BaseView
{
    NSMutableArray *_dataSource;
    NSArray *_dataMusic;
    NSDictionary *_dicFavorite;

}
@property (nonatomic, weak) IBOutlet AHTagsLabel *label;
@property (nonatomic, strong) IBOutlet UIView *vViewNav;
@property (nonatomic, strong) IBOutlet UIView *vContent;
@property (nonatomic, strong) IBOutlet UIButton *btnSave;
@property (nonatomic, strong) IBOutlet UITextField *tfTitle;
@property (nonatomic, strong) IBOutlet UILabel *lbCancel;
@property (strong, nonatomic) IBOutlet UIImageView *imgBG;

@property (nonatomic,copy) AddFavoriteViewCallback callback;
-(void)fnSetDataMusic:(NSArray*)arr;
-(void)fnSetInfoFavorite:(NSDictionary*)dicFavorite;
@property (assign)  MODE_TYPE  modeType;
@end
