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
    [logoIV sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
}

@end
