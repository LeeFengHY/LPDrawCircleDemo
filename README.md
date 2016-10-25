# 自己学习CAShapeLayer和CAGradientLayer(渐变图层)的Demo

> CAShapeLayer是根据UIBezierPath来实现滑出各个形状的一个图层比如实现一个圆弧(实际还是矩形)

```objc
其中的参数分别指定：这段圆弧的中心，半径，开始角度，结束角度，是否顺时针方向
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(50,50) radius:(self.bounds.size.width - PROGRESS_LINE_WIDTH)/ 2 startAngle:degreesToRadians(-210) endAngle:degreesToRadians(30) clockwise:YES];
        NSLog(@"%@",NSStringFromCGPoint(self.center));
        _trackLayer.path = path.CGPath;
        [self.layer addSublayer:_trackLayer];

```

***
> 要实现一个渐变颜色的弧度换需要用到CAGradientLayer这个类来实现

```objc

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
       
```
        

#最终效果
![image](https://github.com/LeeFengHY/LPDrawCircleDemo/raw/master/image/颜色渐变.png)
