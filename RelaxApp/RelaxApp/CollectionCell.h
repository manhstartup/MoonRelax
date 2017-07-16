//
//  CollectionCell.h
//  RelaxApp
//
//  Created by JoJo on 9/28/16.
//  Copyright © 2016 JoJo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Define.h"

typedef void (^CollectionCellCallback)(GESTURE_TYPE type,NSInteger index);

@interface CollectionCell : UICollectionViewCell
{

}
@property (nonatomic, strong) IBOutlet UILabel *lbTitle;
@property (nonatomic, strong) IBOutlet UIImageView *imgIcon;
@property (nonatomic, strong) IBOutlet UIImageView *imgCheck;
@property (nonatomic, strong) IBOutlet UIImageView *imgAds;

@property (nonatomic,copy) CollectionCellCallback callback;

@end
