//
//  BroadcastViewController.m
//  LiveVideo
//
//  Created by 王亮 on 2016/11/3.
//  Copyright © 2016年 wangliang. All rights reserved.
//

#import "BroadcastViewController.h"
#import "LiveViewController.h"
#import "LiveCell.h"
#import <AFNetworking.h>
#import <MJExtension.h>
#import "LiveModel.h"

static NSString * const ID=@"liveCell";

@interface BroadcastViewController ()

@property (nonatomic,strong) NSMutableArray *lives;

@end

@implementation BroadcastViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
  self.title=@"直播列表";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"LiveCell" bundle:nil] forCellReuseIdentifier:ID];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    [self loadData];
    
}

-(void)loadData
{
    NSString *urlStr=@"http://218.11.0.112/api/live/aggregation?uid=59436157&interest=1";
    
    AFHTTPSessionManager *mgr=[AFHTTPSessionManager manager];
    mgr.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/plain", nil];
    
    [mgr GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
       // NSLog(@"responseObject=%@",responseObject);
      
        self.lives=[LiveModel mj_objectArrayWithKeyValuesArray:responseObject[@"lives"]];
        
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error=%@",error);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    NSLog(@"didReceiveMemoryWarning--");
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _lives.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LiveCell *cell= [tableView dequeueReusableCellWithIdentifier:ID];
    
    cell.live=self.lives[indexPath.row];
    
    return cell;
}

#pragma mark -- UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    LiveViewController *liveVc=[[LiveViewController alloc] init];
    
    liveVc.live=self.lives[indexPath.row];
    
    [self presentViewController:liveVc animated:YES completion:nil];

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 430;
}

@end
