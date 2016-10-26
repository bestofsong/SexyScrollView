//
//  ZKScrollableTabsHeaderView.m
//  SexyScrollViews
//
//  Created by wansong.mbp.work on 7/27/16.
//  Copyright © 2016 zhike. All rights reserved.
//

#import "ZKScrollableTabsHeaderView.h"
#import "Masonry.h"

@interface ZKScrollableTabsHeaderView ()<UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) NSArray<UIButton*> *tabs;

@property (strong, nonatomic) UIView *cursorLine;
@property (strong, nonatomic) NSArray *movableConstraints;

@property (strong, nonatomic) UIView *backgroundLine;

@property (assign, nonatomic) CGFloat cursorLineWidth;

@end

@implementation ZKScrollableTabsHeaderView

- (instancetype)initWithFrame:(CGRect)frame tabNames:(NSArray<NSString*> *)names {
  self = [super initWithFrame:frame];
  if (self) {
    [self setupSubviews:names];
  }
  return self;
}

GenLayoutAttributeAsPropertyWithDefaultValue(tabSpacingH, 5);
GenLayoutAttributeAsPropertyWithDefaultValue(movingLineWidth, 2);
GenLayoutAttributeAsGetterWithDefaultValue(backgroundLineWidth, 1.0 / [UIScreen mainScreen].scale);
GenObjectPropertyWithDefaultValue(tabTitleColor, [UIColor blackColor]);
GenObjectPropertyWithDefaultValue(backgroundLineColor, [UIColor colorWithRed:200 green:0 blue:0 alpha:1]);

GenLayoutAttributeAsPropertyWithDefaultValue(cursorLineWidth, 2);

GenObjectPropertyWithDefaultValue(cursorLineColor, [UIColor redColor]);

- (void)setupSubviews:(NSArray<NSString*>*)tabNames {
  if (!tabNames.count) return;
  
  self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
  self.scrollView.delegate = self;
  self.scrollView.showsHorizontalScrollIndicator = NO;
  self.scrollView.showsVerticalScrollIndicator = NO;
  self.contentView = [[UIView alloc] init];
  
  [self addSubview:self.scrollView];
  [self.scrollView addSubview:self.contentView];
  [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.edges.equalTo(self.scrollView);
    make.height.equalTo(self.scrollView.mas_height).offset(-self.backgroundLineWidth);
  }];
  
  [self installBackgroundLine];
  
  NSMutableArray<UIButton*> *buttons = [NSMutableArray array];
  
  [tabNames enumerateObjectsUsingBlock:
   ^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
     
     UIButton *bt = [[UIButton alloc] init];
     bt.tag = idx;
     [bt setTitle:obj forState:UIControlStateNormal];
     [bt addTarget:self action:@selector(tabAction:) forControlEvents:UIControlEventTouchUpInside];
     [bt setTitleColor:self.tabTitleColor forState:UIControlStateNormal];
     
     
     [self.contentView addSubview:bt];
     
     [bt mas_makeConstraints:^(MASConstraintMaker *make) {
       make.top.and.bottom.equalTo(self.contentView);
       if (idx == 0) {
         make.leading.equalTo(self.contentView.mas_leading);
       }else {
         make.leading.equalTo(buttons.lastObject.mas_trailing).offset(self.tabSpacingH);
       }
       
       if (idx == tabNames.count - 1) {
         make.trailing.equalTo(self.contentView.mas_trailing);
       }
     }];
     
     [buttons addObject:bt];
     
  }];
  
  self.tabs = buttons;
  
  [self installCursorLine];
  
}

- (void)installBackgroundLine {
  UIView *backgroundLine = [[UIView alloc] init];
  self.backgroundLine = backgroundLine;
  backgroundLine.backgroundColor = self.backgroundLineColor;
  [self.scrollView addSubview:backgroundLine];
  [self layoutBackgroundLine:0];
}

- (void)installCursorLine {
  UIView *cursorLine = [[UIView alloc] init];
  cursorLine.backgroundColor = self.cursorLineColor;
  self.cursorLine = cursorLine;
  [self.contentView addSubview:cursorLine];
  
  [cursorLine mas_makeConstraints:^(MASConstraintMaker *make) {
    make.height.equalTo(@(self.cursorLineWidth));
    make.bottom.equalTo(self.contentView.mas_bottom).offset(self.backgroundLineWidth);
  }];
  
  [self updateCursorLineConstraintsForIndex:0 animated:NO];
  
}

- (void)updateCursorLineConstraintsForIndex:(NSInteger)index animated:(BOOL)animated {
  if (index >= self.tabs.count) return;
  
  [self.movableConstraints enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    [(MASConstraint*)obj uninstall];
  }];
  
  UIButton *currentBt = self.tabs[index];
  
  NSMutableArray *updates = [NSMutableArray array];
  [self.cursorLine mas_makeConstraints:^(MASConstraintMaker *make) {
    [updates addObject:make.centerX.equalTo(currentBt.mas_centerX)];
    [updates addObject:make.width.equalTo(currentBt.mas_width)];
  }];
  
  self.movableConstraints = updates;
  
  if (animated) {
    [UIView animateWithDuration:0.25 animations:^{
      [self layoutIfNeeded];
    }];
  }
  
}

- (void)tabAction:(UIButton*)bt {
  NSLog(@"button: %ld has been tapped", bt.tag);
  [self updateCursorLineConstraintsForIndex:bt.tag animated:YES];
  [self.scrollView scrollRectToVisible:bt.frame animated:YES];
  [self.delegate scrollableTabsViewDidChangeToIndex:bt.tag];
}

- (void)layoutBackgroundLine:(CGFloat)offset {
  CGRect bglFrame = CGRectMake(offset,
                               CGRectGetHeight(self.bounds) - self.backgroundLineWidth,
                               CGRectGetWidth(self.bounds),
                               self.backgroundLineWidth);
  self.backgroundLine.frame = bglFrame;
}

#pragma mark -- uiscroll view delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  if (scrollView == self.scrollView) {
    [self layoutBackgroundLine:scrollView.contentOffset.x];
  }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
  NSLog(@"did end decelerating");
  [self handleScrollEndChange];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
  NSLog(@"did end scroll animation");
  [self handleScrollEndChange];
}

- (void)handleScrollEndChange {
}

- (void)horizonalScrollDidEndAt:(NSInteger)index {
  [self updateCursorLineConstraintsForIndex:index animated:YES];
}

@end
