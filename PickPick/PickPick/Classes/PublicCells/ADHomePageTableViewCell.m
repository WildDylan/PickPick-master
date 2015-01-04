//
//  ADHomePageTableViewCell.m
//  PickPick
//
//  Created by Alice on 14/12/19.
//  Copyright (c) 2014年 Alice. All rights reserved.
//

#import "ADHomePageTableViewCell.h"
#import <MapKit/MapKit.h>


@interface ADHomePageTableViewCell ()

@property (strong, nonatomic) IBOutlet UIImageView *imageHeader;

@property (strong, nonatomic) IBOutlet UILabel *labelUserName;
@property (strong, nonatomic) IBOutlet UILabel *labelDistance;

@property (strong, nonatomic) IBOutlet UILabel *labelStatus;
@property (strong, nonatomic) IBOutlet UIImageView *imageBreakLine;

@property (strong, nonatomic) IBOutlet UIImageView *imageIcon;

@property (strong, nonatomic) IBOutlet UILabel *labelBelowFirst;
@property (strong, nonatomic) IBOutlet UILabel *labelBelowSecond;
@property (strong, nonatomic) IBOutlet UILabel *labelBelowThird;

@property (strong, nonatomic) CLGeocoder *geocoder;
@end

@implementation ADHomePageTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.geocoder = [[CLGeocoder alloc] init];
    [self adjustSubviews];
    
}

- (void)adjustSubviews {
    
    self.imageHeader.layer.cornerRadius = 5;
    self.imageHeader.layer.masksToBounds = YES;
    self.imageIcon.layer.cornerRadius = 10;
    self.imageIcon.layer.masksToBounds = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

// --------------------------------------------------------------------------------------------------------------------
- (void)setModel:(Mission *)model {
    
    _labelUserName.text = @"user nickname";
    _labelDistance.text = model.address; //  使用逆地理编码 获取经纬度, 计算距离 赋值
    _labelStatus.text = model.reward;
   // _imageHeader.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model.h]]];
    
    _labelBelowFirst.text = model.title;
    _labelBelowSecond.text = model.timeLimit;
    _labelBelowThird.text = model.address;
    
}

// ---------------------------------------------home page--------------------------------------------------------------------
- (void)setModelHome:(ADModelHomePage *)modelHome {
    
    [self setValueForLabelUserName:modelHome];
    [self setValueForLabelDistance:modelHome.latitude Longitude:modelHome.longitude]; //  使用逆地理编码 获取经纬度, 计算距离 赋值
    [self setImageForCellHeader:modelHome];
    _labelStatus.text = [NSString stringWithFormat:@"¥%@",modelHome.reward];
    _labelBelowFirst.text = modelHome.title;
    _labelBelowSecond.text = modelHome.timeLimit;
    _labelBelowThird.text = modelHome.address;
    
    
}

- (void)setImageForCellHeader:(ADModelHomePage *)modelHome {
    
    AVFile *file = [modelHome.host objectForKey:@"imageHeader"];
    NSData *data = [file getData];
    self.imageHeader.image = [UIImage imageWithData:data];
    
}

- (void)setValueForLabelUserName:(ADModelHomePage *)modelHome{

    _labelUserName.text = [modelHome.host objectForKey:@"nickname"];
    
}

- (void)setValueForLabelDistance:(NSString *)latitude Longitude:(NSString *)longitude {
    
    float floatLatitude = [latitude floatValue];
    float floatLongitude = [longitude floatValue];
    CLLocation *locationDestination = [[CLLocation alloc] initWithLatitude:floatLatitude longitude:floatLongitude];
    CLLocation *locationOrigion = [DataHandle shareInstance].currentLocation;
    
    CGFloat distance = [locationOrigion distanceFromLocation:locationDestination];
//    ADLog(@"---- %f----",distance);
    if (distance >= 0.0 && distance < 1000.0) {
        
        NSString *lessKm = [NSString stringWithFormat:@"%.2fm",distance];
        _labelDistance.text = lessKm;
    
    }else if (distance >= 1000.0 && distance < 10000000.0 ){
        
        CGFloat floatMoreThanKm = distance / 1000;
        NSString *moreThanKm = [NSString stringWithFormat:@"%.2fkm",floatMoreThanKm];
        _labelDistance.text = moreThanKm;
        
    }else if (distance >= 10000000.0 ){
        
        NSString *faraway = @"一万公里外";
        _labelDistance.text = faraway;
        
    }else{
        
        _labelDistance.text = @"大概在火星";
    }
    
}

// ----------------------------------------------account page-----------------------------------------------------------------
- (void)setModelAccount:(ADModelHomePage *)modelAccount {
    
    [self setValueForLabelUserName:modelAccount];
    [self setValueForLabelDistance:modelAccount.latitude Longitude:modelAccount.longitude];
    [self setValueForLabelStatus:modelAccount];
    [self setImageForCellHeader:modelAccount];
    _labelStatus.text = modelAccount.status;
    _labelBelowFirst.text = modelAccount.title;
    _labelBelowSecond.text = modelAccount.timeLimit;
    _labelBelowThird.text = modelAccount.address;
   
    
}

- (void)setValueForLabelStatus:(ADModelHomePage *)model {
    
    
    
}








@end
