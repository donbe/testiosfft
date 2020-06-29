//
//  MyScrollowView.m
//  ffttest
//
//  Created by donbe on 2020/6/23.
//  Copyright © 2020 donbe. All rights reserved.
//

#import "WaveScrollView.h"

@interface WaveScrollView(){
    NSArray *drawdata;
}

@end

@implementation WaveScrollView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:241.0/255.0 green:241.0/255.0 blue:241.0/255.0 alpha:1];
    }
    return self;
}

-(void)setdata:(NSArray *)data{
    self->drawdata = data;
    [self setNeedsDisplay];
}


-(void)drawRect:(CGRect)rect{

    int offsetx = MAX(0, self.contentOffset.x);
    // 缩放因子
    float scale = 0.5;
    
    for (int i=MAX(offsetx-100, 0) / scale; i< MIN(offsetx / scale + self.bounds.size.width / scale , [self->drawdata count]); i++) {

        float y = self.bounds.size.height/2 - 10 * [self->drawdata[i] floatValue];
        CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(i*scale,y,scale,scale));
        
        
        // 画刻度
        if (i % 100 == 0) {
            
            NSString *str = [NSString stringWithFormat:@"%d", i];
            NSDictionary *attr = @{
                NSFontAttributeName:[UIFont systemFontOfSize:8],
                NSForegroundColorAttributeName:[UIColor blackColor]
            };
            
            CGRect rect = [str boundingRectWithSize:CGSizeMake(100, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil];
            
            [str drawAtPoint:CGPointMake(i * scale - rect.size.width/2, self.bounds.size.height - 22) withAttributes:attr];
            
            CGContextFillRect(UIGraphicsGetCurrentContext(),
                              CGRectMake(i * scale,
                                         self.bounds.size.height - 10,
                                         0.5,
                                         self.bounds.size.height
                                         )
                              );
        }
    }
    
    //画底线
    CGContextFillRect(UIGraphicsGetCurrentContext(),
                      CGRectMake(offsetx,
                                 self.bounds.size.height - 0.5,
                                 self.bounds.size.width,
                                 self.bounds.size.height
                                 )
                      );
    
}


@end
