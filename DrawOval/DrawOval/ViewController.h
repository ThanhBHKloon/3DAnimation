//
//  ViewController.h
//  DrawOval
//
//  Created by Dinh Linh on 24/9/14.
//  Copyright (c) 2014 Dinh Linh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController{

    NSMutableArray *arrayHeadLineItem;
    NSMutableArray *arrayButton1;
    NSMutableArray *arrayButton2;
    NSMutableArray *arrayButton3;
    NSMutableArray *arrayThumb;
    NSMutableArray *arrayDescription;
    UIButton *btnBack;
    BOOL btnBackSelected;
    BOOL isFinishStep1;
    BOOL isFinishStep2;
    BOOL isFinishStep3;
    int animationType;
    
    BOOL isFinishAnimation;
    
    NSMutableArray *arrCurrentHeadlines;
    NSMutableArray *arrPreviousHeadlines;
    NSInteger currentHeadlineID;
    NSInteger previousHeadlineID;
    UIButton *maskBtn;
    NSMutableArray *arraySelectedID; // store selected headine ID in each level
    UIImageView *imgBackground;
    UIView *parentView;
    
    CGFloat topHeadlinePadding;
    CGFloat headlinePadding;
    CGFloat topHeadlineY;
    CGFloat topHeadlineWidth;
    CGFloat topHeadlineHeigh;
    
    CGFloat headlineImageY;
    CGFloat headlineImageWidth;
    CGFloat headlineImageHeigh;
    CGFloat headlineTitleHeigh;
    CGFloat headlineDescriptionHeigh;
    CGSize screenSize;
    
}



@end
