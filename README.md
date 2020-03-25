![](/images/ram.png)

### 缘起

在电商项目的前端业务中，我们经常会遇到一些复杂一点的界面需求。

比如纵向列表内嵌套横向列表页，这种是比较基础的但是也是相对复杂的布局。

### 思路
如果用传统的UITableview 来做主表格，在视图中嵌套UICollectionView，是需要进行相对多的代理布局，然而更致命的一点是——由于渲染的机制问题，整个主表格会因为UITableview 和UICollectionView 的滑动机制的相互冲突，导致FPS降低到50甚至更低，非常影响用户体验。

### 解决
我们开发团队考虑良久，最终采用的是有Facebook 提供的[AsyncDisplayKit](https://github.com/texturegroup/texture) 的框架，通过ASTableNode 主框架，横向滚动图用ASCollectionNode 来做渲染，由于ASDK的离屏渲染机制以及FlexBox布局，最终达到60FPS 的丝滑体验。

### 实施：
### Demo
Demo 如下， 用了[MJRefresh](https://github.com/CoderMJLee/MJRefresh), 和[FHHFPSIndicator](https://github.com/002and001/FHHFPSIndicator) 监控FPS，简单的实现效果。

### 使用

下载后，记得安装Pods

```bash
pod install
```





### 样品演示

![](/images/scroll.gif)
