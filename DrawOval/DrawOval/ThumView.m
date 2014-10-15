//
//  ThumView.m
//  DrawOval
//
//  Created by Dinh Linh on 25/9/14.
//  Copyright (c) 2014 Dinh Linh. All rights reserved.
//

#import "ThumView.h"

@implementation ThumView
@synthesize imgView,button;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        imgView.image = [UIImage imageNamed:@"eng_flag.png"];
        [self addSubview:imgView];
    }
    return self;
}
-(void)addButtonInThumb{
//    CGRect frame = CGRectMake(0, self.frame.size.height -100, self.frame.size.width, 100);
//    button.frame = frame;
//    [self addSubview:button];
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
