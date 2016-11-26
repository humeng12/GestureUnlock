//
//  HMView.m
//  手势解锁
//
//  Created by 胡猛 on 16/10/29.
//  Copyright © 2016年 HuMeng. All rights reserved.
//

#import "HMView.h"

@interface HMView ()

@property (nonatomic, strong) NSMutableArray *selectBtns;
@property (nonatomic, assign) CGPoint currentMovePoint;

@end

@implementation HMView


-(NSMutableArray *)selectBtns
{
    if (_selectBtns == nil) {
        _selectBtns = [NSMutableArray array];
    }
    
    return _selectBtns;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}


-(void)setup
{
    for (int i =0; i < 9; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.userInteractionEnabled = NO;
        
        btn.tag = i;
        
        [btn setBackgroundImage:[UIImage imageNamed:@"gesture_node_normal"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"gesture_node_highlighted"] forState:UIControlStateSelected];
        
        [self addSubview:btn];
    }
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    for (int i =0; i < self.subviews.count; i++) {
        UIButton *btn = self.subviews[i];
    
        
        CGFloat btnW = 74;
        CGFloat btnH = 74;
        int totalColumus = 3;
        int col = i % 3;
        int row = i / 3;
        CGFloat marginX = (self.frame.size.width - totalColumus * btnW) / (totalColumus + 1);
        CGFloat marginY = marginX;
        CGFloat btnX = marginX + col * (btnW + marginX);
        CGFloat btnY = row * (btnH + marginY);
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    }
}


-(CGPoint)pointWithTouches:(NSSet *)touches
{
    UITouch *touch = [touches anyObject];
    return  [touch locationInView:touch.view];
}

-(UIButton *)buttonWithPoint:(CGPoint)point
{
    for (UIButton *btn in self.subviews) {
        
        CGFloat wh = 30;
        CGFloat frameX = btn.center.x - wh*0.5;
        CGFloat frameY = btn.center.y - wh*0.5;
        
        if(CGRectContainsPoint(CGRectMake(frameX, frameY, wh, wh), point)){
            return btn;
        }
    }
    
    return nil;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.currentMovePoint = CGPointZero;
    
    CGPoint point = [self pointWithTouches:touches];
    
    UIButton *btn = [self buttonWithPoint:point];
    
    if (btn && btn.selected == NO) {
        
        btn.selected = YES;
        [self.selectBtns addObject:btn];
        [self setNeedsDisplay];
    }
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [self pointWithTouches:touches];
    
    UIButton *btn = [self buttonWithPoint:point];
    
    if (btn && btn.selected == NO) {
        
        btn.selected = YES;
        [self.selectBtns addObject:btn];
    } else {
        self.currentMovePoint = point;
    }
    
    [self setNeedsDisplay];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    if ([self.delegate respondsToSelector:@selector(lockView:didFinishPath:)]) {
        NSMutableString *str = [NSMutableString string];
        for (UIButton *btn in self.selectBtns) {
            
            [str appendFormat:@"%ld",(long)btn.tag];
        }
        
        [self.delegate lockView:self didFinishPath:str];
    }
    
    for (UIButton *btn in self.selectBtns) {
        btn.selected = NO;
    }
    
//    [self.selectBtns makeObjectsPerformSelector:@selector(setSelected:) withObject:@(NO)];
    
    [self.selectBtns removeAllObjects];
    [self setNeedsDisplay];
}


-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self touchesEnded:touches withEvent:event];
}


-(void)drawRect:(CGRect)rect
{
    if (self.selectBtns.count == 0) return;
    
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    for (int index = 0; index < self.selectBtns.count; index++) {
        
        UIButton *btn = self.selectBtns[index];
        
        if (index == 0) {
            [path moveToPoint:btn.center];
        } else{
            [path addLineToPoint:btn.center];
        }
    }
    
    if (CGPointEqualToPoint(self.currentMovePoint, CGPointZero) == NO) {
        
        [path addLineToPoint:self.currentMovePoint];
    }
    
    path.lineWidth = 5;
    path.lineJoinStyle = kCGLineJoinBevel;
    [[UIColor colorWithRed:32/255.0 green:210/255.0 blue:254/255.0 alpha:0.5] set];
    [path stroke];
}

@end
