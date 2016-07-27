//
//  ZKScrollableTabsView.h
//  SexyScrollViews
//
//  Created by wansong.mbp.work on 7/27/16.
//  Copyright © 2016 zhike. All rights reserved.
//

#import <UIKit/UIKit.h>

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

@protocol ZKScrollableTabsViewDelegate <NSObject>

- (void)scrollableTabsViewDidStopAt:(NSInteger)index;

@end

@interface ZKScrollableTabsView : UIView

- (instancetype)initWithFrame:(CGRect)frame tabNames:(NSArray*)names;

@property (weak, nonatomic) id<ZKScrollableTabsViewDelegate> delegate;

@property (assign, nonatomic) CGFloat tabSpacingH;
@property (assign, nonatomic) CGFloat movingLineWidth;
@property (assign, nonatomic) CGFloat backgroundLineWidth;

@property (strong, nonatomic) UIColor *tabTitleColor;
@property (strong, nonatomic) UIColor *backgroundLineColor;


@end
