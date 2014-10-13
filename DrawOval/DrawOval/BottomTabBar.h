//
//  BottomTabBar.h
//  publisher
//
//  Created by SonNV on 8/4/14.
//  Copyright (c) 2014 area851 LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BottomTabBarDelegate;
@interface BottomTabBar : UIView
{
    BOOL runningOniPad;
    UIImageView* iconBack;
    UILabel *lableBack;
    UIImageView* iconRefresh;
    UILabel *lableRefresh;
    UIImageView* iconInfo;
    UILabel *lableInfo;
    UIImageView* iconSearch;
    UILabel *lableSearch;
}
@property(nonatomic, retain) UIActivityIndicatorView *refreshSpin;
@property(nonatomic, retain) UIButton* buttonBack;
@property(nonatomic, retain) UIButton* buttonRefresh;
@property(nonatomic, retain) UIButton* buttonInfo;
@property(nonatomic, retain) UIButton* buttonSearch;
@property(nonatomic, assign) id<BottomTabBarDelegate> delegate;

- (void)refreshFrame:(CGRect)frame withheadlineID:(NSInteger) headline withOrientation:(UIInterfaceOrientation) interfaceOrientation;
- (void)createTabBarButtons:(NSInteger)headlineID withOrientation:(UIInterfaceOrientation) interfaceOrientation;
- (void)hideIconAndTextButton:(BOOL) isHidden;
@end
@protocol BottomTabBarDelegate <NSObject>

- (void)buttonBackClickedEvent;
- (void)buttonRefreshClickedEvent;
- (void)buttonInfoClickedEvent;
- (void)buttonSearchClickedEvent;
@end
