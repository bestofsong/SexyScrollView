//
//  ZKScrollableTabsViewController+Delegates.h
//  SexyScrollViews
//
//  Created by wansong on 7/28/16.
//  Copyright © 2016 zhike. All rights reserved.
//

#ifndef ZKScrollableTabsViewController_Delegates_h
#define ZKScrollableTabsViewController_Delegates_h


@protocol HorizonalScrollDelegate <NSObject>

- (void)horizonalScrollDidEndAt:(NSInteger)index;

@end

@protocol ScrollableTabsDidChangeDelegate <NSObject>

- (void)scrollableTabsViewDidChangeToIndex:(NSInteger)index;

@end


#endif /* ZKScrollableTabsViewController_Delegates_h */
