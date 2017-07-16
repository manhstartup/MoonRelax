//
//  AHTagTableViewCell.h
//  AutomaticHeightTagTableViewCell
//
//  Created by WEI-JEN TU on 2016-07-16.
//  Copyright © 2016 Cold Yam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AHTagsLabel.h"

@interface AHTagTableViewCell : UITableViewCell
{
    NSMutableArray *_dataSource;

}
@property (nonatomic, weak) IBOutlet AHTagsLabel *label;
@property (nonatomic, weak) IBOutlet UILabel *title;
@property (nonatomic, weak) IBOutlet UIButton  *btnSelect;

-(void)fnSetDataWithDicMusic:(NSDictionary*)dicMusic;
@end
