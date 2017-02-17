//
//  ViewController.m
//  SexyScrollViews
//
//  Created by wansong on 16/5/11.
//  Copyright © 2016年 zhike. All rights reserved.
//

#import "ViewController.h"
#import "ZKScrollableTabsViewController.h"
#import "TestTableViewController.h"
#import "ZKScrollableTabsView.h"

@interface TestScrollViewController : UIViewController
@end

@implementation TestScrollViewController
- (void)loadView {
  UIScrollView *scrollView = [[UIScrollView alloc] init];
  self.view = scrollView;
  
  CGRect frame = [UIScreen mainScreen].bounds;
  frame.size.height *= 2.0;
  UIView *contentView = [[UIView alloc] initWithFrame:frame];
  contentView.backgroundColor = [UIColor redColor];
  
  [scrollView addSubview:contentView];
  scrollView.contentSize = frame.size;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                forBarMetrics:UIBarMetricsDefault];
  self.navigationController.navigationBar.shadowImage = [UIImage new];
  self.navigationController.navigationBar.translucent = YES;
  self.navigationController.view.backgroundColor = [UIColor clearColor];
  self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  UIScrollView *scrollView = (UIScrollView*)self.view;
  scrollView.backgroundColor = [UIColor yellowColor];
  
  CGPoint offset = scrollView.contentOffset;
  UIEdgeInsets insets = scrollView.contentInset;
  CGRect frame = scrollView.frame;
  NSLog(@"offset: %@, edge insets: %@, frame: %@",
        [NSValue valueWithCGPoint:offset],
        [NSValue valueWithUIEdgeInsets:insets],
        [NSValue valueWithCGRect:frame]);
}

@end

@interface ViewController () <UIGestureRecognizerDelegate>
- (IBAction)testScroll:(id)sender;
@property (weak, nonatomic) ZKScrollableTabsViewController *vc;
@property (assign, nonatomic) CGFloat lastPanPositionY;
@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  UIButton *but = [self.view viewWithTag:1];
  [but addTarget:self action:@selector(butAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)butAction:(UIButton*)sender {
  ZKScrollableTabsViewController *vc = [ZKScrollableTabsViewController new];
  self.vc = vc;
  UIImageView *imgv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"boy"]];
  imgv.contentMode = UIViewContentModeScaleAspectFit;
  imgv.userInteractionEnabled = YES;
  [imgv sizeToFit];
  imgv.backgroundColor = [UIColor redColor];
  UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                        action:@selector(pan:)];
  pan.delegate = self;
  pan.delaysTouchesBegan = YES;
  [imgv addGestureRecognizer:pan];
  
  vc.headerView = imgv;
  
  NSMutableArray *vcs = [NSMutableArray array];
  for (NSInteger i = 0; i < 3; i++) {
    TestTableViewController *tvc = [TestTableViewController new];
    tvc.nCells = i*i*40 + 5;
    [vcs addObject:tvc];
  }
  vc.pagesArray = vcs;
  
  [self.navigationController pushViewController:vc animated:YES];
}

- (void)pan:(UIPanGestureRecognizer*)sender {
  CGPoint position = [sender translationInView:sender.view.window];
  if (sender.state == UIGestureRecognizerStateBegan) {
    self.lastPanPositionY = position.y;
  }
  [self.vc onHeaderPanned:position.y - self.lastPanPositionY];
  self.lastPanPositionY = position.y;
}

- (IBAction)testScroll:(id)sender {
  UIViewController *vc = [[TestScrollViewController alloc] init];
  [self.navigationController pushViewController:vc animated:YES];
}

@end

