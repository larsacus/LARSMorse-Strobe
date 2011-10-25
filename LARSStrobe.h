//
//  LARSStrobe.h
//  RealLED
//
//  Created by Lars Anderson on 12/7/10.
//  Copyright 2010 Lars Anderson. All rights reserved.
//
// Copyright (c) 2011 Lars Anderson, drink&apple
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#if !TARGET_IPHONE_SIMULATOR
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "LARSTorch.h"


@interface LARSStrobe : NSObject {
	
	LARSTorch *_torch;
	float period;
	NSTimer *strobeTimer;
	NSTimer *strobeTimerOff;
	BOOL originalFlashlightState;
	BOOL shouldStopStrobe;
}

@property (nonatomic,retain) LARSTorch *torch;
@property (nonatomic) float period;
@property (nonatomic,retain) NSTimer *strobeTimer;
@property (nonatomic,retain) NSTimer *strobeTimerOff;
@property (nonatomic) BOOL originalFlashlightState;
@property (nonatomic) BOOL shouldStopStrobe;

- (id)initWithLARSTorch:(LARSTorch *)torch;
- (void)toggleStrobe;
- (void)beginStrobeWithOnFraction:(CGFloat)fractionOn period:(NSInteger *)time times:(NSInteger *)times repeat:(BOOL)repeat;
- (void)startStrobe;
- (void)stopStrobe;
- (void)setStrobePeriodWithPeriod:(float)newPeriod;
- (void)setStrobePeriodWithFrequency:(float)newFrequency;
- (BOOL)isRunning;
- (void)restoreFlashlightState;
- (void)toggleStrobeWithTimeOn:(float)timeOn;
- (void)killTimer:(NSTimer *)timer;
- (void)turnOn;
- (void)turnOff;
- (void)setIdleTimerDisabled:(BOOL)disabled;
@end
#endif
