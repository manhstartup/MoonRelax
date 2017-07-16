//
//  WelcomeScreenVC.m
//  RelaxApp
//
//  Created by JoJo on 11/20/16.
//  Copyright © 2016 JoJo. All rights reserved.
//

#import "WelcomeScreenVC.h"
#import "WSItemView.h"
@interface WelcomeScreenVC ()
{
    NSInteger iNumberCollection;
    NSMutableArray *arrData;
}
@end

@implementation WelcomeScreenVC

- (void)viewDidLoad {
    [super viewDidLoad];
    arrData = [NSMutableArray new];
    [self fnSetData];
    // Do any additional setup after loading the view from its nib.
    self.lbTitle.font = [UIFont fontWithName:@"Roboto-Regular" size:17];
    self.lbTitle.textColor = [UIColor whiteColor];
    [self.btnSkip setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.pageControl.tintColor = UIColorFromRGB(COLOR_WELCOME_SCREEN_PAGECONTROL_TINT);
    self.pageControl.currentPageIndicatorTintColor = UIColorFromRGB(COLOR_WELCOME_SCREEN_PAGECONTROL_CURRENT);
    self.imgBackGround.backgroundColor = UIColorFromRGB(COLOR_WELCOME_SCREEN);
    
    [self.btnNext.layer setMasksToBounds:YES];
    self.btnNext.layer.cornerRadius= 22;
    [self.btnNext setTitleColor:UIColorFromRGB(COLOR_WELCOME_SCREEN) forState:UIControlStateNormal];
    self.btnNext.backgroundColor = [UIColor whiteColor];

}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self addWelcomeScreen];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)fnSetData
{
    
    NSMutableDictionary *dic1 = [@{@"name": str(kWSName1),
                                   @"desc": str(kWSDesc1),
                                   @"image": @"ws1"} copy];
    NSMutableDictionary *dic2 = [@{@"name": str(kWSName2),
                                   @"desc": str(kWSDesc2),
                                   @"image": @"ws2"} copy];
    NSMutableDictionary *dic3 = [@{@"name": str(kWSName3),
                                   @"desc": str(kWSDesc3),
                                   @"image": @"ws3"} copy];
    NSMutableDictionary *dic4 = [@{@"name": str(kWSName4),
                                   @"desc": str(kWSDesc4),
                                   @"image": @"ws4"} copy];

    [arrData addObject:dic1];
    [arrData addObject:dic2];
    [arrData addObject:dic3];
    [arrData addObject:dic4];
}

-(void)addWelcomeScreen
{
    //remove subview scroll news
    for (UIView *view in self.scroll_View.subviews) {
        [view removeFromSuperview];
    }
    iNumberCollection = arrData.count;
    float delta = CGRectGetWidth(self.scroll_View.frame);
    for (int i = 0; i< iNumberCollection; i++) {
        UIView *v =[UIView new];
        v.frame = CGRectMake( i*delta, 0 , delta , CGRectGetHeight(self.scroll_View.frame));
        [self.scroll_View addSubview:v];
        WSItemView *view = [[WSItemView alloc] initWithClassName:NSStringFromClass([WSItemView class])];
        [view  addContraintSupview:v];
        [view fnSetData:arrData[i]];
        [self.scroll_View setContentSize:CGSizeMake(iNumberCollection*delta, CGRectGetHeight(self.scroll_View.frame))];
    }
    
    [self.scroll_View setPagingEnabled:YES];
    self.pageControl.numberOfPages = iNumberCollection;
    //set title
    CGFloat pageWidth = CGRectGetWidth(self.scroll_View.frame);
    CGFloat currentPage = floor((self.scroll_View.contentOffset.x-pageWidth/2)/pageWidth)+1;
    // Change the indicator
    self.pageControl.currentPage = (int) currentPage;
    if (currentPage == iNumberCollection -1)
    {
        [self.btnNext setTitle:@"BEGIN" forState:UIControlStateNormal];
        
    }
    else
    {
        [self.btnNext setTitle:@"NEXT" forState:UIControlStateNormal];
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
    if (currentPage == iNumberCollection -1)
    {
        [self.btnNext setTitle:@"FINISH" forState:UIControlStateNormal];
        self.btnSkip.hidden = YES;
    }
    else
    {
        [self.btnNext setTitle:@"NEXT" forState:UIControlStateNormal];
        self.btnSkip.hidden = NO;
    }
}
-(IBAction)closeAction:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:show_welcome_screen];
    [self dismissViewControllerAnimated:YES completion:^{}];
}
-(IBAction)nextAction:(id)sender
{
    if (self.pageControl.currentPage == iNumberCollection -1)
    {
        [self closeAction:nil];
    }
    else
    {
        //NEXT
        CGRect frame = _scroll_View.frame;
        frame.origin.x = frame.size.width * (self.pageControl.currentPage+1);
        frame.origin.y = 0;
        [_scroll_View scrollRectToVisible:frame animated:YES];
        
        self.pageControl.currentPage = (int) self.pageControl.currentPage+1;
        if (self.pageControl.currentPage == iNumberCollection -1)
        {
            [self.btnNext setTitle:@"FINISH" forState:UIControlStateNormal];
            self.btnSkip.hidden = YES;
        }
        else
        {
            [self.btnNext setTitle:@"NEXT" forState:UIControlStateNormal];
            self.btnSkip.hidden = NO;
        }
    }
}
@end
