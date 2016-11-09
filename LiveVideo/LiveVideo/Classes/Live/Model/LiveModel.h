//
//  LiveModel.h
//  LiveVideo
//
//  Created by 王亮 on 2016/11/3.
//  Copyright © 2016年 wangliang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CreatorModel;

@interface LiveModel : NSObject

//直播流地址
@property (nonatomic,copy) NSString *stream_addr;

//关注人
@property (nonatomic,assign) NSUInteger online_users;

//城市
@property (nonatomic,copy) NSString *city;

//主播
@property (nonatomic,strong) CreatorModel *creator;

@end
