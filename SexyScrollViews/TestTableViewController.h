//
//  TestTableViewController.h
//  SexyScrollViews
//
//  Created by wansong on 16/5/12.
//  Copyright © 2016年 zhike. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZKVerticalFlexPageViewController.h"

@interface TestTableViewController : UITableViewController<ScrollPropertyDelegate>
@property (assign, nonatomic) NSInteger nCells;
@end
