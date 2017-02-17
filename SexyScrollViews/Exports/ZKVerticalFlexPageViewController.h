//
//  ZKVerticalFlexPageViewController.h
//  SexyScrollViews
//
//  Created by wansong on 16/5/11.
//  Copyright © 2016年 zhike. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ScrollPropertyDelegate <NSObject>
@property (readonly, nonatomic, nonnull) UIScrollView *scrollView;
@end

@interface ZKVerticalFlexPageViewController : UIViewController

@property (strong, nonatomic, nullable) UIView *headerView;

@property (strong, nonatomic, nullable) UIView *snapBarView;

@property (strong, nonatomic, nonnull) NSArray<UIViewController<ScrollPropertyDelegate>*> *pagesArray;

- (void)onHeaderPanned:(CGFloat)deltaY;

@end
