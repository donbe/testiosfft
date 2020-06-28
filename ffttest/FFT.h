//
//  FFT.h
//  ffttest
//
//  Created by donbe on 2020/6/28.
//  Copyright © 2020 donbe. All rights reserved.
//


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface FFT : NSObject


/// 初始化fft矩阵
-(void)setup;

/// 销毁fft矩阵
-(void)destroy;

/// 执行fft操作
/// @param indata 输入数据，大小2048
/// @param outdata 输出数据，大小1024
-(void)performfft:(float *)indata out:(float *)outdata;


@end

NS_ASSUME_NONNULL_END
