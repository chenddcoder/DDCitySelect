//
//  CitySelectViewController.h
//  TSMClientUI
//
//  Created by PBOC CS on 14-7-30.
//  Copyright (c) 2014年 wangdehuai. All rights reserved.
//

/*
 class  选择城市的页面
 */

#import <UIKit/UIKit.h>
#import "DDCityInfo.h"
@protocol DDCitySelectViewControllerDelegate;
@protocol DDCitySelectViewControllerDataSource;
@interface DDCitySelectViewController : UIViewController

@property (nonatomic, assign) id<DDCitySelectViewControllerDelegate> delegate;
@property (nonatomic, assign) id<DDCitySelectViewControllerDataSource> dataSource;

@end

@protocol DDCitySelectViewControllerDelegate <NSObject>
-(void)touchResponse:(DDCityInfo*)cityInfo;
@end

@protocol DDCitySelectViewControllerDataSource <NSObject>
@required
-(NSArray*)loadHotCity;
@optional
-(NSString*)loadLocationCity;
@end