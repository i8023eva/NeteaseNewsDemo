//
//  ViewController.m
//  网易新闻
//
//  Created by 李元华 on 2018/5/27.
//  Copyright © 2018年 李元华. All rights reserved.
//

#import "ViewController.h"
#import "HeadLineViewController.h"
#import "HotViewController.h"
#import "VideoViewController.h"
#import "SocialViewController.h"
#import "ReadViewController.h"
#import "ScienceViewController.h"

#define screenWidth [UIScreen mainScreen].bounds.size.width
#define screenHeight [UIScreen mainScreen].bounds.size.height
#define eva_StatusBarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height>20?44:20)
@interface ViewController () <UIScrollViewDelegate>

@property (nonatomic, weak) UIScrollView *titleScrollView;
@property (nonatomic, weak) UIScrollView *contentScrollView;
@property (nonatomic, weak) UIButton *selectedButton;
@property (nonatomic, strong) NSMutableArray<UIButton *> *button_Arr;

@property (nonatomic, assign) BOOL isInitialize;
@end

@implementation ViewController

- (NSMutableArray *)button_Arr {
    if (_button_Arr == nil) {
        _button_Arr = [NSMutableArray array];
    }
    return _button_Arr;
}

/**
 viewDidLoad之后执行，self.childViewControllers有值
 这个方法多次执行 - dispatch_once 不行，考虑到页面跳转

 @param animated <#animated description#>
 */
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if (_isInitialize == NO) {
        [self setupTitleButton];
        
        _isInitialize = YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // iOS7以后,导航控制器中scollView顶部会添加64的额外滚动区域
    //    self.automaticallyAdjustsScrollViewInsets = NO;
    //    self.titleScrollView.contentInsetAdjustmentBehavior
    
    self.navigationItem.title = @"网易新闻";
//    添加scrollView
    [self setupScrollView];
//    添加子控制器  子类创建方法
//    [self setupChildViewController];
//    设置标题按钮
//    [self setupTitleButton];
}


#pragma mark - UIScrollViewDelegate

/**
 滚动完成添加子控制器[懒加载] 第一次滚动中不加载
 切换标题按钮 - 获取按钮 - scrollView 有多余的子控件 - 创建数组存储 button
 标题按钮随内容居中 - changeButtonStatus

 @param scrollView <#scrollView description#>
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger tag = scrollView.contentOffset.x / screenWidth;
    [self addViewToScrollViewWithIndex:tag];
    
    UIButton *button = self.button_Arr[tag];
    [self changeButtonStatus:button];
}

/**
 滚动时字体缩放
 获取缩放按钮 - nextBtn数组越界
 不能通过 self.selectedButton.tag来判断下一个按钮， 往左滑是上一个按钮
 缩放比例多打印
 颜色渐变

 @param scrollView <#scrollView description#>
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    CGPoint point = [scrollView.panGestureRecognizer translationInView:scrollView];
//    NSLog(@"%f", point.x);
//    UIButton *nextBtn = self.button_Arr[self.selectedButton.tag + 1];

    NSInteger index = scrollView.contentOffset.x / screenWidth;//取整
//    NSLog(@"index - %ld", index);
    UIButton *leftBtn = self.button_Arr[index];
    UIButton *rightBtn = nil;
    if (index + 1 < self.button_Arr.count) {
        rightBtn = self.button_Arr[index + 1];
    }
    
    CGFloat scaleR = scrollView.contentOffset.x / screenWidth;//0 --
//    NSLog(@"scaleR - %f",scaleR);
    scaleR -= index;
    
    CGFloat scaleL = 1 - scaleR;//取反
    
    leftBtn.transform = CGAffineTransformMakeScale(scaleL * 0.3 + 1, scaleL * 0.3 + 1);
    rightBtn.transform = CGAffineTransformMakeScale(scaleR * 0.3 + 1, scaleR * 0.3 + 1);
    
    UIColor *rightColor = [UIColor colorWithRed:scaleR green:0 blue:0 alpha:1];
    UIColor *leftColor = [UIColor colorWithRed:scaleL green:0 blue:0 alpha:1];
    [rightBtn setTitleColor:rightColor forState:UIControlStateNormal];
    [leftBtn setTitleColor:leftColor forState:UIControlStateNormal];
}
#pragma mark -


/**
 添加子控制器 View
 重复添加 -

 @param index <#index description#>
 */
- (void)addViewToScrollViewWithIndex:(NSInteger)index {
    UIViewController *vc = self.childViewControllers[index];
    if (vc.viewIfLoaded) {
        return;
    }
    vc.view.frame = CGRectMake(screenWidth * index, 0, screenWidth, self.contentScrollView.bounds.size.height);
    [self.contentScrollView addSubview:vc.view];
}


/**
 设置标题按钮居中

 @param button <#button description#>
 */
- (void)setupButtonCenter:(UIButton *)button {
    CGFloat offsetX = button.center.x - screenWidth * 0.5;
    //    NSLog(@"%f", offsetX);
    /*
     往右滑<0 && 左滑 > max 不能滑动
     max -
     */
    if (offsetX < 0) {
        offsetX = 0;
    }
    CGFloat maxOffsetX = self.titleScrollView.contentSize.width - screenWidth;
    if (offsetX > maxOffsetX) {
        offsetX = maxOffsetX;
    }
    [self.titleScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}

/**
 切换选中按钮标题颜色
 让选中的按钮放大，上一个按钮还原

 @param button <#button description#>
 */
- (void)changeButtonStatus:(UIButton *)button {
    _selectedButton.transform = CGAffineTransformIdentity;
    [_selectedButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    button.transform = CGAffineTransformMakeScale(1.3, 1.3);
    _selectedButton = button;
    
    [self setupButtonCenter:button];
}

/**
 点击添加子控制器， 但滑动contentScrollView并不添加子控制器(+)
 切换子控制器

 @param button <#button description#>
 */
- (void)titltClick:(UIButton *)button {
    [self changeButtonStatus:button];
    
    NSInteger tag = button.tag;
    
    [self addViewToScrollViewWithIndex:tag];
    
    self.contentScrollView.contentOffset = CGPointMake(screenWidth * tag, 0);
}

/**
 titleScrollView滚动
 button的 title ->VC 的 title
 */
- (void)setupTitleButton {
    NSInteger count = self.childViewControllers.count;
    
    CGFloat btnW = 100;
    CGFloat btnH = self.titleScrollView.bounds.size.height;
    for (int i = 0; i < count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(btnW * i, 0, btnW, btnH);
        button.tag = i;
        UIViewController *vc = self.childViewControllers[i];
        [button setTitle:vc.title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.titleScrollView addSubview:button];
        
        [button addTarget:self action:@selector(titltClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.button_Arr addObject:button];
        if (i == 0) {
            [self titltClick:button];
        }
    }
    
    self.titleScrollView.contentSize = CGSizeMake(btnW * count, 0);
    self.contentScrollView.contentSize = CGSizeMake(screenWidth * count, 0);
}

- (void)setupChildViewController {
    // 头条
    HeadLineViewController *vc1 = [[HeadLineViewController alloc] init];
    vc1.title = @"头条";
    [self addChildViewController:vc1];
    // 热点
    HotViewController *vc2 = [[HotViewController alloc] init];
    vc2.title = @"热点";
    [self addChildViewController:vc2];
    // 视频
    VideoViewController *vc3 = [[VideoViewController alloc] init];
    vc3.title = @"视频";
    [self addChildViewController:vc3];
    // 社会
    SocialViewController *vc4 = [[SocialViewController alloc] init];
    vc4.title = @"社会";
    [self addChildViewController:vc4];
    // 订阅
    ReadViewController *vc5 = [[ReadViewController alloc] init];
    vc5.title = @"订阅";
    [self addChildViewController:vc5];
    // 科技
    ScienceViewController *vc6 = [[ScienceViewController alloc] init];
    vc6.title = @"科技";
    [self addChildViewController:vc6];
}

- (void)setupScrollView {
    UIScrollView *titleScrollView = [[UIScrollView alloc] init];
//    self.navigationController.navigationBarHidden ? 0 : 44;
    CGFloat titleY = eva_StatusBarHeight + (self.navigationController.navigationBarHidden ? 0 : 44);
    titleScrollView.frame = CGRectMake(0, titleY, screenWidth, 44);
//    titleScrollView.backgroundColor = [UIColor orangeColor];
//    隐藏滚动条 禁用回弹
    titleScrollView.showsHorizontalScrollIndicator = NO;
    titleScrollView.bounces = NO;
    [self.view addSubview:titleScrollView];
    _titleScrollView = titleScrollView;
    
    UIScrollView *contentScrollView = [[UIScrollView alloc] init];
    CGFloat contentY = CGRectGetMaxY(titleScrollView.frame);
    contentScrollView.frame = CGRectMake(0, contentY, screenWidth, screenHeight - contentY);
    contentScrollView.backgroundColor = [UIColor lightGrayColor];
    contentScrollView.showsHorizontalScrollIndicator = NO;
    contentScrollView.bounces = NO;
    contentScrollView.pagingEnabled = YES;
    contentScrollView.delegate = self;
    [self.view addSubview:contentScrollView];
    _contentScrollView = contentScrollView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
