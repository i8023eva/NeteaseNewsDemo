//
//  NeteaseNewsViewController.m
//  网易新闻
//
//  Created by 李元华 on 2018/5/28.
//  Copyright © 2018年 李元华. All rights reserved.
//

#import "NeteaseNewsViewController.h"
#import "HeadLineViewController.h"
#import "HotViewController.h"
#import "VideoViewController.h"
#import "SocialViewController.h"
#import "ReadViewController.h"
#import "ScienceViewController.h"

@interface NeteaseNewsViewController ()

@end

@implementation NeteaseNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //    添加子控制器
    [self setupChildViewController];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
