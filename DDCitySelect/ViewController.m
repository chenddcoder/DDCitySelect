//
//  ViewController.m
//  DDCitySelect
//
//  Created by chendd on 15/6/11.
//  Copyright (c) 2015年 icfcc. All rights reserved.
//

#import "ViewController.h"
#import "DDCitySelectViewController.h"
@interface ViewController ()<DDCitySelectViewControllerDelegate,DDCitySelectViewControllerDataSource>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)clicked:(id)sender {
    DDCitySelectViewController * citySelect=[[DDCitySelectViewController alloc]init];
    citySelect.delegate=self;
    citySelect.dataSource=self;
    [self.navigationController pushViewController:citySelect animated:YES];
}
-(void)touchResponse:(DDCityInfo *)cityInfo{
    NSLog(@"select %@",cityInfo.cityNameLoc);
}
-(NSArray*)loadHotCity{
    return [NSArray arrayWithObjects:@"全国",@"北京",@"成都",@"宁波", nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
