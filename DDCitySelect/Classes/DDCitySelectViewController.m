//
//  CitySelectViewController.m
//  TSMClientUI
//
//  Created by PBOC CS on 14-7-30.
//  Copyright (c) 2014年 wangdehuai. All rights reserved.
//

#import "DDCitySelectViewController.h"
#import "DDCityStorage.h"
#import "DDCitySelectCell.h"
#import <FCCurrentLocationGeocoder/FCCurrentLocationGeocoder.h>
#define SECTION_HOTCITY @"#"
#define SECTION_LOCATIONCITY @"1"
@interface DDCitySelectViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView * citySelectTableView;
/** 城市数据 */
@property (nonatomic, strong) NSMutableDictionary *cityInfoDic;
/** 城市索引 */
@property (nonatomic, strong) NSMutableArray *indexArray;

@property (nonatomic, strong) NSArray * cityInfoArray;

@end

@implementation DDCitySelectViewController

/** 懒加载城市信息及城市索引 */
- (NSMutableDictionary *)cityInfoDic {
    if (!_cityInfoDic) {
        _cityInfoDic = [NSMutableDictionary dictionary];
    }
    return _cityInfoDic;
}

- (NSMutableArray *)indexArray {
    if (!_indexArray) {
        _indexArray = [NSMutableArray array];
    }
    return _indexArray;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"选择城市";
        self.hidesBottomBarWhenPushed = YES;
        //创建TableView
        _citySelectTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
        _citySelectTableView.dataSource = self;
        _citySelectTableView.delegate = self;
        _citySelectTableView.backgroundColor = [UIColor clearColor];
        _citySelectTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_citySelectTableView];
    [self loadAllCityInfo:[[DDCityStorage shareInstance] getAllCityInfo]];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)loadAllCityInfo:(NSArray *)array
{
    for(DDCityInfo * cityInfo in array)
    {
        if([self.cityInfoDic objectForKey:cityInfo.cityIndex])
        {
            [[self.cityInfoDic objectForKey:cityInfo.cityIndex] addObject:cityInfo];
        }
        else
        {
            NSMutableArray * ar = [[NSMutableArray alloc] init];
            [self.cityInfoDic setObject:ar forKey:cityInfo.cityIndex];
            [[self.cityInfoDic objectForKey:cityInfo.cityIndex] addObject:cityInfo];
        }
    }
    [self.indexArray removeAllObjects];
    [self.indexArray addObject:@"1"];
    [self.indexArray addObject:@"#"];
    [self.indexArray addObjectsFromArray:[[self.cityInfoDic allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)]];
    
    if ([_dataSource respondsToSelector:@selector(loadHotCity)]) {
        NSMutableArray * topCityArray = [[NSMutableArray alloc] init];
        NSArray * arr=[_dataSource loadHotCity];
        for (NSString * city in arr) {
            DDCityInfo * cityInfo =nil;
            if ([city isEqualToString:@"全国"]) {
                cityInfo=[[DDCityInfo alloc]init];
                cityInfo.cityNameLoc=city;
                cityInfo.cityCode=@"0";
            }else{
                cityInfo= [[DDCityStorage shareInstance] getCityInfo:city];
            }
            cityInfo.cityIndex=@"#";
            [topCityArray addObject:cityInfo];
        }
        [self.cityInfoDic setObject:topCityArray forKey:@"#"];
    }
    //设置一个空数据现实正在定位。。。
    DDCityInfo * cityInfo = [[DDCityInfo alloc]init];
    NSMutableArray * locationCityArray = [[NSMutableArray alloc] init];
    [locationCityArray addObject:cityInfo];
    [self.cityInfoDic setObject:locationCityArray forKey:@"1"];
    if ([_dataSource respondsToSelector:@selector(loadLocationCity)]) {
        NSMutableArray * locationCityArray = [[NSMutableArray alloc] init];
        NSString * city=[_dataSource loadLocationCity];
        if (city!=nil) {
            DDCityInfo * cityInfo= [[DDCityStorage shareInstance] getCityInfo:city];
            [locationCityArray addObject:cityInfo];
            [self.cityInfoDic setObject:locationCityArray forKey:@"1"];
        }else{
            [self Location];
        }
    }else{
        [self Location];
    }
//    //热门城市
//    [topCityArray addObjectsFromArray:@[
//                                        [self cityInfoWithCityNameLoc:@"全国" cityCode:@"0" cityIndex:@"#"],
//                                        [self cityInfoWithCityNameLoc:@"北京" cityCode:@"131" cityIndex:@"#"],
//                                        [self cityInfoWithCityNameLoc:@"成都" cityCode:@"75" cityIndex:@"#"],
//                                        [self cityInfoWithCityNameLoc:@"宁波" cityCode:@"180" cityIndex:@"#"]
//                                        ]];
    
}
-(void)Location{
    //定位
    FCCurrentLocationGeocoder * geocoder=[FCCurrentLocationGeocoder sharedGeocoder];
    [geocoder reverseGeocode:^(BOOL success) {
        if (success) {
            NSString * address=geocoder.locationCity;
            NSRange providx=[address rangeOfString:@"省"];
            NSRange cityidx=[address rangeOfString:@"市"];
            NSString * LocationCity=nil;
            if (providx.location==NSNotFound) {
                LocationCity= [address substringWithRange:NSMakeRange(0, cityidx.location)];
            }else
            {
                LocationCity= [address substringWithRange:NSMakeRange(providx.location+providx.length, cityidx.location-providx.location-providx.length)];
            }
            //                NSLog(@"城市 : %@",LocationCity);
            NSMutableArray * locationCityArray = [[NSMutableArray alloc] init];;
            DDCityInfo * cityInfo = [[DDCityStorage shareInstance] getCityInfo:LocationCity];
            [locationCityArray addObject:cityInfo];
            [self.cityInfoDic setObject:locationCityArray forKey:@"1"];
            [_citySelectTableView reloadData];
        }else{
            NSLog(@"geocoder reverse failed");
        }
    }];
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray * array=nil;
//    NSLog(@"dict = %@",[_indexArray objectAtIndex:indexPath.section]);
    array = [_cityInfoDic objectForKey:[_indexArray objectAtIndex:indexPath.section]];
    DDCityInfo * cityInfo = [array objectAtIndex:indexPath.row];
    if(_delegate && [_delegate respondsToSelector:@selector(touchResponse:)])
    {
        [_delegate touchResponse:cityInfo];
    }
    if (cityInfo.cityNameLoc!=nil) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_indexArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(0 == section)
    {
        NSArray * array = [_cityInfoDic objectForKey:@"1"];
        return [array count];
    }
    if(1 == section)
    {
        NSArray * array = [_cityInfoDic objectForKey:@"#"];
        return [array count];
    }
    NSString * key = [_indexArray objectAtIndex:section];
    NSUInteger count = [[_cityInfoDic objectForKey:key] count];
    if(count > 0)
    {
        return count;
    }
    else
    {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellString = @"cell";
    DDCitySelectCell * cell = (DDCitySelectCell*)[tableView dequeueReusableCellWithIdentifier:cellString];
    if(nil == cell)
    {
        cell = [[DDCitySelectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellString];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
//    cell.delegate = self;
    
    if(0 == indexPath.section)
    {
        NSArray * array = [_cityInfoDic objectForKey:@"1"];
        DDCityInfo * cityInfo = [array objectAtIndex:indexPath.row];
        
        [cell setData:cityInfo isFirstCell:YES];
    }
    else if(1 == indexPath.section)
    {
        NSArray * array = [_cityInfoDic objectForKey:@"#"];
        DDCityInfo * cityInfo = [array objectAtIndex:indexPath.row];
        [cell setData:cityInfo isFirstCell:NO];
    }
    else
    {
        NSArray * array = [_cityInfoDic objectForKey:[_indexArray objectAtIndex:indexPath.section]];
        DDCityInfo * cityInfo = [array objectAtIndex:indexPath.row];
        [cell setData:cityInfo isFirstCell:NO];
    }
    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(0 == section)
    {
        return @"定位城市";
    }
    if(1 == section)
    {
        return @"热门城市";
    }
    return [_indexArray objectAtIndex:section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return _indexArray;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if(0 == index)
    {
        return 0;
    }
    else
    {
        return index;
    }
    return 0;
}

@end
