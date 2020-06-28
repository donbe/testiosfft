//
//  FFT.m
//  ffttest
//
//  Created by donbe on 2020/6/28.
//  Copyright © 2020 donbe. All rights reserved.
//

#import "FFT.h"
#import <Accelerate/Accelerate.h>



static const int n = 11;
static const int fftsize =  1 << n;
static const int halfSize = fftsize / 2;

@interface FFT(){
    FFTSetup fftSetup;
}
    
@end

@implementation FFT

-(void)setup{
    fftSetup = vDSP_create_fftsetup(n, FFT_RADIX2);
}

-(void)destroy{
    vDSP_destroy_fftsetup(fftSetup);
}


-(void)performfft:(float *)indata out:(float *)outdata{
    float forwardInputReal[halfSize] = {0}; // 实数部分
    float forwardInputImag[halfSize] = {0}; // 虚数部分
    DSPSplitComplex fftInOut;
    fftInOut.realp = forwardInputReal;
    fftInOut.imagp = forwardInputImag;
    
    // 转换成ios特有的fft数据格式
    // 具体参考 vDSP Programming Guide ： Using Fourier Transforms
    vDSP_ctoz((DSPComplex*)indata, 2, &fftInOut, 1, (vDSP_Length)(halfSize));
    
    // 执行fft
    vDSP_fft_zrip(fftSetup, &fftInOut,1, n, (FFTDirection)(FFT_FORWARD));
    
    // 缩放结果
    float fftNormFactor = 1.0 / (float)(fftsize);
    vDSP_vsmul(fftInOut.realp, 1, &fftNormFactor, fftInOut.realp, 1, (vDSP_Length)(halfSize));
    vDSP_vsmul(fftInOut.imagp, 1, &fftNormFactor, fftInOut.imagp, 1, (vDSP_Length)(halfSize));
    
    // 合并实部和虚部（平方和后开方），填充到outdata，结果范围和采样点值范围一致
    vDSP_zvabs(&fftInOut, 1, outdata, 1, (vDSP_Length)(halfSize));
}

@end
