//
//  ViewController.m
//  DrawOval
//
//  Created by Dinh Linh on 24/9/14.
//  Copyright (c) 2014 Dinh Linh. All rights reserved.
//

#import "ViewController.h"
#import "ThumView.h"
#import <QuartzCore/QuartzCore.h>
#import "BottomTabBar.h"
#import "ThumbItem.h"
#import "Globals.h"
@interface ViewController ()

@end

@implementation ViewController
#define ANIMATION_UP_STEP1 1
#define ANIMATION_UP_STEP2 2
#define ANIMATION_FROM_BOTTOM 3
#define ANIMATION_DOWN 4

// for iPad
#define TOP_HEADLINE_PADDING_IPAD 20
#define HEADLINE_PADDING_IPAD 40
#define TOPHEADLINE_SIZE_WIDTH_IPAD 139
#define TOPHEADLINE_SIZE_HEIGHT_IPAD 35

#define HEADLINE_IMAGE_SIZE_WIDTH_IPAD 278
#define HEADLINE_IMAGE_SIZE_HEIGHT_IPAD 156
#define HEADLINE_TITLE_SIZE_HEIGHT_IPAD 70
#define HEADLINE_DESCRIPTION_SIZE_HEIGHT_IPAD 50

// IPAD LANDSCAPE
#define TOP_HEADLINE_ORIGN_Y_IPAD_L 194
#define HEADLINE_IMAGE_ORIGN_Y_IPAD_L 314

// IPAD PORTRAIT
#define TOP_HEADLINE_ORIGN_Y_IPAD_P 268
#define HEADLINE_IMAGE_ORIGN_Y_IPAD_P 388

// for iPhone
#define TOP_HEADLINE_PADDING_IPHONE 8
#define HEADLINE_PADDING_IPHONE 16
#define TOPHEADLINE_SIZE_WIDTH_IPHONE 70
#define TOPHEADLINE_SIZE_HEIGHT_IPHONE 18

#define HEADLINE_IMAGE_SIZE_WIDTH_IPHONE 139
#define HEADLINE_IMAGE_SIZE_HEIGHT_IPHONE 78
#define HEADLINE_TITLE_SIZE_HEIGHT_IPHONE 35
#define HEADLINE_DESCRIPTION_SIZE_HEIGHT_IPHONE 25

// IPHONE 4 LANDSCAPE
#define TOP_HEADLINE_ORIGN_Y_IPHONE_4_L 81
#define HEADLINE_IMAGE_ORIGN_Y_IPHONE_4_L 122

// IPHONE 4 PORTRAIT
#define TOP_HEADLINE_ORIGN_Y_IPHONE_4_P 141
#define HEADLINE_IMAGE_ORIGN_Y_IPHONE_4_P 182

// IPHONE 5 LANDSCAPE :like iphone 4 landscape

// IPHONE 5 PORTRAIT
#define TOP_HEADLINE_ORIGN_Y_IPHONE_5_P 189
#define HEADLINE_IMAGE_ORIGN_Y_IPHONE_5_P 230

// IPHONE 6 LANDSCAPE
#define TOP_HEADLINE_ORIGN_Y_IPHONE_6_L 97
#define HEADLINE_IMAGE_ORIGN_Y_IPHONE_6_L 157

// IPHONE 6 PORTRAIT
#define TOP_HEADLINE_ORIGN_Y_IPHONE_6_P 215
#define HEADLINE_IMAGE_ORIGN_Y_IPHONE_6_P 275

// IPHONE 6PLUS LANDSCAPE
#define TOP_HEADLINE_ORIGN_Y_IPHONE_6_PLUS_L 104
#define HEADLINE_IMAGE_ORIGN_Y_IPHONE_6_PLUS_L 162

// IPHONE 6PLUS PORTRAIT
#define TOP_HEADLINE_ORIGN_Y_IPHONE_6_PLUS_P 218
#define HEADLINE_IMAGE_ORIGN_Y_IPHONE_6_PLUS_P 276

#define TOP_HEADLINE_PADDING_6 10
#define HEADLINE_PADDING_6 20
#define TOPHEADLINE_SIZE_WIDTH_6_PLUS 90
#define TOPHEADLINE_SIZE_HEIGH_6_PLUS 23

#define HEADLINE_IMAGE_SIZE_WIDTH_6_PLUS 180
#define HEADLINE_IMAGE_SIZE_HEIGH_6_PLUS 102
#define HEADLINE_TITLE_SIZE_HEIGH_6_PLUS 46
#define HEADLINE_DESCRIPTION_SIZE_HEIGH_6_PLUS 32

#define IS_IPHONE6 ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)] && fabs( ( double )[ [ UIScreen mainScreen ] nativeBounds ].size.height - ( double )1334 ) < DBL_EPSILON )
#define IS_IPHONE6_PLUS ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)] && fabs( ( double )[ [ UIScreen mainScreen ] nativeBounds ].size.height - ( double )2208 ) < DBL_EPSILON )
#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

#define iPhone6 ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height == 667)

#define iPhone6Plus ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height == 736)


UIScrollView *scrollView1;
UIScrollView *scrollView2;
BottomTabBar *bottomTabBarView;
- (void)viewDidLoad
{
    [super viewDidLoad];
    arrCurrentHeadlines= [[NSMutableArray alloc]init];
    arrPreviousHeadlines= [[NSMutableArray alloc]init];
    arraySelectedID= [[NSMutableArray alloc]init];
    btnBackSelected=NO;
    arrayButton2= [[NSMutableArray alloc]init];
    arrayButton3= [[NSMutableArray alloc]init];
    
    arrayDescription= [[NSMutableArray alloc]init];
    
    arrayThumb= [[NSMutableArray alloc]init];
    isFinishAnimation=YES;
    CGRect screenRect1 = [[UIScreen mainScreen]bounds];
    scrollView1  = [[UIScrollView alloc]init];
    
    UIInterfaceOrientation interfaceOrientation = [UIApplication sharedApplication].statusBarOrientation;
    if(UIInterfaceOrientationIsPortrait(interfaceOrientation)){
        imgBackground= [[UIImageView alloc]initWithFrame:CGRectMake(screenRect1.origin.x,
                                                                    screenRect1.origin.y,
                                                                    screenRect1.size.width,
                                                                    screenRect1.size.height)];
        if (IS_IPHONE6_PLUS || IS_IPHONE6) {
            imgBackground.image= [UIImage imageNamed:@"title_background-568h_p@2x~iphone.jpg"];
        }
        else if (IS_IPHONE_5)
        {
            imgBackground.image= [UIImage imageNamed:@"title_background_p@2x~iphone.jpg"];
        }
        else if ([Globals sharedManager].runningOniPad)
        {
            imgBackground.image= [UIImage imageNamed:@"Default-Portrait~ipad.png"];
        }else
        {
            imgBackground.image= [UIImage imageNamed:@"title_background_p~iphone.jpg"];
        }
        
        
        scrollView1.frame=CGRectMake(screenRect1.origin.x,
                                     screenRect1.origin.y,
                                     screenRect1.size.width,
                                     screenRect1.size.height-48);
    }
    else{
        imgBackground= [[UIImageView alloc]initWithFrame:CGRectMake(screenRect1.origin.x,
                                                                    screenRect1.origin.y,
                                                                    screenRect1.size.height,
                                                                    screenRect1.size.width)];
        if (IS_IPHONE6_PLUS || IS_IPHONE6) {
            imgBackground.image= [UIImage imageNamed:@"title_background-568h_l@2x~iphone.jpg"];
        }
        else if (IS_IPHONE_5)
        {
            imgBackground.image= [UIImage imageNamed:@"title_background_l@2x~iphone.jpg"];
        }
        else if ([Globals sharedManager].runningOniPad)
        {
            imgBackground.image= [UIImage imageNamed:@"Default-Landscape~ipad.png"];
        }else
        {
            imgBackground.image= [UIImage imageNamed:@"title_background_l~iphone.jpg"];
        }
        
        scrollView1.frame=CGRectMake(screenRect1.origin.x,
                                     screenRect1.origin.y,
                                     screenRect1.size.height,
                                     screenRect1.size.width-48);
    }
    
    [self.view addSubview:imgBackground];
    
    
    scrollView1.backgroundColor= [UIColor clearColor];
    [self.view addSubview:scrollView1];
    
    
    btnBack= [UIButton buttonWithType:UIButtonTypeCustom];
    btnBack.backgroundColor=[UIColor clearColor];
    btnBack.center=CGPointMake(20,10);
    [btnBack sizeToFit];
    [btnBack addTarget:self action:@selector(backButton:)forControlEvents:UIControlEventTouchUpInside];
    
    [btnBack setImage:[UIImage imageNamed:@"button_back_unselected.png"]forState:UIControlStateNormal];
    
    
    CGRect frameBottomBar;
    if(UIInterfaceOrientationIsPortrait(interfaceOrientation)){
        frameBottomBar =CGRectMake(0,self.view.frame.size.height-48,self.view.frame.size.width,48);
    }
    else{
        
        frameBottomBar =CGRectMake(0,self.view.frame.size.width-48,self.view.frame.size.height,48);
    }
    
    bottomTabBarView= [[BottomTabBar alloc]initWithFrame:frameBottomBar];
    bottomTabBarView.backgroundColor= [[UIColor blackColor]colorWithAlphaComponent:0.5];
    [bottomTabBarView addSubview:btnBack];
    [self.view addSubview:bottomTabBarView];
    
    currentHeadlineID=0;
    previousHeadlineID=0;
    [self loadScrollViewAtBegining];
    
    NSLog(@"iphone???: %f - %@",[[UIScreen mainScreen] bounds].size.height, iPhone6Plus?@"YES":@"NO");
    
}
-(void)setPositonAndFrame{
    //top/middle padding, buttons, views size are the same in all devices except for iphone 6 plus
    if ([Globals sharedManager].runningOniPad) {
        if UIInterfaceOrientationIsPortrait(self.interfaceOrientation){
            topHeadlineY = TOP_HEADLINE_ORIGN_Y_IPAD_P;
            headlineImageY = HEADLINE_IMAGE_ORIGN_Y_IPAD_P;
        }
        else {
            topHeadlineY = TOP_HEADLINE_ORIGN_Y_IPAD_L;
            headlineImageY = HEADLINE_IMAGE_ORIGN_Y_IPAD_L;
        }
        
        topHeadlinePadding = TOP_HEADLINE_PADDING_IPAD;
        headlinePadding = HEADLINE_PADDING_IPAD;
        topHeadlineWidth = TOPHEADLINE_SIZE_WIDTH_IPAD;
        topHeadlineHeigh = TOPHEADLINE_SIZE_HEIGHT_IPAD;
        
        headlineImageWidth = HEADLINE_IMAGE_SIZE_WIDTH_IPAD;
        headlineImageHeigh = HEADLINE_IMAGE_SIZE_HEIGHT_IPAD;
        headlineTitleHeigh = HEADLINE_TITLE_SIZE_HEIGHT_IPAD;
        headlineDescriptionHeigh = HEADLINE_DESCRIPTION_SIZE_HEIGHT_IPAD;
    }else if (IS_IPHONE6_PLUS) {
        if UIInterfaceOrientationIsPortrait(self.interfaceOrientation){
            topHeadlineY = TOP_HEADLINE_ORIGN_Y_IPHONE_6_PLUS_P;
            headlineImageY = HEADLINE_IMAGE_ORIGN_Y_IPHONE_6_PLUS_P;
        }
        else {
            topHeadlineY = TOP_HEADLINE_ORIGN_Y_IPHONE_6_PLUS_L;
            headlineImageY = HEADLINE_IMAGE_ORIGN_Y_IPHONE_6_PLUS_L;
        }
        
        topHeadlinePadding = TOP_HEADLINE_PADDING_6;
        headlinePadding = HEADLINE_PADDING_6;
        topHeadlineWidth = TOPHEADLINE_SIZE_WIDTH_6_PLUS;
        topHeadlineHeigh = TOPHEADLINE_SIZE_HEIGH_6_PLUS;
        
        headlineImageWidth = HEADLINE_IMAGE_SIZE_WIDTH_6_PLUS;
        headlineImageHeigh = HEADLINE_IMAGE_SIZE_HEIGH_6_PLUS;
        headlineTitleHeigh = HEADLINE_TITLE_SIZE_HEIGH_6_PLUS;
        headlineDescriptionHeigh = HEADLINE_DESCRIPTION_SIZE_HEIGH_6_PLUS;
    }else if (IS_IPHONE6)
    {
        if UIInterfaceOrientationIsPortrait(self.interfaceOrientation){
            topHeadlineY = TOP_HEADLINE_ORIGN_Y_IPHONE_6_P;
            headlineImageY = HEADLINE_IMAGE_ORIGN_Y_IPHONE_6_P;
        }
        else {
            topHeadlineY = TOP_HEADLINE_ORIGN_Y_IPHONE_6_L;
            headlineImageY = HEADLINE_IMAGE_ORIGN_Y_IPHONE_6_L;
        }
        
        topHeadlinePadding = TOP_HEADLINE_PADDING_6;
        headlinePadding = HEADLINE_PADDING_6;
        topHeadlineWidth = TOPHEADLINE_SIZE_WIDTH_IPHONE;
        topHeadlineHeigh = TOPHEADLINE_SIZE_HEIGHT_IPHONE;
        
        headlineImageWidth = HEADLINE_IMAGE_SIZE_WIDTH_IPHONE;
        headlineImageHeigh = HEADLINE_IMAGE_SIZE_HEIGHT_IPHONE;
        headlineTitleHeigh = HEADLINE_TITLE_SIZE_HEIGHT_IPHONE;
        headlineDescriptionHeigh = HEADLINE_DESCRIPTION_SIZE_HEIGHT_IPHONE;
    }else if ([Globals sharedManager].has4InchDisplay) // iPhone 5
    {
        if UIInterfaceOrientationIsPortrait(self.interfaceOrientation){
            topHeadlineY = TOP_HEADLINE_ORIGN_Y_IPHONE_5_P;
            headlineImageY = HEADLINE_IMAGE_ORIGN_Y_IPHONE_5_P;
        }
        else {
            topHeadlineY = TOP_HEADLINE_ORIGN_Y_IPHONE_4_L;
            headlineImageY = HEADLINE_IMAGE_ORIGN_Y_IPHONE_4_L;
        }
        
        topHeadlinePadding = TOP_HEADLINE_PADDING_IPHONE;
        headlinePadding = HEADLINE_PADDING_IPHONE;
        topHeadlineWidth = TOPHEADLINE_SIZE_WIDTH_IPHONE;
        topHeadlineHeigh = TOPHEADLINE_SIZE_HEIGHT_IPHONE;
        
        headlineImageWidth = HEADLINE_IMAGE_SIZE_WIDTH_IPHONE;
        headlineImageHeigh = HEADLINE_IMAGE_SIZE_HEIGHT_IPHONE;
        headlineTitleHeigh = HEADLINE_TITLE_SIZE_HEIGHT_IPHONE;
        headlineDescriptionHeigh = HEADLINE_DESCRIPTION_SIZE_HEIGHT_IPHONE;
    }
    else { // iPhone 4 and earlier
        
        if UIInterfaceOrientationIsPortrait(self.interfaceOrientation){
            topHeadlineY = TOP_HEADLINE_ORIGN_Y_IPHONE_4_P;
            headlineImageY = HEADLINE_IMAGE_ORIGN_Y_IPHONE_4_P;
        }
        else {
            topHeadlineY = TOP_HEADLINE_ORIGN_Y_IPHONE_4_L;
            headlineImageY = HEADLINE_IMAGE_ORIGN_Y_IPHONE_4_L;
        }
        
        topHeadlinePadding = TOP_HEADLINE_PADDING_IPHONE;
        headlinePadding = HEADLINE_PADDING_IPHONE;
        topHeadlineWidth = TOPHEADLINE_SIZE_WIDTH_IPHONE;
        topHeadlineHeigh = TOPHEADLINE_SIZE_HEIGHT_IPHONE;
        
        headlineImageWidth = HEADLINE_IMAGE_SIZE_WIDTH_IPHONE;
        headlineImageHeigh = HEADLINE_IMAGE_SIZE_HEIGHT_IPHONE;
        headlineTitleHeigh = HEADLINE_TITLE_SIZE_HEIGHT_IPHONE;
        headlineDescriptionHeigh = HEADLINE_DESCRIPTION_SIZE_HEIGHT_IPHONE;
    }
    
    //        topHeadlinePadding = TOP_HEADLINE_PADDING;
    //        headlinePadding = HEADLINE_PADDING;
    //        topHeadlineWidth = TOPHEADLINE_SIZE_WIDTH;
    //        topHeadlineHeigh = TOPHEADLINE_SIZE_HEIGH;
    //
    //        headlineImageWidth = HEADLINE_IMAGE_SIZE_WIDTH;
    //        headlineImageHeigh = HEADLINE_IMAGE_SIZE_HEIGH;
    //        headlineTitleHeigh = HEADLINE_TITLE_SIZE_HEIGH;
    //        headlineDescriptionHeigh = HEADLINE_DESCRIPTION_SIZE_HEIGH;
    //
    //
    //        if UIInterfaceOrientationIsPortrait(self.interfaceOrientation){
    //            screenSize = [[UIScreen mainScreen] bounds].size;
    //            if ([Globals sharedManager].runningOniPad){
    //                topHeadlineY = TOP_HEADLINE_ORIGN_Y_IPAD_P;
    //                headlineImageY = HEADLINE_IMAGE_ORIGN_Y_IPAD_P;
    //                return;
    //
    //            }
    //            if (IS_IPHONE6) {
    //                topHeadlineY = TOP_HEADLINE_ORIGN_Y_IPHONE_6_P;
    //                headlineImageY = HEADLINE_IMAGE_ORIGN_Y_IPHONE_6_P;
    //                return;
    //            }
    //
    //            if ([Globals sharedManager].has4InchDisplay) {
    //                topHeadlineY = TOP_HEADLINE_ORIGN_Y_IPHONE_5_P;
    //                headlineImageY = HEADLINE_IMAGE_ORIGN_Y_IPHONE_5_P;
    //                return;
    //            }
    //            if ([Globals sharedManager].hasRetinaDisplay) {
    //                topHeadlineY = TOP_HEADLINE_ORIGN_Y_IPHONE_4_P/2;
    //                headlineImageY = HEADLINE_IMAGE_ORIGN_Y_IPHONE_4_P/2;
    //
    //                topHeadlinePadding = TOP_HEADLINE_PADDING/2;
    //                headlinePadding = HEADLINE_PADDING/2;
    //                topHeadlineWidth = TOPHEADLINE_SIZE_WIDTH/2;
    //                topHeadlineHeigh = TOPHEADLINE_SIZE_HEIGH/2;
    //
    //                headlineImageWidth = HEADLINE_IMAGE_SIZE_WIDTH/2;
    //                headlineImageHeigh = HEADLINE_IMAGE_SIZE_HEIGH/2;
    //                headlineTitleHeigh = HEADLINE_TITLE_SIZE_HEIGH/2;
    //                headlineDescriptionHeigh = HEADLINE_DESCRIPTION_SIZE_HEIGH/2;
    //                return;
    //            }
    //
    //        }
    //        else { // running in landscape
    //            CGSize screenSize1 = [[UIScreen mainScreen] bounds].size;
    //            screenSize =CGSizeMake (screenSize1.height, screenSize1.width);
    //            if ([Globals sharedManager].runningOniPad){
    //                topHeadlineY = TOP_HEADLINE_ORIGN_Y_IPAD_L;
    //                headlineImageY = HEADLINE_IMAGE_ORIGN_Y_IPAD_L;
    //                return;
    //
    //            }
    //            if (IS_IPHONE6) {
    //                topHeadlineY = TOP_HEADLINE_ORIGN_Y_IPAD_L;
    //                headlineImageY = HEADLINE_IMAGE_ORIGN_Y_IPAD_L;
    //                return;
    //            }
    //
    //            if ([Globals sharedManager].hasRetinaDisplay) {
    //                topHeadlineY = TOP_HEADLINE_ORIGN_Y_IPHONE_4_L;
    //                headlineImageY = HEADLINE_IMAGE_ORIGN_Y_IPHONE_4_L;
    //                return;
    //            }
    //        }
    
    //    }
    
}


-(void)clickTopButton:(id)sender{
    if (!isFinishAnimation) {
        return;
    }
    UIButton *clickButton = sender;
    previousHeadlineID = currentHeadlineID;
    if (previousHeadlineID == clickButton.tag) {
        return;
    }
    
    for (int i=0; i<[arrayButton2 count]; i++) {
        UIButton *b = [arrayButton2 objectAtIndex:i];
        if (b.tag == previousHeadlineID) {
            b.backgroundColor = [UIColor colorWithRed:60.0/255 green:60.0/255 blue:60.0/255 alpha:0.8];
            b.alpha = 0.8;
            [[b layer] setBorderColor:[[UIColor colorWithRed:223.0/255.0
                                                       green:223.0/255.0
                                                        blue:223.0/255.0
                                                       alpha:0.8] CGColor]];
            [b.layer setBorderWidth:1.f];
            break;
        }
    }
    
    [clickButton setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:108.0/255 green:108.0/255 blue:108.0/255 alpha:0.8]] forState:UIControlStateHighlighted];
    clickButton.backgroundColor = [UIColor colorWithRed:108.0/255 green:108.0/255 blue:108.0/255 alpha:0.8];
    clickButton.alpha = 0.8;
    
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform"];
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anim.duration = 0.2;
    anim.repeatCount = 1;
    anim.autoreverses = YES;
    anim.removedOnCompletion = YES;
    anim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)];
    [clickButton.layer addAnimation:anim forKey:nil];
    
    currentHeadlineID = clickButton.tag;
    [self loadCurrentHeadlines:clickButton.tag];
    
    if ([arrCurrentHeadlines count]==0) {
        [self performSelector:@selector(showCover) withObject:nil afterDelay:0.4];
        [arraySelectedID addObject:[NSNumber numberWithInteger:currentHeadlineID]];
        return;
    }
    [arraySelectedID removeLastObject];
    int lastObject = [[arraySelectedID lastObject] integerValue];
    if (lastObject != [sender tag])
        [arraySelectedID addObject:[NSNumber numberWithInteger:currentHeadlineID]];
    
    [self loadScrollViewFadeInForHeadline:currentHeadlineID];
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

-(void)clickButton:(id)sender{
    if (!isFinishAnimation) {
        return;
    }
    isFinishAnimation = NO;
    isFinishStep1 = NO;
    isFinishStep2 = NO;
    
    btnBackSelected = NO;
    UIButton *clickButton = sender;
    
    
    
    previousHeadlineID = currentHeadlineID;
    currentHeadlineID = clickButton.tag;
    
    [self zoomHeadline];
    
    [self loadCurrentHeadlines:currentHeadlineID];
    int lastObject = [[arraySelectedID lastObject] integerValue];
    if (lastObject != [sender tag])
        [arraySelectedID addObject:[NSNumber numberWithInteger:currentHeadlineID]];
    NSLog(@"selected: %@",arraySelectedID);
    
    if ([arrCurrentHeadlines count]==0) {
        [self performSelector:@selector(showCover) withObject:nil afterDelay:0.4];
        return;
    }
    NSArray *tempArray = [arrayButton2 mutableCopy];
    for (int i =0; i<[tempArray count]; i++) {
        UIButton *tempBtn = [tempArray objectAtIndex:i];
        
        [UIView animateWithDuration:0.9 animations:^{
            tempBtn.alpha = 0.0;
        } completion:^(BOOL finished){
            [tempBtn removeFromSuperview];
        }];
    }
    
    [arrayButton2 removeAllObjects];
    [clickButton setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:108.0/255 green:108.0/255 blue:108.0/255 alpha:0.8]] forState:UIControlStateHighlighted];
    clickButton.backgroundColor = [UIColor colorWithRed:108.0/255 green:108.0/255 blue:108.0/255 alpha:0.8];
    clickButton.alpha = 0.8;
    arrayButton2 = [arrayButton3 mutableCopy];
    [self loadTopButtonForHeadline:currentHeadlineID];
    
    [self performSelector:@selector(moveHeadline) withObject:nil afterDelay:0.4];
    
    
    
    [self performSelector:@selector(loadScrollForCurrentHeadline) withObject:nil afterDelay:0.65];
}
-(void)showCover {
    [self hideCoverView:NO];
    isFinishAnimation = YES;
}
-(void)zoomHeadline {
    [self setPositonAndFrame];
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform"];
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anim.duration = 0.2;
    anim.autoreverses = YES;
    anim.removedOnCompletion = NO;
    [anim setValue:@"anim1" forKey:@"anim1"];
    anim.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    anim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)];
    
    
    for (int i =0; i<[arrayButton3 count]; i++) {
        
        UIButton *b2 = [arrayButton3 objectAtIndex:i];
        if (b2.tag == currentHeadlineID) {
            CGRect viewFrame= CGRectMake(topHeadlinePadding +i*(headlinePadding+ headlineImageWidth) , headlineImageY, headlineImageWidth, headlineImageHeigh + headlineTitleHeigh +headlineDescriptionHeigh);
            
            if (!parentView) {
                parentView = [[UIView alloc] initWithFrame:viewFrame];
            }
            else {
                parentView.frame = viewFrame;
                [self.view bringSubviewToFront: parentView];
            }
            parentView.backgroundColor = [UIColor clearColor];
            
            
            UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
            ThumbItem *item = [arrCurrentHeadlines objectAtIndex:i];
            [b setTitle:item.thumbTitle forState:UIControlStateNormal];
            b.frame = CGRectMake(0, headlineImageHeigh-1, headlineImageWidth, headlineTitleHeigh);;
            [b setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:108.0/255 green:108.0/255 blue:108.0/255 alpha:1.0]] forState:UIControlStateHighlighted];
            b.backgroundColor = [UIColor colorWithRed:60.0/255 green:60.0/255 blue:60.0/255 alpha:1.0];
            b.alpha = 1.0;
            [[b layer] setBorderColor:[[UIColor colorWithRed:223.0/255.0
                                                       green:223.0/255.0
                                                        blue:223.0/255.0
                                                       alpha:1.0] CGColor]];
            [b.layer setBorderWidth:1.f];
            b.titleLabel.font= [UIFont systemFontOfSize:34];
            if (![Globals sharedManager].runningOniPad) {
                b.titleLabel.font= [UIFont systemFontOfSize:17];
            }
            b.titleLabel.textColor = [UIColor whiteColor];
            [b setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [b setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            [b setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            
            
            ThumView *thumb = [[ThumView alloc]initWithFrame:CGRectMake(0, 0, headlineImageWidth, headlineImageHeigh)];
            thumb.item = item;
            [thumb loadImageForThumb];
            [thumb.layer setBorderWidth:1.0];
            [thumb.layer setBorderColor:[[UIColor colorWithRed:223.0/255.0
                                                         green:223.0/255.0
                                                          blue:223.0/255.0
                                                         alpha:1.0] CGColor]];
            thumb.backgroundColor = [UIColor whiteColor];
            thumb.alpha = 1.0;
            // add button
            maskBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            maskBtn.backgroundColor = [UIColor clearColor];
            maskBtn.frame = thumb.bounds;
            maskBtn.tag = item.thumbID;
            [thumb addSubview:maskBtn];
            
            // add Description
            UIButton *descriptionView = [[UIButton alloc] initWithFrame:CGRectMake(0, headlineImageHeigh + headlineTitleHeigh-2, headlineImageWidth, headlineDescriptionHeigh)];
            
            descriptionView.titleLabel.textColor = [UIColor whiteColor];
            [descriptionView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [descriptionView setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            [descriptionView setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:108.0/255 green:108.0/255 blue:108.0/255 alpha:1.0]] forState:UIControlStateHighlighted];
            //        [descriptionView setTitleColor:[UIColor colorWithRed:99.0/255 green:99.0/255 blue:99.0/255 alpha:1.0] forState:UIControlStateHighlighted];
            [descriptionView setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [[descriptionView layer] setBorderColor:[[UIColor colorWithRed:223.0/255.0
                                                                     green:223.0/255.0
                                                                      blue:223.0/255.0
                                                                     alpha:1.0] CGColor]];
            
            descriptionView.backgroundColor = [UIColor colorWithRed:60.0/255 green:60.0/255 blue:60.0/255 alpha:1.0];
            descriptionView.alpha = 1.0;
            NSString *textDes = @"There are many variations of passages of Lorem Ipsum avaiable";
            [descriptionView setTitle:textDes forState:UIControlStateNormal];
            descriptionView.titleLabel.textAlignment = NSTextAlignmentCenter;;
            descriptionView.titleLabel.numberOfLines = 2;
            descriptionView.titleLabel.font = [UIFont systemFontOfSize:17.0];
            if (![Globals sharedManager].runningOniPad) {
                descriptionView.titleLabel.font= [UIFont systemFontOfSize:17.0/2];
            }
            descriptionView.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
            [descriptionView.layer setBorderWidth:1.f];
            
            [parentView addSubview:thumb];
            [parentView addSubview:b];
            [parentView addSubview:descriptionView];
            [scrollView1 addSubview:parentView];
            [parentView.layer addAnimation:anim forKey:nil];
            return;
            
        }
        
        
        
    }
}

-(void)moveHeadline {
    [parentView removeFromSuperview];
    animationType = ANIMATION_UP_STEP1;
    
    for (int i =0; i<[arrayButton2 count]; i++) {
        
        
        CGRect frameTop= CGRectMake(topHeadlinePadding +i*(topHeadlinePadding + topHeadlineWidth) , topHeadlineY, topHeadlineWidth, topHeadlineHeigh);
        CGPoint topPoint = CGPointMake(frameTop.origin.x + frameTop.size.width/2, frameTop.origin.y+frameTop.size.height/2);
        
        UIButton *b2 = [arrayButton2 objectAtIndex:i];
        [b2 removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
        [b2 addTarget:nil action:@selector(clickTopButton:) forControlEvents:UIControlEventTouchUpInside];
        if (b2.tag == currentHeadlineID) {
            b2.backgroundColor = [UIColor colorWithRed:108.0/255 green:108.0/255 blue:108.0/255 alpha:0.8];
            b2.alpha = 0.8;
        }
        ThumView *thumb = [arrayThumb objectAtIndex:i];
        thumb.alpha = 0.0;
        
        CGPoint middlePoint = b2.center;
        
        
        b2.frame = frameTop;
        b2.center = topPoint;
        b2.titleLabel.font = [UIFont systemFontOfSize:17];
        if (![Globals sharedManager].runningOniPad) {
            b2.titleLabel.font= [UIFont systemFontOfSize:17.0/2];
        }
        b2.titleLabel.textColor = [UIColor whiteColor];
        [b2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [b2 setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [b2 setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        
        UIBezierPath *movePath = [UIBezierPath bezierPath];
        [movePath moveToPoint:middlePoint];
        
        [movePath addLineToPoint:topPoint];
        CAKeyframeAnimation *moveAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        moveAnim.path = movePath.CGPath;
        moveAnim.removedOnCompletion = YES;
        
        CABasicAnimation *scaleAnim = [CABasicAnimation animationWithKeyPath:@"transform"];
        scaleAnim.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
        scaleAnim.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(2.0, 2.0, 1.0)];
        
        scaleAnim.removedOnCompletion = YES;
        
        CABasicAnimation *opacityAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
        opacityAnim.fromValue = [NSNumber numberWithFloat:1.0];
        opacityAnim.toValue = [NSNumber numberWithFloat:1.0];
        opacityAnim.removedOnCompletion = YES;
        
        CAAnimationGroup *animGroup = [CAAnimationGroup animation];
        animGroup.animations = [NSArray arrayWithObjects:moveAnim, scaleAnim, opacityAnim, nil];
        animGroup.duration = 0.45;
        [animGroup setValue:@"step1" forKey:@"step1"];
        [animGroup setDelegate:self];
        b2.alpha =0.8;
        [b2.layer addAnimation:animGroup forKey:nil];
        
        
        
        
        //animation for imageview
        
        CGFloat middleY = middlePoint.y/2 + topPoint.y/2;
        CGFloat middleX = (middleY*(middlePoint.x - topPoint.x) +(topPoint.x * middlePoint.y - middlePoint.x*topPoint.y))/(middlePoint.y - topPoint.y);
        
        
        CGPoint p1 = CGPointMake(middleX, middleY - (headlineImageHeigh+headlineTitleHeigh)/2*(1-(1-0.5)/2));
        
        UIBezierPath *movePath1 = [UIBezierPath bezierPath];
        CGPoint p2 = thumb.center;
        [movePath1 moveToPoint:p2];
        
        [movePath1 addLineToPoint:p1];
        CAKeyframeAnimation *moveAnim1 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        moveAnim1.path = movePath1.CGPath;
        moveAnim1.removedOnCompletion = YES;
        
        CABasicAnimation *scaleAnim1 = [CABasicAnimation animationWithKeyPath:@"transform"];
        scaleAnim1.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
        scaleAnim1.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1-0.5/2, 1-0.5/2, 1.0)];
        scaleAnim1.removedOnCompletion = YES;
        
        CABasicAnimation *opacityAnim1 = [CABasicAnimation animationWithKeyPath:@"opacity"];
        opacityAnim1.fromValue = [NSNumber numberWithFloat:0.5];
        opacityAnim1.toValue = [NSNumber numberWithFloat:0.0];
        opacityAnim1.removedOnCompletion = YES;
        
        CAAnimationGroup *animGroup1 = [CAAnimationGroup animation];
        animGroup1.animations = [NSArray arrayWithObjects:moveAnim1, scaleAnim1, opacityAnim1, nil];
        animGroup1.duration = 0.45/2;
        thumb.alpha = 0;
        [thumb.layer addAnimation:animGroup1 forKey:nil];
        
        
        //animation for descriptionview
        UIButton *descView = [arrayDescription objectAtIndex:i];
        
        CGPoint p1Desc = CGPointMake(middleX, middleY + (headlineTitleHeigh + headlineDescriptionHeigh)/2*(1-(1-0.5)/2));
        
        UIBezierPath *movePath2 = [UIBezierPath bezierPath];
        CGPoint p2Desc = descView.center;
        [movePath2 moveToPoint:p2Desc];
        
        [movePath2 addLineToPoint:p1Desc];
        CAKeyframeAnimation *moveAnim2 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        moveAnim2.path = movePath2.CGPath;
        moveAnim2.removedOnCompletion = YES;
        
        CABasicAnimation *scaleAnim2 = [CABasicAnimation animationWithKeyPath:@"transform"];
        scaleAnim2.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
        scaleAnim2.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1-0.5/2, 1-0.5/2, 1.0)];
        scaleAnim2.removedOnCompletion = YES;
        
        CABasicAnimation *opacityAnim2 = [CABasicAnimation animationWithKeyPath:@"opacity"];
        opacityAnim2.fromValue = [NSNumber numberWithFloat:0.5];
        opacityAnim2.toValue = [NSNumber numberWithFloat:0.0];
        opacityAnim2.removedOnCompletion = YES;
        
        CAAnimationGroup *animGroup2 = [CAAnimationGroup animation];
        animGroup2.animations = [NSArray arrayWithObjects:moveAnim2, scaleAnim2, opacityAnim2, nil];
        animGroup2.duration = 0.45/2;
        descView.alpha = 0;
        [descView.layer addAnimation:animGroup2 forKey:nil];
        
    }
    
    
}
-(void)loadScrollForCurrentHeadline{
    [self loadScrollViewForHeadLineID:currentHeadlineID];
}
-(void)maskBtnDidClick:(id)sender {
    int lastObject = [[arraySelectedID lastObject] intValue];
    if (lastObject != [sender tag])
        [arraySelectedID addObject:[NSNumber numberWithInteger:[sender tag]]];
    for (int i =0; i<[arrayButton3 count]; i++) {
        UIButton *b = [arrayButton3 objectAtIndex:i];
        if (b.tag == [sender tag]) {
            [self clickButton:b];
            break;
        }
    }
    
    
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    return YES;
    //    return NO;
}

- (BOOL) shouldAutorotate{
    return YES;
    
}

- (BOOL)isLandscapeMode {
    
    if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight)
        return YES;
    else
        return NO;
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                 duration:(NSTimeInterval)duration{
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGRect newFrameBottomBar;
    if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation)) {
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGRect portraitRect = CGRectMake(0,0,screenRect.size.width,screenRect.size.height);
        
        scrollView1.frame = portraitRect;
        
        imgBackground.frame = portraitRect;
        if (arraySelectedID.count == 3) {
            imgBackground.image = [UIImage imageNamed:@"ipad_p.png"];
        }
        else
        {
            if (IS_IPHONE6_PLUS || IS_IPHONE6) {
                imgBackground.image= [UIImage imageNamed:@"title_background-568h_p@2x~iphone.jpg"];
            }
            else if (IS_IPHONE_5)
            {
                imgBackground.image= [UIImage imageNamed:@"title_background_p@2x~iphone.jpg"];
            }
            else if ([Globals sharedManager].runningOniPad)
            {
                imgBackground.image= [UIImage imageNamed:@"Default-Portrait~ipad.png"];
            }else
            {
                imgBackground.image= [UIImage imageNamed:@"title_background_p~iphone.jpg"];
            }
        }
        
        newFrameBottomBar = CGRectMake(0, screenRect.size.height - 48, screenRect.size.width, 48);
        screenSize =CGSizeMake (screenRect.size.width, screenRect.size.height);
    }
    else
    {
        CGRect lanscapeRect = CGRectMake(0,0,screenRect.size.height,screenRect.size.width);
        
        scrollView1.frame = lanscapeRect;
        
        imgBackground.frame = lanscapeRect;
        if (arraySelectedID.count ==  3) {
            imgBackground.image = [UIImage imageNamed:@"ipad_l.png"];
        }
        else
        {
            if (IS_IPHONE6_PLUS || IS_IPHONE6) {
                imgBackground.image= [UIImage imageNamed:@"title_background-568h_l@2x~iphone.jpg"];
            }
            else if (IS_IPHONE_5)
            {
                imgBackground.image= [UIImage imageNamed:@"title_background_l@2x~iphone.jpg"];
            }
            else if ([Globals sharedManager].runningOniPad)
            {
                imgBackground.image= [UIImage imageNamed:@"Default-Landscape~ipad.png"];
            }else
            {
                imgBackground.image= [UIImage imageNamed:@"title_background_l~iphone.jpg"];
            }
        }
        
        newFrameBottomBar = CGRectMake(0, screenRect.size.width - 48, screenRect.size.height, 48);
        screenSize =CGSizeMake (screenRect.size.height, screenRect.size.width);
    }
    scrollView1.contentSize = CGSizeMake((headlinePadding + headlineImageWidth)*[arrCurrentHeadlines count] + topHeadlinePadding, screenSize.height - 48);
    bottomTabBarView.frame = newFrameBottomBar;
    [scrollView1.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [arrayButton3 removeAllObjects];
    [arrayThumb removeAllObjects];
    [arrayButton2 removeAllObjects];
    [arrayDescription removeAllObjects];
    
}
-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    
    [self loadScrollViewAtBegining];
    [self loadTopButtonForRotating];
    
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    //
    isFinishAnimation = YES;
    if ([anim valueForKey:@"step1"]) {
        if (isFinishStep1) {
            
            return;
        }
        isFinishStep1 = YES;
        
    }
}

-(void)backButton:(id)sender{
    if (currentHeadlineID ==0) {
        return;
    }
    if (!isFinishAnimation) {
        return;
    }
    [arraySelectedID removeLastObject];
    if ([arraySelectedID count]>0) {
        currentHeadlineID = [[arraySelectedID lastObject] integerValue];
        [self hideCoverView:YES];
    }
    else {
        currentHeadlineID = 0;
    }
    [self loadScrollViewBackToHeadLineID:currentHeadlineID];
}
-(void)loadScrollViewAtBegining{
    [self setPositonAndFrame];
    
    
    [self loadCurrentHeadlines:currentHeadlineID];
    [self loadPreviousHeadlines:currentHeadlineID];
    
    for (UIButton *b in arrayButton3) {
        [b removeFromSuperview];
    }
    [arrayButton3 removeAllObjects];
    
    scrollView1.contentSize = CGSizeMake((headlinePadding + headlineImageWidth)*[arrCurrentHeadlines count] +headlinePadding, screenSize.height - 48);
    
    
    
    for (int i= 0; i<[arrCurrentHeadlines count]; i++) {
        CGRect frame = CGRectMake(topHeadlinePadding +i*(headlinePadding+ headlineImageWidth) , headlineImageY, headlineImageWidth, headlineImageHeigh+1);
        
        UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
        ThumbItem *item = [arrCurrentHeadlines objectAtIndex:i];
        [b setTitle:item.thumbTitle forState:UIControlStateNormal];
        CGRect btnFrame = CGRectMake(frame.origin.x, frame.origin.y+headlineImageHeigh, frame.size.width, headlineTitleHeigh +2);
        b.frame = btnFrame;
        [b setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:108.0/255 green:108.0/255 blue:108.0/255 alpha:0.8]] forState:UIControlStateHighlighted];
        b.backgroundColor = [UIColor colorWithRed:60.0/255 green:60.0/255 blue:60.0/255 alpha:0.8];
        b.alpha = 0.8;
        [[b layer] setBorderColor:[[UIColor colorWithRed:223.0/255.0
                                                   green:223.0/255.0
                                                    blue:223.0/255.0
                                                   alpha:0.8] CGColor]];
        [b.layer setBorderWidth:1.f];
        [arrayButton3 addObject:b];
        
        b.titleLabel.font= [UIFont systemFontOfSize:34];
        if (![Globals sharedManager].runningOniPad) {
            b.titleLabel.font= [UIFont systemFontOfSize:17];
        }
        b.titleLabel.textColor = [UIColor whiteColor];
        [b setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [b setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [b setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [b addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        b.tag = item.thumbID;
        [scrollView1 addSubview:b];
        
        
        ThumView *thumb = [[ThumView alloc]initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height)];
        thumb.item = item;
        [thumb loadImageForThumb];
        [thumb.layer setBorderWidth:1.0];
        [thumb.layer setBorderColor:[[UIColor colorWithRed:223.0/255.0
                                                     green:223.0/255.0
                                                      blue:223.0/255.0
                                                     alpha:0.8] CGColor]];
        thumb.backgroundColor = [UIColor whiteColor];
        thumb.alpha = 1.0;
        // add button
        maskBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        maskBtn.backgroundColor = [UIColor clearColor];
        [maskBtn addTarget:self action:@selector(maskBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
        maskBtn.frame = thumb.bounds;
        maskBtn.tag = item.thumbID;
        [thumb addSubview:maskBtn];
        [arrayThumb addObject:thumb];
        
        // add Description
        UIButton *descriptionView = [[UIButton alloc] initWithFrame:CGRectMake(b.frame.origin.x,
                                                                               b.frame.origin.y + b.frame.size.height -1,
                                                                               b.frame.size.width,
                                                                               headlineDescriptionHeigh)];
        
        descriptionView.titleLabel.textColor = [UIColor whiteColor];
        [descriptionView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [descriptionView setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [descriptionView setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:108.0/255 green:108.0/255 blue:108.0/255 alpha:0.8]] forState:UIControlStateHighlighted];
        //        [descriptionView setTitleColor:[UIColor colorWithRed:99.0/255 green:99.0/255 blue:99.0/255 alpha:1.0] forState:UIControlStateHighlighted];
        [descriptionView setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [descriptionView addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        descriptionView.tag = item.thumbID;
        [[descriptionView layer] setBorderColor:[[UIColor colorWithRed:223.0/255.0
                                                                 green:223.0/255.0
                                                                  blue:223.0/255.0
                                                                 alpha:0.8] CGColor]];
        
        descriptionView.backgroundColor = [UIColor colorWithRed:60.0/255 green:60.0/255 blue:60.0/255 alpha:0.8];
        descriptionView.alpha = 0.8;
        NSString *textDes = @"There are many variations of passages of Lorem Ipsum avaiable";
        [descriptionView setTitle:textDes forState:UIControlStateNormal];
        descriptionView.titleLabel.textAlignment = NSTextAlignmentCenter;;
        descriptionView.titleLabel.numberOfLines = 2;
        descriptionView.titleLabel.font = [UIFont systemFontOfSize:17.0];
        if (![Globals sharedManager].runningOniPad) {
            descriptionView.titleLabel.font= [UIFont systemFontOfSize:17.0/2];
        }
        descriptionView.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [descriptionView.layer setBorderWidth:1.f];
        [arrayDescription addObject:descriptionView];
        [scrollView1 addSubview:descriptionView];
        [scrollView1 addSubview:thumb];
        
    }
    
}

- (void)startButtonTouch:(id)sender {
    // start the process running...
    
    UIButton *clickButton = sender;
    NSInteger i = clickButton.tag;
    
    UIButton *b;
    
    for (UIButton *btn in arrayButton3) {
        if (btn.tag == i) {
            b = btn;
        }
    }
    //    b.backgroundColor = [UIColor colorWithRed:108.0/255 green:108.0/255 blue:108.0/255 alpha:1.0];
    
    UIButton *d;
    
    for (UIButton *btn in arrayDescription) {
        if (btn.tag == i) {
            d = btn;
        }
    }
    //    d.backgroundColor = [UIColor colorWithRed:108.0/255 green:108.0/255 blue:108.0/255 alpha:1.0];
    
    //    NSLog(@"startButtonTouch %i",i);
}

- (void)endButtonTouch:(id)sender {
    // stop the running process...
    NSLog(@"endButtonTouch");
    
    UIButton *clickButton = sender;
    NSInteger i = clickButton.tag;
    
    UIButton *b;
    
    for (UIButton *btn in arrayButton3) {
        if (btn.tag == i) {
            b = btn;
        }
    }
    
    UIButton *d;
    
    for (UIButton *btn in arrayDescription) {
        if (btn.tag == i) {
            d = btn;
        }
    }
    
}

-(void)loadScrollViewFadeInForHeadline:(NSInteger)headlineID{
    [self setPositonAndFrame];
    [self loadCurrentHeadlines:headlineID];
    [self loadPreviousHeadlines:headlineID];
    
    // remove all button and thubmview at current level
    for (int i =0; i<[arrayButton3 count]; i++) {
        UIButton *b= [arrayButton3 objectAtIndex:i];
        [b removeFromSuperview];
        
        ThumView *thumb = [arrayThumb objectAtIndex:i];
        [thumb removeFromSuperview];
        
        UIButton *descView = [arrayDescription objectAtIndex:i];
        [descView removeFromSuperview];
    }
    [arrayButton3 removeAllObjects];
    [arrayThumb removeAllObjects];
    [arrayDescription removeAllObjects];
    
    scrollView1.contentSize = CGSizeMake((headlinePadding + headlineImageWidth)*[arrCurrentHeadlines count] +headlinePadding, screenSize.height - 48);
    
    
    
    for (int i= 0; i<[arrCurrentHeadlines count]; i++) {
        CGRect frame = CGRectMake(topHeadlinePadding +i*(headlinePadding+ headlineImageWidth) , headlineImageY, headlineImageWidth, headlineImageHeigh);
        
        UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
        ThumbItem *item = [arrCurrentHeadlines objectAtIndex:i];
        [b setTitle:item.thumbTitle forState:UIControlStateNormal];
        CGRect btnFrame = CGRectMake(frame.origin.x, frame.origin.y+headlineImageHeigh, frame.size.width, headlineTitleHeigh);
        b.frame = btnFrame;
        [b setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:108.0/255 green:108.0/255 blue:108.0/255 alpha:0.8]] forState:UIControlStateHighlighted];
        b.backgroundColor = [UIColor colorWithRed:60.0/255 green:60.0/255 blue:60.0/255 alpha:0.8];
        b.alpha = 0.8;
        [[b layer] setBorderColor:[[UIColor colorWithRed:223.0/255.0
                                                   green:223.0/255.0
                                                    blue:223.0/255.0
                                                   alpha:0.8] CGColor]];
        [b.layer setBorderWidth:1.f];
        [arrayButton3 addObject:b];
        b.titleLabel.font= [UIFont systemFontOfSize:34];
        if (![Globals sharedManager].runningOniPad) {
            b.titleLabel.font= [UIFont systemFontOfSize:17];
        }
        [b setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [b setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [b setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [b addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        b.tag = item.thumbID;
        b.alpha = 0.1;
        [scrollView1 addSubview:b];
        
        
        ThumView *thumb = [[ThumView alloc]initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height)];
        thumb.item = item;
        [thumb loadImageForThumb];
        [thumb.layer setBorderWidth:1.0];
        [thumb.layer setBorderColor:[[UIColor colorWithRed:223.0/255.0
                                                     green:223.0/255.0
                                                      blue:223.0/255.0
                                                     alpha:0.8] CGColor]];
        maskBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        maskBtn.backgroundColor = [UIColor clearColor];
        [maskBtn addTarget:self action:@selector(maskBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
        maskBtn.frame = thumb.bounds;
        maskBtn.tag = item.thumbID;
        [thumb addSubview:maskBtn];
        
        thumb.backgroundColor = [UIColor whiteColor];
        thumb.alpha = 0.1;
        [arrayThumb addObject:thumb];
        [scrollView1 addSubview:thumb];
        
        UIButton *descriptionView = [[UIButton alloc] initWithFrame:CGRectMake(thumb.frame.origin.x,
                                                                               thumb.frame.origin.y + headlineImageHeigh+headlineTitleHeigh,
                                                                               headlineImageWidth,
                                                                               headlineDescriptionHeigh)];
        descriptionView.alpha = 0.0;
        descriptionView.titleLabel.textColor = [UIColor whiteColor];
        [descriptionView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [descriptionView setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [descriptionView setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:108.0/255 green:108.0/255 blue:108.0/255 alpha:0.8]] forState:UIControlStateHighlighted];
        //        [descriptionView setTitleColor:[UIColor colorWithRed:99.0/255 green:99.0/255 blue:99.0/255 alpha:1.0] forState:UIControlStateHighlighted];
        [descriptionView setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [descriptionView addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        descriptionView.tag = item.thumbID;
        [[descriptionView layer] setBorderColor:[[UIColor colorWithRed:223.0/255.0
                                                                 green:223.0/255.0
                                                                  blue:223.0/255.0
                                                                 alpha:0.8] CGColor]];
        
        descriptionView.backgroundColor = [UIColor colorWithRed:60.0/255 green:60.0/255 blue:60.0/255 alpha:0.8];
        NSString *textDes = @"There are many variations of passages of Lorem Ipsum avaiable";
        [descriptionView setTitle:textDes forState:UIControlStateNormal];
        descriptionView.titleLabel.textAlignment = NSTextAlignmentCenter;;
        descriptionView.titleLabel.numberOfLines = 2;
        descriptionView.titleLabel.font = [UIFont systemFontOfSize:17.0];
        if (![Globals sharedManager].runningOniPad) {
            descriptionView.titleLabel.font= [UIFont systemFontOfSize:17.0/2];
        }
        descriptionView.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [descriptionView.layer setBorderWidth:1.f];
        [arrayDescription addObject:descriptionView];
        [scrollView1 addSubview:descriptionView];
        
        [UIView animateWithDuration:0.6
                              delay:0
                            options:UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             thumb.alpha = 1.0;
                             b.alpha = 0.8;
                             descriptionView.alpha = 0.8;
                         }
                         completion:nil];
        
    }
    
}
-(void)loadScrollViewBackToHeadLineID:(NSInteger)headlineID{
    [self setPositonAndFrame];
    isFinishAnimation = NO;
    
    [self loadCurrentHeadlines:headlineID];
    [self loadPreviousHeadlines:headlineID];
    
    // remove all button and thubmview at current level
    [scrollView1.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [arrayButton3 removeAllObjects];
    [arrayThumb removeAllObjects];
    [arrayButton2 removeAllObjects];
    [arrayDescription removeAllObjects];
    
    
    //end
    
    
    scrollView1.contentSize = CGSizeMake((headlinePadding + headlineImageWidth)*[arrCurrentHeadlines count] +headlinePadding, screenSize.height - 48);
    
    
    
    for (int i= 0; i<[arrCurrentHeadlines count]; i++) {
        CGRect frame = CGRectMake(topHeadlinePadding +i*(headlinePadding+ headlineImageWidth) , headlineImageY, headlineImageWidth, headlineImageHeigh);
        
        UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
        ThumbItem *item = [arrCurrentHeadlines objectAtIndex:i];
        [b setTitle:item.thumbTitle forState:UIControlStateNormal];
        CGRect btnFrame = CGRectMake(frame.origin.x, frame.origin.y+headlineImageHeigh, frame.size.width, headlineTitleHeigh);
        b.frame = btnFrame;
        [b setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:108.0/255 green:108.0/255 blue:108.0/255 alpha:0.8]] forState:UIControlStateHighlighted];
        b.backgroundColor = [UIColor colorWithRed:60.0/255 green:60.0/255 blue:60.0/255 alpha:0.8];
        b.alpha = 0.8;
        [[b layer] setBorderColor:[[UIColor colorWithRed:223.0/255.0
                                                   green:223.0/255.0
                                                    blue:223.0/255.0
                                                   alpha:0.8] CGColor]];
        [b.layer setBorderWidth:1.f];
        [arrayButton3 addObject:b];
        
        
        b.titleLabel.font= [UIFont systemFontOfSize:34];
        if (![Globals sharedManager].runningOniPad) {
            b.titleLabel.font= [UIFont systemFontOfSize:17];
        }
        [b setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [b setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [b setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [b addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        b.tag = item.thumbID;
        maskBtn.tag = item.thumbID;
        b.alpha = 0.8;
        [scrollView1 addSubview:b];
        
        
        CGRect frameTop= CGRectMake(topHeadlinePadding +i*(topHeadlinePadding+topHeadlineWidth) , topHeadlineY, topHeadlineWidth, topHeadlineHeigh);
        CGPoint topPoint = CGPointMake(frameTop.origin.x + frameTop.size.width/2, frameTop.origin.y+frameTop.size.height/2);
        UIBezierPath *movePath = [UIBezierPath bezierPath];
        [movePath moveToPoint:topPoint];
        //        [movePath addQuadCurveToPoint:middleButtonPoint
        //                         controlPoint:CGPointMake(b2.center.x, middleButtonPoint.y)];
        
        [movePath addLineToPoint:b.center];
        CAKeyframeAnimation *moveAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        moveAnim.path = movePath.CGPath;
        moveAnim.removedOnCompletion = YES;
        
        CABasicAnimation *scaleAnim = [CABasicAnimation animationWithKeyPath:@"transform"];
        scaleAnim.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
        scaleAnim.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5, 0.5, 1.0)];
        
        scaleAnim.removedOnCompletion = YES;
        
        CABasicAnimation *opacityAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
        opacityAnim.fromValue = [NSNumber numberWithFloat:1.0];
        opacityAnim.toValue = [NSNumber numberWithFloat:1.0];
        opacityAnim.removedOnCompletion = YES;
        
        CAAnimationGroup *animGroup = [CAAnimationGroup animation];
        animGroup.animations = [NSArray arrayWithObjects:moveAnim, scaleAnim, opacityAnim, nil];
        animGroup.duration = 0.4;
        [animGroup setValue:@"back" forKey:@"back"];
        [animGroup setDelegate:self];
        b.alpha =0.8;
        [b.layer addAnimation:animGroup forKey:nil];
        
        
    }
    [self loadThumbViewForBack];
    [self performSelector:@selector(loadTopButtonForBack) withObject:nil afterDelay:0.4];
}
-(void)loadTopButtonForRotating{
    //    [self setPositonAndFrame];
    //    scrollView1.contentSize = CGSizeMake((headlinePadding + headlineImageWidth)*[arrCurrentHeadlines count] + topHeadlinePadding, screenSize.height - 48);
    if ([arraySelectedID count] >0) {
        for (int i =0; i<[arrPreviousHeadlines count]; i++) {
            
            CGRect frameTop= CGRectMake(topHeadlinePadding +i*(topHeadlinePadding+topHeadlineWidth) , topHeadlineY, topHeadlineWidth, topHeadlineHeigh);
            
            UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
            ThumbItem *item = [arrPreviousHeadlines objectAtIndex:i];
            [b setTitle:item.thumbTitle forState:UIControlStateNormal];
            b.frame = frameTop;
            [b setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [b setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            [b setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [b setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:108.0/255 green:108.0/255 blue:108.0/255 alpha:0.8]] forState:UIControlStateHighlighted];
            b.backgroundColor = [UIColor colorWithRed:60.0/255 green:60.0/255 blue:60.0/255 alpha:0.8];
            b.alpha = 0.8;
            [[b layer] setBorderColor:[[UIColor colorWithRed:223.0/255.0
                                                       green:223.0/255.0
                                                        blue:223.0/255.0
                                                       alpha:0.8] CGColor]];
            [b.layer setBorderWidth:1.f];
            if (![Globals sharedManager].runningOniPad) {
                b.titleLabel.font= [UIFont systemFontOfSize:17.0/2];
            }
            
            [b addTarget:nil action:@selector(clickTopButton:) forControlEvents:UIControlEventTouchUpInside];
            b.tag = item.thumbID;
            if (b.tag == currentHeadlineID) {
                [b setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:108.0/255 green:108.0/255 blue:108.0/255 alpha:0.8]] forState:UIControlStateHighlighted];
                b.backgroundColor = [UIColor colorWithRed:108.0/255 green:108.0/255 blue:108.0/255 alpha:0.8];
                b.alpha = 0.8;
            }
            [arrayButton2 addObject:b];
            [scrollView1 addSubview:b];
            
        }
    }
}
-(void)loadTopButtonForBack{
    [self setPositonAndFrame];
    
    scrollView1.contentSize = CGSizeMake((headlinePadding + headlineImageWidth)*[arrCurrentHeadlines count] + topHeadlinePadding, screenSize.height - 48);
    
    if ([arraySelectedID count] >0) {
        for (int i =0; i<[arrPreviousHeadlines count]; i++) {
            
            CGRect frameTop= CGRectMake(topHeadlinePadding +i*(topHeadlinePadding+topHeadlineWidth) , topHeadlineY, topHeadlineWidth, topHeadlineHeigh);
            
            UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
            ThumbItem *item = [arrPreviousHeadlines objectAtIndex:i];
            [b setTitle:item.thumbTitle forState:UIControlStateNormal];
            b.frame = frameTop;
            [b setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [b setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            [b setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [b setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:108.0/255 green:108.0/255 blue:108.0/255 alpha:0.8]] forState:UIControlStateHighlighted];
            b.backgroundColor = [UIColor colorWithRed:60.0/255 green:60.0/255 blue:60.0/255 alpha:0.8];
            b.alpha = 0.8;
            [[b layer] setBorderColor:[[UIColor colorWithRed:223.0/255.0
                                                       green:223.0/255.0
                                                        blue:223.0/255.0
                                                       alpha:0.8] CGColor]];
            [b.layer setBorderWidth:1.f];
            if (![Globals sharedManager].runningOniPad) {
                b.titleLabel.font= [UIFont systemFontOfSize:17.0/2];
            }
            
            [b addTarget:nil action:@selector(clickTopButton:) forControlEvents:UIControlEventTouchUpInside];
            b.tag = item.thumbID;
            if (b.tag == currentHeadlineID) {
                [b setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:108.0/255 green:108.0/255 blue:108.0/255 alpha:0.8]] forState:UIControlStateHighlighted];
                b.backgroundColor = [UIColor colorWithRed:108.0/255 green:108.0/255 blue:108.0/255 alpha:0.8];
                b.alpha = 0.8;
            }
            b.alpha = 0.0;
            [arrayButton2 addObject:b];
            [scrollView1 addSubview:b];
            
            [UIView animateWithDuration:0.2 animations:^{
                b.alpha = 0.8;
            }];
            
        }
    }
}
-(void)loadThumbViewForBack {
    [self setPositonAndFrame];
    
    scrollView1.contentSize = CGSizeMake((headlinePadding + headlineImageWidth)*[arrCurrentHeadlines count] + topHeadlinePadding, screenSize.height - 48);
    
    for (int i= 0; i<[arrCurrentHeadlines count]; i++) {
        CGRect frame = CGRectMake(topHeadlinePadding +i*(headlinePadding+ headlineImageWidth) , headlineImageY, headlineImageWidth, headlineImageHeigh);
        
        
        ThumView *thumb = [[ThumView alloc]initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height)];
        ThumbItem *item = [arrCurrentHeadlines objectAtIndex:i];
        thumb.item = item;
        [thumb loadImageForThumb];
        [thumb.layer setBorderWidth:1.0];
        [thumb.layer setBorderColor:[[UIColor colorWithRed:223.0/255.0
                                                     green:223.0/255.0
                                                      blue:223.0/255.0
                                                     alpha:0.8] CGColor]];
        thumb.backgroundColor = [UIColor whiteColor];
        thumb.alpha = 1.0;
        maskBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        maskBtn.backgroundColor = [UIColor clearColor];
        [maskBtn addTarget:self action:@selector(maskBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
        maskBtn.frame = thumb.bounds;
        maskBtn.tag = item.thumbID;
        [thumb addSubview:maskBtn];
        [arrayThumb addObject:thumb];
        
        
        
        
        //when button animating 2/3 path, start animating to display thumbview
        
        CGRect frameTop= CGRectMake(topHeadlinePadding +i*(topHeadlinePadding+topHeadlineWidth) , topHeadlineY, topHeadlineWidth, topHeadlineHeigh);
        CGRect frameTop1= CGRectMake(topHeadlinePadding +i*(topHeadlinePadding+topHeadlineWidth) , topHeadlineY-headlineImageHeigh/2, topHeadlineWidth, headlineImageHeigh/2 +1);
        CGPoint buttonTopPoint = CGPointMake(frameTop.origin.x + frameTop.size.width/2, frameTop.origin.y+frameTop.size.height/2);
        
        CGPoint thumbTopPoint = CGPointMake(frameTop1.origin.x + frameTop1.size.width/2, frameTop1.origin.y+frameTop1.size.height/2);
        [scrollView1 addSubview:thumb];
        UIBezierPath *movePath1 = [UIBezierPath bezierPath];
        [movePath1 moveToPoint:thumbTopPoint];
        
        [movePath1 addLineToPoint:thumb.center];
        CAKeyframeAnimation *moveAnim1 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        moveAnim1.path = movePath1.CGPath;
        moveAnim1.removedOnCompletion = YES;
        
        CABasicAnimation *scaleAnim1 = [CABasicAnimation animationWithKeyPath:@"transform"];
        
        scaleAnim1.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5, 0.5, 1.0)];
        scaleAnim1.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
        scaleAnim1.removedOnCompletion = YES;
        
        CABasicAnimation *opacityAnim1 = [CABasicAnimation animationWithKeyPath:@"opacity"];
        opacityAnim1.fromValue = [NSNumber numberWithFloat:0.0];
        opacityAnim1.toValue = [NSNumber numberWithFloat:1.0];
        opacityAnim1.removedOnCompletion = YES;
        
        CAAnimationGroup *animGroup1 = [CAAnimationGroup animation];
        animGroup1.animations = [NSArray arrayWithObjects:moveAnim1, scaleAnim1, opacityAnim1, nil];
        animGroup1.duration = 0.4;
        //        [animGroup1 setDelegate:self];
        [thumb.layer addAnimation:animGroup1 forKey:nil];
        
        
        UIButton *descriptionView = [[UIButton alloc] initWithFrame:CGRectMake(thumb.frame.origin.x,
                                                                               thumb.frame.origin.y + headlineImageHeigh+headlineTitleHeigh,
                                                                               headlineImageWidth,
                                                                               headlineDescriptionHeigh)];
        descriptionView.titleLabel.textColor = [UIColor whiteColor];
        [descriptionView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [descriptionView setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [descriptionView setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:108.0/255 green:108.0/255 blue:108.0/255 alpha:0.8]] forState:UIControlStateHighlighted];
        //        [descriptionView setTitleColor:[UIColor colorWithRed:99.0/255 green:99.0/255 blue:99.0/255 alpha:1.0] forState:UIControlStateHighlighted];
        [descriptionView setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [descriptionView addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        descriptionView.tag = item.thumbID;
        [[descriptionView layer] setBorderColor:[[UIColor colorWithRed:223.0/255.0
                                                                 green:223.0/255.0
                                                                  blue:223.0/255.0
                                                                 alpha:0.8] CGColor]];
        
        descriptionView.backgroundColor = [UIColor colorWithRed:60.0/255 green:60.0/255 blue:60.0/255 alpha:0.8];
        descriptionView.alpha = 0.8;
        NSString *textDes = @"There are many variations of passages of Lorem Ipsum avaiable";
        [descriptionView setTitle:textDes forState:UIControlStateNormal];
        descriptionView.titleLabel.textAlignment = NSTextAlignmentCenter;;
        descriptionView.titleLabel.numberOfLines = 2;
        descriptionView.titleLabel.font = [UIFont systemFontOfSize:17.0];
        if (![Globals sharedManager].runningOniPad) {
            descriptionView.titleLabel.font= [UIFont systemFontOfSize:17.0/2];
        }
        descriptionView.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [descriptionView.layer setBorderWidth:1.f];
        [arrayDescription addObject:descriptionView];
        [scrollView1 addSubview:descriptionView];
        
        
        CGPoint descTopPoint = CGPointMake(buttonTopPoint.x, buttonTopPoint.y+ (headlineTitleHeigh + headlineDescriptionHeigh)*0.5/2);
        
        UIBezierPath *movePath2 = [UIBezierPath bezierPath];
        [movePath2 moveToPoint:descTopPoint];
        
        [movePath2 addLineToPoint:descriptionView.center];
        CAKeyframeAnimation *moveAnim2 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        moveAnim2.path = movePath2.CGPath;
        moveAnim2.removedOnCompletion = YES;
        
        CABasicAnimation *scaleAnim2 = [CABasicAnimation animationWithKeyPath:@"transform"];
        
        scaleAnim2.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5, 0.5, 1.0)];
        scaleAnim2.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
        scaleAnim2.removedOnCompletion = YES;
        
        CABasicAnimation *opacityAnim2 = [CABasicAnimation animationWithKeyPath:@"opacity"];
        opacityAnim2.fromValue = [NSNumber numberWithFloat:0.0];
        opacityAnim2.toValue = [NSNumber numberWithFloat:1.0];
        opacityAnim2.removedOnCompletion = YES;
        
        CAAnimationGroup *animGroup2 = [CAAnimationGroup animation];
        animGroup2.animations = [NSArray arrayWithObjects:moveAnim2, scaleAnim2, opacityAnim2, nil];
        animGroup2.duration = 0.4;
        //        [animGroup1 setDelegate:self];
        [descriptionView.layer addAnimation:animGroup2 forKey:nil];
        
    }
}

-(void)loadScrollViewForHeadLineID:(NSInteger)headLineID{
    [self setPositonAndFrame];
    [self loadCurrentHeadlines:headLineID];
    [self loadPreviousHeadlines:headLineID];
    for (UIButton *b in arrayButton3) {
        [b removeFromSuperview];
    }
    [arrayButton3 removeAllObjects];
    
    scrollView1.contentSize = CGSizeMake((headlinePadding + headlineImageWidth)*[arrCurrentHeadlines count] +headlinePadding, screenSize.height - 48);
    
    
    
    for (int i= 0; i<[arrCurrentHeadlines count]; i++) {
        CGRect frame = CGRectMake(topHeadlinePadding +i*(headlinePadding+ headlineImageWidth) , headlineImageY, headlineImageWidth, headlineImageHeigh);
        
        UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
        ThumbItem *item = [arrCurrentHeadlines objectAtIndex:i];
        [b setTitle:item.thumbTitle forState:UIControlStateNormal];
        CGRect btnFrame = CGRectMake(frame.origin.x, frame.origin.y+headlineImageHeigh, frame.size.width, headlineTitleHeigh + 2);
        b.frame = btnFrame;
        [b setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:108.0/255 green:108.0/255 blue:108.0/255 alpha:0.8]] forState:UIControlStateHighlighted];
        b.backgroundColor = [UIColor colorWithRed:60.0/255 green:60.0/255 blue:60.0/255 alpha:0.8];
        b.alpha = 0.8;
        [[b layer] setBorderColor:[[UIColor colorWithRed:223.0/255.0
                                                   green:223.0/255.0
                                                    blue:223.0/255.0
                                                   alpha:0.8] CGColor]];
        [b.layer setBorderWidth:1.f];
        [arrayButton3 addObject:b];
        
        b.titleLabel.font= [UIFont systemFontOfSize:34];
        if (![Globals sharedManager].runningOniPad) {
            b.titleLabel.font= [UIFont systemFontOfSize:17];
        }
        [b setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [b setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [b setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [b addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        
        b.tag = item.thumbID;
        [scrollView1 addSubview:b];
        
        
        CGRect bottomFrame =CGRectMake(topHeadlinePadding +i*(topHeadlinePadding+topHeadlineWidth) , topHeadlineY +2*(headlineImageY- topHeadlineY + headlineImageHeigh), topHeadlineWidth, topHeadlineHeigh);
        CGPoint bottomPoint = CGPointMake(bottomFrame.origin.x + bottomFrame.size.width/2, bottomFrame.origin.y +bottomFrame.size.height/2);
        
        
        CGPoint btnCenter = b.center;
        
        
        UIBezierPath *movePath = [UIBezierPath bezierPath];
        [movePath moveToPoint:bottomPoint];
        
        [movePath addLineToPoint:btnCenter];
        CAKeyframeAnimation *moveAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        moveAnim.path = movePath.CGPath;
        moveAnim.removedOnCompletion = YES;
        
        CABasicAnimation *scaleAnim = [CABasicAnimation animationWithKeyPath:@"transform"];
        scaleAnim.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5, 0.5, 1.0)];
        scaleAnim.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
        scaleAnim.removedOnCompletion = YES;
        
        CABasicAnimation *opacityAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
        opacityAnim.fromValue = [NSNumber numberWithFloat:1.0];
        opacityAnim.toValue = [NSNumber numberWithFloat:1.0];
        opacityAnim.removedOnCompletion = YES;
        
        CAAnimationGroup *animGroup = [CAAnimationGroup animation];
        animGroup.animations = [NSArray arrayWithObjects:moveAnim, scaleAnim, opacityAnim, nil];
        animGroup.duration = 0.45/2;
        [animGroup setValue:b forKey:@"step3"];
        isFinishStep3 = NO;
        [animGroup setDelegate:self];
        b.alpha =0.8;
        [b.layer addAnimation:animGroup forKey:nil];
        
        
        
        
    }
    [self loadThumViewsForCurrentHeadline];
}
-(void)loadThumViewsForCurrentHeadline{
    [self setPositonAndFrame];
    for (int i=0; i<[arrayThumb count]; i++) {
        ThumView *thumb = [arrayThumb objectAtIndex:i];
        [thumb removeFromSuperview];
        
        UIButton *b= [arrayDescription objectAtIndex:i];
        [b removeFromSuperview];
    }
    [arrayThumb removeAllObjects];
    [arrayDescription removeAllObjects];
    for (int i= 0; i<[arrCurrentHeadlines count]; i++) {
        CGRect frame = CGRectMake(topHeadlinePadding +i*(headlinePadding+ headlineImageWidth) , headlineImageY, headlineImageWidth, headlineImageHeigh);
        ThumView *thumb = [[ThumView alloc]initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height)];
        [thumb.layer setBorderWidth:1.0];
        [thumb.layer setBorderColor:[[UIColor colorWithRed:223.0/255.0
                                                     green:223.0/255.0
                                                      blue:223.0/255.0
                                                     alpha:0.8] CGColor]];
        ThumbItem *item = [arrCurrentHeadlines objectAtIndex:i];
        thumb.item = item;
        [thumb loadImageForThumb];
        thumb.backgroundColor = [UIColor whiteColor];
        // add button
        maskBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        maskBtn.backgroundColor = [UIColor clearColor];
        [maskBtn addTarget:self action:@selector(maskBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
        maskBtn.frame = thumb.bounds;
        maskBtn.tag = item.thumbID;
        [thumb addSubview:maskBtn];
        [arrayThumb addObject:thumb];
        [scrollView1 addSubview:thumb];
        
        //when button animating 2/3 path, start animating to display thumbview
        CGRect bottomFrame =CGRectMake(topHeadlinePadding +i*(topHeadlinePadding+topHeadlineWidth) , topHeadlineY +2*(headlineImageY- topHeadlineY + headlineImageHeigh), topHeadlineWidth, topHeadlineHeigh);
        CGPoint buttonPoint = CGPointMake(bottomFrame.origin.x + bottomFrame.size.width/2, (bottomFrame.origin.y +bottomFrame.size.height/2));
        
        CGPoint bottomPoint = CGPointMake(buttonPoint.x, buttonPoint.y-(headlineTitleHeigh+headlineImageHeigh)*0.5/2);
        
        UIBezierPath *movePath1 = [UIBezierPath bezierPath];
        [movePath1 moveToPoint:bottomPoint];
        
        [movePath1 addLineToPoint:thumb.center];
        CAKeyframeAnimation *moveAnim1 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        moveAnim1.path = movePath1.CGPath;
        moveAnim1.removedOnCompletion = YES;
        
        CABasicAnimation *scaleAnim1 = [CABasicAnimation animationWithKeyPath:@"transform"];
        
        scaleAnim1.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5, 0.5, 1.0)];
        scaleAnim1.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
        scaleAnim1.removedOnCompletion = YES;
        
        CABasicAnimation *opacityAnim1 = [CABasicAnimation animationWithKeyPath:@"opacity"];
        opacityAnim1.fromValue = [NSNumber numberWithFloat:0.0];
        opacityAnim1.toValue = [NSNumber numberWithFloat:1.0];
        opacityAnim1.removedOnCompletion = YES;
        
        CAAnimationGroup *animGroup1 = [CAAnimationGroup animation];
        animGroup1.animations = [NSArray arrayWithObjects:moveAnim1, scaleAnim1, opacityAnim1, nil];
        animGroup1.duration = 0.45/2;
        [thumb.layer addAnimation:animGroup1 forKey:nil];
        
        
        // load description view
        UIButton *descriptionView = [[UIButton alloc] initWithFrame:CGRectMake(thumb.frame.origin.x,
                                                                               thumb.frame.origin.y + headlineImageHeigh+headlineTitleHeigh,
                                                                               headlineImageWidth,
                                                                               headlineDescriptionHeigh)];
        descriptionView.titleLabel.textColor = [UIColor whiteColor];
        [descriptionView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [descriptionView setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [descriptionView setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:108.0/255 green:108.0/255 blue:108.0/255 alpha:0.8]] forState:UIControlStateHighlighted];
        [descriptionView setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [descriptionView addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        descriptionView.tag = item.thumbID;
        [[descriptionView layer] setBorderColor:[[UIColor colorWithRed:223.0/255.0
                                                                 green:223.0/255.0
                                                                  blue:223.0/255.0
                                                                 alpha:0.8] CGColor]];
        
        descriptionView.backgroundColor = [UIColor colorWithRed:60.0/255 green:60.0/255 blue:60.0/255 alpha:0.8];
        descriptionView.alpha = 0.8;
        NSString *textDes = @"There are many variations of passages of Lorem Ipsum avaiable";
        [descriptionView setTitle:textDes forState:UIControlStateNormal];
        descriptionView.titleLabel.textAlignment = NSTextAlignmentCenter;;
        descriptionView.titleLabel.numberOfLines = 2;
        descriptionView.titleLabel.font = [UIFont systemFontOfSize:17.0];
        if (![Globals sharedManager].runningOniPad) {
            descriptionView.titleLabel.font= [UIFont systemFontOfSize:17.0/2];
        }
        descriptionView.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [descriptionView.layer setBorderWidth:1.f];
        [arrayDescription addObject:descriptionView];
        [scrollView1 addSubview:descriptionView];
        
        
        CGPoint bottomPoint2 = CGPointMake(buttonPoint.x, buttonPoint.y+(headlineTitleHeigh+headlineDescriptionHeigh)*0.5/2);
        
        UIBezierPath *movePath2 = [UIBezierPath bezierPath];
        [movePath2 moveToPoint:bottomPoint2];
        
        [movePath2 addLineToPoint:descriptionView.center];
        CAKeyframeAnimation *moveAnim2 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        moveAnim2.path = movePath2.CGPath;
        moveAnim2.removedOnCompletion = YES;
        
        CABasicAnimation *scaleAnim2 = [CABasicAnimation animationWithKeyPath:@"transform"];
        
        scaleAnim2.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5, 0.5, 1.0)];
        scaleAnim2.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
        scaleAnim2.removedOnCompletion = YES;
        
        CABasicAnimation *opacityAnim2 = [CABasicAnimation animationWithKeyPath:@"opacity"];
        opacityAnim2.fromValue = [NSNumber numberWithFloat:0.0];
        opacityAnim2.toValue = [NSNumber numberWithFloat:1.0];
        opacityAnim2.removedOnCompletion = YES;
        
        CAAnimationGroup *animGroup2 = [CAAnimationGroup animation];
        animGroup2.animations = [NSArray arrayWithObjects:moveAnim2, scaleAnim2, opacityAnim2, nil];
        animGroup2.duration = 0.45/2;
        [descriptionView.layer addAnimation:animGroup2 forKey:nil];
        
    }
    
    
}
-(void)loadTopButtonForHeadline:(NSInteger)headlineID{
    [self setPositonAndFrame];
    [self loadPreviousHeadlines:headlineID];
    [arrayButton3 removeAllObjects];
    scrollView1.contentSize = CGSizeMake((headlinePadding + headlineImageWidth)*[arrCurrentHeadlines count] + topHeadlinePadding, screenSize.height - 48);
    for (int i= 0; i<[arrPreviousHeadlines count]; i++) {
        CGRect frame = CGRectMake(topHeadlinePadding +i*(topHeadlinePadding+topHeadlineWidth) , topHeadlineY, topHeadlineWidth, topHeadlineHeigh);
        
        UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
        ThumbItem *item = [arrPreviousHeadlines objectAtIndex:i];
        [b setTitle:item.thumbTitle forState:UIControlStateNormal];
        b.frame = frame;
        b.backgroundColor = [UIColor colorWithRed:108.0/255 green:108.0/255 blue:108.0/255 alpha:0.8];
        b.alpha = 0.8;
        b.hidden = YES;
    }
}
-(void)loadCurrentHeadlines:(NSInteger)headLineID{
    [arrCurrentHeadlines removeAllObjects];
    switch (headLineID) {
            
            //first level
        case 0:
            for (int i=0; i<5; i++) {
                ThumbItem *item = [[ThumbItem alloc]init];
                item.thumbID = i+1;
                item.thumbTitle = [NSString stringWithFormat:@"Headline %d",i+1];
                item.imgName = [NSString stringWithFormat:@"%d.png",i+1];
                [arrCurrentHeadlines addObject:item];
            }
            //            [arrCurrentHeadlines addObject:@"Headline 1"];
            //            [arrCurrentHeadlines addObject:@"Headline 2"];
            //            [arrCurrentHeadlines addObject:@"Headline 3"];
            //            [arrCurrentHeadlines addObject:@"Headline 4"];
            //            [arrCurrentHeadlines addObject:@"Headline 5"];
            break;
            
            //second level
        case 1:
            for (int i=5; i<11; i++) {
                ThumbItem *item = [[ThumbItem alloc]init];
                item.thumbID = i+1;
                item.thumbTitle = [NSString stringWithFormat:@"Headline 1%d",i+1-5];
                item.imgName = [NSString stringWithFormat:@"%d.png",i+1];
                [arrCurrentHeadlines addObject:item];
            }
            //            [arrCurrentHeadlines addObject:@"Headline 11"];
            //            [arrCurrentHeadlines addObject:@"Headline 12"];
            //            [arrCurrentHeadlines addObject:@"Headline 13"];
            //            [arrCurrentHeadlines addObject:@"Headline 14"];
            //            [arrCurrentHeadlines addObject:@"Headline 15"];
            //            [arrCurrentHeadlines addObject:@"Headline 16"];
            break;
            
        case 2:
            for (int i=11; i<14; i++) {
                ThumbItem *item = [[ThumbItem alloc]init];
                item.thumbID = i+1;
                item.thumbTitle = [NSString stringWithFormat:@"Headline 2%d",i+1-11];
                item.imgName = [NSString stringWithFormat:@"%d.png",i+1-10];
                [arrCurrentHeadlines addObject:item];
            }
            //            [arrCurrentHeadlines addObject:@"Headline 21"];
            //            [arrCurrentHeadlines addObject:@"Headline 22"];
            //            [arrCurrentHeadlines addObject:@"Headline 23"];
            break;
            
        case 3:
            for (int i=14; i<20; i++) {
                ThumbItem *item = [[ThumbItem alloc]init];
                item.thumbID = i+1;
                item.thumbTitle = [NSString stringWithFormat:@"Headline 3%d",i+1-14];
                item.imgName = [NSString stringWithFormat:@"%d.png",i+1-10];
                [arrCurrentHeadlines addObject:item];
            }
            
            //            [arrCurrentHeadlines addObject:@"Headline 31"];
            //            [arrCurrentHeadlines addObject:@"Headline 32"];
            //            [arrCurrentHeadlines addObject:@"Headline 33"];
            //            [arrCurrentHeadlines addObject:@"Headline 34"];
            //            [arrCurrentHeadlines addObject:@"Headline 35"];
            break;
            
        case 4:
            
            for (int i=20; i<26; i++) {
                ThumbItem *item = [[ThumbItem alloc]init];
                item.thumbID = i+1;
                item.thumbTitle = [NSString stringWithFormat:@"Headline 4%d",i+1-20];
                item.imgName = [NSString stringWithFormat:@"%d.png",i+1-20];
                [arrCurrentHeadlines addObject:item];
            }
            
            
            //            [arrCurrentHeadlines addObject:@"Headline 41"];
            //            [arrCurrentHeadlines addObject:@"Headline 42"];
            //            [arrCurrentHeadlines addObject:@"Headline 43"];
            //            [arrCurrentHeadlines addObject:@"Headline 44"];
            //            [arrCurrentHeadlines addObject:@"Headline 45"];
            break;
            
        case 5:
            for (int i=26; i<32; i++) {
                ThumbItem *item = [[ThumbItem alloc]init];
                item.thumbID = i+1;
                item.thumbTitle = [NSString stringWithFormat:@"Headline 5%d",i+1-26];
                item.imgName = [NSString stringWithFormat:@"%d.png",i+1-24];
                [arrCurrentHeadlines addObject:item];
            }
            
            
            //            [arrCurrentHeadlines addObject:@"Headline 51"];
            //            [arrCurrentHeadlines addObject:@"Headline 52"];
            //            [arrCurrentHeadlines addObject:@"Headline 53"];
            //            [arrCurrentHeadlines addObject:@"Headline 54"];
            //            [arrCurrentHeadlines addObject:@"Headline 55"];
            break;
            
            //third level
        case 6:
            for (int i=32; i<36; i++) {
                ThumbItem *item = [[ThumbItem alloc]init];
                item.thumbID = i+1;
                item.thumbTitle = [NSString stringWithFormat:@"Headline 11%d",i+1-32];
                item.imgName = [NSString stringWithFormat:@"%d.png",i+1-30];
                [arrCurrentHeadlines addObject:item];
            }
            
            //            [arrCurrentHeadlines addObject:@"Headline 111"];
            //            [arrCurrentHeadlines addObject:@"Headline 112"];
            //            [arrCurrentHeadlines addObject:@"Headline 113"];
            //            [arrCurrentHeadlines addObject:@"Headline 114"];
            break;
            
        case 7:
            for (int i=36; i<38; i++) {
                ThumbItem *item = [[ThumbItem alloc]init];
                item.thumbID = i+1;
                item.thumbTitle = [NSString stringWithFormat:@"Headline 12%d",i+1-35];
                item.imgName = [NSString stringWithFormat:@"%d.png",i+1-35];
                [arrCurrentHeadlines addObject:item];
            }
            
            //            [arrCurrentHeadlines addObject:@"Headline 121"];
            //            [arrCurrentHeadlines addObject:@"Headline 112"];
            //            [arrCurrentHeadlines addObject:@"Headline 113"];
            //            [arrCurrentHeadlines addObject:@"Headline 114"];
            break;
            
        default:
            break;
    }
}
-(void)loadPreviousHeadlines:(NSInteger)headLineID{
    [arrPreviousHeadlines removeAllObjects];
    switch (headLineID) {
        case 6:
            for (int i=5; i<11; i++) {
                ThumbItem *item = [[ThumbItem alloc]init];
                item.thumbID = i+1;
                item.thumbTitle = [NSString stringWithFormat:@"Headline 1%d",i+1-5];
                [arrPreviousHeadlines addObject:item];
            }
            
            
            //            [arrPreviousHeadlines addObject:@"Headline 12"];
            //            [arrPreviousHeadlines addObject:@"Headline 13"];
            //            [arrPreviousHeadlines addObject:@"Headline 14"];
            //            [arrPreviousHeadlines addObject:@"Headline 15"];
            //            [arrPreviousHeadlines addObject:@"Headline 16"];
            break;
        case 7:
            for (int i=5; i<11; i++) {
                ThumbItem *item = [[ThumbItem alloc]init];
                item.thumbID = i+1;
                item.thumbTitle = [NSString stringWithFormat:@"Headline 1%d",i+1-5];
                [arrPreviousHeadlines addObject:item];
            }
            
            
            //            [arrPreviousHeadlines addObject:@"Headline 12"];
            //            [arrPreviousHeadlines addObject:@"Headline 13"];
            //            [arrPreviousHeadlines addObject:@"Headline 14"];
            //            [arrPreviousHeadlines addObject:@"Headline 15"];
            //            [arrPreviousHeadlines addObject:@"Headline 16"];
            break;
            
        default:
            for (int i=0; i<5; i++) {
                ThumbItem *item = [[ThumbItem alloc]init];
                item.thumbID = i+1;
                item.thumbTitle = [NSString stringWithFormat:@"Headline %d",i+1];
                [arrPreviousHeadlines addObject:item];
            }
            //            [arrPreviousHeadlines addObject:@"Headline 1"];
            //            [arrPreviousHeadlines addObject:@"Headline 2"];
            //            [arrPreviousHeadlines addObject:@"Headline 3"];
            //            [arrPreviousHeadlines addObject:@"Headline 4"];
            //            [arrPreviousHeadlines addObject:@"Headline 5"];
            break;
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) hideCoverView:(BOOL) isHidden {
    if (isHidden) {
        UIInterfaceOrientation interfaceOrientation = [UIApplication sharedApplication].statusBarOrientation;
        if(UIInterfaceOrientationIsPortrait(interfaceOrientation)){
            if (IS_IPHONE6_PLUS || IS_IPHONE6) {
                imgBackground.image= [UIImage imageNamed:@"title_background-568h_p@2x~iphone.jpg"];
            }
            else if (IS_IPHONE_5)
            {
                imgBackground.image= [UIImage imageNamed:@"title_background_p@2x~iphone.jpg"];
            }
            else if ([Globals sharedManager].runningOniPad)
            {
                imgBackground.image= [UIImage imageNamed:@"Default-Portrait~ipad.png"];
            }else
            {
                imgBackground.image= [UIImage imageNamed:@"title_background_p~iphone.jpg"];
            }
        }
        else
        {
            if (IS_IPHONE6_PLUS || IS_IPHONE6) {
                imgBackground.image= [UIImage imageNamed:@"title_background-568h_l@2x~iphone.jpg"];
            }
            else if (IS_IPHONE_5)
            {
                imgBackground.image= [UIImage imageNamed:@"title_background_l@2x~iphone.jpg"];
            }
            else if ([Globals sharedManager].runningOniPad)
            {
                imgBackground.image= [UIImage imageNamed:@"Default-Landscape~ipad.png"];
            }else
            {
                imgBackground.image= [UIImage imageNamed:@"title_background_l~iphone.jpg"];
            }
        }
        
        scrollView1.hidden = NO;
        bottomTabBarView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    }
    else {
        UIInterfaceOrientation interfaceOrientation = [UIApplication sharedApplication].statusBarOrientation;
        if(UIInterfaceOrientationIsPortrait(interfaceOrientation)){
            imgBackground.image = [UIImage imageNamed:@"ipad_p.png"];
        }
        else
        {
            imgBackground.image = [UIImage imageNamed:@"ipad_l.png"];
        }
        scrollView1.hidden = YES;
        bottomTabBarView.backgroundColor = [UIColor clearColor];
    }
}
-(ThumbItem *)thumbItemForID:(NSInteger)thumbID {
    for (int i = 0; i<[arrPreviousHeadlines count]; i++) {
        ThumbItem * item  = [arrPreviousHeadlines objectAtIndex:i];
        if (item.thumbID == thumbID) {
            return item;
        }
    }
    return nil;
}

@end