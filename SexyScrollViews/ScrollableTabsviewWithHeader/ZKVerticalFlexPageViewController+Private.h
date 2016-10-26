//
//  ZKVerticalFlexPageViewController+Private.h
//  SexyScrollViews
//
//  Created by wansong on 7/28/16.
//  Copyright © 2016 zhike. All rights reserved.
//

#ifndef ZKVerticalFlexPageViewController_Private_h
#define ZKVerticalFlexPageViewController_Private_h

#import "ZKVerticalFlexPageViewController.h"
#import "ZKScrollableTabsViewController+Delegates.h"

@interface ZKVerticalFlexPageViewController ()<UIScrollViewDelegate, ScrollableTabsDidChangeDelegate>

@property (weak, nonatomic) id<HorizonalScrollDelegate> horizonalDelegate;

@end

#endif /* ZKVerticalFlexPageViewController_Private_h */
