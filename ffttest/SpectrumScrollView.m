//
//  SpectrumScrollView.m
//  ffttest
//
//  Created by donbe on 2020/6/29.
//  Copyright © 2020 donbe. All rights reserved.
//

#import "SpectrumScrollView.h"


@interface SpectrumScrollView(){
    NSArray *drawdata;
}

@end

@implementation SpectrumScrollView

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
    
    for (int i=offsetx*2; i< MIN(offsetx*2+self.bounds.size.width*2, [self->drawdata count]); i++) {
    
        float y = self.bounds.size.height/2 - 10 * [self->drawdata[i] floatValue];
        CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(i*0.5,y,0.5,10*[self->drawdata[i] floatValue]));
        
    }
    
}
@end
