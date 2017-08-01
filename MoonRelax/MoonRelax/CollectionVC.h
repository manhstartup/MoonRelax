//
//  CollectionVC.h
//  RelaxApp
//
//  Created by JoJo on 9/28/16.
//  Copyright © 2016 JoJo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDButtonIcon.h"
typedef void (^CollectionVCCallback)(NSDictionary *itemMusic,NSDictionary *dicCategory,BOOL isLongTap);
typedef void (^CategoryCallback)(NSDictionary *dicCategory, BOOL isDownload);

@interface CollectionVC : UIView<UIScrollViewDelegate>
@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) IBOutlet UIImageView *image;
@property (nonatomic, strong) IBOutlet MDButtonIcon *btnDownLoad;
@property (nonatomic, strong) IBOutlet UIButton *btnClose;
@property (nonatomic, strong) IBOutlet UIView *vDownLoad;
@property (nonatomic, strong) IBOutlet UIImageView *imageBackground;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contraintBottomBackGround;

-(instancetype)initWithEVC;
-(void)addContraintSupview:(UIView*)viewSuper;
-(void)updateDataMusic:(NSDictionary*)dicTmp;
@property (nonatomic,copy) CollectionVCCallback callback;
@property (nonatomic,copy) CategoryCallback callbackCategory;

@end
