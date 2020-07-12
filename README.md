![](/images/ram.png)

## 1、起因

在电商项目的前端业务中，我们经常会遇到一些复杂一点的界面需求。

比如纵向列表内嵌套横向列表页，以及内部可能的**圆角**、**阴影**、**透明度**的计算，导致大量的界面图形计算，CPU 不堪重负，最终经常导致不得不造成重新开辟离屏缓冲区，计算后交付给帧缓存区进行，**帧率下降**，给用户带来页面卡顿的不良体验。

## 2、思路
如果用传统的UITableview 来做主表格，在视图中嵌套UICollectionView，是需要进行相对多的代理布局，然而更致命的一点是——由于渲染的机制问题，整个主表格会因为UITableview 和UICollectionView 的滑动机制的相互冲突，导致FPS降低到50甚至更低，非常影响用户体验。

## 3、解决
考虑良久，最终采用的是有Facebook 提供的[AsyncDisplayKit](https://github.com/texturegroup/texture) 的框架，通过ASTableNode 主框架，横向滚动图用ASCollectionNode 来做渲染，由于ASDK的离屏渲染机制以及FlexBox布局，最终达到60FPS 的丝滑体验。

## 4、样品演示

![](/images/scroll.gif)

## 5、Demo项目结构

### 4.1 Demo项目结构

- Controller - 主要负责布局的配置
- View 
  - 主Cell - DemoNode 
  - 次级图片格 - GridBlockNode

### 6、步骤

#### 6.1 添加纵向滚动表格

```objective-c
- (void)initCollectionNode
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 10;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self.mainCollectionNode = [[ASCollectionNode alloc] initWithCollectionViewLayout:layout];
    self.mainCollectionNode.dataSource = self;
    self.mainCollectionNode.delegate = self;
    self.mainCollectionNode.backgroundColor = [UIColor whiteColor];
    [self.view addSubnode:self.mainCollectionNode];
    
}
```

### 6.2 部署主Cell

这里的主Cell 是`DemoNode`，使用的是`nodeBlockForItemAtIndexPath` 方法，并且返回`ASCellNode` 的普通基类，在`block` 内部实现业务逻辑

1. `nodeBlockForItemAtIndexPath`方法

   ```cpp
   - (ASCellNodeBlock)collectionNode:(ASCollectionNode *)collectionNode nodeBlockForItemAtIndexPath:(NSIndexPath *)indexPath
   {
       @WeakObj(self);
       
       ASCellNode *(^cellNodeBlock)(void) = ^ASCellNode *(){
           NSDictionary *dic = [NSDictionary dictionary];
           if (selfWeak.dataArray && selfWeak.dataArray.count) {
               dic = selfWeak.dataArray [indexPath.row];
           }
           DemoNode *cellNode = [[DemoNode alloc] initWithData: dic];
           return cellNode;
       };
       return cellNodeBlock;
   }
   ```

2. DemoNode内部逻辑：

   - 添加横向滚动式图。在view 创建后的`didLoad`方法里，添加横向一个`UICollectionView`

     ```cpp
     - (void)didLoad
     {
         [super didLoad];
         
         [self addBannerView];
         
         // 添加横向滚动视图
         [self addCollectionView];
     }
     ```

     

   - 添加一个ASCollectionNode 用来在ASDK布局里的占位，部署横向轮播布局的尺寸

     ```cpp
     
     - (instancetype)initWithData: (id)info
     {
         if (self != [super init ]) {
             return nil;
         }
     		
     		/* 添加占位的collectionNode*/
         [self addCollectionNode];
         
         return self;
     }
     
     ```

   - 将ASCollectionNode 的frame 赋给 UICollectionView，确定横向滚动图的frame

     ```c
     - (void)layout
     {
         [super layout];
         
         _bannerIV.frame = _bannerNode.frame;
         
         self.subCollectionView.frame = self.collectionNode.frame;
     }
     ```

   - 在`layoutSpecThatFits` 方法里，将占位的`_collectionNode` 添加进去，形成最终的layout

### 6.3、部署横向滚动Cell

- 实现图片的简单初始化

  ```cpp
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
  ```

  

- 对图片进行菊花图，及布局

  ```cpp
  
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
  ```

## 7、第三方工具引用

用了[MJRefresh](https://github.com/CoderMJLee/MJRefresh), 和[FHHFPSIndicator](https://github.com/002and001/FHHFPSIndicator) 监控FPS，简单的实现效果。

## 8、使用

下载后，记得安装Pods

```bash
pod install
```


