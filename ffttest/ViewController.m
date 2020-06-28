//
//  ViewController.m
//  ffttest
//
//  Created by donbe on 2020/6/23.
//  Copyright © 2020 donbe. All rights reserved.
//

#import "ViewController.h"
#import <math.h>
#import "MyScrollowView.h"
#import <Accelerate/Accelerate.h>

@interface ViewController ()<UIScrollViewDelegate>

@property(nonatomic,strong)MyScrollowView *scrollview;

@property(nonatomic,strong)MyScrollowView *fftscr;
@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    const int dsplength = 2048.0f;
    
    _scrollview = [[MyScrollowView alloc] initWithFrame:CGRectMake(0, 200, self.view.bounds.size.width, 200)];
    [self.view addSubview:_scrollview];
    _scrollview.contentSize = CGSizeMake(dsplength/2, 100);
    _scrollview.backgroundColor = [UIColor grayColor];
    _scrollview.delegate = self;
    
    _fftscr = [[MyScrollowView alloc] initWithFrame:CGRectMake(0, 450, self.view.bounds.size.width, 200)];
    [self.view addSubview:_fftscr];
    _fftscr.contentSize = CGSizeMake(dsplength/2, 100);
    _fftscr.backgroundColor = [UIColor grayColor];
    _fftscr.delegate = self;
    
    
    int frequencies[10] = {1, 5, 25, 30, 75, 100, 300, 500, 512, 1023};
    float tau = M_PI * 2;
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
    
    
    
    FFTSetup fftSetup = vDSP_create_fftsetup(11, FFT_RADIX2);
    const int halfN = dsplength / 2;
    
    float forwardInputReal[halfN] = {0};
    float forwardInputImag[halfN] = {0};
    
    
    DSPSplitComplex fftInOut;
    fftInOut.realp = forwardInputReal;
    fftInOut.imagp = forwardInputImag;
    
    vDSP_ctoz((DSPComplex*)fbuff, 2, &fftInOut, 1, (vDSP_Length)(halfN));
    vDSP_fft_zrip(fftSetup, &fftInOut,1, 11, (FFTDirection)(FFT_FORWARD));
    
    float fftNormFactor = 1.0 / (float)(dsplength);
    vDSP_vsmul(fftInOut.realp, 1, &fftNormFactor, fftInOut.realp, 1, (vDSP_Length)(halfN));
    vDSP_vsmul(fftInOut.imagp, 1, &fftNormFactor, fftInOut.imagp, 1, (vDSP_Length)(halfN));
    
    float outP[halfN];
    vDSP_zvabs(&fftInOut, 1, outP, 1, (vDSP_Length)(halfN));
    
    
    NSMutableArray *buff2 = [NSMutableArray new];
    for (int i=0; i<halfN; i++) {
        [buff2 addObject:@(outP[i])];
        if (outP[i] > 0.1) {
        NSLog(@"%d = %f",i,outP[i]);
        }
    }
    [_fftscr setdata:buff2];
    
    vDSP_destroy_fftsetup(fftSetup);

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_scrollview setNeedsDisplay];
    [_fftscr setNeedsDisplay];
}
@end
