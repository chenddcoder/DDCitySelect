//
//  CitySelectCell.m
//  TSMClientUI
//
//  Created by PBOC CS on 14-7-31.
//  Copyright (c) 2014年 wangdehuai. All rights reserved.
//

#import "DDCitySelectCell.h"

@interface DDCitySelectCell ()

@property (nonatomic, strong) DDCityInfo * info;

@end

@implementation DDCitySelectCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        cityName = [[UILabel alloc] init];
        cityName.font = [UIFont systemFontOfSize:16.0f];
        cityName.textColor = [UIColor blackColor];
        cityName.backgroundColor = [UIColor clearColor];
        [self addSubview:cityName];
        
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 40, 40)];
        NSString * db_bundle=[[NSBundle mainBundle]pathForResource:@"DDCitySelect" ofType:@"bundle"];
        NSString * pathString = [db_bundle stringByAppendingPathComponent:@"cityMap.png"];
        imageView.image = [UIImage imageNamed:pathString];

        UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 49.5f, [UIScreen mainScreen].bounds.size.width, 0.5f)];
        lineView.backgroundColor = [UIColor grayColor];
        [self addSubview:lineView];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setData:(DDCityInfo*)cityInfo isFirstCell:(BOOL)isFirstCell
{
    self.info = cityInfo;
    cityName.text = _info.cityNameLoc;
    if(isFirstCell)
    {
        if(nil == _info.cityNameLoc || [_info.cityNameLoc isEqualToString:@""])
        {
            cityName.text = @"正在定位. . .";
        }
        
        [self addSubview:imageView];
        cityName.frame = CGRectMake(60, 15, 200, 20);
    }
    else
    {
        [imageView removeFromSuperview];
        cityName.frame = CGRectMake(15, 15, 200, 20);
    }
}

@end
