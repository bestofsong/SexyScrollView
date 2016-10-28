//
//  ZKScrollableTabsViewController.h
//  SexyScrollViews
//
//  Created by wansong.mbp.work on 7/27/16.
//  Copyright © 2016 zhike. All rights reserved.
//

#import "ZKVerticalFlexPageViewController.h"

@interface ZKScrollableTabsViewController : ZKVerticalFlexPageViewController

@property (copy, nonatomic) NSString *headerImageName;

@property (copy, nonatomic) NSArray *pageConfigs;//{type, dataSource, }

@end
