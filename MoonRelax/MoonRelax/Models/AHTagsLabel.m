//
//  AHTagsLabel.m
//  AutomaticHeightTagTableViewCell
//
//  Created by WEI-JEN TU on 2016-07-16.
//  Copyright © 2016 Cold Yam. All rights reserved.
//

#import "AHTagsLabel.h"
#import "AHTagView.h"
#import "Define.h"
#import "UIImage+ProportionalFill.h"
@implementation AHTagsLabel

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
        [self setupGesture];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setup];
    [self setupGesture];
}

- (void)setup {
    self.numberOfLines = 0;
    self.lineBreakMode = NSLineBreakByWordWrapping;
    self.textAlignment = NSTextAlignmentLeft;
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = YES;
}

- (void)setupGesture {
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(tap:)];
    [self addGestureRecognizer:recognizer];
}
-(void)setCallback:(AHTagsLabelCallback)callback
{
    _callback = callback;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)tap:(UITapGestureRecognizer *)recognizer {
    UILabel *label = (UILabel *)recognizer.view;
    CGSize labelSize = recognizer.view.bounds.size;
    
    NSTextContainer *container = [[NSTextContainer alloc] initWithSize:labelSize];
    container.lineFragmentPadding = 0.0;
    container.lineBreakMode = label.lineBreakMode;
    container.maximumNumberOfLines = label.numberOfLines;
    
    NSLayoutManager *manager = [NSLayoutManager new];
    [manager addTextContainer:container];
    
    NSTextStorage *storage = [[NSTextStorage alloc] initWithAttributedString:label.attributedText];
    [storage addLayoutManager:manager];
    
    CGPoint touchPoint = [recognizer locationInView:label];
    NSInteger indexOfCharacter = [manager characterIndexForPoint:touchPoint
                                                 inTextContainer:container
                        fractionOfDistanceBetweenInsertionPoints:nil];
    if (indexOfCharacter >= _tags.count) {
        if (_callback) {
            _callback(_dicMusic);
        }
    }
}

#pragma mark - Tags setter

- (void)fnSetTags:(NSArray*)tags withDicMusic:(NSDictionary*)dicMusic withScreen:(int)screen {
    _tags = tags;
    _dicMusic = dicMusic;
    UITableViewCell *cell = [UITableViewCell new];
    NSMutableAttributedString *mutableString = [NSMutableAttributedString new];
    for (NSInteger i = 0; i < tags.count; i++) {
        AHTag *tag = tags[i];
        NSString *title = tag.title;
        
        AHTagView *view = [AHTagView new];
        view.label.attributedText = [AHTagsLabel attributedString:title];
        if (screen == FAVORITE_SCREEN_INFO) {
            view.backgroundColor = UIColorFromRGB(COLOR_BACKGROUND_FAVORITE);
            view.label.backgroundColor = UIColorFromRGB(COLOR_VIEWFAVORITE_TAGS);
            view.label.textColor = [UIColor whiteColor];
        }
        else
        {
            view.backgroundColor = [UIColor whiteColor];
            view.label.backgroundColor = UIColorFromRGB(COLOR_ADDFAVORITE_TAGS);
            view.label.textColor = [UIColor whiteColor];
        }

        CGSize size = [view systemLayoutSizeFittingSize:view.frame.size
                          withHorizontalFittingPriority:UILayoutPriorityFittingSizeLevel
                                verticalFittingPriority:UILayoutPriorityFittingSizeLevel];
        view.frame = CGRectMake(0, 0, size.width + 20, size.height);
        [cell.contentView addSubview:view];
        
        UIImage *image = view.image;
        NSTextAttachment *attachment = [NSTextAttachment new];
        attachment.image = image;
        
        NSAttributedString *attrStr = [NSAttributedString attributedStringWithAttachment:attachment];
        [mutableString beginEditing];
        [mutableString appendAttributedString:attrStr];
        [mutableString endEditing];
    }
    //ADD Button Share
    if (screen == FAVORITE_SCREEN_INFO) {
        
        AHTagView *view = [AHTagView new];
        view.backgroundColor = [UIColor whiteColor];
        view.label.backgroundColor = [UIColor clearColor];
        view.label.textColor = [UIColor clearColor];
        view.imgBackGround.image = [UIImage imageNamed:@"ic_favo_share"];
        CGSize size = [view systemLayoutSizeFittingSize:view.frame.size
                          withHorizontalFittingPriority:UILayoutPriorityFittingSizeLevel
                                verticalFittingPriority:UILayoutPriorityFittingSizeLevel];
        view.frame = CGRectMake(0, 0, 40, size.height);
        [cell.contentView addSubview:view];
        
        UIImage *image = view.image;
        NSTextAttachment *attachment = [NSTextAttachment new];
        attachment.image = image;
        
        NSAttributedString *attrStr = [NSAttributedString attributedStringWithAttachment:attachment];
        [mutableString beginEditing];
        [mutableString appendAttributedString:attrStr];
        [mutableString endEditing];
    }
    //
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineSpacing = 5.0;
    [mutableString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, mutableString.length)];
    
    self.attributedText = mutableString;
}

#pragma mark - NSAttributedString

+ (NSAttributedString *)attributedString:(NSString *)string {
    NSMutableParagraphStyle *paragraphStyle =  [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    paragraphStyle.firstLineHeadIndent = 10.0f;
    paragraphStyle.headIndent = 10.0f;
    paragraphStyle.tailIndent = 10.0f;
    NSDictionary *attributes = @{
                                 NSParagraphStyleAttributeName  : paragraphStyle,
                                 NSFontAttributeName            : [UIFont fontWithName:@"Roboto-Regular" size:13]
                                 };
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:string
                                                                         attributes:attributes];
    return attributedText;
}

@end
