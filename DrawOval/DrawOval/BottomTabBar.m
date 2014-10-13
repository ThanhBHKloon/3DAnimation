//
//  BottomTabBar.m
//  publisher
//
//  Created by SonNV on 8/4/14.
//  Copyright (c) 2014 area851 LLC. All rights reserved.
//

#import "BottomTabBar.h"
#import <QuartzCore/QuartzCore.h>
@implementation BottomTabBar
@synthesize buttonBack;
@synthesize buttonInfo;
@synthesize buttonRefresh;
@synthesize buttonSearch;
@synthesize delegate;
@synthesize refreshSpin;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
//        UIImageView *imageviewTabBar = [[UIImageView alloc] initWithFrame:frame];
//        imageviewTabBar.backgroundColor = [UIColor grayColor];
        self.frame = frame;
        self.backgroundColor = [UIColor clearColor];
//        self.alpha = 0.95;
//        [self createTabBarButtons];
//        [self addSubview:imageviewTabBar];
    }
    return self;
}
- (void)refreshFrame:(CGRect)frame withheadlineID:(NSInteger) headline withOrientation:(UIInterfaceOrientation) interfaceOrientation
{
    self.frame = frame;
    [self createTabBarButtons:headline withOrientation:interfaceOrientation];
}
- (void)createTabBarButtons:(NSInteger)headlineID withOrientation:(UIInterfaceOrientation) interfaceOrientation {
    if (headlineID == 0) {
//        if (!refreshSpin.isAnimating)
            [self addButtonsToView:headlineID withOrientation:interfaceOrientation];
        buttonRefresh.frame = CGRectMake(0, 0, self.frame.size.width/2, self.frame.size.height);
        UIView *lineButtonRefresh= [[UIView alloc] initWithFrame:CGRectMake(buttonRefresh.frame.size.width-1, 5, 1,self.frame.size.height - 10)];
        lineButtonRefresh.backgroundColor = [UIColor whiteColor];
        [buttonRefresh addSubview:lineButtonRefresh];
//        buttonSearch.frame = CGRectMake(self.frame.size.width/3, 0, self.frame.size.width/3, self.frame.size.height);
//        UIView *lineButtonSearch = [[UIView alloc] initWithFrame:CGRectMake(buttonSearch.frame.origin.x -1, 5, 1,self.frame.size.height -10)];
//        lineButtonSearch.backgroundColor = [UIColor whiteColor];
//        [buttonSearch addSubview:lineButtonSearch];
//        [lineButtonSearch release];
        buttonInfo.frame = CGRectMake(self.frame.size.width/2, 0, self.frame.size.width/2, self.frame.size.height);
        if (runningOniPad) {
            
            lableRefresh.frame = CGRectMake(0,
                                            0,
                                            buttonRefresh.frame.size.width/2,
                                            40);
            lableRefresh.center = buttonRefresh.center;
            lableInfo.frame = CGRectMake(0,
                                         0,
                                         buttonInfo.frame.size.width/2,
                                         40);
            lableInfo.center = buttonInfo.center;
            if (UIInterfaceOrientationIsPortrait(interfaceOrientation)) {
                iconRefresh.frame = CGRectMake(buttonRefresh.center.x - lableRefresh.frame.size.width/2 + 45, 15, 20, 20);
                iconInfo.frame = CGRectMake(buttonInfo.center.x - lableInfo.frame.size.width/2 + 65, 15, 20, 20);
            }
            else {
                iconRefresh.frame = CGRectMake(buttonRefresh.center.x - lableRefresh.frame.size.width/2 + 70, 15, 20, 20);
                iconInfo.frame = CGRectMake(buttonInfo.center.x - lableInfo.frame.size.width/2 + 90, 15, 20, 20);
            }
//            iconSearch.frame = CGRectMake(buttonSearch.frame.origin.x + 10, 3, 40, 40);
//            lableSearch.frame = CGRectMake(buttonSearch.frame.origin.x + iconSearch.frame.size.width ,
//                                           3,
//                                           buttonSearch.frame.size.width/2,
//                                           40);
            refreshSpin.frame = iconRefresh.frame;
            refreshSpin.center = iconRefresh.center;
        }
        else {
            if (UIInterfaceOrientationIsPortrait(interfaceOrientation)) {
            iconRefresh.frame = CGRectMake(buttonRefresh.frame.origin.x + buttonRefresh.frame.size.width/2 - buttonRefresh.frame.size.height/2,
                                           buttonRefresh.frame.origin.y + 5,
                                           buttonRefresh.frame.size.height - 10,
                                           buttonRefresh.frame.size.height - 10);
            iconInfo.frame = CGRectMake(buttonInfo.frame.origin.x + buttonInfo.frame.size.width/2 - buttonInfo.frame.size.height/2,
                                        buttonInfo.frame.origin.y + 5,
                                        buttonInfo.frame.size.height -10,
                                        buttonInfo.frame.size.height -10);
//            iconSearch.frame = CGRectMake(buttonSearch.frame.origin.x + buttonSearch.frame.size.width/2 - buttonSearch.frame.size.height/2,
//                                          buttonSearch.frame.origin.y +5,
//                                          buttonSearch.frame.size.height -10,
//                                          buttonSearch.frame.size.height - 10);
            refreshSpin.frame = CGRectMake(buttonRefresh.frame.origin.x + buttonRefresh.frame.size.width/2 - buttonRefresh.frame.size.height/2,
                                           buttonRefresh.frame.origin.y +5,
                                           buttonRefresh.frame.size.height - 10,
                                           buttonRefresh.frame.size.height - 10);
            refreshSpin.center = buttonRefresh.center;
            }
            else {
                lableRefresh.frame = CGRectMake(0,
                                                0,
                                                buttonRefresh.frame.size.width/2,
                                                40);
                lableRefresh.center = buttonRefresh.center;
                lableInfo.frame = CGRectMake(0,
                                             0,
                                             buttonInfo.frame.size.width/2,
                                             40);
                lableInfo.center = buttonInfo.center;
                
                iconRefresh.frame = CGRectMake(buttonRefresh.center.x - lableRefresh.frame.size.width/2 + 22,
                                               buttonRefresh.frame.origin.y + 12,
                                               20,
                                               20);
                iconInfo.frame = CGRectMake(buttonInfo.center.x - lableInfo.frame.size.width/2 +40,
                                            buttonInfo.frame.origin.y +12,
                                            20,
                                            20);

//               if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
//                    iconRefresh.frame = CGRectMake(buttonRefresh.center.x - lableRefresh.frame.size.width/2 + 22,
//                                                   buttonRefresh.frame.origin.y + 12,
//                                                   20,
//                                                   20);
//                    iconInfo.frame = CGRectMake(buttonInfo.center.x - lableInfo.frame.size.width/2 +40,
//                                                buttonInfo.frame.origin.y +12,
//                                                20,
//                                                20);
//               }
//               else {
//                   iconRefresh.frame = CGRectMake(buttonRefresh.center.x - lableRefresh.frame.size.width/2 + 12,
//                                                  buttonRefresh.frame.origin.y + 12,
//                                                  20,
//                                                  20);
//                   iconInfo.frame = CGRectMake(buttonInfo.center.x - lableInfo.frame.size.width/2 +30,
//                                               buttonInfo.frame.origin.y +12,
//                                               20,
//                                               20);
//               }
                //        iconSearch.frame = CGRectMake(buttonSearch.frame.origin.x + buttonSearch.frame.size.width/2 - buttonSearch.frame.size.height/2,
                //                                      buttonSearch.frame.origin.y + 5,
                //                                      buttonSearch.frame.size.height - 10,
                //                                      buttonSearch.frame.size.height - 10);
                refreshSpin.frame = iconRefresh.frame;
                refreshSpin.center = iconRefresh.center;

            }
        }

    }
    else {
//    if (!refreshSpin.isAnimating)
    [self addButtonsToView:headlineID withOrientation:interfaceOrientation];
    buttonBack.frame = CGRectMake(0, 0, self.frame.size.width/3, self.frame.size.height);
        UIView *lineButtonBack = [[UIView alloc] initWithFrame:CGRectMake(buttonBack.frame.size.width-1, 5, 1,self.frame.size.height -10)];
        lineButtonBack.backgroundColor = [UIColor whiteColor];
        [buttonBack addSubview:lineButtonBack];
    buttonRefresh.frame = CGRectMake(self.frame.size.width/3, 0, self.frame.size.width/3, self.frame.size.height);
        UIView *lineButtonRefresh= [[UIView alloc] initWithFrame:CGRectMake(buttonRefresh.frame.origin.x-1, 5, 1,self.frame.size.height - 10)];
        lineButtonRefresh.backgroundColor = [UIColor whiteColor];
        [buttonRefresh addSubview:lineButtonRefresh];

//    buttonSearch.frame = CGRectMake(self.frame.size.width/2, 0, self.frame.size.width/4, self.frame.size.height);
//        UIView *lineButtonSearch = [[UIView alloc] initWithFrame:CGRectMake(buttonBack.frame.size.width -1, 5, 1,self.frame.size.height -10)];
//        lineButtonSearch.backgroundColor = [UIColor whiteColor];
//        [buttonSearch addSubview:lineButtonSearch];
//        [lineButtonSearch release];
    buttonInfo.frame = CGRectMake(2*self.frame.size.width/3, 0, self.frame.size.width/3, self.frame.size.height);
    if (runningOniPad) {
        lableBack.frame = CGRectMake(0,
                                     0,
                                     buttonBack.frame.size.width/2,
                                     40);
        lableBack.center = buttonBack.center;
        lableRefresh.frame = CGRectMake(0,
                                        0,
                                        buttonRefresh.frame.size.width/2,
                                        40);
        lableRefresh.center = buttonRefresh.center;
        lableInfo.frame = CGRectMake(0,
                                     0,
                                     buttonInfo.frame.size.width/2,
                                     40);
        lableInfo.center = buttonInfo.center;
        if (UIInterfaceOrientationIsPortrait(interfaceOrientation)) {
            iconBack.frame = CGRectMake(buttonBack.center.x - lableBack.frame.size.width/2 + 15, 15, 20, 20);
            iconRefresh.frame = CGRectMake(buttonRefresh.center.x - lableRefresh.frame.size.width/2 + 10, 15, 20, 20);
            iconInfo.frame = CGRectMake(buttonInfo.center.x - lableInfo.frame.size.width/2 + 30, 15, 20, 20);
        }
        else {
            iconBack.frame = CGRectMake(buttonBack.center.x - lableBack.frame.size.width/2 + 40, 15, 20, 20);
            iconRefresh.frame = CGRectMake(buttonRefresh.center.x - lableRefresh.frame.size.width/2 + 30, 15, 20, 20);
            iconInfo.frame = CGRectMake(buttonInfo.center.x - lableInfo.frame.size.width/2 + 50, 15, 20, 20);
        }
//        iconSearch.frame = CGRectMake(buttonSearch.frame.origin.x +10, 3, 40, 40);
//        lableSearch.frame = CGRectMake(buttonSearch.frame.origin.x + iconSearch.frame.size.width ,
//                                       3,
//                                       buttonSearch.frame.size.width/2,
//                                       40);
        refreshSpin.frame = iconRefresh.frame;
        refreshSpin.center = iconRefresh.center;
    }
    else {
      if (UIInterfaceOrientationIsPortrait(interfaceOrientation)) {
        iconBack.frame = CGRectMake(buttonBack.frame.origin.x + buttonBack.frame.size.width/2 - buttonBack.frame.size.height/2,
                                    buttonBack.frame.origin.y + 5,
                                    buttonBack.frame.size.height - 10,
                                    buttonBack.frame.size.height - 10);
        iconRefresh.frame = CGRectMake(buttonRefresh.frame.origin.x + buttonRefresh.frame.size.width/2 - buttonRefresh.frame.size.height/2,
                                       buttonRefresh.frame.origin.y + 5,
                                       buttonRefresh.frame.size.height - 10,
                                       buttonRefresh.frame.size.height - 10);
        iconInfo.frame = CGRectMake(buttonInfo.frame.origin.x + buttonInfo.frame.size.width/2 - buttonInfo.frame.size.height/2,
                                    buttonInfo.frame.origin.y +5,
                                    buttonInfo.frame.size.height -10,
                                    buttonInfo.frame.size.height - 10);
//        iconSearch.frame = CGRectMake(buttonSearch.frame.origin.x + buttonSearch.frame.size.width/2 - buttonSearch.frame.size.height/2,
//                                      buttonSearch.frame.origin.y + 5,
//                                      buttonSearch.frame.size.height - 10,
//                                      buttonSearch.frame.size.height - 10);
        refreshSpin.frame = CGRectMake(buttonRefresh.frame.origin.x + buttonRefresh.frame.size.width/2,
                                       buttonRefresh.frame.origin.y +5,
                                       buttonRefresh.frame.size.height - 10,
                                       buttonRefresh.frame.size.height - 10);
        refreshSpin.center = buttonRefresh.center;
      }
      else {
          lableBack.frame = CGRectMake(0,
                                       0,
                                       buttonBack.frame.size.width/2,
                                       40);
          lableBack.center = buttonBack.center;
          lableRefresh.frame = CGRectMake(0,
                                          0,
                                          buttonRefresh.frame.size.width/2,
                                          40);
          lableRefresh.center = buttonRefresh.center;
          lableInfo.frame = CGRectMake(0,
                                       0,
                                       buttonInfo.frame.size.width/2,
                                       40);
          lableInfo.center = buttonInfo.center;
//          if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
              iconBack.frame = CGRectMake(buttonBack.center.x - lableBack.frame.size.width/2 +5,
                                          buttonBack.frame.origin.y + 12,
                                          20,
                                          20);
              
              iconRefresh.frame = CGRectMake(buttonRefresh.center.x - lableRefresh.frame.size.width/2,
                                             buttonRefresh.frame.origin.y + 12,
                                             20,
                                             20);
              
              iconInfo.frame = CGRectMake(buttonInfo.center.x - lableInfo.frame.size.width/2 +15,
                                          buttonInfo.frame.origin.y + 12,
                                          20,
                                          20);
//          }
//          else {
//              iconBack.frame = CGRectMake(buttonBack.center.x - lableBack.frame.size.width/2,
//                                          buttonBack.frame.origin.y + 12,
//                                          20,
//                                          20);
//              
//              iconRefresh.frame = CGRectMake(buttonRefresh.center.x - lableRefresh.frame.size.width/2 - 8,
//                                             buttonRefresh.frame.origin.y + 12,
//                                             20,
//                                             20);
//              iconInfo.frame = CGRectMake(buttonInfo.center.x - lableInfo.frame.size.width/2 +10,
//                                          buttonInfo.frame.origin.y + 12,
//                                          20,
//                                          20);
//          }
          //        iconSearch.frame = CGRectMake(buttonSearch.frame.origin.x + buttonSearch.frame.size.width/2 - buttonSearch.frame.size.height/2,
          //                                      buttonSearch.frame.origin.y + 5,
          //                                      buttonSearch.frame.size.height - 10,
          //                                      buttonSearch.frame.size.height - 10);
          refreshSpin.frame = iconRefresh.frame;
          refreshSpin.center = buttonRefresh.center;
      }
    }
  }
}
- (void)addButtonsToView:(NSInteger) currentHeadlineID withOrientation:(UIInterfaceOrientation) interfaceOrientation{
    // button Back
    [self removeButtonsFromView];
    buttonBack = [UIButton buttonWithType:UIButtonTypeCustom];
    [self setBackgroundButton:buttonBack withColor:[[UIColor blackColor] colorWithAlphaComponent:0.75] forState:UIControlStateNormal];
    [self setBackgroundButton:buttonBack withColor:[[UIColor blackColor] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
    [buttonBack addTarget:self action:@selector(buttonBackClicked:) forControlEvents:UIControlEventTouchUpInside];
    iconBack = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"button_back_unselected.png"]];
    lableBack = [[UILabel alloc] init];
    lableBack.font = [UIFont boldSystemFontOfSize:14];
    lableBack.textColor = [UIColor whiteColor];
    lableBack.text = @"Back";
    lableBack.backgroundColor = [UIColor clearColor];
    
    // button refresh
    buttonRefresh = [UIButton buttonWithType:UIButtonTypeCustom];
    [self setBackgroundButton:buttonRefresh withColor:[[UIColor blackColor] colorWithAlphaComponent:0.75] forState:UIControlStateNormal];
    [self setBackgroundButton:buttonRefresh withColor:[[UIColor blackColor] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
    [buttonRefresh addTarget:self action:@selector(buttonRefreshClicked:) forControlEvents:UIControlEventTouchUpInside];
    iconRefresh = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"button_refresh_unselected.png"]];
    lableRefresh = [[UILabel alloc] init];
    lableRefresh.font = [UIFont boldSystemFontOfSize:14];
    lableRefresh.textColor = [UIColor whiteColor];
    lableRefresh.text = @"Refresh";
    lableRefresh.backgroundColor = [UIColor clearColor];
    refreshSpin = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    // button info
    buttonInfo = [UIButton buttonWithType:UIButtonTypeCustom];
    [self setBackgroundButton:buttonInfo withColor:[[UIColor blackColor] colorWithAlphaComponent:0.75] forState:UIControlStateNormal];
    [self setBackgroundButton:buttonInfo withColor:[[UIColor blackColor] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
    [buttonInfo addTarget:self action:@selector(buttonInfoClicked:) forControlEvents:UIControlEventTouchUpInside];
    iconInfo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"button_info_unselected.png"]];
    lableInfo = [[UILabel alloc] init];
    lableInfo.font = [UIFont boldSystemFontOfSize:14];
    lableInfo.textAlignment = UITextAlignmentCenter;
    lableInfo.textColor = [UIColor whiteColor];
    lableInfo.text = @"Info";
    lableInfo.backgroundColor = [UIColor clearColor];
//    // button Search
//    buttonSearch = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
//    [self setBackgroundButton:buttonSearch withColor:[[UIColor blackColor] colorWithAlphaComponent:0.75] forState:UIControlStateNormal];
//    [self setBackgroundButton:buttonSearch withColor:[[UIColor blackColor] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
//    [buttonSearch addTarget:self action:@selector(buttonSearchClicked:) forControlEvents:UIControlEventTouchUpInside];
//    iconSearch = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"button_search_unselected.png"]];
//    lableSearch = [[UILabel alloc] init];
//    lableSearch.font = [UIFont boldSystemFontOfSize:12];
//    lableSearch.textAlignment = UITextAlignmentCenter;
//    lableSearch.textColor = [UIColor whiteColor];
//    lableSearch.text = @"Search";
    
    if (currentHeadlineID != 0) {
        [self addSubview:buttonBack];
        [self insertSubview:iconBack aboveSubview:buttonBack];
    }
    [self addSubview:buttonRefresh];
    [self addSubview:buttonInfo];
//    [self addSubview:buttonSearch];
    
    [self insertSubview:iconRefresh aboveSubview:buttonRefresh];
    [self insertSubview:iconInfo aboveSubview:buttonInfo];
//    [self insertSubview:iconSearch aboveSubview:buttonSearch];
    [self insertSubview:refreshSpin aboveSubview:iconRefresh];
    if (runningOniPad) {
        if (currentHeadlineID != 0) {
            [buttonBack addSubview:lableBack];
            [self insertSubview:lableBack aboveSubview:buttonBack];
        }
        [buttonRefresh addSubview:lableRefresh];
        [buttonInfo addSubview:lableInfo];
//        [buttonSearch addSubview:lableSearch];
        
        [self insertSubview:lableRefresh aboveSubview:buttonRefresh];
        [self insertSubview:lableInfo aboveSubview:buttonInfo];
//        [self insertSubview:lableSearch aboveSubview:buttonSearch];
    }
    else {
        if (!UIInterfaceOrientationIsPortrait(interfaceOrientation)) {
            if (currentHeadlineID != 0) {
                [buttonBack addSubview:lableBack];
                [self insertSubview:lableBack aboveSubview:buttonBack];
            }
            [buttonRefresh addSubview:lableRefresh];
            [buttonInfo addSubview:lableInfo];
            //        [buttonSearch addSubview:lableSearch];
            
            [self insertSubview:lableRefresh aboveSubview:buttonRefresh];
            [self insertSubview:lableInfo aboveSubview:buttonInfo];
            //        [self insertSubview:lableSearch aboveSubview:buttonSearch];
        }
    }
}
- (void) removeButtonsFromView {
    if (buttonBack)
        [buttonBack removeFromSuperview];
    if (lableBack) {
        [lableBack removeFromSuperview];
    }
    if (iconBack) {
        [iconBack removeFromSuperview];
    }
    if (buttonRefresh)
        [buttonRefresh removeFromSuperview];
    if (lableRefresh) {
        [lableRefresh removeFromSuperview];
    }
    if (iconRefresh) {
        [iconRefresh removeFromSuperview];
    }
    if (buttonInfo)
        [buttonInfo removeFromSuperview];
    if (lableInfo) {
        [lableInfo removeFromSuperview];
    }
    if (iconInfo) {
        [iconInfo removeFromSuperview];
    }
    if (buttonSearch)
        [buttonSearch removeFromSuperview];
    if (lableSearch) {
        [lableSearch removeFromSuperview];
    }
//    if (iconSearch) {
//        [iconSearch removeFromSuperview];
//    }
    if (refreshSpin) {
        [refreshSpin removeFromSuperview];
    }
}
- (IBAction)buttonBackClicked:(id)sender {
    
    if (delegate && [delegate respondsToSelector:@selector(buttonBackClickedEvent)]) {
        [delegate buttonBackClickedEvent];
    }
}
- (IBAction)buttonRefreshClicked:(id)sender {
    
    if (delegate && [delegate respondsToSelector:@selector(buttonRefreshClickedEvent)]) {
        [delegate buttonRefreshClickedEvent];
    }
}
- (IBAction)buttonInfoClicked:(id)sender {
    
    if (delegate && [delegate respondsToSelector:@selector(buttonInfoClickedEvent)]) {
        [delegate buttonInfoClickedEvent];
    }
}
- (IBAction)buttonSearchClicked:(id)sender {
    
    if (delegate && [delegate respondsToSelector:@selector(buttonSearchClickedEvent)]) {
        [delegate buttonSearchClickedEvent];
    }
}

- (void)setBackgroundButton:(UIButton*)button withColor:(UIColor *)color forState:(UIControlState)state
{
    UIView *colorView = [[UIView alloc] initWithFrame:self.frame];
    colorView.backgroundColor = color;
    
    UIGraphicsBeginImageContext(colorView.bounds.size);
    [colorView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *colorImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [button setBackgroundImage:colorImage forState:state];
}
- (void)hideIconAndTextButton:(BOOL) isHidden {
    if (isHidden) {
        iconRefresh.hidden = YES;
        lableRefresh.hidden = YES;
    }
    else {
        iconRefresh.hidden = NO;
        lableRefresh.hidden = NO;
    }
}
-(void)dealloc {

}

@end
