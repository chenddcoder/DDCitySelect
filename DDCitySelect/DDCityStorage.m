//
//  TSMCityStorage.m
//  TSMClientUtils
//
//  Created by PBOC CS on 14-7-30.
//  Copyright (c) 2014年 chendd. All rights reserved.
//

#import "DDCityStorage.h"
#define TSMSTORAGE_TABLE_CITYINFO @"APP_CITY_LOCATION"
#define TSMSTORAGE_TABLE_CITYINFO_CITY_NAME @"CITY_NAME"
#define TSMSTORAGE_TABLE_CITYINFO_CITY_CODE @"CITY_CODE"
#define TSMSTORAGE_TABLE_CITYINFO_CITY_ABBR @"CITY_ABBR"

@implementation DDCityStorage

static DDCityStorage * cityStorage;
+(instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        if(!cityStorage)
        {
            cityStorage = [[DDCityStorage alloc] init];
        }
    });
    
    return cityStorage;
}

-(id)init
{
    if(self = [super init])
    {
        NSString * db_bundle=[[NSBundle mainBundle]pathForResource:@"DDCitySelect" ofType:@"bundle"];
        NSString * pathString = [db_bundle stringByAppendingPathComponent:@"city.db"];
        dbQueue = [[FMDatabaseQueue alloc]initWithPath:pathString];
    }
    return self;
}

-(NSArray*)getAllCityInfo
{
    __block NSMutableArray * dataArray = [[NSMutableArray alloc] init];
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        [db open];
        
        NSString *sqlString=[NSString stringWithFormat:@"select * from %@;",TSMSTORAGE_TABLE_CITYINFO];
        FMResultSet *resultSet=[db executeQuery:sqlString];
        while ([resultSet next])
        {
            NSString * cityName = [resultSet stringForColumn:TSMSTORAGE_TABLE_CITYINFO_CITY_NAME];
            NSString * cityCode = [resultSet stringForColumn:TSMSTORAGE_TABLE_CITYINFO_CITY_CODE];
            NSString * cityIndex = [resultSet stringForColumn:TSMSTORAGE_TABLE_CITYINFO_CITY_ABBR];
        
            DDCityInfo * cityInfo = [[DDCityInfo alloc] init];
            cityInfo.cityNameLoc = cityName;
            cityInfo.cityCode = cityCode;
            cityInfo.cityIndex = cityIndex;
            
            [dataArray addObject:cityInfo];
        }

        [db close];
    }];
    
    return dataArray;
}

-(DDCityInfo*)getCityInfo:(NSString*)cityName
{
    __block DDCityInfo * cityInfo = [[DDCityInfo alloc] init];
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        [db open];
        
        NSString *sqlString = [NSString stringWithFormat:@"select * from %@ where %@ = ?;",TSMSTORAGE_TABLE_CITYINFO, TSMSTORAGE_TABLE_CITYINFO_CITY_NAME];
        NSArray *argvArray = [NSArray arrayWithObjects:cityName, nil];
        FMResultSet *resultSet=[db executeQuery:sqlString withArgumentsInArray:argvArray];
        while ([resultSet next])
        {
            NSString * cityName = [resultSet stringForColumn:TSMSTORAGE_TABLE_CITYINFO_CITY_NAME];
            NSString * cityCode = [resultSet stringForColumn:TSMSTORAGE_TABLE_CITYINFO_CITY_CODE];
            
            cityInfo.cityNameLoc = cityName;
            cityInfo.cityCode = cityCode;
            
            break;
        }
        
        [db close];
    }];
    
    return cityInfo;
}

@end
