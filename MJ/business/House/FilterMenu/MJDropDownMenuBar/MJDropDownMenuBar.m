//
//  MJDropDownMenuBar.m
//  MJ
//
//  Created by harry on 15/5/12.
//  Copyright (c) 2015年 Simtoon. All rights reserved.
//


#define INDICATOR_COLOR [UIColor blackColor]
#define TEXT_COLOR [UIColor darkGrayColor]
#define TEXT_HIGHLIGHT_COLOR [UIColor colorWithRed:0x01/255.0 green:0xAF/255.0 blue:0xE8/255.0 alpha:1]
#define SEPER_COLOR [UIColor colorWithWhite:0.9 alpha:1.0]
#define BG_COLOR [UIColor colorWithWhite:0.0 alpha:0.5]

#import "MJDropDownMenuBar.h"
#import "MJDropDownMenu.h"


@interface MJDropDownMenuBar ()
@property (nonatomic, assign) NSInteger currentSelectedMenudIndex;
@property (nonatomic, assign) BOOL show;
@property (nonatomic, assign) NSInteger numOfColumn;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, strong) UIView *backGroundView;


//layers array
@property (nonatomic, copy) NSArray *titles;
@property (nonatomic, copy) NSArray *indicators;

@end


@implementation MJDropDownMenuBar





#pragma mark - setter
- (void)setDataSource:(id<MJDropDownMenuBarDataSource>)dataSource
{
    _dataSource = dataSource;
    
    

    //configure view
    if ([_dataSource respondsToSelector:@selector(NumberOfColumns:)])
    {
        _numOfColumn = [_dataSource NumberOfColumns:self];
    }
    else
    {
        _numOfColumn = 1;
    }
    
    CGFloat textLayerInterval = self.frame.size.width / ( _numOfColumn * 2);
    CGFloat separatorLineInterval = self.frame.size.width / _numOfColumn;

    
    NSMutableArray *tempTitles = [[NSMutableArray alloc] initWithCapacity:_numOfColumn];
    NSMutableArray *tempIndicators = [[NSMutableArray alloc] initWithCapacity:_numOfColumn];

    
    for (int i = 0; i < _numOfColumn; i++)
    {
        //title
        CGPoint titlePosition = CGPointMake( (i * 2 + 1) * textLayerInterval , self.frame.size.height / 2);
        NSString *titleString = [_dataSource MJDropDownMenuBar:self TitleForColumn:i];
        CATextLayer *title = [self createTextLayerWithNSString:titleString withColor:self.textColor andPosition:titlePosition];
        [self.layer addSublayer:title];
        [tempTitles addObject:title];
        
        //indicator
        CAShapeLayer *indicator = [self createIndicatorWithColor:_indicatorColor andPosition:CGPointMake(titlePosition.x + title.bounds.size.width / 2 + 8, self.frame.size.height / 2)];
        [self.layer addSublayer:indicator];
        [tempIndicators addObject:indicator];
        
        //separator
        if (i != _numOfColumn - 1)
        {
            CGPoint separatorPosition = CGPointMake((i + 1) * separatorLineInterval, self.frame.size.height / 2);
            CAShapeLayer *separator = [self createSeparatorLineWithColor:self.separatorColor andPosition:separatorPosition];
            [self.layer addSublayer:separator];
        }
        
        
    }
    _titles = [tempTitles copy];
    _indicators = [tempIndicators copy];

}

#pragma mark - init method
- (instancetype)initWithOrigin:(CGPoint)origin andHeight:(CGFloat)height
{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    self = [self initWithFrame:CGRectMake(origin.x, origin.y, screenSize.width, height)];
    if (self)
    {
        _origin = origin;
        _currentSelectedMenudIndex = -1;
        _show = NO;
        
        self.separatorColor = SEPER_COLOR;
        self.textColor = TEXT_COLOR;
        self.indicatorColor = INDICATOR_COLOR;
        self.bgColor = BG_COLOR;
        
        //self tapped
        self.backgroundColor = [UIColor whiteColor];
        UIGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(menuTapped:)];
        [self addGestureRecognizer:tapGesture];
        
        //background init and tapped
        _backGroundView = [[UIView alloc] initWithFrame:CGRectMake(origin.x, origin.y, screenSize.width, screenSize.height)];
        _backGroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        _backGroundView.opaque = NO;
        UIGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapped:)];
        [_backGroundView addGestureRecognizer:gesture];
        
        //add top shadow
        UIView *topShadow = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, 0.5)];
        topShadow.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:topShadow];
        
        //add bottom shadow
        UIView *bottomShadow = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-0.5, screenSize.width, 0.5)];
        bottomShadow.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:bottomShadow];
    }
    return self;
}

#pragma mark - init support

- (CAShapeLayer *)createIndicatorWithColor:(UIColor *)color andPosition:(CGPoint)point {
    CAShapeLayer *layer = [CAShapeLayer new];
    
    UIBezierPath *path = [UIBezierPath new];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(8, 0)];
    [path addLineToPoint:CGPointMake(4, 5)];
    [path closePath];
    
    layer.path = path.CGPath;
    layer.lineWidth = 1.0;
    layer.fillColor = color.CGColor;
    
    CGPathRef bound = CGPathCreateCopyByStrokingPath(layer.path, nil, layer.lineWidth, kCGLineCapButt, kCGLineJoinMiter, layer.miterLimit);
    layer.bounds = CGPathGetBoundingBox(bound);
    
    layer.position = point;
    
    return layer;
}

- (CAShapeLayer *)createSeparatorLineWithColor:(UIColor *)color andPosition:(CGPoint)point {
    CAShapeLayer *layer = [CAShapeLayer new];
    
    UIBezierPath *path = [UIBezierPath new];
    [path moveToPoint:CGPointMake(160,0)];
    [path addLineToPoint:CGPointMake(160, 15)];
    
    layer.path = path.CGPath;
    layer.lineWidth = 2.0;
    layer.strokeColor = color.CGColor;
    
    CGPathRef bound = CGPathCreateCopyByStrokingPath(layer.path, nil, layer.lineWidth, kCGLineCapButt, kCGLineJoinMiter, layer.miterLimit);
    layer.bounds = CGPathGetBoundingBox(bound);
    
    layer.position = point;
    return layer;
}

- (CATextLayer *)createTextLayerWithNSString:(NSString *)string withColor:(UIColor *)color andPosition:(CGPoint)point {
    
    CGSize size = [self calculateTitleSizeWithString:string];
    
    CATextLayer *layer = [CATextLayer new];
    CGFloat sizeWidth = (size.width < (self.frame.size.width / _numOfColumn) - 30) ? size.width : self.frame.size.width / _numOfColumn - 30;
    
    //CGFloat sizeWidth = ((self.frame.size.width / _numOfColumn) - 15);
    layer.bounds = CGRectMake(0, 0, sizeWidth, size.height);
    layer.string = string;
    layer.fontSize = 12;
    layer.alignmentMode = kCAAlignmentCenter;
    layer.foregroundColor = color.CGColor;
    
    layer.contentsScale = [[UIScreen mainScreen] scale];
    
    layer.position = point;
    
    return layer;
}

- (CGSize)calculateTitleSizeWithString:(NSString *)string
{
    CGFloat fontSize = 12;
    NSDictionary *dic = @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]};
    CGSize size = [string boundingRectWithSize:CGSizeMake(280, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    return size;
}

#pragma mark - gesture handle
- (void)menuTapped:(UITapGestureRecognizer *)paramSender
{
    CGPoint touchPoint = [paramSender locationInView:self];
    //calculate index
    NSInteger tapIndex = touchPoint.x / (self.frame.size.width / _numOfColumn);
 
    for (int i = 0; i < _numOfColumn; i++)
    {
        if (i != tapIndex)
        {
            [self animateIndicator:_indicators[i] Forward:NO complete:^{
                [self animateTitle:_titles[i] show:NO complete:^{
                    
                }];
            }];
        }
    }
    
    //点击了当前已经展开的菜单项
    if (tapIndex == _currentSelectedMenudIndex && _show)
    {
        //关闭背景,移除当前菜单
        [self WillDismissView:nil AtIndex:tapIndex];
        [self animateAtIndex:_currentSelectedMenudIndex forward:NO complecte:^{
            [self hideCurMenu];
            _currentSelectedMenudIndex = tapIndex;
            _show = NO;
            
        }];
    }
    else
    {
        //当前没有菜单展开，点击了某个菜单项
        if (!_show)
        {
            //打开背景,展开第一个菜单
            
            [self willPresentView:nil AtIndex:tapIndex];
            [self animateAtIndex:tapIndex forward:YES complecte:^{
                [self tapMenuOfIndex:tapIndex];
                 _currentSelectedMenudIndex = tapIndex;
                _show = YES;
            }];
        }
        //当前有菜单展开,点击了不是当前展开的菜单项
        else//if(tapIndex != _currentSelectedMenudIndex && _show)
        {
            //关闭当前菜单,打开点击的菜单项
//            [self hideCurMenu];
//            [self tapMenuOfIndex:tapIndex];
//            _currentSelectedMenudIndex = tapIndex;
//            _show = YES;
            
            [self animateAtIndex:tapIndex forward:YES complecte:^{
                [self WillDismissView:nil AtIndex:_currentSelectedMenudIndex];
                [self hideCurMenu];
                [self willPresentView:nil AtIndex:tapIndex];
                [self tapMenuOfIndex:tapIndex];
                _currentSelectedMenudIndex = tapIndex;
                _show = YES;
            }];
        }
//        else
//        {
//            
//            [self animateAtIndex:tapIndex forward:YES complecte:^{
//                [self tapMenuOfIndex:tapIndex];
//                _currentSelectedMenudIndex = tapIndex;
//                
//                _show = YES;
//            }];
//        }
       
        
    }
}

- (void)backgroundTapped:(UITapGestureRecognizer *)paramSender
{
    
    [self closeCurrentMenu];
    
}

#pragma mark - animation method
- (void)animateIndicator:(CAShapeLayer *)indicator Forward:(BOOL)forward complete:(void(^)())complete {
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.25];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithControlPoints:0.4 :0.0 :0.2 :1.0]];
    
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    anim.values = forward ? @[ @0, @(M_PI) ] : @[ @(M_PI), @0 ];
    
    if (!anim.removedOnCompletion) {
        [indicator addAnimation:anim forKey:anim.keyPath];
    } else {
        [indicator addAnimation:anim forKey:anim.keyPath];
        [indicator setValue:anim.values.lastObject forKeyPath:anim.keyPath];
    }
    
    [CATransaction commit];
    
    complete();
}

- (void)animateBackGroundView:(UIView *)view show:(BOOL)show complete:(void(^)())complete {
    if (show)
    {
        [self.superview addSubview:view];
        [view.superview addSubview:self];
        
        [UIView animateWithDuration:0.2 animations:^{
            view.backgroundColor = self.bgColor;
        }];
    }
    else
    {
        [UIView animateWithDuration:0.2 animations:^{
            view.backgroundColor = [UIColor clearColor];
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
    }
    complete();
}


- (void)animateTitle:(CATextLayer *)title show:(BOOL)show complete:(void(^)())complete {

    if (show)
    {
        [title setForegroundColor:TEXT_HIGHLIGHT_COLOR.CGColor];
    }
    else
    {
        [title setForegroundColor:self.textColor.CGColor];
    }

    complete();
}


- (void)animateAtIndex:(NSInteger)index forward:(BOOL)forward complecte:(void(^)())complete{
    
    if (index < MIN(_indicators.count, _titles.count))
    {
        [self animateIndicator:_indicators[index] Forward:forward complete:^{
            [self animateTitle:_titles[index] show:forward complete:^{

                [self animateBackGroundView:_backGroundView show:forward complete:^
                 {
                     complete();
                 }];
            }];
        }];
    }

}

-(void)tapMenuOfIndex:(NSInteger)index
{
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(MJDropDownMenuBar:MenuForColumn:)])
    {
        MJDropDownMenu*menu = [self.dataSource MJDropDownMenuBar:self MenuForColumn:index];
        if (menu)
        {
            [menu menuTappedOnView:self.superview];
        }
        
    }
}




-(void)WillDismissView:(id)view AtIndex:(NSInteger)index
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(MJDropDownMenuBar:WillDismissView:atIndex:)])
    {
        [self.delegate MJDropDownMenuBar:self WillDismissView:nil atIndex:index];
    }
    
    
}

-(void)willPresentView:(id)view AtIndex:(NSInteger)index
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(MJDropDownMenuBar:WillPresentView:atIndex:)])
    {
        [self.delegate MJDropDownMenuBar:self WillPresentView:nil atIndex:index];
    }
}


-(void)updateTitle:(NSString*)title ForIndex:(NSInteger)index
{
    if (title != nil && title.length >0 && self.titles != nil && index < self.titles.count && self.titles[index] != nil)
    {
        CATextLayer* layer = [self.titles objectAtIndex:index];
        if ([layer isKindOfClass:[CATextLayer class]])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                layer.string = title;
                [layer setNeedsLayout];
            });
        }
        
    }
}


-(void)hideCurMenu
{
    [self tapMenuOfIndex:_currentSelectedMenudIndex];
}


-(void)closeCurrentMenu
{
    if (_show)
    {
        [self hideCurMenu];
        [self animateAtIndex:_currentSelectedMenudIndex forward:NO complecte:^{
            [self WillDismissView:nil AtIndex:_currentSelectedMenudIndex];
            _show = NO;
        }];
    }
    
    
}


@end
