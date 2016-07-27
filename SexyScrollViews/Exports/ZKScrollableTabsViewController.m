//
//  ZKScrollableTabsViewController.m
//  SexyScrollViews
//
//  Created by wansong.mbp.work on 7/27/16.
//  Copyright © 2016 zhike. All rights reserved.
//

#import "ZKScrollableTabsViewController.h"
#import "ZKScrollableTabsView.h"
#import "ZKVerticalFlexPageViewController+Private.h"

@interface ZKScrollableTabsViewController ()

@end

@implementation ZKScrollableTabsViewController
@synthesize snapBarView = _snapBarView;

- (void)viewDidLoad {
  [super viewDidLoad];
  self.horizonalDelegate = (id<HorizonalScrollDelegate>)self.snapBarView;
}

- (UIView*)snapBarView {
  if (!_snapBarView) {
    CGRect dummyTabViewFrame = [UIScreen mainScreen].bounds;
    dummyTabViewFrame.size.height = 60;
    ZKScrollableTabsView *tabsView = [[ZKScrollableTabsView alloc]
                                      initWithFrame:dummyTabViewFrame
                                      tabNames:@[
                                                 @"goodbye", @"oc", @"hello", @"swift", @"php is the best of languages"
                                                 ]
                                      ];
    tabsView.delegate = self;
    _snapBarView = tabsView;
  }
  return _snapBarView;
}

- (void)setSnapBarView:(UIView *)snapBarView {
  NSAssert(NO, @"");
}

@end
