//
//  BaseVC.h
//  RelaxApp
//
//  Created by JoJo on 9/27/16.
//  Copyright © 2016 JoJo. All rights reserved.
//

#import "TabVC.h"

@interface TabVC ()

@end

@implementation TabVC


-(IBAction)fnSubNavClick:(id)sender
{
    //Left -> Right... 10 11 12
    UIButton *btn = (UIButton*) sender;
    
    //Set selected color
    
    for (UIView*view in self.subviews) {
        if ([view isKindOfClass: [UIButton class] ]) {
            
            UIButton*bTmp = (UIButton*)view;
            if (bTmp == btn) {
                [bTmp setSelected:YES];
                continue;
            }else{
                //Change color
                [bTmp setSelected:NO];
            }
            
        }
    }
    
    
    //set selected
    if (self.myCallBack) {
        self.myCallBack(btn);
        
    }
    
}

@end
