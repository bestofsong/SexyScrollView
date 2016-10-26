//
//  ZKScrollableTabsHeaderViewController+Delegates.h
//  SexyScrollViews
//
//  Created by wansong on 7/28/16.
//  Copyright © 2016 zhike. All rights reserved.
//

#ifndef ZKScrollableTabsHeaderViewController_Delegates_h
#define ZKScrollableTabsHeaderViewController_Delegates_h


@protocol HorizonalScrollDelegate <NSObject>

- (void)horizonalScrollDidEndAt:(NSInteger)index;

@end

@protocol ScrollableTabsDidChangeDelegate <NSObject>

- (void)scrollableTabsViewDidChangeToIndex:(NSInteger)index;

@end


#endif /* ZKScrollableTabsHeaderViewController_Delegates_h */
