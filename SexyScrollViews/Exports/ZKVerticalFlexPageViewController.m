//
//  ZKVerticalFlexPageViewController.m
//  SexyScrollViews
//
//  Created by wansong on 16/5/11.
//  Copyright © 2016年 zhike. All rights reserved.
//

#import "ZKVerticalFlexPageViewController.h"
#import "UIScrollView+Utility.h"

#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height

static void *OffsetKVOCtx = &OffsetKVOCtx;

@interface ZKVerticalFlexPageViewController ()<UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *horizonalScrollView;

@property (assign, nonatomic) BOOL initialLayoutCalled;

@property (assign, nonatomic) NSInteger lastVisiblePageIndex;

@end

@implementation ZKVerticalFlexPageViewController

- (void)viewDidLoad {
  self.automaticallyAdjustsScrollViewInsets = NO;
  [super viewDidLoad];
  [self setupSubviews];
}

- (void)setupSubviews {
  self.horizonalScrollView = [[UIScrollView alloc] init];
  self.horizonalScrollView.pagingEnabled = YES;
  self.horizonalScrollView.showsVerticalScrollIndicator = NO;
  self.horizonalScrollView.showsHorizontalScrollIndicator = NO;
  self.horizonalScrollView.backgroundColor = [UIColor whiteColor];
  self.horizonalScrollView.delegate = self;
  [self.view addSubview:self.horizonalScrollView];
  
  [self.view addSubview:self.headerView];
  [self.view addSubview:self.snapBarView];
  
  [self.view setNeedsLayout];
}

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
  if (!self.initialLayoutCalled) {
    self.initialLayoutCalled = YES;
    [self initialLayout];
  }
}

- (void)initialLayout {
  CGFloat topExtend = self.topLayoutGuide.length;
  CGFloat botExtend = CGRectGetHeight(self.view.bounds) - self.bottomLayoutGuide.length;
  
  CGFloat availableHeight = botExtend - topExtend;
  NSAssert(availableHeight > 400, @"");
  CGSize contentSize = CGSizeMake(ScreenW*self.pagesArray.count, availableHeight);
  
  self.horizonalScrollView.frame = CGRectMake(0, topExtend, ScreenW, availableHeight);
  self.horizonalScrollView.contentSize = contentSize;
  
  [self addPageViewController:self.pagesArray[0] atIndex:0];
  [self layoutHeadViewAndSnapBarViewWithTransition:0];
  
  UIScrollView *firstScrollView = [self visiblePageView];
  [firstScrollView addObserver:self
                    forKeyPath:@"contentOffset"
                       options:NSKeyValueObservingOptionNew
                       context:OffsetKVOCtx];
}

- (void)dealloc {
  [self.pagesArray[self.lastVisiblePageIndex].scrollView removeObserver:self
                                                             forKeyPath:@"contentOffset"];
}

- (void)layoutHeadViewAndSnapBarViewWithTransition:(CGFloat)transitionY {
  //transitionY is relative offset value
  CGFloat topExtend = self.topLayoutGuide.length;
  
  CGRect headerFrame = self.headerView.frame;
  headerFrame.origin.x = CGRectGetWidth(self.view.bounds)/2.0 - CGRectGetWidth(headerFrame)/2.0;
  headerFrame.origin.y = topExtend - transitionY;
  self.headerView.frame = headerFrame;
  
  CGRect snapBarFrame = self.snapBarView.frame;
  snapBarFrame.origin.x = CGRectGetWidth(self.view.bounds)/2.0 - CGRectGetWidth(snapBarFrame)/2.0;
  snapBarFrame.origin.y = CGRectGetMaxY(headerFrame);
  self.snapBarView.frame = snapBarFrame;
}

- (void)addPageViewController:(UIViewController<ScrollPropertyDelegate>*)controller atIndex:(NSInteger)index {
  //addsubveiw, contentinset
  CGFloat topExtend = self.topLayoutGuide.length;
  CGFloat botExtend = CGRectGetHeight(self.view.bounds) - self.bottomLayoutGuide.length;
  CGFloat availableHeight = botExtend - topExtend;
  
  UIScrollView *scrollView = controller.scrollView;
  scrollView.showsVerticalScrollIndicator = NO;
  scrollView.contentInset = UIEdgeInsetsMake([self innerScrollTopInset], 0, 0, 0);
  CGRect frame = CGRectMake(ScreenW*index, 0, ScreenW, availableHeight);
  scrollView.frame = frame;
  
  [self.horizonalScrollView addSubview:scrollView];
  [controller didMoveToParentViewController:self];
}

- (void)setPagesArray:(NSArray<UIViewController<ScrollPropertyDelegate> *> *)pagesArray {
  [pagesArray enumerateObjectsUsingBlock:^(UIViewController<ScrollPropertyDelegate> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    obj.automaticallyAdjustsScrollViewInsets = NO;
    [self addChildViewController:obj];
  }];
  _pagesArray = pagesArray;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
  if (context == OffsetKVOCtx && [keyPath isEqualToString:@"contentOffset"]) {
    NSValue *offset = change[NSKeyValueChangeNewKey];
    if (offset) {
      [self reLayoutWithInnerScrollOffset:offset.CGPointValue.y];
    }
  }else {
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
  }
}

- (void)reLayoutWithInnerScrollOffset:(CGFloat)offsetY {
  CGFloat maxOffsetBeforeHalt = [self maxOffsetBeforeHalt];
  CGFloat offsetRelative = [self relativeOffsetY:offsetY];
  CGFloat translation = MIN(MAX(0, offsetRelative), maxOffsetBeforeHalt);
  [self layoutHeadViewAndSnapBarViewWithTransition:translation];
}

#pragma mark - convenient methods: layout
- (CGFloat)maxOffsetBeforeHalt {
  return CGRectGetHeight(self.headerView.frame);
}

- (CGFloat)currentTranslationY {
  CGFloat topExtend = self.topLayoutGuide.length;
  return CGRectGetMinY(self.headerView.frame) - topExtend;
}

- (CGFloat)relativeOffsetY:(CGFloat)offsetAbs {
  return offsetAbs + [self innerScrollTopInset];
}

- (CGFloat)innerScrollTopInset {
  return CGRectGetHeight(self.headerView.frame) + CGRectGetHeight(self.snapBarView.frame);
}

#pragma mark - horizonal scroll delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
  [self updateKvoObject];
}

- (void)updateKvoObject {
  NSInteger currentVisibleIndex = [self visiblePageIndex];
  if (currentVisibleIndex != self.lastVisiblePageIndex) {
    UIScrollView *lastScrollView = self.pagesArray[self.lastVisiblePageIndex].scrollView;
    [lastScrollView removeObserver:self forKeyPath:@"contentOffset"];
    UIScrollView *incomingScrollView = [self visiblePageView];
    [incomingScrollView addObserver:self
                         forKeyPath:@"contentOffset"
                            options:NSKeyValueObservingOptionNew
                            context:OffsetKVOCtx];
  }
  self.lastVisiblePageIndex = currentVisibleIndex;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  //adjusting next or prev scrollview before it shows!
  NSInteger incomingIndex = [self incomingIndex];
  if (scrollView == self.horizonalScrollView && incomingIndex >= 0 && incomingIndex < self.pagesArray.count) {
    UIScrollView *incomingScrollView = self.pagesArray[incomingIndex].scrollView;
    if (incomingScrollView.superview != self.horizonalScrollView) {
      [self addPageViewController:self.pagesArray[incomingIndex] atIndex:incomingIndex];
    }
    
    CGPoint offset = incomingScrollView.contentOffset;
    CGFloat currentOffsetY = -[self innerScrollTopInset] - [self currentTranslationY];
    if (-[self currentTranslationY] < [self maxOffsetBeforeHalt]) {
      offset.y = MIN(incomingScrollView.maxScrollY, currentOffsetY);
    }else {
      offset.y = MIN(incomingScrollView.maxScrollY, MAX(offset.y, currentOffsetY));
    }
    
    [UIView animateWithDuration:0.2 animations:^{
      incomingScrollView.contentOffset = offset;
      [self reLayoutWithInnerScrollOffset:incomingScrollView.contentOffset.y];
    }];
  }
  
}

#pragma mark - convenient methods: scroll horizonally
- (NSInteger)visiblePageIndex {
  return (NSInteger)floor(self.horizonalScrollView.contentOffset.x/ScreenW + .5);
}

- (UIScrollView*)visiblePageView {
  NSInteger index = [self visiblePageIndex];
  NSAssert(index >= 0 && index < self.pagesArray.count, @"");
  return self.pagesArray[index].scrollView;
}

- (NSInteger)incomingIndex {
  NSInteger visible = [self visiblePageIndex];
  CGPoint v =
  [self.horizonalScrollView.panGestureRecognizer velocityInView:self.horizonalScrollView.panGestureRecognizer.view];
  NSInteger ret = self.horizonalScrollView.contentOffset.x > visible*ScreenW ? visible + 1 : visible - 1;
  
  if (v.x < 0) {
    return MAX(visible, ret);
  }else if (v.x == 0) {
    return visible;
  }else {
    return MIN(visible, ret);
  }
  
}

@end
