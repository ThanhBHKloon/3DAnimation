//
//  ThumView.m
//  DrawOval
//
//  Created by Dinh Linh on 25/9/14.
//  Copyright (c) 2014 Dinh Linh. All rights reserved.
//

#import "ThumView.h"
#import "ThumbItem.h"

@implementation ThumView
@synthesize imgView,button,item;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
//        imgView.image = [UIImage imageNamed:item.imgName];
//        [[imgView layer] setBorderColor:[[UIColor colorWithRed:223.0/255.0
//                                                                 green:223.0/255.0
//                                                                  blue:223.0/255.0
//                                                                 alpha:1.0] CGColor]];
//        [imgView.layer setBorderWidth:1.f];
        [self addSubview:imgView];
    }
    return self;
}
-(void)loadImageForThumb{
    imgView.image = [UIImage imageNamed:item.imgName];
    imgView.contentMode = UIViewContentModeScaleToFill;
//    [[imgView layer] setBorderColor:[[UIColor colorWithRed:223.0/255.0
//                                                     green:223.0/255.0
//                                                      blue:223.0/255.0
//                                                     alpha:1.0] CGColor]];
//    [imgView.layer setBorderWidth:1.f];
//    imgView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);

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
