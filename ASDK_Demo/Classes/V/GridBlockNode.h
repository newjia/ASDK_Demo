//
//  GridBlockNode.h
//  ASDK_Demo
//
//  Created by Li Jia on 2018/2/1.
//  Copyright © 2018年 Nils Li. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

@interface GridBlockNode : ASCellNode <ASNetworkImageNodeDelegate>

@property (nonatomic, strong) ASNetworkImageNode * imageNode;

- (instancetype)initWithData: (id)info;

@end
