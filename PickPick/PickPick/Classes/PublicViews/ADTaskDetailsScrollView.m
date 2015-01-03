//
//  ADTaskDetailsScrollView.m
//  PickPick
//
//  Created by Alice on 14/12/17.
//  Copyright (c) 2014年 Alice. All rights reserved.
//

#import "ADTaskDetailsScrollView.h"

@interface ADTaskDetailsScrollView ()

@property (nonatomic, strong) UILabel *labelTitle;
@property (nonatomic, strong) UILabel *labelReward;
@property (nonatomic, strong) UILabel *labelContent;

@property (nonatomic, strong) UITextField *textFieldTitle;
@property (nonatomic, strong) UITextField *textFieldReward;

@property (nonatomic, strong) UITextView *textViewContent;

@property (nonatomic, strong) UIButton *buttonTimeLimit;
@property (nonatomic, strong) UIButton *buttonRecording;
@property (nonatomic, strong) UIButton *buttonPost;

@end

@implementation ADTaskDetailsScrollView




- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        
        
        // Labels :
        // title
        self.labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 40, 25)];
        _labelTitle.text = @"主题";
        _labelTitle.backgroundColor = [UIColor orangeColor];
        _labelTitle.font = FONT(16);
        _labelTitle.textAlignment = NSTextAlignmentCenter;
        _labelTitle.layer.cornerRadius = 3;
        _labelTitle.layer.masksToBounds = YES;
        
        [self addSubview:_labelTitle];
        
        // reward
        self.labelReward = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_labelTitle.frame), CGRectGetMaxY(_labelTitle.frame)+10, CGRectGetWidth(_labelTitle.frame), CGRectGetHeight(_labelTitle.frame))];
        _labelReward.text = @"酬金";
        _labelReward.backgroundColor = [UIColor orangeColor];
        _labelReward.font = FONT(16);
        _labelReward.textAlignment = NSTextAlignmentCenter;
        _labelReward.layer.cornerRadius = 3;
        _labelReward.layer.masksToBounds = YES;
        [self addSubview:_labelReward];
        
        // content
        self.labelContent = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_labelTitle.frame), CGRectGetMaxY(_labelReward.frame)+10, CGRectGetWidth(_labelReward.frame), CGRectGetHeight(_labelReward.frame))];
        _labelContent.text = @"内容";
        _labelContent.textAlignment = NSTextAlignmentCenter;
        _labelContent.backgroundColor = [UIColor orangeColor];
        _labelContent.font = FONT(16);
        _labelContent.layer.cornerRadius = 3;
        _labelContent.layer.masksToBounds = YES;
        [self addSubview:_labelContent];
        
        
        // TextFields :
        // title
        self.textFieldTitle = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_labelTitle.frame)+10, CGRectGetMinY(_labelTitle.frame), self.frame.size.width - (CGRectGetWidth(_labelTitle.frame)+40), 25)];
        _textFieldTitle.borderStyle = UITextBorderStyleRoundedRect;
        //_textFieldTitle.layer.cornerRadius = 10;
        //_textFieldTitle.layer.masksToBounds = YES;
        [self addSubview:_textFieldTitle];
        
        
        // reward
        self.textFieldReward = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(_textFieldTitle.frame), CGRectGetMaxY(_textFieldTitle.frame)+10, CGRectGetWidth(_textFieldTitle.frame)-100, CGRectGetHeight(_textFieldTitle.frame))];
        _textFieldReward.borderStyle = UITextBorderStyleRoundedRect;
//        _textFieldReward.layer.cornerRadius = 10;
//        _textFieldReward.layer.masksToBounds = YES;
        [self addSubview:_textFieldReward];
        
        
        // TextView :
        // textViewContent
        self.textViewContent = [[UITextView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_labelContent.frame)+10, CGRectGetMaxY(_textFieldReward.frame)+10, CGRectGetWidth(_textFieldTitle.frame), 180)];
        _textViewContent.layer.cornerRadius = 3;
        _textViewContent.backgroundColor = [UIColor lightGrayColor];
        _textViewContent.layer.masksToBounds = YES;
        [self addSubview:_textViewContent];
        
        
        // Buttons :
        // buttonTimeLimit
        self.buttonTimeLimit = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [_buttonTimeLimit setTitle:@"时间限制" forState:(UIControlStateNormal)];
        _buttonTimeLimit.backgroundColor = [UIColor orangeColor];
        _buttonTimeLimit.layer.cornerRadius = 3;
        _buttonTimeLimit.layer.masksToBounds = YES;
        _buttonTimeLimit.frame = CGRectMake(CGRectGetMaxX(_textFieldReward.frame)+10, CGRectGetMinY(_textFieldReward.frame),frame.size.width - CGRectGetMaxX(_textFieldReward.frame)-25, CGRectGetHeight(_textFieldReward.frame));
        [self addSubview:_buttonTimeLimit];
        
        // buttonRecording
        self.buttonRecording = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [_buttonRecording setTitle:@"语音发布" forState:(UIControlStateNormal)];
        _buttonPost.backgroundColor = [UIColor orangeColor];
        _buttonRecording.frame = CGRectMake(CGRectGetMinX(_textViewContent.frame), CGRectGetMaxY(_textViewContent.frame)+10, CGRectGetWidth(_textViewContent.frame)/2 - 10, CGRectGetHeight(_labelTitle.frame));
        _buttonRecording.layer.cornerRadius = 3;
        _buttonRecording.backgroundColor = [UIColor orangeColor];
        _buttonRecording.layer.masksToBounds = YES;
        [self addSubview:_buttonRecording];
        
        // buttonPost
        self.buttonPost = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [_buttonPost setTitle:@"发布需求" forState:(UIControlStateNormal)];
         _buttonPost.backgroundColor = [UIColor orangeColor];
        _buttonPost.frame = CGRectMake(CGRectGetMaxX(_buttonRecording.frame)+10, CGRectGetMaxY(_textViewContent.frame)+10, CGRectGetWidth(_buttonRecording.frame), CGRectGetHeight(_buttonRecording.frame));
        _buttonPost.layer.cornerRadius = 3;
        _buttonPost.layer.masksToBounds = YES;
        [self addSubview:_buttonPost];
        
        
        // scroll view Data Source
        self.contentSize = CGSizeMake(frame.size.width, frame.size.height+100);
        self.alwaysBounceVertical = YES;
    }
    
    return self;
    
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
