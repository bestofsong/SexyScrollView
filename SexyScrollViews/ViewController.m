//
//  ViewController.m
//  SexyScrollViews
//
//  Created by wansong on 16/5/11.
//  Copyright © 2016年 zhike. All rights reserved.
//

#import "ViewController.h"
#import "ZKScrollableTabsViewController.h"
#import "TestTableViewController.h"
#import "ZKScrollableTabsView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  UIButton *but = [self.view viewWithTag:1];
  [but addTarget:self action:@selector(butAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)butAction:(UIButton*)sender {
  ZKScrollableTabsViewController *vc = [ZKScrollableTabsViewController new];
  UIImageView *imgv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"boy"]];
  imgv.contentMode = UIViewContentModeScaleAspectFit;
  imgv.userInteractionEnabled = YES;
  [imgv sizeToFit];
  imgv.backgroundColor = [UIColor redColor];
  vc.headerView = imgv;
  
  NSMutableArray *vcs = [NSMutableArray array];
  for (NSInteger i = 0; i < 3; i++) {
    TestTableViewController *tvc = [TestTableViewController new];
    tvc.nCells = i*i*40 + 5;
    [vcs addObject:tvc];
  }
  vc.pagesArray = vcs;
  
  [self.navigationController pushViewController:vc animated:YES];
}


@end
