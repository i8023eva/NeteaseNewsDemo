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
@interface ViewController ()

@property (nonatomic, weak) UIScrollView *titleScrollView;
@property (nonatomic, weak) UIScrollView *contentScrollView;
@property (nonatomic, weak) UIButton *selectedButton;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"网易新闻";
//    添加scrollView
    [self setupScrollView];
//    添加子控制器
    [self setupChildViewController];
//    设置标题按钮
    [self setupTitle];
}


/**
 切换按钮标题颜色

 @param button <#button description#>
 */
- (void)changeButtonStatus:(UIButton *)button {
    [_selectedButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    _selectedButton = button;
}

/**
 添加子控制器
 切换子控制器

 @param button <#button description#>
 */
- (void)titltClick:(UIButton *)button {
    [self changeButtonStatus:button];
    
    NSInteger tag = button.tag;
    UIViewController *vc = self.childViewControllers[tag];
    vc.view.frame = CGRectMake(screenWidth * tag, 0, screenWidth, self.contentScrollView.bounds.size.height);
    [self.contentScrollView addSubview:vc.view];
    
    self.contentScrollView.contentOffset = CGPointMake(screenWidth * tag, 0);
}

/**
 titleScrollView滚动
 button的 title ->VC 的 title
 */
- (void)setupTitle {
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
    ScienceViewController *vc4 = [[ScienceViewController alloc] init];
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
    CGFloat titleY = self.navigationController.navigationBarHidden ? 20 : 64;
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
    [self.view addSubview:contentScrollView];
    _contentScrollView = contentScrollView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
