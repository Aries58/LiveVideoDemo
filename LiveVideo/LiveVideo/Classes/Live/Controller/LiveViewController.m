//
//  LiveViewController.m
//  LiveVideo
//
//  Created by 王亮 on 2016/11/3.
//  Copyright © 2016年 wangliang. All rights reserved.
//

#import "LiveViewController.h"
#import <IJKMediaFramework/IJKMediaFramework.h>
#import "LiveModel.h"
#import "CreatorModel.h"
#import <UIImageView+WebCache.h>

@interface LiveViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (nonatomic,strong) IJKFFMoviePlayerController *player;

@end

@implementation LiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    NSURL *imageUrl=[NSURL URLWithString:[NSString stringWithFormat:@"http://img.meelive.cn/%@",self.live.creator.portrait]];
    [self.imageView sd_setImageWithURL:imageUrl placeholderImage:nil];
    
    //拉流地址
    NSURL *url=[NSURL URLWithString:self.live.stream_addr];
    
    IJKFFMoviePlayerController *playerVc=[[IJKFFMoviePlayerController alloc] initWithContentURL:url withOptions:nil];
    
    //准备播放
    [playerVc prepareToPlay];
    
    
    playerVc.view.frame=[UIScreen mainScreen].bounds;
    [self.view insertSubview:playerVc.view atIndex:1];
    self.player=playerVc;
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //界面消失 停止播放
    [self.player pause];
    [self.player stop];
    [self.player shutdown];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//退出
- (IBAction)close:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
