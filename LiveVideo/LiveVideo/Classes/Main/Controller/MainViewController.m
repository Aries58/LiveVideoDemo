//
//  MainViewController.m
//  LiveVideo
//
//  Created by 王亮 on 2016/11/3.
//  Copyright © 2016年 wangliang. All rights reserved.
//

#import "MainViewController.h"
#import "BroadcastViewController.h"
#import "CaptureViewController.h"


@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor=[UIColor redColor];
}

- (IBAction)playList:(UIButton *)sender {
    
    NSLog(@"palyList---");
    
    BroadcastViewController *broadcastVc=[[BroadcastViewController alloc] init];
    
    [self.navigationController pushViewController:broadcastVc animated:YES];
    
}

- (IBAction)myLive:(UIButton *)sender {
    
    NSLog(@"myLive--");
    
    CaptureViewController *captureVc=[[CaptureViewController alloc] init];
    
    [self presentViewController:captureVc animated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
