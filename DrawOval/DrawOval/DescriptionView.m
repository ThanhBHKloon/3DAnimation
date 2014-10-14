//
//  DescriptionView.m
//  DrawOval
//
//  Created by SonNV on 10/14/14.
//  Copyright (c) 2014 Dinh Linh. All rights reserved.
//

#import "DescriptionView.h"

@implementation DescriptionView
@synthesize descriptionView, imgView;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        descriptionView = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                    0,
                                                                    frame.size.width,
                                                                    frame.size.height)];
        descriptionView.backgroundColor = [UIColor blackColor];
        descriptionView.alpha = 0.5;
        descriptionView.textColor = [UIColor whiteColor];
        descriptionView.text = @"There are many variations of passages of Lorem Ipsum avaiable";
        descriptionView.textAlignment = NSTextAlignmentCenter;;
        descriptionView.numberOfLines = 2;
        descriptionView.lineBreakMode = NSLineBreakByWordWrapping;

        imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        imgView.image = [UIImage imageNamed:@"description_bg.png"];
        [self addSubview:imgView];
        [self addSubview:descriptionView];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
