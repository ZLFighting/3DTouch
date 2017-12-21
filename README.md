# 3DTouch
3DTouch - iOS新特性

6s和6s plus之后特有效果，对着应用图标用力按会触发3DTouch.

![](https://github.com/ZLFighting/3DTouch/blob/master/3DTouch/3DTouch%202%20下午11.34.50.gif)

>第一步 : 3DTouch 设备支持检测
第二步 : 配置快捷视图列表
第三步 : 给列表视图中的cell注册 3DTouch 事件
第四步: 完成UIViewControllerPreviewingDelegate 协议回调，实现Peek Pop
第五步 : 在Peek状态下向上滑动出现的按钮配置方法

### 第一步 : 3DTouch 设备支持检测：

检测当前的设备是否支持3DTouch
```
//  在iOS9中有一个新的枚举
typedef NS_ENUM(NSInteger, UIForceTouchCapability) {
UIForceTouchCapabilityUnknown        = 0,  // 未知的支持属性
UIForceTouchCapabilityUnavailable    = 1,  // 不支持
UIForceTouchCapabilityAvailable      = 2 // 支持
};
```

一般我们都在每个ViewController的生命周期中这样做：

定义一个是否设备支持的BOOL值属性
```
@property (nonatomic , assign) BOOL support3DTouch;
```
在生命周期函数中检测支持与否
```
- (void)viewWillAppear:(BOOL)animated {
[super viewWillAppear:animated];
//检测当前是否支持3DTouch
self.support3DTouch = [self support3DTouch];
}
```
在生命周期外检测支持与否（因为有可能出了生命周期函数而发生了变化）
```
- (void)traitCollectionDidChange:(nullable UITraitCollection *)previousTraitCollection NS_AVAILABLE_IOS(8_0) {
self.support3DTouch = [self support3DTouch];
}
```
检测是否支持3DTouch的方法
```
- (BOOL)support3DTouch
{
// 如果开启了3D touch
if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable)
{
return YES;
}
return NO;
}
}
```


### 第二步 : 配置快捷视图列表

创建快捷视图列表有两种方法:
1，一种是编辑info.plist文件中的UIApplicationShortcutItems,
通过可视化的界面添加键值对直接配置info.plist
![](http://upload-images.jianshu.io/upload_images/576025-2d106da92a5e28d5.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

2，另一种是使用代码在工程中加入items
在工程的 AppDelegate.m
```
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[HomeViewController alloc] init]];
[self.window makeKeyAndVisible];

//  代码创建快捷视图列表的方法，
[self create3DTouchShotItems];

return YES;
}

- (void)create3DTouchShotItems {
//创建快捷item的icon UIApplicationShortcutItemIconFile
UIApplicationShortcutIcon *icon1 = [UIApplicationShortcutIcon iconWithTemplateImageName:@"icon1"];
UIApplicationShortcutIcon *icon2 = [UIApplicationShortcutIcon iconWithTemplateImageName:@"icon2"];
UIApplicationShortcutIcon *icon3 = [UIApplicationShortcutIcon iconWithTemplateImageName:@"icon3"];

//创建快捷item的userinfo UIApplicationShortcutItemUserInfo
NSDictionary *info1 = @{@"url":@"url1"};
NSDictionary *info2 = @{@"url":@"url2"};
NSDictionary *info3 = @{@"url":@"url3"};

//创建ShortcutItem
UIMutableApplicationShortcutItem *item1 = [[UIMutableApplicationShortcutItem alloc]initWithType:@"XS_3DTocuh_1" localizedTitle:@"扫一扫" localizedSubtitle:@"" icon:icon1 userInfo:info1];
UIMutableApplicationShortcutItem *item2 = [[UIMutableApplicationShortcutItem alloc]initWithType:@"XS_3DTocuh_2" localizedTitle:@"smile" localizedSubtitle:@"微笑面对生活" icon:icon2 userInfo:info2];
UIMutableApplicationShortcutItem *item3 = [[UIMutableApplicationShortcutItem alloc]initWithType:@"XS_3DTocuh_3" localizedTitle:@"购物" localizedSubtitle:@"Shopping" icon:icon3 userInfo:info3];

NSArray *items = @[item1, item2, item3];
[UIApplication sharedApplication].shortcutItems = items;
}
```

### 第三步 : 给列表视图中的cell注册 3DTouch 事件
1，首先，在首页当前控制器里遵守UIViewControllerPreviewingDelegate协议
UIViewControllerPreviewingDelegate
2，在注册前先判断是否设备支持(也就是第一步)

3，注册: [self registerForPreviewingWithDelegate:self sourceView:cell];
```
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

ZLTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZLTableViewCell"];
if (cell == nil) {
cell = [ZLTableViewCell cellWithTableView:tableView];
}
cell.dataFrame = self.dataSource[indexPath.row];
//给cell注册代理，使其支持3DTouch手势
if (self.support3DTouch) {
[self registerForPreviewingWithDelegate:self sourceView:cell];
}

return cell;
}
```

### 第四步: 完成UIViewControllerPreviewingDelegate 协议回调，实现Peek Pop
在首页当前控制器里,
```
#pragma mark - 3DTouch  UIViewControllerPreviewingDelegate
```
**Peek 实现代码：**
```
// 此方法是轻按控件时，跳出peek的代理方法
- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {

//防止重复加入
if ([self.presentedViewController isKindOfClass:[ZLPeekViewController class]])
{
return nil;
}
else
{
ZLTableViewCell *cell = (ZLTableViewCell *)previewingContext.sourceView;
ZLCellData * cellData = cell.dataFrame.cellData;
ZLPeekViewController *peekViewController = [[ZLPeekViewController alloc] init];
peekViewController.cellData = cellData;
peekViewController.delegate = self;
return peekViewController;
}
}
```

**Pop 代码**
```
//此方法是重按peek时，跳入pop的代理方法
- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext
commitViewController:(UIViewController *)viewControllerToCommit {

ZLTableViewCell *cell = (ZLTableViewCell *)previewingContext.sourceView;
ZLCellData * cellData = cell.dataFrame.cellData;
ZLPopViewController *popViewController = [[ZLPopViewController alloc] init];
popViewController.cellData = cellData;
// 以prentViewController的形式展现
[self showViewController:popViewController sender:self];

// 以push的形势展现
//    [self.navigationController pushViewController:popViewController animated:YES];
}
```

### 第五步 : 在Peek状态下向上滑动出现的按钮配置方法

在 ZLPeekViewController.m 里, 实现 - (NSArray> *)previewActionItems 回调方法
```
#pragma mark - Preview Actions

- (NSArray<id<UIPreviewActionItem>> *)previewActionItems {

// 生成UIPreviewAction
UIPreviewAction *action1 = [UIPreviewAction actionWithTitle:@"事件 1" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
NSLog(@"Action 1 selected");
[self.delegate pushToPopViewControllerWithCellData:self.cellData];
}];

UIPreviewAction *action2 = [UIPreviewAction actionWithTitle:@"事件 2" style:UIPreviewActionStyleDestructive handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
NSLog(@"Action 2 selected");
}];

UIPreviewAction *action3 = [UIPreviewAction actionWithTitle:@"事件 3" style:UIPreviewActionStyleSelected handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
NSLog(@"Action 3 selected");
}];

UIPreviewAction *tap1 = [UIPreviewAction actionWithTitle:@"按钮 1" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
NSLog(@"tap 1 selected");
}];

UIPreviewAction *tap2 = [UIPreviewAction actionWithTitle:@"按钮 2" style:UIPreviewActionStyleDestructive handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
NSLog(@"tap 2 selected");
}];

UIPreviewAction *tap3 = [UIPreviewAction actionWithTitle:@"按钮 3" style:UIPreviewActionStyleSelected handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
NSLog(@"tap 3 selected");
}];

NSArray *actions = @[action1, action2, action3];
NSArray *taps = @[tap1, tap2, tap3];
UIPreviewActionGroup *group1 = [UIPreviewActionGroup actionGroupWithTitle:@"一组事件" style:UIPreviewActionStyleDefault actions:actions];
UIPreviewActionGroup *group2 = [UIPreviewActionGroup actionGroupWithTitle:@"一组按钮" style:UIPreviewActionStyleDefault actions:taps];
NSArray *group = @[group1,group2];

//当然你也可以返回三个单独的action对象的数组，而不是group，具体效果，可以自己试一下

return group;
}
```

现在可以测试喽, 看下效果吧, 如果需要可以发demo给亲们~
![3DTouch.gif](http://upload-images.jianshu.io/upload_images/576025-ff1e62eeee1147ce.gif?imageMogr2/auto-orient/strip)

思路详情请移步技术文章:[3DTouch - iOS新特性](http://blog.csdn.net/smilezhangli/article/details/78557685)

您的支持是作为程序媛的我最大的动力, 如果觉得对你有帮助请送个Star吧,谢谢啦


