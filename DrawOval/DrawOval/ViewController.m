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
@interface ViewController ()

@end

@implementation ViewController
#define ANIMATION_UP_STEP1 1
#define ANIMATION_UP_STEP2 2
#define ANIMATION_FROM_BOTTOM 3
#define ANIMATION_DOWN 4
UIScrollView *scrollView1;
UIScrollView *scrollView2;
BottomTabBar *bottomTabBarView;
- (void)viewDidLoad
{
    [super viewDidLoad];
    arrayMiddleFrame = [[NSMutableArray alloc]init];
    arrayMiddlePoint = [[NSMutableArray alloc]init];
    arrCurrentHeadlines = [[NSMutableArray alloc]init];
    arrPreviousHeadlines = [[NSMutableArray alloc]init];
    arraySelectedID = [[NSMutableArray alloc]init];
    btnBackSelected = NO;
    arrayButton1 = [[NSMutableArray alloc]init];
    arrayButton2 = [[NSMutableArray alloc]init];
    arrayButton3 = [[NSMutableArray alloc]init];
    
    
    arrayThumb = [[NSMutableArray alloc]init];
    
    CGRect screenRect1 = [[UIScreen mainScreen] bounds];
    CGRect screenRect;
    
    UIInterfaceOrientation interfaceOrientation = [UIApplication sharedApplication].statusBarOrientation;
    if(UIInterfaceOrientationIsPortrait(interfaceOrientation)){
        screenRect = CGRectMake(0, 0, screenRect1.size.width, screenRect1.size.height);
    }
    else {
        screenRect = CGRectMake(0, 0, screenRect1.size.height, screenRect1.size.width);
    }
    scrollView1  = [[UIScrollView alloc]init];
    scrollView1.frame = CGRectMake(0, 0, screenRect.size.width, screenRect.size.height);
    scrollView1.backgroundColor = [UIColor grayColor];
    [self.view addSubview:scrollView1];
    
    
    btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    btnBack.backgroundColor =[UIColor grayColor];
    btnBack.center = CGPointMake(20, 10);
    [btnBack sizeToFit];
    [btnBack addTarget:self action:@selector(backButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [btnBack setImage:[UIImage imageNamed:@"button_back_unselected.png"] forState:UIControlStateNormal];
    
    
    CGRect frameBottomBar ;
    if(UIInterfaceOrientationIsPortrait(interfaceOrientation)){
        frameBottomBar = CGRectMake(0, self.view.frame.size.height - 48, self.view.frame.size.width, 48);
    }
    else {
        
        frameBottomBar = CGRectMake(0, self.view.frame.size.width - 48, self.view.frame.size.height, 48);
    }
    
    bottomTabBarView = [[BottomTabBar alloc] initWithFrame:frameBottomBar];
    bottomTabBarView.backgroundColor = [UIColor grayColor];
    [bottomTabBarView addSubview:btnBack];
    [self.view addSubview:bottomTabBarView];
    
    currentHeadlineID = 0;
    previousHeadlineID =0;
    [self loadScrollViewAtBegining];
    
    
}


-(void)clickTopButton:(id)sender{
    NSLog(@"click top button");
    UIButton *clickButton = sender;
    previousHeadlineID = currentHeadlineID;
    if (previousHeadlineID == clickButton.tag) {
        return;
    }
    
    for (int i=0; i<[arrayButton2 count]; i++) {
        UIButton *b = [arrayButton2 objectAtIndex:i];
        if (b.tag == previousHeadlineID) {
            b.backgroundColor = [UIColor colorWithRed:239.0/255 green:185.0/255 blue:88.0/255 alpha:1.0];
            break;
        }
    }
    
    
    currentHeadlineID = clickButton.tag;
    [arraySelectedID removeLastObject];
    [arraySelectedID addObject:[NSNumber numberWithInteger:currentHeadlineID]];
    NSLog(@"selected: %@",arraySelectedID);
    
    clickButton.backgroundColor = [UIColor redColor];
    [self loadScrollViewFadeInForHeadline:currentHeadlineID];
}

-(void)clickButton:(id)sender{
    isFinishStep1 = NO;
    isFinishStep2 = NO;
    
    [arrayMiddleFrame removeAllObjects];
    [arrayMiddlePoint removeAllObjects];
    btnBackSelected = NO;
    UIButton *clickButton = sender;
    
    
    [self loadCurrentHeadlines:clickButton.tag];
    
    
    if ([arrCurrentHeadlines count]==0) {
        return;
    }
    
    previousHeadlineID = currentHeadlineID;
    currentHeadlineID = clickButton.tag;
    [arraySelectedID addObject:[NSNumber numberWithInteger:currentHeadlineID]];
    NSLog(@"selected: %@",arraySelectedID);
    
    [arrayButton2 removeAllObjects];
    arrayButton2 = [arrayButton3 mutableCopy];
    [self loadTopButtonForHeadline:currentHeadlineID];
    [self loadScrollViewForHeadLineID:currentHeadlineID];
    clickButton.backgroundColor = [UIColor redColor];
    animationType = ANIMATION_UP_STEP1;
    CGFloat padding1 = 15;
    for (int i =0; i<[arrayButton2 count]; i++) {
        
        
        CGRect frameTop= CGRectMake(20 +i*(padding1+143) , 190, 143, 40);
        CGPoint topPoint = CGPointMake(frameTop.origin.x + frameTop.size.width/2, frameTop.origin.y+frameTop.size.height/2);
        
        //        UIButton *b1 = [arrayButton1 objectAtIndex:i];
        UIButton *b2 = [arrayButton2 objectAtIndex:i];
        [b2 removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
        [b2 addTarget:nil action:@selector(clickTopButton:) forControlEvents:UIControlEventTouchUpInside];
        ThumView *thumb = [arrayThumb objectAtIndex:i];
        thumb.alpha = 0.0;
        
        CGPoint middlePoint = b2.center;
        
        b2.center = topPoint;
        
        
        UIBezierPath *movePath = [UIBezierPath bezierPath];
        [movePath moveToPoint:middlePoint];
        //        [movePath addQuadCurveToPoint:middleButtonPoint
        //                         controlPoint:CGPointMake(b2.center.x, middleButtonPoint.y)];
        
        [movePath addLineToPoint:topPoint];
        CAKeyframeAnimation *moveAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        moveAnim.path = movePath.CGPath;
        moveAnim.removedOnCompletion = NO;
        
        CABasicAnimation *scaleAnim = [CABasicAnimation animationWithKeyPath:@"transform"];
        scaleAnim.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
        scaleAnim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5, 0.5, 1.0)];
        
        scaleAnim.removedOnCompletion = NO;
        
        CABasicAnimation *opacityAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
        opacityAnim.fromValue = [NSNumber numberWithFloat:1.0];
        opacityAnim.toValue = [NSNumber numberWithFloat:1.0];
        opacityAnim.removedOnCompletion = NO;
        
        CAAnimationGroup *animGroup = [CAAnimationGroup animation];
        animGroup.animations = [NSArray arrayWithObjects:moveAnim, scaleAnim, opacityAnim, nil];
        animGroup.duration = 1.5;
        [animGroup setValue:@"step1" forKey:@"step1"];
        [animGroup setDelegate:self];
        b2.alpha =1.0;
        [b2.layer addAnimation:animGroup forKey:nil];
        
        
        
        
        
        
        CGFloat middleY = 2*middlePoint.y/3 + topPoint.y/3;
        CGFloat middleX = (middleY*(middlePoint.x - topPoint.x) +(topPoint.x * middlePoint.y - middlePoint.x*topPoint.y))/(middlePoint.y - topPoint.y);
        
        
        CGPoint p1 = CGPointMake(middleX, middleY - 205/2*(1-1*(1-0.5)/3));
        
        UIBezierPath *movePath1 = [UIBezierPath bezierPath];
        CGPoint p2 = thumb.center;
        [movePath1 moveToPoint:p2];
        
        [movePath1 addLineToPoint:p1];
        CAKeyframeAnimation *moveAnim1 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        moveAnim1.path = movePath1.CGPath;
        moveAnim1.removedOnCompletion = NO;
        
        CABasicAnimation *scaleAnim1 = [CABasicAnimation animationWithKeyPath:@"transform"];
        scaleAnim1.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
        scaleAnim1.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1-0.5/3, 1-0.5/3, 1.0)];
        scaleAnim1.removedOnCompletion = NO;
        
        CABasicAnimation *opacityAnim1 = [CABasicAnimation animationWithKeyPath:@"opacity"];
        opacityAnim1.fromValue = [NSNumber numberWithFloat:0.3];
        opacityAnim1.toValue = [NSNumber numberWithFloat:0.0];
        opacityAnim1.removedOnCompletion = NO;
        
        CAAnimationGroup *animGroup1 = [CAAnimationGroup animation];
        animGroup1.animations = [NSArray arrayWithObjects:moveAnim1, scaleAnim1, opacityAnim1, nil];
        animGroup1.duration = 0.5;
        //        [animGroup1 setDelegate:self];
        thumb.alpha = 0;
        [thumb.layer addAnimation:animGroup1 forKey:nil];
        
    }
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    return YES;
    //    return NO;
}

- (BOOL) shouldAutorotate{
    return YES;
    
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                 duration:(NSTimeInterval)duration{
    CGRect screenRect1 = [[UIScreen mainScreen] bounds];
    CGRect screenRect,frameBottomBar;
    
    //    UIInterfaceOrientation interfaceOrientation = [UIApplication sharedApplication].statusBarOrientation;
    //    if(UIInterfaceOrientationIsPortrait(interfaceOrientation)){
    //        screenRect = CGRectMake(0, 0, screenRect1.size.height, screenRect1.size.width);
    //         frameBottomBar = CGRectMake(0, self.view.frame.size.width - 48, self.view.frame.size.height, 48);
    //    }
    //    else {
    //
    //        screenRect = CGRectMake(0, 0, screenRect1.size.width, screenRect1.size.height);
    //
    //
    //         frameBottomBar = CGRectMake(0, self.view.frame.size.height - 48, self.view.frame.size.width, 48);
    //    }
    
    screenRect = CGRectMake(0, 0, screenRect1.size.height, screenRect1.size.width);
    frameBottomBar = CGRectMake(0, self.view.frame.size.width - 48, self.view.frame.size.height, 48);
    bottomTabBarView.frame= frameBottomBar;
    scrollView1.frame = CGRectMake(0, 100, screenRect.size.width, 550);
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    //
    if ([anim valueForKey:@"step1"]) {
        if (isFinishStep1) {
            
            return;
        }
        isFinishStep1 = YES;
        for (int i= 0; i<[arrayButton2 count]; i++) {
            UIButton *b1 = [arrayButton2 objectAtIndex:i];
            CGPoint topCenter = b1.center;
            b1.frame = CGRectMake(b1.frame.origin.x, b1.frame.origin.y, b1.frame.size.width *0.5, b1.frame.size.height*0.5);
            b1.titleLabel.font = [UIFont systemFontOfSize:23*0.5];
            b1.center = topCenter;
            b1.hidden = NO;
            
        }
        
    }
    if ([[anim valueForKey:@"step2"] isEqualToString:@"step2"]) {
        if (isFinishStep2 ) {
            return;
        }
        isFinishStep2 = YES;
        for (int i= 0; i<[arrayButton1 count]; i++) {
            UIButton *b1 = [arrayButton1 objectAtIndex:i];
            
            b1.hidden = NO;
            
        }
        for (int i= 0; i<[arrayButton2 count]; i++) {
            
            UIButton *b2 = [arrayButton2 objectAtIndex:i];
            b2.alpha = 0.0;
            [b2 removeFromSuperview];
        }
        animationType = 0;
    }
    
    if ([anim valueForKey:@"step3"]) {
        if (isFinishStep3) {
            return;
        }
        for (int i= 0; i<[arrCurrentHeadlines count]; i++){
            
            ThumView *thumb = [arrayThumb objectAtIndex:i];
            
            thumb.alpha = 1.0;
            
            
            isFinishStep3 = YES;
        }
    }
    
}

-(void)backButton:(id)sender{
    if (currentHeadlineID ==0) {
        return;
    }
    [arraySelectedID removeLastObject];
    if ([arraySelectedID count]>0) {
        currentHeadlineID = [[arraySelectedID lastObject] integerValue];
        
    }
    else {
        currentHeadlineID = 0;
    }
    [self loadScrollViewBackToHeadLineID:currentHeadlineID];
}
-(void)loadScrollViewAtBegining{
    currentHeadlineID = 0;
    [self loadCurrentHeadlines:currentHeadlineID];
    [self loadPreviousHeadlines:currentHeadlineID];
    
    for (UIButton *b in arrayButton3) {
        [b removeFromSuperview];
    }
    [arrayButton3 removeAllObjects];
    CGFloat padding = 30;
    scrollView1.contentSize = CGSizeMake((padding + 286)*[arrCurrentHeadlines count] +padding, 300);
    
    
    
    for (int i= 0; i<[arrCurrentHeadlines count]; i++) {
        CGRect frame = CGRectMake(20 +i*(padding+ 286) , 290, 286, 136);
        
        UIButton *b = [UIButton buttonWithType:UIButtonTypeSystem];
        ThumbItem *item = [arrCurrentHeadlines objectAtIndex:i];
        [b setTitle:item.thumbTitle forState:UIControlStateNormal];
        CGRect btnFrame = CGRectMake(frame.origin.x, frame.origin.y+130, frame.size.width, 75);
        b.frame = btnFrame;
        b.backgroundColor = [UIColor colorWithRed:239.0/255 green:185.0/255 blue:88.0/255 alpha:1.0];
        [arrayButton3 addObject:b];
        //        if (currentHeadlineID ==0) {
        //            [arrayButton2 addObject:b];
        //        }
        b.titleLabel.font= [UIFont systemFontOfSize:23];
        [b addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        b.tag = item.thumbID;
        [scrollView1 addSubview:b];
        
        
        ThumView *thumb = [[ThumView alloc]initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height)];
        
        thumb.backgroundColor = [UIColor whiteColor];
        thumb.alpha = 1.0;
        [arrayThumb addObject:thumb];
        [scrollView1 addSubview:thumb];
        
        
        
    }
    
}

-(void)loadScrollViewFadeInForHeadline:(NSInteger)headlineID{
    [self loadCurrentHeadlines:headlineID];
    [self loadPreviousHeadlines:headlineID];
    
    // remove all button and thubmview at current level
    for (int i =0; i<[arrayButton3 count]; i++) {
        UIButton *b= [arrayButton3 objectAtIndex:i];
        [b removeFromSuperview];
        
        ThumView *thumb = [arrayThumb objectAtIndex:i];
        [thumb removeFromSuperview];
    }
    [arrayButton3 removeAllObjects];
    [arrayThumb removeAllObjects];
    
    CGFloat padding = 30;
    scrollView1.contentSize = CGSizeMake((padding + 286)*[arrCurrentHeadlines count] +padding, 300);
    
    
    
    for (int i= 0; i<[arrCurrentHeadlines count]; i++) {
        CGRect frame = CGRectMake(20 +i*(padding+ 286) , 290, 286, 136);
        
        UIButton *b = [UIButton buttonWithType:UIButtonTypeSystem];
        ThumbItem *item = [arrCurrentHeadlines objectAtIndex:i];
        [b setTitle:item.thumbTitle forState:UIControlStateNormal];
        CGRect btnFrame = CGRectMake(frame.origin.x, frame.origin.y+130, frame.size.width, 75);
        b.frame = btnFrame;
        b.backgroundColor = [UIColor colorWithRed:239.0/255 green:185.0/255 blue:88.0/255 alpha:1.0];
        [arrayButton3 addObject:b];
        //        if (currentHeadlineID ==0) {
        //            [arrayButton2 addObject:b];
        //        }
        b.titleLabel.font= [UIFont systemFontOfSize:23];
        [b addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        b.tag = item.thumbID;
        b.alpha = 0.1;
        [scrollView1 addSubview:b];
        
        
        ThumView *thumb = [[ThumView alloc]initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height)];
        
        thumb.backgroundColor = [UIColor whiteColor];
        thumb.alpha = 0.1;
        [arrayThumb addObject:thumb];
        [scrollView1 addSubview:thumb];
        
        [UIView animateWithDuration:1.0 animations:^{
            thumb.alpha = 1.0;
            b.alpha = 1.0;
        }];
        
        //        [UIView animateWithDuration:1.f delay:0.f options:UIViewAnimationOptionCurveEaseIn animations:^{
        //            thumb.alpha = 1.0;
        //            b.alpha = 1.0;
        //        } completion:nil];
        
    }
    
}
-(void)loadScrollViewBackToHeadLineID:(NSInteger)headlineID{
    CGFloat padding1 = 15;
    CGFloat padding = 30;
    [self loadCurrentHeadlines:headlineID];
    [self loadPreviousHeadlines:headlineID];
    
    // remove all button and thubmview at current level
    [scrollView1.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [arrayButton3 removeAllObjects];
    [arrayThumb removeAllObjects];
    [arrayButton2 removeAllObjects];
    
    // add top buttons
    
    
    
    
    if ([arraySelectedID count] >0) {
        for (int i =0; i<[arrPreviousHeadlines count]; i++) {
            
            CGRect frameTopBG= CGRectMake(20 +i*(padding1+143) , 190, 143, 40);
            CGRect frameTop= CGRectMake(3 , 3, 137, 34);
            //        CGPoint topPoint = CGPointMake(frameTop.origin.x + frameTop.size.width/2, frameTop.origin.y+frameTop.size.height/2);
            
            UIView *buttonsBackground = [[UIView alloc] initWithFrame:frameTopBG];
            buttonsBackground.backgroundColor = [UIColor whiteColor];
            
            UIButton *b = [UIButton buttonWithType:UIButtonTypeSystem];
            ThumbItem *item = [arrPreviousHeadlines objectAtIndex:i];
            [b setTitle:item.thumbTitle forState:UIControlStateNormal];
            b.frame = frameTop;
            b.backgroundColor = [UIColor colorWithRed:239.0/255 green:185.0/255 blue:88.0/255 alpha:1.0];
            
            [b addTarget:nil action:@selector(clickTopButton:) forControlEvents:UIControlEventTouchUpInside];
            b.tag = item.thumbID;
            if (b.tag == currentHeadlineID) {
                b.backgroundColor = [UIColor redColor];
            }
            b.alpha = 0.0;
            buttonsBackground.alpha = 0.0;
            [arrayButton2 addObject:b];
            [buttonsBackground addSubview:b];
            [scrollView1 addSubview:buttonsBackground];
            
            [UIView animateWithDuration:1.5 animations:^{
                b.alpha = 1.0;
                buttonsBackground.alpha = 1.0;
            }];
            
        }
    }
    
    
    
    //end
    
    
    scrollView1.contentSize = CGSizeMake((padding + 286)*[arrCurrentHeadlines count] +padding, 300);
    
    
    
    for (int i= 0; i<[arrCurrentHeadlines count]; i++) {
        CGRect frame = CGRectMake(20 +i*(padding+ 286) , 290, 286, 136);
        
        UIButton *b = [UIButton buttonWithType:UIButtonTypeSystem];
        ThumbItem *item = [arrCurrentHeadlines objectAtIndex:i];
        [b setTitle:item.thumbTitle forState:UIControlStateNormal];
        CGRect btnFrame = CGRectMake(frame.origin.x, frame.origin.y+130, frame.size.width, 75);
        b.frame = btnFrame;
        b.backgroundColor = [UIColor colorWithRed:239.0/255 green:185.0/255 blue:88.0/255 alpha:1.0];
        [arrayButton3 addObject:b];
        //        if (currentHeadlineID ==0) {
        //            [arrayButton2 addObject:b];
        //        }
        b.titleLabel.font= [UIFont systemFontOfSize:23];
        [b addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        b.tag = item.thumbID;
        b.alpha = 1.0;
        [scrollView1 addSubview:b];
        
        CGRect frameTop= CGRectMake(20 +i*(padding+143) , 190, 143, 40);
        CGPoint topPoint = CGPointMake(frameTop.origin.x + frameTop.size.width/2, frameTop.origin.y+frameTop.size.height/2);
        UIBezierPath *movePath = [UIBezierPath bezierPath];
        [movePath moveToPoint:topPoint];
        //        [movePath addQuadCurveToPoint:middleButtonPoint
        //                         controlPoint:CGPointMake(b2.center.x, middleButtonPoint.y)];
        
        [movePath addLineToPoint:b.center];
        CAKeyframeAnimation *moveAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        moveAnim.path = movePath.CGPath;
        moveAnim.removedOnCompletion = NO;
        
        CABasicAnimation *scaleAnim = [CABasicAnimation animationWithKeyPath:@"transform"];
        scaleAnim.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
        scaleAnim.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5, 0.5, 1.0)];
        
        scaleAnim.removedOnCompletion = NO;
        
        CABasicAnimation *opacityAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
        opacityAnim.fromValue = [NSNumber numberWithFloat:1.0];
        opacityAnim.toValue = [NSNumber numberWithFloat:1.0];
        opacityAnim.removedOnCompletion = NO;
        
        CAAnimationGroup *animGroup = [CAAnimationGroup animation];
        animGroup.animations = [NSArray arrayWithObjects:moveAnim, scaleAnim, opacityAnim, nil];
        animGroup.duration = 1.5;
        //        [animGroup setValue:@"step1" forKey:@"step1"];
        //        [animGroup setDelegate:self];
        b.alpha =1.0;
        [b.layer addAnimation:animGroup forKey:nil];
        
        
        
        
        
        //        ThumView *thumb = [[ThumView alloc]initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height)];
        //
        //        thumb.backgroundColor = [UIColor whiteColor];
        //        thumb.alpha = 1.0;
        //        [arrayThumb addObject:thumb];
        //        [scrollView1 addSubview:thumb];
        
        
    }
    [self performSelector:@selector(loadThumbViewForBack) withObject:nil afterDelay:1.0];
}
-(void)loadThumbViewForBack {
    CGFloat padding = 30;
    for (int i= 0; i<[arrCurrentHeadlines count]; i++) {
        CGRect frame = CGRectMake(20 +i*(padding+ 286) , 290, 286, 136);
        
        
        ThumView *thumb = [[ThumView alloc]initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height)];
        
        thumb.backgroundColor = [UIColor whiteColor];
        thumb.alpha = 1.0;
        [arrayThumb addObject:thumb];
        [scrollView1 addSubview:thumb];
        
        
        
        //when button animating 2/3 path, start animating to display thumbview
        
        CGRect frameTop= CGRectMake(20 +i*(padding+143) , 190, 143, 40);
        CGPoint buttonTopPoint = CGPointMake(frameTop.origin.x + frameTop.size.width/2, frameTop.origin.y+frameTop.size.height/2);
        
        CGPoint thumbTopPoint = CGPointMake(buttonTopPoint.x, buttonTopPoint.y-205*0.5/2);
        CGPoint bottomPoint = thumb.center;
        
        
        CGFloat middleY = 2*bottomPoint.y/3 + thumbTopPoint.y/3;
        CGFloat middleX = (middleY*(bottomPoint.x - thumbTopPoint.x) +(thumbTopPoint.x * bottomPoint.y - bottomPoint.x*thumbTopPoint.y))/(bottomPoint.y - thumbTopPoint.y);
        
        
        CGPoint middlePoint = CGPointMake(middleX, middleY);
        
        
        
        UIBezierPath *movePath1 = [UIBezierPath bezierPath];
        [movePath1 moveToPoint:middlePoint];
        
        [movePath1 addLineToPoint:thumb.center];
        CAKeyframeAnimation *moveAnim1 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        moveAnim1.path = movePath1.CGPath;
        moveAnim1.removedOnCompletion = NO;
        
        CABasicAnimation *scaleAnim1 = [CABasicAnimation animationWithKeyPath:@"transform"];
        
        scaleAnim1.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1-0.5/3, 1-0.5/3, 1.0)];
        scaleAnim1.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
        scaleAnim1.removedOnCompletion = NO;
        
        CABasicAnimation *opacityAnim1 = [CABasicAnimation animationWithKeyPath:@"opacity"];
        opacityAnim1.fromValue = [NSNumber numberWithFloat:0.0];
        opacityAnim1.toValue = [NSNumber numberWithFloat:1.0];
        opacityAnim1.removedOnCompletion = NO;
        
        CAAnimationGroup *animGroup1 = [CAAnimationGroup animation];
        animGroup1.animations = [NSArray arrayWithObjects:moveAnim1, scaleAnim1, opacityAnim1, nil];
        animGroup1.duration = 0.5;
        //        [animGroup1 setDelegate:self];
        [thumb.layer addAnimation:animGroup1 forKey:nil];
    }
}

-(void)loadScrollViewForHeadLineID:(NSInteger)headLineID{
    [self loadCurrentHeadlines:headLineID];
    [self loadPreviousHeadlines:headLineID];
    for (UIButton *b in arrayButton3) {
        [b removeFromSuperview];
    }
    [arrayButton3 removeAllObjects];
    CGFloat padding = 30;
    scrollView1.contentSize = CGSizeMake((padding + 286)*[arrCurrentHeadlines count] +padding, 300);
    
    
    
    for (int i= 0; i<[arrCurrentHeadlines count]; i++) {
        CGRect frame = CGRectMake(20 +i*(padding+ 286) , 290, 286, 136);
        
        UIButton *b = [UIButton buttonWithType:UIButtonTypeSystem];
        ThumbItem *item = [arrCurrentHeadlines objectAtIndex:i];
        [b setTitle:item.thumbTitle forState:UIControlStateNormal];
        CGRect btnFrame = CGRectMake(frame.origin.x, frame.origin.y+130, frame.size.width, 75);
        b.frame = btnFrame;
        b.backgroundColor = [UIColor colorWithRed:239.0/255 green:185.0/255 blue:88.0/255 alpha:1.0];
        [arrayButton3 addObject:b];
        
        b.titleLabel.font= [UIFont systemFontOfSize:23];
        [b addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        b.tag = item.thumbID;
        [scrollView1 addSubview:b];
        
        
        CGRect bottomFrame =CGRectMake(20 +i*(padding+143) , 540, 143, 40);
        CGPoint bottomPoint = CGPointMake(bottomFrame.origin.x + bottomFrame.size.width/2, bottomFrame.origin.y +bottomFrame.size.height/2);
        
        
        CGPoint btnCenter = b.center;
        
        
        UIBezierPath *movePath = [UIBezierPath bezierPath];
        [movePath moveToPoint:bottomPoint];
        
        [movePath addLineToPoint:btnCenter];
        CAKeyframeAnimation *moveAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        moveAnim.path = movePath.CGPath;
        moveAnim.removedOnCompletion = NO;
        
        CABasicAnimation *scaleAnim = [CABasicAnimation animationWithKeyPath:@"transform"];
        scaleAnim.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5, 0.5, 1.0)];
        scaleAnim.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
        scaleAnim.removedOnCompletion = NO;
        
        CABasicAnimation *opacityAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
        opacityAnim.fromValue = [NSNumber numberWithFloat:1.0];
        opacityAnim.toValue = [NSNumber numberWithFloat:1.0];
        opacityAnim.removedOnCompletion = NO;
        
        CAAnimationGroup *animGroup = [CAAnimationGroup animation];
        animGroup.animations = [NSArray arrayWithObjects:moveAnim, scaleAnim, opacityAnim, nil];
        animGroup.duration = 1.5;
        [animGroup setValue:b forKey:@"step3"];
        isFinishStep3 = NO;
        [animGroup setDelegate:self];
        b.alpha =1;
        [b.layer addAnimation:animGroup forKey:nil];
        
        
        
        
    }
    [self performSelector:@selector(loadThumViewsForCurrentHeadline) withObject:nil afterDelay:1.0];
    
}
-(void)loadThumViewsForCurrentHeadline{
    CGFloat padding = 30;
    [arrayThumb removeAllObjects];
    for (int i= 0; i<[arrCurrentHeadlines count]; i++) {
        CGRect frame = CGRectMake(20 +i*(padding+ 286) , 290, 286, 136);
        ThumView *thumb = [[ThumView alloc]initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height)];
        
        thumb.backgroundColor = [UIColor whiteColor];
        thumb.alpha = 0.0;
        [arrayThumb addObject:thumb];
        [scrollView1 addSubview:thumb];
        
        //when button animating 2/3 path, start animating to display thumbview
        CGRect bottomFrame =CGRectMake(20 +i*(padding+143) , 540, 143, 40);
        CGPoint buttonPoint = CGPointMake(bottomFrame.origin.x + bottomFrame.size.width/2, (bottomFrame.origin.y +bottomFrame.size.height/2));
        
        CGPoint bottomPoint = CGPointMake(buttonPoint.x, buttonPoint.y-205*0.5/2);
        CGPoint topPoint = thumb.center;
        
        CGFloat middleY = 2*topPoint.y/3 + bottomPoint.y/3;
        CGFloat middleX = (middleY*(bottomPoint.x - topPoint.x) +(topPoint.x * bottomPoint.y - bottomPoint.x*topPoint.y))/(bottomPoint.y - topPoint.y);
        
        
        CGPoint middlePoint = CGPointMake(middleX, middleY);
        
        
        
        UIBezierPath *movePath1 = [UIBezierPath bezierPath];
        [movePath1 moveToPoint:middlePoint];
        
        [movePath1 addLineToPoint:thumb.center];
        CAKeyframeAnimation *moveAnim1 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        moveAnim1.path = movePath1.CGPath;
        moveAnim1.removedOnCompletion = NO;
        
        CABasicAnimation *scaleAnim1 = [CABasicAnimation animationWithKeyPath:@"transform"];
        
        scaleAnim1.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1-0.5/3, 1-0.5/3, 1.0)];
        scaleAnim1.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
        scaleAnim1.removedOnCompletion = NO;
        
        CABasicAnimation *opacityAnim1 = [CABasicAnimation animationWithKeyPath:@"opacity"];
        opacityAnim1.fromValue = [NSNumber numberWithFloat:0.0];
        opacityAnim1.toValue = [NSNumber numberWithFloat:1.0];
        opacityAnim1.removedOnCompletion = NO;
        
        CAAnimationGroup *animGroup1 = [CAAnimationGroup animation];
        animGroup1.animations = [NSArray arrayWithObjects:moveAnim1, scaleAnim1, opacityAnim1, nil];
        animGroup1.duration = 0.5;
        //        [animGroup1 setDelegate:self];
        [thumb.layer addAnimation:animGroup1 forKey:nil];
        
    }
    
    
}
-(void)loadTopButtonForHeadline:(NSInteger)headlineID{
    [self loadPreviousHeadlines:headlineID];
    [arrayButton1 removeAllObjects];
    [arrayButton3 removeAllObjects];
    CGFloat padding = 15;
    scrollView1.contentSize = CGSizeMake((padding + 300)*[arrCurrentHeadlines count] +padding, 300);
    for (int i= 0; i<[arrPreviousHeadlines count]; i++) {
        CGRect frame = CGRectMake(20 +i*(padding+143) , 30, 143, 40);
        
        UIButton *b = [UIButton buttonWithType:UIButtonTypeSystem];
        ThumbItem *item = [arrPreviousHeadlines objectAtIndex:i];
        [b setTitle:item.thumbTitle forState:UIControlStateNormal];
        b.frame = frame;
        b.backgroundColor = [UIColor redColor];
        [arrayButton1 addObject:b];
        b.hidden = YES;
        //        [scrollView1 addSubview:b];
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
                item.thumbTitle = [NSString stringWithFormat:@"Headline 12%d",i+1-36];
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


@end