//
//  CitySelectCell.h
//  TSMClientUI
//
//  Created by PBOC CS on 14-7-31.
//  Copyright (c) 2014年 wangdehuai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDCityInfo.h"
@interface DDCitySelectCell : UITableViewCell
{
    UILabel * cityName;
    UIImageView * imageView;
}
-(void)setData:(DDCityInfo*)cityInfo isFirstCell:(BOOL)isFirstCell;

@end
