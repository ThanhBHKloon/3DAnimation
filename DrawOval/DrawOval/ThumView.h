//
//  ThumView.h
//  DrawOval
//
//  Created by Dinh Linh on 25/9/14.
//  Copyright (c) 2014 Dinh Linh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ThumbItem;
@interface ThumView : UIView {
    UIImageView *imgView;
    UIButton *button;
    ThumbItem *item;
}
@property (nonatomic, retain)UIImageView *imgView;
@property (nonatomic, retain) UIButton *button;
@property (nonatomic, retain) ThumbItem *item;

-(void)loadImageForThumb;
@end
