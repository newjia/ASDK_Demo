//
//  DemoCell.m
//  MultScrollViewDemo-ASDK
//
//  Created by newjia on 2017/7/24.
//  Copyright © 2017年 Nils Li. All rights reserved.
//

#import "DemoCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
@implementation DemoCell

@synthesize logoIV;

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        logoIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        logoIV.backgroundColor = [UIColor whiteColor];
        logoIV.layer.borderColor = [UIColor lightGrayColor].CGColor;
        logoIV.layer.borderWidth = 1;
        [self addSubview:logoIV];
    }
    return self;
}

- (void)setImageUrl:(NSString *)imageUrl
{
 
    __block UIActivityIndicatorView *activityIndicator;
    __weak typeof(self) weakSelf = self;
    [logoIV sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil options:SDWebImageProgressiveLoad progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        if (!activityIndicator)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.logoIV addSubview:activityIndicator = [UIActivityIndicatorView.alloc initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray]];
                   activityIndicator.center = weakSelf.logoIV.center;
                   [activityIndicator startAnimating];
            });
   
        }
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [activityIndicator removeFromSuperview];
             activityIndicator = nil;
        });
 
    }];
    
    
}

@end
