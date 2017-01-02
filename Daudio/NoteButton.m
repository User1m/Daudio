//
//  NoteButton.m
//  Daudio
//
//  Created by Claudius Mbemba on 1/2/17.
//  Copyright © 2017 Claudius Mbemba. All rights reserved.
//

#import "NoteButton.h"
#import <ChameleonFramework/Chameleon.h>

@implementation NoteButton  {
    CAShapeLayer *_layer;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    [self.layer addSublayer:_layer];
}

- (void)setStrokeColor:(UIColor *)strokeColor {
    _strokeColor = strokeColor;
    [self setNeedsDisplay];
}

- (void)layoutSubviews {
    _layer.frame = self.bounds;
}

- (void)drawRect:(CGRect)rect {
    _layer.path = [self drawIcon:rect].CGPath;
}

- (UIBezierPath * )drawIcon:(CGRect)frame {
    //// Color Declarations
    UIColor* fillColor2 = self.strokeColor;
    
    //// circle-edit-pen-pencil-outline-stroke Drawing
    UIBezierPath* circleeditpenpenciloutlinestrokePath = [UIBezierPath bezierPath];
    [circleeditpenpenciloutlinestrokePath moveToPoint: CGPointMake(CGRectGetMinX(frame) + 24, CGRectGetMinY(frame) + 48)];
    [circleeditpenpenciloutlinestrokePath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 48, CGRectGetMinY(frame) + 24) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 37.25, CGRectGetMinY(frame) + 48) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 48, CGRectGetMinY(frame) + 37.25)];
    [circleeditpenpenciloutlinestrokePath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 24, CGRectGetMinY(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 48, CGRectGetMinY(frame) + 10.75) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 37.25, CGRectGetMinY(frame))];
    [circleeditpenpenciloutlinestrokePath addCurveToPoint: CGPointMake(CGRectGetMinX(frame), CGRectGetMinY(frame) + 24) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 10.75, CGRectGetMinY(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame), CGRectGetMinY(frame) + 10.75)];
    [circleeditpenpenciloutlinestrokePath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 24, CGRectGetMinY(frame) + 48) controlPoint1: CGPointMake(CGRectGetMinX(frame), CGRectGetMinY(frame) + 37.25) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 10.75, CGRectGetMinY(frame) + 48)];
    [circleeditpenpenciloutlinestrokePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 24, CGRectGetMinY(frame) + 48)];
    [circleeditpenpenciloutlinestrokePath closePath];
    [circleeditpenpenciloutlinestrokePath moveToPoint: CGPointMake(CGRectGetMinX(frame) + 24, CGRectGetMinY(frame) + 45.91)];
    [circleeditpenpenciloutlinestrokePath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 45.91, CGRectGetMinY(frame) + 24) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 36.1, CGRectGetMinY(frame) + 45.91) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 45.91, CGRectGetMinY(frame) + 36.1)];
    [circleeditpenpenciloutlinestrokePath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 24, CGRectGetMinY(frame) + 2.09) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 45.91, CGRectGetMinY(frame) + 11.9) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 36.1, CGRectGetMinY(frame) + 2.09)];
    [circleeditpenpenciloutlinestrokePath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 2.09, CGRectGetMinY(frame) + 24) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 11.9, CGRectGetMinY(frame) + 2.09) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 2.09, CGRectGetMinY(frame) + 11.9)];
    [circleeditpenpenciloutlinestrokePath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 24, CGRectGetMinY(frame) + 45.91) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 2.09, CGRectGetMinY(frame) + 36.1) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 11.9, CGRectGetMinY(frame) + 45.91)];
    [circleeditpenpenciloutlinestrokePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 24, CGRectGetMinY(frame) + 45.91)];
    [circleeditpenpenciloutlinestrokePath closePath];
    [circleeditpenpenciloutlinestrokePath moveToPoint: CGPointMake(CGRectGetMinX(frame) + 26.92, CGRectGetMinY(frame) + 14.24)];
    [circleeditpenpenciloutlinestrokePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 14.71, CGRectGetMinY(frame) + 29.87)];
    [circleeditpenpenciloutlinestrokePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 14.61, CGRectGetMinY(frame) + 35.08)];
    [circleeditpenpenciloutlinestrokePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 19.64, CGRectGetMinY(frame) + 33.72)];
    [circleeditpenpenciloutlinestrokePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 31.85, CGRectGetMinY(frame) + 18.1)];
    [circleeditpenpenciloutlinestrokePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 30.2, CGRectGetMinY(frame) + 16.81)];
    [circleeditpenpenciloutlinestrokePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 18.39, CGRectGetMinY(frame) + 31.94)];
    [circleeditpenpenciloutlinestrokePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 16.53, CGRectGetMinY(frame) + 32.62)];
    [circleeditpenpenciloutlinestrokePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 16.74, CGRectGetMinY(frame) + 30.66)];
    [circleeditpenpenciloutlinestrokePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 28.56, CGRectGetMinY(frame) + 15.53)];
    [circleeditpenpenciloutlinestrokePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 26.92, CGRectGetMinY(frame) + 14.24)];
    [circleeditpenpenciloutlinestrokePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 26.92, CGRectGetMinY(frame) + 14.24)];
    [circleeditpenpenciloutlinestrokePath closePath];
    [circleeditpenpenciloutlinestrokePath moveToPoint: CGPointMake(CGRectGetMinX(frame) + 31.77, CGRectGetMinY(frame) + 11.28)];
    [circleeditpenpenciloutlinestrokePath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 28.84, CGRectGetMinY(frame) + 11.64) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 30.93, CGRectGetMinY(frame) + 10.62) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 28.84, CGRectGetMinY(frame) + 11.64)];
    [circleeditpenpenciloutlinestrokePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 27.55, CGRectGetMinY(frame) + 13.28)];
    [circleeditpenpenciloutlinestrokePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 32.49, CGRectGetMinY(frame) + 17.14)];
    [circleeditpenpenciloutlinestrokePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 33.77, CGRectGetMinY(frame) + 15.49)];
    [circleeditpenpenciloutlinestrokePath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 33.41, CGRectGetMinY(frame) + 12.56) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 33.77, CGRectGetMinY(frame) + 15.49) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 34.25, CGRectGetMinY(frame) + 13.22)];
    [circleeditpenpenciloutlinestrokePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 31.77, CGRectGetMinY(frame) + 11.28)];
    [circleeditpenpenciloutlinestrokePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 31.77, CGRectGetMinY(frame) + 11.28)];
    [circleeditpenpenciloutlinestrokePath closePath];
    circleeditpenpenciloutlinestrokePath.miterLimit = 4;
    
    circleeditpenpenciloutlinestrokePath.usesEvenOddFillRule = YES;
    
    [fillColor2 setFill];
    [circleeditpenpenciloutlinestrokePath fill];
    return circleeditpenpenciloutlinestrokePath;
}

@end
