//
//  TSMCityStorage.h
//  TSMClientUtils
//
//  Created by PBOC CS on 14-7-30.
//  Copyright (c) 2014年 chendd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB/FMDB.h>
#import "DDCityInfo.h"

@interface DDCityStorage : NSObject
{
    FMDatabaseQueue *dbQueue;
}

/*!
 *	@brief	单例方法
 */
+(instancetype)shareInstance;

/*!
 *	@brief	读取全国的城市信息
 *
 *	@return	由CityInfo组成的数组
 */
-(NSArray*)getAllCityInfo;

-(DDCityInfo*)getCityInfo:(NSString*)cityName;

@end
