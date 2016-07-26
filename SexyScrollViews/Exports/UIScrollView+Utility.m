//
//  UIScrollView+Utility.m
//  SexyScrollViews
//
//  Created by wansong on 16/5/19.
//  Copyright © 2016年 zhike. All rights reserved.
//

#import "UIScrollView+Utility.h"

@implementation UIScrollView (Utility)

- (CGFloat)maxScrollY {
  CGSize contentSZ = self.contentSize;
  CGSize frameSZ = self.frame.size;
  CGFloat bottomInset = self.contentInset.bottom;
  if (contentSZ.height + bottomInset < frameSZ.height) {
    return -self.contentInset.top;
  }else {
    return contentSZ.height + bottomInset - frameSZ.height;
  }
}

- (CGFloat)minScrollY {
  return -self.contentInset.top;
}

@end
