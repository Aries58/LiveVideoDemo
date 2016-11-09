//
//  LiveCell.m
//  LiveVideo
//
//  Created by 王亮 on 2016/11/3.
//  Copyright © 2016年 wangliang. All rights reserved.
//

#import "LiveCell.h"
#import "LiveModel.h"
#import "CreatorModel.h"
#import <UIImageView+WebCache.h>

#define Color(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

@interface LiveCell()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@property (weak, nonatomic) IBOutlet UIImageView *bigView;

@property (weak, nonatomic) IBOutlet UILabel *countLable;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UILabel *liveLabel;

@end

@implementation LiveCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.iconView.layer.cornerRadius=40;
    self.iconView.layer.masksToBounds=YES;
    
    self.liveLabel.layer.cornerRadius=5;
    self.liveLabel.layer.masksToBounds=YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setLive:(LiveModel *)live
{
    _live=live;
    
    NSURL *imageUrl=[NSURL URLWithString:[NSString stringWithFormat:@"http://img.meelive.cn/%@",live.creator.portrait]];
    
    [self.iconView sd_setImageWithURL:imageUrl placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
       
        NSLog(@"error=%@",error);
        
    }];
    
    if (live.city.length == 0) {
        _addressLabel.text=@"难道在火星";
    }else
    {
        _addressLabel.text=live.city;
    }
    
    self.nameLabel.text=live.creator.nick;
    
    [self.bigView sd_setImageWithURL:imageUrl placeholderImage:nil];
    
    
    NSString *lineUser=[NSString stringWithFormat:@"%zd人在看",live.online_users];
    
    NSRange range=[lineUser rangeOfString:[NSString stringWithFormat:@"%zd",live.online_users]];
    
    NSMutableAttributedString *attr=[[NSMutableAttributedString alloc] initWithString:lineUser];
    [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:range];
    
    [attr addAttribute:NSForegroundColorAttributeName value:Color(216, 41, 116)  range:range];
    
    self.countLable.attributedText=attr;
    
}

@end
