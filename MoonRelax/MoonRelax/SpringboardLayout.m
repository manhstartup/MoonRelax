//
//  SpringboardLayout.m
//  RelaxApp
//
//  Created by JoJo on 9/28/16.
//  Copyright © 2016 JoJo. All rights reserved.
//

#import "SpringboardLayout.h"

@implementation SpringboardLayout
- (id)init
{
    if (self = [super init])
    {
        self.itemSize = CGSizeMake(40, 40);
        self.minimumInteritemSpacing = 48;
        self.minimumLineSpacing = 48;
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.sectionInset = UIEdgeInsetsMake(32, 32, 32, 32);
    }
    return self;
}
@end
