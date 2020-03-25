//
//  DemoNode.m
//  MultScrollViewDemo-ASDK
//
//  Created by newjia on 2017/7/24.
//  Copyright © 2017年 Nils Li. All rights reserved.
//

#import "DemoNode.h"
#import "DemoCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface DemoNode () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (strong, nonatomic) UICollectionView *subCollectionView;
@property (strong, nonatomic) ASDisplayNode *collectionNode;
@property (strong, nonatomic) ASDisplayNode *bannerNode;
@property (strong, nonatomic) UIImageView *bannerIV;
@property (strong, nonatomic) NSDictionary *dataDic;
@end;
@implementation DemoNode
// 随机颜色
#define RANDOMCOLOR [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1]
#define DEVICE_WIDTH [[UIScreen mainScreen] bounds].size.width      //硬件宽度
#define DEVICE_HEIGHT [[UIScreen mainScreen] bounds].size.height    //硬件高度


- (instancetype)initWithData: (id)info
{
    if (self != [super init ]) {
        return nil;
    }

    self.automaticallyManagesSubnodes = YES;

    self.dataDic = (NSDictionary *)info;

    self.backgroundColor = [UIColor whiteColor];

    [self addBannerNode];

    [self addCollectionNode];

    return self;
}

- (void)didLoad
{
    [super didLoad];

    [self addBannerView];

    [self addCollectionView];
}

- (void)addBannerView
{
    UIImageView *bannerIV = [[UIImageView alloc] init];
    bannerIV.backgroundColor = [UIColor whiteColor];
    bannerIV.contentMode = UIViewContentModeScaleAspectFill;
    NSString *imageUrl = [self.dataDic objectForKey:@"banner"];
    [self.view addSubview:bannerIV];
 
    [bannerIV sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil options:1 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        //
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                bannerIV.image = image;

    }];
    _bannerIV = bannerIV;
}

- (void)addCollectionView
{
    UICollectionViewFlowLayout *mainLayout = [[UICollectionViewFlowLayout alloc] init];
    mainLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    mainLayout.minimumLineSpacing = 10;
    mainLayout.minimumInteritemSpacing = 10;
    mainLayout.itemSize = CGSizeMake(100, 100);
    mainLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    UICollectionView *subCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:mainLayout];
    subCollectionView.delegate = self;
    subCollectionView.dataSource = self;
    subCollectionView.backgroundColor = [UIColor whiteColor];
    [subCollectionView registerClass:[DemoCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:subCollectionView];
    _subCollectionView = subCollectionView;
}

- (void)addBannerNode
{
    ASDisplayNode *bannernode = [[ASDisplayNode alloc] init];
    bannernode.layerBacked = YES;
    bannernode.backgroundColor = [UIColor whiteColor];
    [self addSubnode:bannernode];
    _bannerNode = bannernode;
}

- (void)addCollectionNode
{
    ASDisplayNode *collectionNode = [[ASDisplayNode alloc] init];
    collectionNode.layerBacked = YES;
    collectionNode.backgroundColor = [UIColor whiteColor];
    [self addSubnode:collectionNode];
    _collectionNode = collectionNode;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray *imgList = [self.dataDic objectForKey:@"imageList"];
    return imgList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *imgList = [self.dataDic objectForKey:@"imageList"];
    NSString *url = @"https://img14.360buyimg.com/n0/jfs/t2656/295/34058120/362134/d92995e5/56fc835dNe349b797.jpg";// imgList [indexPath.row];
    DemoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];

    cell.imageUrl = url;
    return cell;
}

- (void)layout
{
    [super layout];

    _bannerIV.frame = _bannerNode.frame;

    self.subCollectionView.frame = self.collectionNode.frame;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
    _bannerNode.style.preferredSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 190);
    _collectionNode.style.preferredSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 120);
    ASStackLayoutSpec *layout = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                                                        spacing:10
                                                                 justifyContent:ASStackLayoutJustifyContentStart
                                                                     alignItems:ASStackLayoutAlignItemsCenter
                                                                       children:@[_bannerNode, _collectionNode]];
    return layout;
}
@end
