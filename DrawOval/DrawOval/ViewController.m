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
    arrCurrentHeadlines = [[NSMutableArray alloc]init];
    arrPreviousHeadlines = [[NSMutableArray alloc]init];
    arraySelectedID = [[NSMutableArray alloc]init];
    btnBackSelected = NO;
    arrayButton1 = [[NSMutableArray alloc]init];
    arrayButton2 = [[NSMutableArray alloc]init];
    arrayButton3 = [[NSMutableArray alloc]init];
    
    arrayDescription = [[NSMutableArray alloc]init];
    
    arrayThumb = [[NSMutableArray alloc]init];
    isFinishAnimation = YES;
    CGRect screenRect1 = [[UIScreen mainScreen] bounds];
    CGRect screenRect;
    imgBackground = [[UIImageView alloc] initWithFrame:CGRectMake(screenRect1.origin.x,
                                                                  screenRect1.origin.y,
                                                                  screenRect1.size.height,
                                                                  screenRect1.size.width)];
    imgBackground.image = [UIImage imageNamed:@"Default-Landscape~ipad.png"];
    [self.view addSubview:imgBackground];
    UIInterfaceOrientation interfaceOrientation = [UIApplication sharedApplication].statusBarOrientation;
    if(UIInterfaceOrientationIsPortrait(interfaceOrientation)){
        screenRect = CGRectMake(0, 0, screenRect1.size.width, screenRect1.size.height);
    }
    else {
        screenRect = CGRectMake(0, 0, screenRect1.size.height, screenRect1.size.width);
    }
    scrollView1  = [[UIScrollView alloc]init];
    scrollView1.frame = CGRectMake(0, 0, screenRect.size.width, screenRect.size.height-48);
    scrollView1.backgroundColor = [UIColor clearColor];
    [self.view addSubview:scrollView1];
    
    
    btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    btnBack.backgroundColor =[UIColor clearColor];
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
    bottomTabBarView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [bottomTabBarView addSubview:btnBack];
    [self.view addSubview:bottomTabBarView];
    
    currentHeadlineID = 0;
    previousHeadlineID =0;
    [self loadScrollViewAtBegining];
    
    
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
            //            b.backgroundColor = [UIColor colorWithRed:239.0/255 green:185.0/255 blue:88.0/255 alpha:1.0];
            //            [b setBackgroundImage:[UIImage imageNamed:@"button_3dmode_sub.png"] forState:UIControlStateNormal];
            b.backgroundColor = [UIColor colorWithRed:60.0/255 green:60.0/255 blue:60.0/255 alpha:0.8];
            b.alpha = 0.8;
            [[b layer] setBorderColor:[[UIColor colorWithRed:223.0/255.0
                                                       green:223.0/255.0
                                                        blue:223.0/255.0
                                                       alpha:0.8] CGColor]];
//            [b.layer setBorderWidth:1.f];
            break;
        }
    }
    
    
    currentHeadlineID = clickButton.tag;
    [self loadCurrentHeadlines:clickButton.tag];
    
    if ([arrCurrentHeadlines count]==0) {
        [self hideCoverView:NO];
    }
    [arraySelectedID removeLastObject];
    int lastObject = [[arraySelectedID lastObject] integerValue];
    if (lastObject != [sender tag])
        [arraySelectedID addObject:[NSNumber numberWithInteger:currentHeadlineID]];
    NSLog(@"selected: %@",arraySelectedID);
    
    //    clickButton.backgroundColor = [UIColor redColor];
    //    [clickButton setBackgroundImage:[UIImage imageNamed:@"button_3dmode_sub_pressed.png"] forState:UIControlStateNormal];
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
    
    [self loadCurrentHeadlines:clickButton.tag];

    previousHeadlineID = currentHeadlineID;
    currentHeadlineID = clickButton.tag;
    int lastObject = [[arraySelectedID lastObject] integerValue];
    if (lastObject != [sender tag])
        [arraySelectedID addObject:[NSNumber numberWithInteger:currentHeadlineID]];
    NSLog(@"selected: %@",arraySelectedID);
    if ([arrCurrentHeadlines count]==0) {
        [self hideCoverView:NO];
        isFinishAnimation = YES;
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
    //    [clickButton setBackgroundImage:[UIImage imageNamed:@"button_3dmode_pressed.png"] forState:UIControlStateNormal];
    //    clickButton.backgroundColor = [UIColor colorWithRed:108.0/255 green:108.0/255 blue:108.0/255 alpha:1.0];
    [clickButton setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:108.0/255 green:108.0/255 blue:108.0/255 alpha:0.8]] forState:UIControlStateHighlighted];
    clickButton.backgroundColor = [UIColor colorWithRed:108.0/255 green:108.0/255 blue:108.0/255 alpha:0.8];
    clickButton.alpha = 0.8;
    arrayButton2 = [arrayButton3 mutableCopy];
    [self loadTopButtonForHeadline:currentHeadlineID];
//    [self loadScrollViewForHeadLineID:currentHeadlineID];
    //    clickButton.backgroundColor = [UIColor redColor];
    
    animationType = ANIMATION_UP_STEP1;
    CGFloat padding1 = 20;
    for (int i =0; i<[arrayButton2 count]; i++) {
        
        
        CGRect frameTop= CGRectMake(20 +i*(padding1+139) , 194, 139, 35);
        CGPoint topPoint = CGPointMake(frameTop.origin.x + frameTop.size.width/2, frameTop.origin.y+frameTop.size.height/2);
        
        //        UIButton *b1 = [arrayButton1 objectAtIndex:i];
        UIButton *b2 = [arrayButton2 objectAtIndex:i];
        [b2 removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
        [b2 addTarget:nil action:@selector(clickTopButton:) forControlEvents:UIControlEventTouchUpInside];
        if (b2.tag == clickButton.tag) {
            b2.backgroundColor = [UIColor colorWithRed:108.0/255 green:108.0/255 blue:108.0/255 alpha:0.8];
            b2.alpha = 0.8;
        }
        ThumView *thumb = [arrayThumb objectAtIndex:i];
        thumb.alpha = 0.0;
        
        CGPoint middlePoint = b2.center;
        
        
        b2.frame = frameTop;
        b2.center = topPoint;
        b2.titleLabel.font = [UIFont systemFontOfSize:17];
        b2.titleLabel.textColor = [UIColor whiteColor];
        [b2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [b2 setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [b2 setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        
        UIBezierPath *movePath = [UIBezierPath bezierPath];
        [movePath moveToPoint:middlePoint];
        //        [movePath addQuadCurveToPoint:middleButtonPoint
        //                         controlPoint:CGPointMake(b2.center.x, middleButtonPoint.y)];
        
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
        animGroup.duration = 0.6;
        [animGroup setValue:@"step1" forKey:@"step1"];
        [animGroup setDelegate:self];
        b2.alpha =0.8;
        [b2.layer addAnimation:animGroup forKey:nil];
        
        
        
        
        //animation for imageview
        
        CGFloat middleY = 2*middlePoint.y/3 + topPoint.y/3;
        CGFloat middleX = (middleY*(middlePoint.x - topPoint.x) +(topPoint.x * middlePoint.y - middlePoint.x*topPoint.y))/(middlePoint.y - topPoint.y);
        
        
        CGPoint p1 = CGPointMake(middleX, middleY - 226/2*(1-1*(1-0.5)/3));
        
        UIBezierPath *movePath1 = [UIBezierPath bezierPath];
        CGPoint p2 = thumb.center;
        [movePath1 moveToPoint:p2];
        
        [movePath1 addLineToPoint:p1];
        CAKeyframeAnimation *moveAnim1 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        moveAnim1.path = movePath1.CGPath;
        moveAnim1.removedOnCompletion = YES;
        
        CABasicAnimation *scaleAnim1 = [CABasicAnimation animationWithKeyPath:@"transform"];
        scaleAnim1.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
        scaleAnim1.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1-0.5/3, 1-0.5/3, 1.0)];
        scaleAnim1.removedOnCompletion = YES;
        
        CABasicAnimation *opacityAnim1 = [CABasicAnimation animationWithKeyPath:@"opacity"];
        opacityAnim1.fromValue = [NSNumber numberWithFloat:0.5];
        opacityAnim1.toValue = [NSNumber numberWithFloat:0.0];
        opacityAnim1.removedOnCompletion = YES;
        
        CAAnimationGroup *animGroup1 = [CAAnimationGroup animation];
        animGroup1.animations = [NSArray arrayWithObjects:moveAnim1, scaleAnim1, opacityAnim1, nil];
        animGroup1.duration = 0.2;
        thumb.alpha = 0;
        [thumb.layer addAnimation:animGroup1 forKey:nil];
        
        
        //animation for descriptionview
        UIButton *descView = [arrayDescription objectAtIndex:i];
        
        CGPoint p1Desc = CGPointMake(middleX, middleY + 150/2*(1-1*(1-0.5)/3));
        
        UIBezierPath *movePath2 = [UIBezierPath bezierPath];
        CGPoint p2Desc = descView.center;
        [movePath2 moveToPoint:p2Desc];
        
        [movePath2 addLineToPoint:p1Desc];
        CAKeyframeAnimation *moveAnim2 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        moveAnim2.path = movePath2.CGPath;
        moveAnim2.removedOnCompletion = YES;
        
        CABasicAnimation *scaleAnim2 = [CABasicAnimation animationWithKeyPath:@"transform"];
        scaleAnim2.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
        scaleAnim2.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1-0.5/3, 1-0.5/3, 1.0)];
        scaleAnim2.removedOnCompletion = YES;
        
        CABasicAnimation *opacityAnim2 = [CABasicAnimation animationWithKeyPath:@"opacity"];
        opacityAnim2.fromValue = [NSNumber numberWithFloat:0.5];
        opacityAnim2.toValue = [NSNumber numberWithFloat:0.0];
        opacityAnim2.removedOnCompletion = YES;
        
        CAAnimationGroup *animGroup2 = [CAAnimationGroup animation];
        animGroup2.animations = [NSArray arrayWithObjects:moveAnim2, scaleAnim2, opacityAnim2, nil];
        animGroup2.duration = 0.2;
        descView.alpha = 0;
        [descView.layer addAnimation:animGroup2 forKey:nil];
        
    }
    [self performSelector:@selector(loadScrollForCurrentHeadline) withObject:nil afterDelay:0.2];
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
    
    if ([arrCurrentHeadlines count]==0) {
        [self hideCoverView:NO];
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
    
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    //
    isFinishAnimation = YES;
    if ([anim valueForKey:@"step1"]) {
        if (isFinishStep1) {
            
            return;
        }
        isFinishStep1 = YES;
//        for (int i= 0; i<[arrayButton2 count]; i++) {
//            UIButton *b1 = [arrayButton2 objectAtIndex:i];
//            
//            CGPoint topCenter = b1.center;
//            b1.frame = CGRectMake(b1.frame.origin.x, b1.frame.origin.y, b1.frame.size.width *0.5, b1.frame.size.height*0.5);
//            
////            CGRect frameTop= CGRectMake(20 +i*(padding1+139) , 194, 139, 35);
////            b1.frame = CGRectMake(b1.frame.origin.x, b1.frame.origin.y, b1.frame.size.width *0.5, b1.frame.size.height*0.5);
//            b1.titleLabel.font = [UIFont systemFontOfSize:17];
//            b1.titleLabel.textColor = [UIColor whiteColor];
//            [b1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            [b1 setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
//            [b1 setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
//             b1.center = topCenter;
//            b1.hidden = NO;
//            
//        }
        
    }
//    if ([[anim valueForKey:@"step2"] isEqualToString:@"step2"]) {
//        if (isFinishStep2 ) {
//            return;
//        }
//        isFinishStep2 = YES;
//        for (int i= 0; i<[arrayButton1 count]; i++) {
//            UIButton *b1 = [arrayButton1 objectAtIndex:i];
//            
//            b1.hidden = NO;
//            
//        }
//        for (int i= 0; i<[arrayButton2 count]; i++) {
//            
//            UIButton *b2 = [arrayButton2 objectAtIndex:i];
//            b2.alpha = 0.0;
//            [b2 removeFromSuperview];
//        }
//        animationType = 0;
//    }
    
//    if ([anim valueForKey:@"step3"]) {
//        if (isFinishStep3) {
//            return;
//        }
//        for (int i= 0; i<[arrCurrentHeadlines count]; i++){
//            
//            ThumView *thumb = [arrayThumb objectAtIndex:i];
//            
//            thumb.alpha = 1.0;
//            
//            
//            isFinishStep3 = YES;
//        }
//    }
    
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
    currentHeadlineID = 0;
    [self loadCurrentHeadlines:currentHeadlineID];
    [self loadPreviousHeadlines:currentHeadlineID];
    
    for (UIButton *b in arrayButton3) {
        [b removeFromSuperview];
    }
    [arrayButton3 removeAllObjects];
    CGFloat padding = 40;
    scrollView1.contentSize = CGSizeMake((padding + 278)*[arrCurrentHeadlines count] +padding, 720);
    
    
    
    for (int i= 0; i<[arrCurrentHeadlines count]; i++) {
        CGRect frame = CGRectMake(20 +i*(padding+ 278) , 314, 278, 157);
        
        UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
        ThumbItem *item = [arrCurrentHeadlines objectAtIndex:i];
        [b setTitle:item.thumbTitle forState:UIControlStateNormal];
        CGRect btnFrame = CGRectMake(frame.origin.x, frame.origin.y+156, frame.size.width, 72);
        b.frame = btnFrame;
        //        b.backgroundColor = [UIColor colorWithRed:239.0/255 green:185.0/255 blue:88.0/255 alpha:1.0];
        //        UIImage *buttonBackground = [UIImage imageNamed:@"button_3dmode.png"];
        //        [b setBackgroundImage:buttonBackground forState:UIControlStateNormal];
        //        UIImage *pressedBackground = [UIImage imageNamed:@"button_3dmode_pressed.png"];
        //        [b setBackgroundImage:pressedBackground forState:UIControlStateHighlighted];
        [b setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:108.0/255 green:108.0/255 blue:108.0/255 alpha:0.8]] forState:UIControlStateHighlighted];
        b.backgroundColor = [UIColor colorWithRed:60.0/255 green:60.0/255 blue:60.0/255 alpha:0.8];
        b.alpha = 0.8;
        [[b layer] setBorderColor:[[UIColor colorWithRed:223.0/255.0
                                                   green:223.0/255.0
                                                    blue:223.0/255.0
                                                   alpha:0.8] CGColor]];
//        [b.layer setBorderWidth:1.f];
        [arrayButton3 addObject:b];
        //        if (currentHeadlineID ==0) {
        //            [arrayButton2 addObject:b];
        //        }
        b.titleLabel.font= [UIFont systemFontOfSize:34];
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
                                                                               50)];
        
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
        descriptionView.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
//        [descriptionView.layer setBorderWidth:1.f];
        [arrayDescription addObject:descriptionView];
        [scrollView1 addSubview:descriptionView];
        [scrollView1 addSubview:thumb];
        
        [descriptionView addTarget:self action:@selector(startButtonTouch:) forControlEvents:UIControlEventTouchDown];
        [descriptionView addTarget:self action:@selector(endButtonTouch:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
        
        [b addTarget:self action:@selector(startButtonTouch:) forControlEvents:UIControlEventTouchDown];
        [b addTarget:self action:@selector(endButtonTouch:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
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
//    b.backgroundColor = [UIColor colorWithRed:60.0/255 green:60.0/255 blue:60.0/255 alpha:1.0];
    
    UIButton *d;
    
    for (UIButton *btn in arrayDescription) {
        if (btn.tag == i) {
            d = btn;
        }
    }
//    d.backgroundColor = [UIColor colorWithRed:60.0/255 green:60.0/255 blue:60.0/255 alpha:1.0];
    
//    NSLog(@"startButtonTouch %i",i);
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
        
        UIButton *descView = [arrayDescription objectAtIndex:i];
        [descView removeFromSuperview];
    }
    [arrayButton3 removeAllObjects];
    [arrayThumb removeAllObjects];
    [arrayDescription removeAllObjects];
    
    CGFloat padding = 40;
    scrollView1.contentSize = CGSizeMake((padding + 278)*[arrCurrentHeadlines count] +padding, 720);
    
    
    
    for (int i= 0; i<[arrCurrentHeadlines count]; i++) {
        CGRect frame = CGRectMake(20 +i*(padding+ 278) , 314, 278, 157);
        
        UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
        ThumbItem *item = [arrCurrentHeadlines objectAtIndex:i];
        [b setTitle:item.thumbTitle forState:UIControlStateNormal];
        CGRect btnFrame = CGRectMake(frame.origin.x, frame.origin.y+156, frame.size.width, 72);
        b.frame = btnFrame;
        //        b.backgroundColor = [UIColor colorWithRed:239.0/255 green:185.0/255 blue:88.0/255 alpha:1.0];
        //        UIImage *buttonBackground = [UIImage imageNamed:@"button_3dmode.png"];
        //        [b setBackgroundImage:buttonBackground forState:UIControlStateNormal];
        //        UIImage *pressedBackground = [UIImage imageNamed:@"button_3dmode_pressed.png"];
        //        [b setBackgroundImage:pressedBackground forState:UIControlStateHighlighted];
        [b setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:108.0/255 green:108.0/255 blue:108.0/255 alpha:0.8]] forState:UIControlStateHighlighted];
        b.backgroundColor = [UIColor colorWithRed:60.0/255 green:60.0/255 blue:60.0/255 alpha:0.8];
        b.alpha = 0.8;
        [[b layer] setBorderColor:[[UIColor colorWithRed:223.0/255.0
                                                   green:223.0/255.0
                                                    blue:223.0/255.0
                                                   alpha:0.8] CGColor]];
//        [b.layer setBorderWidth:1.f];
        [arrayButton3 addObject:b];
        //        if (currentHeadlineID ==0) {
        //            [arrayButton2 addObject:b];
        //        }
        b.titleLabel.font= [UIFont systemFontOfSize:34];
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
                                                                               thumb.frame.origin.y + 156+72-1,
                                                                               278,
                                                                               50)];
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
//        descriptionView.alpha = 0.8;
        NSString *textDes = @"There are many variations of passages of Lorem Ipsum avaiable";
        [descriptionView setTitle:textDes forState:UIControlStateNormal];
        descriptionView.titleLabel.textAlignment = NSTextAlignmentCenter;;
        descriptionView.titleLabel.numberOfLines = 2;
        descriptionView.titleLabel.font = [UIFont systemFontOfSize:17.0];
        descriptionView.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
//        [descriptionView.layer setBorderWidth:1.f];
        [arrayDescription addObject:descriptionView];
        [scrollView1 addSubview:descriptionView];
        
        [descriptionView addTarget:self action:@selector(startButtonTouch:) forControlEvents:UIControlEventTouchDown];
        [descriptionView addTarget:self action:@selector(endButtonTouch:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
        
        [b addTarget:self action:@selector(startButtonTouch:) forControlEvents:UIControlEventTouchDown];
        [b addTarget:self action:@selector(endButtonTouch:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
        
        [UIView animateWithDuration:0.9 animations:^{
            thumb.alpha = 1.0;
            b.alpha = 0.8;
            descriptionView.alpha = 0.8;
        }];
        
    }
    
}
-(void)loadScrollViewBackToHeadLineID:(NSInteger)headlineID{
    isFinishAnimation = NO;
    CGFloat padding1 = 20;
    CGFloat padding = 40;
    [self loadCurrentHeadlines:headlineID];
    [self loadPreviousHeadlines:headlineID];
    
    // remove all button and thubmview at current level
    [scrollView1.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [arrayButton3 removeAllObjects];
    [arrayThumb removeAllObjects];
    [arrayButton2 removeAllObjects];
    [arrayDescription removeAllObjects];
    
    // add top buttons
    
    
    
    
//    if ([arraySelectedID count] >0) {
//        for (int i =0; i<[arrPreviousHeadlines count]; i++) {
//            
//            CGRect frameTop= CGRectMake(20 +i*(padding1+139) , 194, 139, 35);
//            //        CGPoint topPoint = CGPointMake(frameTop.origin.x + frameTop.size.width/2, frameTop.origin.y+frameTop.size.height/2);
//            
//            UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
//            ThumbItem *item = [arrPreviousHeadlines objectAtIndex:i];
//            [b setTitle:item.thumbTitle forState:UIControlStateNormal];
//            b.frame = frameTop;
//            [b setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            [b setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
//            [b setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
//            //            b.backgroundColor = [UIColor colorWithRed:239.0/255 green:185.0/255 blue:88.0/255 alpha:1.0];
//            //            [b setBackgroundImage:[UIImage imageNamed:@"button_3dmode_sub.png"] forState:UIControlStateNormal];
//            [b setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:108.0/255 green:108.0/255 blue:108.0/255 alpha:0.8]] forState:UIControlStateHighlighted];
//            b.backgroundColor = [UIColor colorWithRed:60.0/255 green:60.0/255 blue:60.0/255 alpha:0.8];
//            b.alpha = 0.8;
//            [[b layer] setBorderColor:[[UIColor colorWithRed:223.0/255.0
//                                                       green:223.0/255.0
//                                                        blue:223.0/255.0
//                                                       alpha:0.8] CGColor]];
////            [b.layer setBorderWidth:1.f];
//            [b addTarget:self action:@selector(startButtonTouch:) forControlEvents:UIControlEventTouchDown];
//            [b addTarget:self action:@selector(endButtonTouch:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
//            
//            [b addTarget:nil action:@selector(clickTopButton:) forControlEvents:UIControlEventTouchUpInside];
//            b.tag = item.thumbID;
//            if (b.tag == currentHeadlineID) {
//                //                b.backgroundColor = [UIColor redColor];
//                //                [b setBackgroundImage:[UIImage imageNamed:@"button_3dmode_sub_pressed.png"] forState:UIControlStateNormal];
//                [b setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:108.0/255 green:108.0/255 blue:108.0/255 alpha:0.8]] forState:UIControlStateHighlighted];
//                b.backgroundColor = [UIColor colorWithRed:108.0/255 green:108.0/255 blue:108.0/255 alpha:0.8];
//                b.alpha = 0.8;
//            }
//            b.alpha = 0.0;
//            [arrayButton2 addObject:b];
//            [scrollView1 addSubview:b];
//            
//            [UIView animateWithDuration:0.6 animations:^{
//                b.alpha = 0.8;
//            }];
//            
//        }
//    }
    
    
    
    //end
    
    
    scrollView1.contentSize = CGSizeMake((padding + 278)*[arrCurrentHeadlines count] +padding, 720);
    
    
    
    for (int i= 0; i<[arrCurrentHeadlines count]; i++) {
        CGRect frame = CGRectMake(20 +i*(padding+ 278) , 314, 278, 157);
        
        UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
        ThumbItem *item = [arrCurrentHeadlines objectAtIndex:i];
        [b setTitle:item.thumbTitle forState:UIControlStateNormal];
        CGRect btnFrame = CGRectMake(frame.origin.x, frame.origin.y+156, frame.size.width, 70);
        b.frame = btnFrame;
        //        b.backgroundColor = [UIColor colorWithRed:239.0/255 green:185.0/255 blue:88.0/255 alpha:1.0];
        //        UIImage *buttonBackground = [UIImage imageNamed:@"button_3dmode.png"];
        //        [b setBackgroundImage:buttonBackground forState:UIControlStateNormal];
        //        UIImage *pressedBackground = [UIImage imageNamed:@"button_3dmode_pressed.png"];
        //        [b setBackgroundImage:pressedBackground forState:UIControlStateHighlighted];
        [b setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:108.0/255 green:108.0/255 blue:108.0/255 alpha:0.8]] forState:UIControlStateHighlighted];
        b.backgroundColor = [UIColor colorWithRed:60.0/255 green:60.0/255 blue:60.0/255 alpha:0.8];
        b.alpha = 0.8;
        [[b layer] setBorderColor:[[UIColor colorWithRed:223.0/255.0
                                                   green:223.0/255.0
                                                    blue:223.0/255.0
                                                   alpha:0.8] CGColor]];
//        [b.layer setBorderWidth:1.f];
        [arrayButton3 addObject:b];
        //        if (currentHeadlineID ==0) {
        //            [arrayButton2 addObject:b];
        //        }
        b.titleLabel.font= [UIFont systemFontOfSize:34];
        [b setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [b setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [b setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [b addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
//        [b addTarget:self action:@selector(startButtonTouch:) forControlEvents:UIControlEventTouchDown];
//        [b addTarget:self action:@selector(endButtonTouch:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
        b.tag = item.thumbID;
        maskBtn.tag = item.thumbID;
        b.alpha = 0.8;
        [scrollView1 addSubview:b];
        
        
        CGRect frameTop= CGRectMake(20 +i*(padding1+139) , 194, 139, 35);
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
        animGroup.duration = 0.6;
        [animGroup setValue:@"back" forKey:@"back"];
        [animGroup setDelegate:self];
        b.alpha =0.8;
        [b.layer addAnimation:animGroup forKey:nil];
//        b.frame = CGRectMake(20 +i*(padding1+139) , 194, 139, 35);
        
        
        
        
        //        ThumView *thumb = [[ThumView alloc]initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height)];
        //
        //        thumb.backgroundColor = [UIColor whiteColor];
        //        thumb.alpha = 1.0;
        //        [arrayThumb addObject:thumb];
        //        [scrollView1 addSubview:thumb];
        
        
    }
    [self loadThumbViewForBack];
    [self performSelector:@selector(loadTopButtonForBack) withObject:nil afterDelay:0.4];
//    [self performSelector:@selector(loadThumbViewForBack) withObject:nil afterDelay:.0];
}
-(void)loadTopButtonForBack{
    CGFloat padding1 = 20;
    if ([arraySelectedID count] >0) {
        for (int i =0; i<[arrPreviousHeadlines count]; i++) {
            
            CGRect frameTop= CGRectMake(20 +i*(padding1+139) , 194, 139, 35);
            //        CGPoint topPoint = CGPointMake(frameTop.origin.x + frameTop.size.width/2, frameTop.origin.y+frameTop.size.height/2);
            
            UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
            ThumbItem *item = [arrPreviousHeadlines objectAtIndex:i];
            [b setTitle:item.thumbTitle forState:UIControlStateNormal];
            b.frame = frameTop;
            [b setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [b setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            [b setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            //            b.backgroundColor = [UIColor colorWithRed:239.0/255 green:185.0/255 blue:88.0/255 alpha:1.0];
            //            [b setBackgroundImage:[UIImage imageNamed:@"button_3dmode_sub.png"] forState:UIControlStateNormal];
            [b setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:108.0/255 green:108.0/255 blue:108.0/255 alpha:0.8]] forState:UIControlStateHighlighted];
            b.backgroundColor = [UIColor colorWithRed:60.0/255 green:60.0/255 blue:60.0/255 alpha:0.8];
            b.alpha = 0.8;
            [[b layer] setBorderColor:[[UIColor colorWithRed:223.0/255.0
                                                       green:223.0/255.0
                                                        blue:223.0/255.0
                                                       alpha:0.8] CGColor]];
            //            [b.layer setBorderWidth:1.f];
            [b addTarget:self action:@selector(startButtonTouch:) forControlEvents:UIControlEventTouchDown];
            [b addTarget:self action:@selector(endButtonTouch:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
            
            [b addTarget:nil action:@selector(clickTopButton:) forControlEvents:UIControlEventTouchUpInside];
            b.tag = item.thumbID;
            if (b.tag == currentHeadlineID) {
                //                b.backgroundColor = [UIColor redColor];
                //                [b setBackgroundImage:[UIImage imageNamed:@"button_3dmode_sub_pressed.png"] forState:UIControlStateNormal];
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
    CGFloat padding = 40;
    CGFloat padding1 = 20;
    for (int i= 0; i<[arrCurrentHeadlines count]; i++) {
        CGRect frame = CGRectMake(20 +i*(padding+ 278) , 314, 278, 157);
        
        
        ThumView *thumb = [[ThumView alloc]initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height)];
        ThumbItem *item = [arrCurrentHeadlines objectAtIndex:i];
        thumb.item = item;
        [thumb loadImageForThumb];
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
        
        CGRect frameTop= CGRectMake(20 +i*(padding1+139) , 194, 139, 35);
        CGRect frameTop1= CGRectMake(20 +i*(padding1+139) , 194-78, 139, 79);
        CGPoint buttonTopPoint = CGPointMake(frameTop.origin.x + frameTop.size.width/2, frameTop.origin.y+frameTop.size.height/2);
        
//        CGPoint thumbTopPoint1 = CGPointMake(buttonTopPoint.x, buttonTopPoint.y-226*0.5/2);
         CGPoint thumbTopPoint = CGPointMake(frameTop1.origin.x + frameTop1.size.width/2, frameTop1.origin.y+frameTop1.size.height/2);
//        CGPoint bottomPoint = thumb.center;
        
        
//        CGFloat middleY = bottomPoint.y/2 + thumbTopPoint.y/2;
//        CGFloat middleX = (middleY*(bottomPoint.x - thumbTopPoint.x) +(thumbTopPoint.x * bottomPoint.y - bottomPoint.x*thumbTopPoint.y))/(bottomPoint.y - thumbTopPoint.y);
        
        
//        CGPoint middlePoint = CGPointMake(middleX, middleY);
        
//        thumb.frame =CGRectMake(20 +i*(padding1+139) , 194-78, 139, 79);
//        [thumb loadImageForThumb];
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
        animGroup1.duration = 0.6;
        //        [animGroup1 setDelegate:self];
        [thumb.layer addAnimation:animGroup1 forKey:nil];
        
        
        UIButton *descriptionView = [[UIButton alloc] initWithFrame:CGRectMake(thumb.frame.origin.x,
                                                                               thumb.frame.origin.y + 156+70 -1,
                                                                               278,
                                                                               50)];
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
        descriptionView.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
//        [descriptionView.layer setBorderWidth:1.f];
        [arrayDescription addObject:descriptionView];
        [scrollView1 addSubview:descriptionView];
        
        [descriptionView addTarget:self action:@selector(startButtonTouch:) forControlEvents:UIControlEventTouchDown];
        [descriptionView addTarget:self action:@selector(endButtonTouch:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
        
        CGPoint descTopPoint = CGPointMake(buttonTopPoint.x, buttonTopPoint.y+120*0.5/2);
//        CGPoint bottomPoint2 = descriptionView.center;
        
        
//        CGFloat middleY2 = bottomPoint2.y/2 + descTopPoint.y/2;
//        CGFloat middleX2 = (middleY2*(bottomPoint2.x - descTopPoint.x) +(descTopPoint.x * bottomPoint2.y - bottomPoint2.x*descTopPoint.y))/(bottomPoint2.y - descTopPoint.y);
        
//        CGPoint middlePoint2 = CGPointMake(middleX2, middleY2);
        
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
        animGroup2.duration = 0.6;
        //        [animGroup1 setDelegate:self];
        [descriptionView.layer addAnimation:animGroup2 forKey:nil];
        
    }
}

-(void)loadScrollViewForHeadLineID:(NSInteger)headLineID{
    [self loadCurrentHeadlines:headLineID];
    [self loadPreviousHeadlines:headLineID];
    for (UIButton *b in arrayButton3) {
        [b removeFromSuperview];
    }
    [arrayButton3 removeAllObjects];
    CGFloat padding = 40;
    CGFloat padding1 = 20;
    scrollView1.contentSize = CGSizeMake((padding + 278)*[arrCurrentHeadlines count] +padding, 720);
    
    
    
    for (int i= 0; i<[arrCurrentHeadlines count]; i++) {
        CGRect frame = CGRectMake(20 +i*(padding+ 278) , 314, 278, 157);
        
        UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
        ThumbItem *item = [arrCurrentHeadlines objectAtIndex:i];
        [b setTitle:item.thumbTitle forState:UIControlStateNormal];
        CGRect btnFrame = CGRectMake(frame.origin.x, frame.origin.y+156, frame.size.width, 72);
        b.frame = btnFrame;
        //        b.backgroundColor = [UIColor colorWithRed:239.0/255 green:185.0/255 blue:88.0/255 alpha:1.0];
        //        UIImage *buttonBackground = [UIImage imageNamed:@"button_3dmode.png"];
        //        [b setBackgroundImage:buttonBackground forState:UIControlStateNormal];
        //        UIImage *pressedBackground = [UIImage imageNamed:@"button_3dmode_pressed.png"];
        //        [b setBackgroundImage:pressedBackground forState:UIControlStateHighlighted];
        [b setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:108.0/255 green:108.0/255 blue:108.0/255 alpha:0.8]] forState:UIControlStateHighlighted];
        b.backgroundColor = [UIColor colorWithRed:60.0/255 green:60.0/255 blue:60.0/255 alpha:0.8];
        b.alpha = 0.8;
        [[b layer] setBorderColor:[[UIColor colorWithRed:223.0/255.0
                                                   green:223.0/255.0
                                                    blue:223.0/255.0
                                                   alpha:0.8] CGColor]];
//        [b.layer setBorderWidth:1.f];
        [arrayButton3 addObject:b];
        
        b.titleLabel.font= [UIFont systemFontOfSize:34];
        [b setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [b setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [b setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [b addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [b addTarget:self action:@selector(startButtonTouch:) forControlEvents:UIControlEventTouchDown];
        [b addTarget:self action:@selector(endButtonTouch:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
        b.tag = item.thumbID;
        [scrollView1 addSubview:b];
        
        
        CGRect bottomFrame =CGRectMake(20 +i*(padding1+136) , 746, 139, 35);
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
        animGroup.duration = 0.4;
        [animGroup setValue:b forKey:@"step3"];
        isFinishStep3 = NO;
        [animGroup setDelegate:self];
        b.alpha =0.8;
        [b.layer addAnimation:animGroup forKey:nil];
        
        
        
        
    }
//    [self performSelector:@selector(loadThumViewsForCurrentHeadline) withObject:nil afterDelay:0.3];
    [self loadThumViewsForCurrentHeadline];
}
-(void)loadThumViewsForCurrentHeadline{
    CGFloat padding = 40;
    CGFloat padding1 = 20;
    for (int i=0; i<[arrayThumb count]; i++) {
        ThumView *thumb = [arrayThumb objectAtIndex:i];
        [thumb removeFromSuperview];
        
        UIButton *b= [arrayDescription objectAtIndex:i];
        [b removeFromSuperview];
    }
    [arrayThumb removeAllObjects];
    [arrayDescription removeAllObjects];
    for (int i= 0; i<[arrCurrentHeadlines count]; i++) {
        CGRect frame = CGRectMake(20 +i*(padding+ 278) , 314, 278, 157);
        ThumView *thumb = [[ThumView alloc]initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height)];
        ThumbItem *item = [arrCurrentHeadlines objectAtIndex:i];
        thumb.item = item;
        [thumb loadImageForThumb];
        thumb.backgroundColor = [UIColor whiteColor];
//        thumb.alpha = 0.0;
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
        CGRect bottomFrame =CGRectMake(20 +i*(padding1+139) , 746, 136, 35);
        CGPoint buttonPoint = CGPointMake(bottomFrame.origin.x + bottomFrame.size.width/2, (bottomFrame.origin.y +bottomFrame.size.height/2));
        
        CGPoint bottomPoint = CGPointMake(buttonPoint.x, buttonPoint.y-226*0.5/2);
//        CGPoint topPoint = thumb.center;
        
//        CGFloat middleY = topPoint.y/3 + 2*bottomPoint.y/3;
//        CGFloat middleX = (middleY*(bottomPoint.x - topPoint.x) +(topPoint.x * bottomPoint.y - bottomPoint.x*topPoint.y))/(bottomPoint.y - topPoint.y);
//        
//        
//        CGPoint middlePoint = CGPointMake(middleX, middleY);
        
        
        
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
        animGroup1.duration = 0.4;
        //        [animGroup1 setDelegate:self];
        [thumb.layer addAnimation:animGroup1 forKey:nil];
        
        
        // load description view
        UIButton *descriptionView = [[UIButton alloc] initWithFrame:CGRectMake(thumb.frame.origin.x,
                                                                               thumb.frame.origin.y + 156+72-1,
                                                                               278,
                                                                               50)];
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
        descriptionView.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
//        [descriptionView.layer setBorderWidth:1.f];
        [arrayDescription addObject:descriptionView];
        [scrollView1 addSubview:descriptionView];
        
        [descriptionView addTarget:self action:@selector(startButtonTouch:) forControlEvents:UIControlEventTouchDown];
        [descriptionView addTarget:self action:@selector(endButtonTouch:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
        
        CGPoint bottomPoint2 = CGPointMake(buttonPoint.x, buttonPoint.y+120*0.5/2);
//        CGPoint topPoint2 = descriptionView.center;
        
//        CGFloat middleY2 = topPoint2.y/3 + 2*bottomPoint2.y/3;
//        CGFloat middleX2 = (middleY2*(bottomPoint2.x - topPoint2.x) +(topPoint2.x * bottomPoint2.y - bottomPoint2.x*topPoint2.y))/(bottomPoint2.y - topPoint2.y);
//        
        
//        CGPoint middlePoint2 = CGPointMake(middleX2,middleY2);
        
        
        
        
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
        animGroup2.duration = 0.4;
        //        [animGroup1 setDelegate:self];
        [descriptionView.layer addAnimation:animGroup2 forKey:nil];
        
    }
    
    
}
-(void)loadTopButtonForHeadline:(NSInteger)headlineID{
    [self loadPreviousHeadlines:headlineID];
    [arrayButton1 removeAllObjects];
    [arrayButton3 removeAllObjects];
    CGFloat padding = 20;
    scrollView1.contentSize = CGSizeMake((padding + 300)*[arrCurrentHeadlines count] +padding, 720);
    for (int i= 0; i<[arrPreviousHeadlines count]; i++) {
        CGRect frame = CGRectMake(20 +i*(padding+139) , 30, 139, 35);
        
        UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
        ThumbItem *item = [arrPreviousHeadlines objectAtIndex:i];
        [b setTitle:item.thumbTitle forState:UIControlStateNormal];
        b.frame = frame;
        //        b.backgroundColor = [UIColor redColor];
        b.backgroundColor = [UIColor colorWithRed:108.0/255 green:108.0/255 blue:108.0/255 alpha:0.8];
        b.alpha = 0.8;
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
        imgBackground.image = [UIImage imageNamed:@"Default-Landscape~ipad.png"];
        
        scrollView1.hidden = NO;
        bottomTabBarView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    }
    else {
        imgBackground.image = [UIImage imageNamed:@"background.png"];
        scrollView1.hidden = YES;
        bottomTabBarView.backgroundColor = [UIColor clearColor];
    }
}

@end