//
//  GridBlockNode.m
//  ASDK_Demo
//
//  Created by Li Jia on 2018/2/1.
//  Copyright © 2018年 Nils Li. All rights reserved.
//

#import "GridBlockNode.h"

@implementation GridBlockNode
- (instancetype)initWithData: (id)info
{
    self = [super init];
    if (self) {
        [self initUI];
        // 使用静态图片
  

    }
    return self;
}

- (void)initUI
{
    self.imageNode = [[ASNetworkImageNode alloc] init];
    self.imageNode.delegate = self;
    self.imageNode.borderWidth = 0.5;
    self.imageNode.borderColor = [UIColor grayColor].CGColor;
    [self addSubnode:self.imageNode];
}

-(ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
    self.imageNode.style.preferredSize = CGSizeMake(100, 100);
    self.imageNode.style.spacingAfter = 7;
    return [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:0 justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsCenter children:@[self.imageNode]];
    
}


#pragma mark - ASNetworkImageNodeDelegate
- (void)imageNode:(ASNetworkImageNode *)imageNode didLoadImage:(UIImage *)image {
    imageNode.defaultImage = image;
    ASPerformBlockOnMainThread(^{
        [UIView transitionWithView:imageNode.view
                          duration:0.35
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            imageNode.image = image;
                        } completion:NULL];
    });
}

@end
