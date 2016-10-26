//
//  ZKScrollableTabsHeaderView.h
//  SexyScrollViews
//
//  Created by wansong.mbp.work on 7/27/16.
//  Copyright © 2016 zhike. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZKScrollableTabsHeaderViewController+Delegates.h"

#define GenLayoutAttributeAsPropertyWithDefaultValue(propertyName, value) GenLayoutAttributeAsGetterWithDefaultValue(propertyName, value)

#define GenLayoutAttributeAsGetterWithDefaultValue(propertyName, value)\
-(CGFloat)propertyName {\
  if (_##propertyName <= 0) {\
    _##propertyName=value;\
  }\
  return _##propertyName;\
}

#define GenObjectPropertyWithDefaultValue(propertyName, value)\
-(id)propertyName {\
  if (_##propertyName == nil) {\
    _##propertyName=value;\
  }\
  return _##propertyName;\
}

@interface ZKScrollableTabsHeaderView : UIView<HorizonalScrollDelegate>

- (instancetype)initWithFrame:(CGRect)frame tabNames:(NSArray*)names;

@property (assign, nonatomic) CGFloat tabSpacingH;
@property (assign, nonatomic) CGFloat movingLineWidth;
@property (assign, nonatomic) CGFloat backgroundLineWidth;

@property (strong, nonatomic) UIColor *tabTitleColor;
@property (strong, nonatomic) UIColor *backgroundLineColor;
@property (strong, nonatomic) UIColor *cursorLineColor;

@property (weak, nonatomic) id<ScrollableTabsDidChangeDelegate> delegate;

@end
