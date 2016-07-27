//
//  ZKScrollableTabsView.m
//  SexyScrollViews
//
//  Created by wansong.mbp.work on 7/27/16.
//  Copyright © 2016 zhike. All rights reserved.
//

#import "ZKScrollableTabsView.h"
#import "Masonry.h"

@interface ZKScrollableTabsView ()<UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) NSArray<UIButton*> *tabs;

@property (strong, nonatomic) UIView *backgroundLine;

@end

@implementation ZKScrollableTabsView

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
GenObjectPropertyWithDefaultValue(backgroundLineColor, [UIColor colorWithRed:96 green:96 blue:96 alpha:.6]);

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
  
  UIView *backgroundLine = [[UIView alloc] init];
  self.backgroundLine = backgroundLine;
  backgroundLine.backgroundColor = self.backgroundLineColor;
  [self.scrollView addSubview:backgroundLine];
  [self layoutBackgroundLine:0];
  
  NSMutableArray<UIView*> *buttons = [NSMutableArray array];
  
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
  
}

- (void)tabAction:(UIButton*)bt {
  NSLog(@"button: %ld has been tapped", bt.tag);
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

@end
