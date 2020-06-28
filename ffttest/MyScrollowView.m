//
//  MyScrollowView.m
//  ffttest
//
//  Created by donbe on 2020/6/23.
//  Copyright © 2020 donbe. All rights reserved.
//

#import "MyScrollowView.h"

@interface MyScrollowView(){
    NSArray *drawdata;
}

@end

@implementation MyScrollowView


-(void)setdata:(NSArray *)data{
    self->drawdata = data;
    
    [self setNeedsDisplay];
}


-(void)drawRect:(CGRect)rect{

    int offsetx = MAX(0, self.contentOffset.x);
    
    for (int i=offsetx*2; i< MIN(offsetx*2+self.bounds.size.width*2, [self->drawdata count]); i++) {
    
        float y = self.bounds.size.height/2 - 10 * [self->drawdata[i] floatValue];
        CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(i*0.5,y,1,1));
        
    }
    
}


@end
