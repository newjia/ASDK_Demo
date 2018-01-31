### 缘起

在电商项目的前段业务中，我们经常会遇到一些复杂一点的界面需求。

比如纵向列表内嵌套横向列表页，这种是比较基础的但是也是相对复杂的布局。

### 思路
如果用传统的UITableview 来做主表格，在视图中嵌套UICollectionView，是需要进行相对多的代理布局，然而更致命的一点是——由于渲染的机制问题，整个主表格会因为

### 解决
我们开发团队考虑良久，最终采用的是有Facebook 提供的[AsyncDisplayKit](https://github.com/texturegroup/texture) 的框架，通过ASTableNode 主框架，横向滚动图用ASCollectionNode 来做渲染，由于ASDK的离屏渲染机制以及FlexBox，最终达到60FPS 的丝滑体验。

### 实施：
待补充，今天先回家了。

### Demo
Demo 如下：

![](/scroll.gif)
