//
//  MJRefreshConst.m
//  MJRefresh
//
//  Created by mj on 14-1-3.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

const CGFloat MJRefreshViewHeight = 64.0;
const CGFloat MJRefreshFastAnimationDuration = 0.25;
const CGFloat MJRefreshSlowAnimationDuration = 0.4;

NSString *const MJRefreshBundleName = @"MJRefresh.bundle";

NSString *const MJRefreshFooterPullToRefresh = @"上拉可以加载更多数据";
NSString *const MJRefreshFooterReleaseToRefresh = @"松开夹在更多需求";
NSString *const MJRefreshFooterRefreshing = @"正在加载距离最近的需求";

NSString *const MJRefreshHeaderPullToRefresh = @"下拉可以刷新需求";
NSString *const MJRefreshHeaderReleaseToRefresh = @"显示距我最近的需求";
NSString *const MJRefreshHeaderRefreshing = @"正在刷新附近的需求";
NSString *const MJRefreshHeaderTimeKey = @"MJRefreshHeaderView";

NSString *const MJRefreshContentOffset = @"contentOffset";
NSString *const MJRefreshContentSize = @"contentSize";