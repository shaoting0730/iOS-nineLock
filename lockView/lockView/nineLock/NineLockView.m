//
//  NineLockView.m
//  lockView
//
//  Created by Shaoting Zhou on 2018/1/24.
//  Copyright © 2018年 Shaoting Zhou. All rights reserved.
//

#import "NineLockView.h"

CGFloat const btnCount = 9; //九宫格个数
CGFloat const btnW = 74;    //单个按钮宽
CGFloat const btnH = 74;    //单个按钮高
CGFloat const viewY = 300;  //视图Y
int const columnCount = 3;   //列数
#define kScreenWidth [UIScreen mainScreen].bounds.size.width

@interface NineLockView ()
@property (nonatomic, strong) NSMutableArray * selectBtnsAry; //选中按钮的数组
@property (nonatomic, assign) CGPoint currentPoint;    //当前的点 坐标 用于判断最后一个点
@end


@implementation NineLockView

-(NSMutableArray *)selectBtnsAry{
    if(!_selectBtnsAry){
        _selectBtnsAry = [NSMutableArray array];
    }
    return _selectBtnsAry;
}

//通过代码布局时会调用这个方法
-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor clearColor];
        [self addButton];
    }
    return self;
}

//通过sb xib布局时会调用这个方法
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super initWithCoder:aDecoder]){
        [self addButton];
    }
    return self;
}

#pragma Mark - 布局按钮
- (void)addButton{
    CGFloat height = 0;;
    for (int i = 0; i < btnCount; i++) {
        UIButton * btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        btn.tag = i;
        btn.userInteractionEnabled = NO; //不可交互
        //设置默认的图片
        [btn setBackgroundImage:[UIImage imageNamed:@"gesture_normal"] forState:(UIControlStateNormal)];
        //设置选中的图片
        [btn setBackgroundImage:[UIImage imageNamed:@"gesture_selected"] forState:(UIControlStateSelected)];
        int row = i / columnCount;  //第几行
        int column = i % columnCount;   //第几列
        CGFloat margin = (self.frame.size.width - columnCount * btnW) / (columnCount + 1); //边距
        CGFloat btnX = margin + column * (btnW + margin);   //x轴
        CGFloat btnY = row * (btnW + margin);       //y轴
//        btn.backgroundColor =[UIColor redColor];
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        height = btnH + btnY;   //视图高等于 最后一个点的高+y
        [self addSubview:btn];
    }
    self.frame = CGRectMake(0, viewY, kScreenWidth, height);   //视图frame
}


- (CGPoint)pointWithTouch:(NSSet *)touches{
    UITouch * touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    return point;
}
- (UIButton *)buttonWithPoint:(CGPoint)point{
    for (UIButton * btn in self.subviews) {
        if(CGRectContainsPoint(btn.frame, point)){
            return btn;
        }
    }
    return nil;
}


#pragma Mark - 开始移动
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //1.拿到触摸的点
    CGPoint point = [self pointWithTouch:touches];
    //2.根据触摸的点拿到相应的按钮
    UIButton * btn = [self buttonWithPoint:point];
    //3.设置状态
    if(btn && btn.selected == NO){
        btn.selected = YES;
        [self.selectBtnsAry addObject:btn];
    }
    
    
}

#pragma Mark  - 移动中
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //1.拿到触摸的点
    CGPoint point = [self pointWithTouch:touches];
    //2.根据触摸的点拿到相应的按钮
    UIButton * btn = [self buttonWithPoint:point];
    //3.设置状态
    if(btn && btn.selected == NO){
        btn.selected = YES;
        [self.selectBtnsAry addObject:btn];
    }else{
        self.currentPoint = point;
    }
    [self setNeedsDisplay];
}

#pragma Mark - 结束移动
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if([self.delegete respondsToSelector:@selector(lockView:didFinishPath:)]){
        NSMutableString * path = [NSMutableString string];
        for (UIButton * btn in self.selectBtnsAry) {
            [path appendFormat:@"%ld",(long)btn.tag];
        }
        [self.delegete lockView:self didFinishPath:path];
    }
    //清空状态
    for(int i = 0; i < self.selectBtnsAry.count; i++ ){
        UIButton * button = self.selectBtnsAry[i];
        button.selected = NO;
    }
    [self.selectBtnsAry removeAllObjects];
    [self setNeedsDisplay];
}

#pragma  Mark - 取消移动
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self touchesEnded:touches withEvent:event];
}

#pragma Mark - 绘图
- (void)drawRect:(CGRect)rect{
    if(self.selectBtnsAry.count  == 0){
        return;
    }
    UIBezierPath * path = [UIBezierPath bezierPath];
    path.lineWidth = 8;
    path.lineJoinStyle = kCGLineJoinRound;
    [[UIColor colorWithRed:32/255.0 green:210/255.0 blue:254/255.0 alpha:0.5] set];
    //遍历按钮
    for(int i = 0; i < self.selectBtnsAry.count; i++ ){
        UIButton * button = self.selectBtnsAry[i];
        NSLog(@"%d",i);
        if(i == 0){
            //设置起点
            [path moveToPoint:button.center];
        }else{
            //连线
            [path addLineToPoint:button.center];
        }

    }
    [path addLineToPoint:self.currentPoint]; //最后一点 连接自己
    [path stroke];

}




@end
