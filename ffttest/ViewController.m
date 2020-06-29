//
//  ViewController.m
//  ffttest
//
//  Created by donbe on 2020/6/23.
//  Copyright © 2020 donbe. All rights reserved.
//

#import "ViewController.h"
#import <math.h>
#import "WaveScrollView.h"
#import <Accelerate/Accelerate.h>
#import "FFT.h"
#import "SpectrumScrollView.h"

@interface ViewController ()<UIScrollViewDelegate>

@property(nonatomic,strong)WaveScrollView *scrollview;
@property(nonatomic,strong)SpectrumScrollView *spectrum;


@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1024
    const int n = 11;
    const int dsplength =  1 << n;
    
    
    // 显示原数据图
    _scrollview = [[WaveScrollView alloc] initWithFrame:CGRectMake(0, 200, self.view.bounds.size.width, 200)];
    [self.view addSubview:_scrollview];
    _scrollview.contentSize = CGSizeMake(dsplength/2, 200);
    _scrollview.delegate = self;
    
    // 显示频率视图
    _spectrum = [[SpectrumScrollView alloc] initWithFrame:CGRectMake(0, 450, self.view.bounds.size.width, 80)];
    [self.view addSubview:_spectrum];
    _spectrum.contentSize = CGSizeMake(dsplength/2, 80);
    _spectrum.delegate = self;
    
    // 频率数组，最终由以下频率组成的波形
    int frequencies[10] = {1, 5, 25, 30, 75, 100, 300, 500, 512, 1023};
    float tau = M_PI * 2;
    
    // 生成数据
    NSMutableArray *buff = [NSMutableArray new];
    float fbuff[dsplength] = {0};
    for (int i=0; i<dsplength; i++) {
        float normalizedIndex = i / 1.0f / dsplength;
        
        float total = 0;
        for (int j =0 ; j < 10; j++) {
            int feq = frequencies[j];
            total += sin(tau * normalizedIndex * feq);
        }
        
        [buff addObject:@(total)];
        fbuff[i] = total;
    }
    [_scrollview setdata:buff];
    
    
    // 初始化fft
    FFT *fft = [FFT new];
    [fft setup];
    
    float outP[dsplength/2] = {0};
    [fft performfft:fbuff out:outP];
    
    // 销毁
    [fft destroy];

    // 打印频率
    NSMutableArray *spectrumData = [NSMutableArray new];
    for (int i=0; i<dsplength/2; i++) {
        if (outP[i]>0.1) {
            NSLog(@"%d = %f",i,outP[i]);
        }
        [spectrumData addObject:@(outP[i])];
    }
    
    // 显示频率
    [_spectrum setdata:spectrumData];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_scrollview setNeedsDisplay];
    [_spectrum setNeedsDisplay];
}
@end
