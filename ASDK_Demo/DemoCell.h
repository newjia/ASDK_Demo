//
//  DemoCell.h
//  MultScrollViewDemo-ASDK
//
//  Created by newjia on 2017/7/24.
//  Copyright © 2017年 Nils Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DemoCell : UICollectionViewCell
{
    UIImageView *logoIV;
}
@property (strong, nonatomic) UIImageView *logoIV;
@property (strong, nonatomic) NSString *imageUrl;

@end
