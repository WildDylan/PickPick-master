//
//  ADBaseTableViewCell.m
//  PickPick
//
//  Created by Alice on 14/12/17.
//  Copyright (c) 2014年 Alice. All rights reserved.
//

#import "ADBaseTableViewCell.h"

@interface ADBaseTableViewCell ()
@property (strong, nonatomic)  UIImageView *imageHeader;
@property (strong, nonatomic)  UILabel *labelUpperLeft;
@property (strong, nonatomic)  UILabel *labelUpperRight;
@property (strong, nonatomic)  UILabel *labelBottom;
@end

@implementation ADBaseTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
       
        // headerView
        self.imageHeader = [[UIImageView alloc] initWithFrame:CGRectMake(3, 3, 38, 38)];
        self.imageHeader.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_imageHeader];
    
        // labelUpperLeft
        self.labelUpperLeft = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_imageHeader.frame)+10, 5, (self.frame.size.width - (CGRectGetWidth(_imageHeader.frame)+10))/2, 20)];
        self.labelUpperLeft.font = FONT(14);
        self.labelUpperLeft.text = @"leftText";
        [self.contentView addSubview:_labelUpperLeft];
        
        // labelUpperRight
        self.labelUpperRight = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_labelUpperLeft.frame), 5, (self.frame.size.width - (CGRectGetWidth(_imageHeader.frame)+10))/2, 20)];
        self.labelUpperRight.font= FONT(14);
        self.labelUpperRight.text = @"rightLabel";
        [self.contentView addSubview:_labelUpperRight];
        
        // labelBottom
        self.labelBottom = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_imageHeader.frame)+10, CGRectGetMaxY(_labelUpperLeft.frame), self.frame.size.width - (CGRectGetMaxX(_imageHeader.frame)+10), 20)];
        _labelBottom.font =  FONT(13.5);
        _labelBottom.textColor = [UIColor darkGrayColor];
        _labelBottom.text = @"labelBottom text";
        [self.contentView addSubview:_labelBottom];
    
    }
    
    return self;
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
