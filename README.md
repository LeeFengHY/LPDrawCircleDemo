# 自己学习CAShapeLayer和CAGradientLayer的Demo

> CAShapeLayer是根据UIBezierPath来实现滑出各个形状的一个图层比如实现一个圆弧(实际还是矩形)

    其中的参数分别指定：这段圆弧的中心，半径，开始角度，结束角度，是否顺时针方向
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(50,50) radius:(self.bounds.size.width - PROGRESS_LINE_WIDTH)/ 2 startAngle:degreesToRadians(-210) endAngle:degreesToRadians(30) clockwise:YES];
        NSLog(@"%@",NSStringFromCGPoint(self.center));
        _trackLayer.path = path.CGPath;
        [self.layer addSublayer:_trackLayer];
