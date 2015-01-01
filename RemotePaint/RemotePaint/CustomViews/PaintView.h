//
//  PaintView.h
//  PaintingSample
//
//  Created by Sean Christmann on 10/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PaintDelegate <NSObject>

-(void)touchBeganAtPoint:(CGPoint)point;
-(void)touchMovedAtPoint:(CGPoint)point;
@end

@interface PaintView : UIView {
    void *cacheBitmap;
    CGContextRef cacheContext;
    float hue;
    
    CGPoint point0;
    CGPoint point1;
    CGPoint point2;
    CGPoint point3;
}
- (BOOL) initContext:(CGSize)size;
- (void) drawToCache;

-(void)receivedTouchBegan:(CGPoint)point;
-(void)receivedTouchMoved:(CGPoint)point;

@property (nonatomic,weak) id<PaintDelegate> delegate;

@end
