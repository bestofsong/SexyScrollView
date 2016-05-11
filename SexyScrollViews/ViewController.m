//
//  ViewController.m
//  SexyScrollViews
//
//  Created by wansong on 16/5/11.
//  Copyright © 2016年 zhike. All rights reserved.
//

#import "ViewController.h"
#import "ZKVerticalFlexPageViewController.h"
#import "TestTableViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  UIButton *but = [self.view viewWithTag:1];
  [but addTarget:self action:@selector(butAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)butAction:(UIButton*)sender {
  ZKVerticalFlexPageViewController *vc = [ZKVerticalFlexPageViewController new];
  UIImageView *imgv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"boy"]];
  imgv.contentMode = UIViewContentModeScaleAspectFit;
  [imgv sizeToFit];
  imgv.backgroundColor = [UIColor redColor];
  vc.headerView = imgv;
  
  CGRect dummyTabViewFrame = [UIScreen mainScreen].bounds;
  dummyTabViewFrame.size.height = 60;
  vc.snapBarView = [[UIView alloc] initWithFrame:dummyTabViewFrame];
  vc.snapBarView.backgroundColor = [UIColor orangeColor];
  
  NSMutableArray *vcs = [NSMutableArray array];
  for (NSInteger i = 0; i < 3; i++) {
    [vcs addObject:[TestTableViewController new]];
  }
  vc.pagesArray = vcs;
  
  [self.navigationController pushViewController:vc animated:YES];
}


@end
