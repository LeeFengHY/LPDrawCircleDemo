//
//  ViewController.m
//  LPDrawCircleDemo
//
//  Created by QFWangLP on 15/12/29.
//  Copyright © 2015年 QFWang. All rights reserved.
//

#import "ViewController.h"


#define degreesToRadians(x) (M_PI*(x)/180.0) //把角度转换成PI的方式
#define  PROGREESS_WIDTH 80 //圆直径
#define PROGRESS_LINE_WIDTH 4 //弧线的宽度
// RGB颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue)\
\
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 \
alpha:1.0]

@interface  circleLayer: UIView

{
    CAShapeLayer *_trackLayer;
    UIBezierPath *_trackPath;
    CAShapeLayer *_progressLayer;
    UIBezierPath *_progressPath;
    
    
}

@property (nonatomic, strong) UIColor *trackColor;
@property (nonatomic, strong) UIColor *progressColor;
@property (nonatomic, assign) float progress;//0~1之间的数
@property (nonatomic, assign) float progressWidth;
@property (nonatomic, strong) UILabel *titleLabel; //百分比水分label

- (void)setProgress:(float)progress animated:(BOOL)animated;

@end

@implementation circleLayer

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _trackLayer = [CAShapeLayer layer];
        _trackLayer.frame = self.bounds;
        NSLog(@"%@",NSStringFromCGRect(_trackLayer.frame));
        _trackLayer.fillColor = [UIColor redColor].CGColor;
        _trackLayer.lineCap = kCALineCapRound;
        _trackLayer.opacity = 0.25;//背景透明度
        _trackLayer.lineWidth = PROGRESS_LINE_WIDTH;
        _trackLayer.strokeColor = [[UIColor yellowColor] CGColor];
    
        //其中的参数分别指定：这段圆弧的中心，半径，开始角度，结束角度，是否顺时针方向
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(50,50) radius:(self.bounds.size.width - PROGRESS_LINE_WIDTH)/ 2 startAngle:degreesToRadians(-210) endAngle:degreesToRadians(30) clockwise:YES];
        NSLog(@"%@",NSStringFromCGPoint(self.center));
        _trackLayer.path = path.CGPath;
        [self.layer addSublayer:_trackLayer];
       
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.bounds.size.width - 80)/2, (self.bounds.size.height - 80)/2, 80, 80)];
        _titleLabel.font = [UIFont systemFontOfSize:24 weight:0.5];
        _titleLabel.textColor = [UIColor blueColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = [NSString stringWithFormat:@"%ld%@",(long)0,@"%"];
        [self addSubview:_titleLabel];

        
        _progressLayer = [CAShapeLayer layer];
        _progressLayer.frame = self.bounds;
        _progressLayer.fillColor =  [[UIColor clearColor] CGColor];
        _progressLayer.strokeColor  = [[UIColor yellowColor] CGColor];
        _progressLayer.lineCap = kCALineCapRound;
        _progressLayer.lineWidth = PROGRESS_LINE_WIDTH;
        _progressLayer.path = [path CGPath];
        _progressLayer.strokeEnd = 0;
        
        CALayer *gradientLayer = [CALayer layer];
        CAGradientLayer *gradientLayer1 =  [CAGradientLayer layer];
        gradientLayer1.frame = CGRectMake(0, 0, self.bounds.size.width/2, self.bounds.size.height);
        [gradientLayer1 setColors:[NSArray arrayWithObjects:(id)[[UIColor redColor] CGColor],(id)[UIColorFromRGB(0xfde802) CGColor], nil]];
        /*
         颜色开始进行过渡的位置
         这个数组中的元素是NSNumber类型，单调递增的，并且在0——1之间
         例如，如果我们设置两个颜色进行过渡，这个数组中写入0.5，则第一个颜色会在达到layer一半的时候开始向第二个颜色过渡
         */
        [gradientLayer1 setLocations:@[@0.5,@1]];//@[@0.5,@0.9,@1 ]];
        /*
         下面两个参数用于设置渲染颜色的起点和终点 取值范围均为0——1
         默认起点为（0.5 ，0） 终点为（0.5 ，1）,颜色的过渡范围就是沿y轴从上向下
         */
        [gradientLayer1 setStartPoint:CGPointMake(0.5, 1)];
        [gradientLayer1 setEndPoint:CGPointMake(0.5, 0)];
        [gradientLayer addSublayer:gradientLayer1];
        
        CAGradientLayer *gradientLayer2 =  [CAGradientLayer layer];
        [gradientLayer2 setLocations:@[@0.1,@0.5,@1]];
        gradientLayer2.frame = CGRectMake(self.bounds.size.width/2, 0, self.bounds.size.width/2, self.bounds.size.height);
        [gradientLayer2 setColors:[NSArray arrayWithObjects:(id)[UIColorFromRGB(0xfde802) CGColor],(id)[[UIColor blueColor] CGColor], nil]];
        [gradientLayer2 setStartPoint:CGPointMake(0.5, 0)];
        [gradientLayer2 setEndPoint:CGPointMake(0.5, 1)];
        [gradientLayer addSublayer:gradientLayer2];
        
        [gradientLayer setMask:_progressLayer]; //用progressLayer来截取渐变层
        [self.layer addSublayer:gradientLayer];
        
        
//        _progressLayer = [CAShapeLayer layer];
//        _progressLayer.frame = self.bounds;
//        _progressLayer.fillColor = [UIColor greenColor].CGColor;
//        _progressLayer.lineCap = kCALineCapRound;
//        _progressLayer.strokeColor = [UIColor yellowColor].CGColor;
//        [self.layer addSublayer:_progressLayer];
        
    }
    return self;
}
#if 0
- (void)needTack
{
    //其中的参数分别指定：这段圆弧的中心，半径，开始角度，结束角度，是否顺时针方向
    _trackPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2) radius:(self.bounds.size.width - _progressWidth)/ 2 startAngle:M_PI endAngle:-M_PI clockwise:YES];
    NSLog(@"%@",NSStringFromCGPoint(self.center));
    _trackLayer.path = _trackPath.CGPath;
}
- (void)needProgress
{
    _progressPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2) radius:(self.bounds.size.width - _progressWidth)/ 2 startAngle:-M_PI_2 endAngle:M_PI*2 *_progress - M_PI_2 clockwise:YES];
    _progressLayer.path = _progressPath.CGPath;
    
}

- (void)setProgressWidth:(float)progressWidth
{
    _progressWidth = progressWidth;
    _trackLayer.lineWidth = progressWidth;
    _progressLayer.lineWidth = progressWidth;
    [self needTack];
    [self needProgress];
}

- (void)setTrackColor:(UIColor *)trackColor
{
    _trackColor = trackColor;
    _trackLayer.strokeColor = _trackColor.CGColor;
}

- (void)setProgressColor:(UIColor *)progressColor
{
    _progressColor = progressColor;
    _progressLayer.strokeColor = progressColor.CGColor;
}

- (void)setProgress:(float)progress
{
    _progress = progress;
    [self needProgress];
}
#endif
- (void)setProgress:(float)progress animated:(BOOL)animated
{
     _progress = progress;
    [CATransaction begin];
    [CATransaction setDisableActions:!animated];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [CATransaction setAnimationDuration:0.5];
    _progressLayer.strokeEnd = _progress/100.0;
    [CATransaction commit];
    _titleLabel.text = [NSString stringWithFormat:@"%0.f%@",_progress,@"%"];
    
   
}


@end



@interface ViewController ()

@property (nonatomic, strong) circleLayer *layerView;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _layerView = [[circleLayer alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 100)/2,([UIScreen mainScreen].bounds.size.height - 100)/2, 100, 100)];
    //_layerView.backgroundColor = [UIColor lightGrayColor];
    //_layerView.progress = 0.6;
    //_layerView.progressWidth = 8;
   // _layerView.trackColor = [UIColor blueColor];
    [self.view addSubview:_layerView];
    //[ _layerView setProgress:50 animated:NO];
    

}

- (IBAction)progress:(UISlider *)sender {
    NSLog(@"%0.2f",sender.value);
    
    [ _layerView setProgress:sender.value*100 animated:YES];
}




@end
