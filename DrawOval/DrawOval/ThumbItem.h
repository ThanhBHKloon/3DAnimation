//
//  ThumbItem.h
//  DrawOval
//
//  Created by Dinh Linh on 1/10/14.
//  Copyright (c) 2014 Dinh Linh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThumbItem : NSObject{
    NSInteger thumbID;
    NSString *thumbTitle;
    NSString *imgName;
}
@property(nonatomic, retain) NSString *thumbTitle;
@property(nonatomic, retain) NSString *imgName;
@property(assign) NSInteger thumbID;

@end
