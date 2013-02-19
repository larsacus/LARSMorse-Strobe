//
//  LARSStrobe.m
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
#import "LARSStrobe.h"

@implementation LARSStrobe

@synthesize torch = _torch,
            period, 
            strobeTimer, 
            strobeTimerOff,
            originalFlashlightState, 
            shouldStopStrobe;

- (id)initWithLARSTorch:(LARSTorch *)torch{
	if(self = [super init]){
		//perform setup here
		[self setTorch:torch];
	}
	self.originalFlashlightState = [[self torch] isTorchOn];
	self.period = 0.5;
	return self;
}

- (void)toggleStrobe{	
	//activate the LED
	if ([self torch]){
        BOOL torchState = [[self torch] isTorchOn];
        
        [[self torch] setTorchState:!torchState];
        
        [self killTimer:strobeTimerOff];

        if (!torchState)
			self.strobeTimerOff = [NSTimer scheduledTimerWithTimeInterval:0.005 //basically as fast as it will switch
																   target:self 
																 selector:@selector(turnOff) 
																 userInfo:nil 
																  repeats:NO];
	}
}

- (void)toggleStrobeWithDutyCycle:(float)dutyCycle{
	if ([self torch]){
        BOOL torchState = [[self torch] isTorchOn];
        
        [[self torch] setTorchState:!torchState];
        
        [self killTimer:strobeTimerOff];
        
        if (!torchState)
            self.strobeTimerOff = [NSTimer scheduledTimerWithTimeInterval:self.period*dutyCycle
																   target:self 
																 selector:@selector(turnOff) 
																 userInfo:nil 
																  repeats:NO];
	}
}

- (void)toggleStrobeWithTimeOn:(float)timeOn{
	if ([self torch]){
		
		BOOL torchState = [[self torch] isTorchOn];
        
        [[self torch] setTorchState:!torchState];
        
        [self killTimer:strobeTimerOff];
		
		self.strobeTimerOff = [NSTimer scheduledTimerWithTimeInterval:timeOn
															   target:self 
															 selector:@selector(turnOff) 
															 userInfo:nil 
															  repeats:NO];
    }
}

- (void)turnOff{
	if ([self torch]) {
        [[self torch] setTorchState:NO];
    }
}

- (void)turnOn{
	if ([self torch]) {
        [[self torch] setTorchState:YES];
    }
}

- (void)killTimer:(NSTimer *)timer{
	if ([timer isValid]) {
		[timer invalidate];
		timer = nil;
	}
	else {
		timer = nil;
	}
}

- (void)beginStrobeWithOnFraction:(CGFloat)fractionOn period:(NSInteger *)time times:(NSInteger *)times repeat:(BOOL)repeat{	
	self.period = 0.1;
	if (!strobeTimer) {
		self.strobeTimer = [NSTimer scheduledTimerWithTimeInterval:self.period/2
															  target:self 
															selector:@selector(toggleStrobe) 
															userInfo:nil 
															 repeats:repeat];
	}
}

- (void)startStrobe{
	if (self.period > 2 || self.period < 0.1) {
		self.period = 0.1;
	}
	//if (!strobeTimer) {
		self.strobeTimer = [NSTimer scheduledTimerWithTimeInterval:self.period/2
															target:self 
														  selector:@selector(toggleStrobe) 
														  userInfo:nil 
														   repeats:YES];
	//}
}

- (void)stopStrobe{
	[self killTimer:strobeTimer];
	[self killTimer:strobeTimerOff];
}

- (BOOL)isRunning{
	if ([strobeTimer isValid]) {
		return YES;
	}
	else {
		return NO;
	}
}


- (void)setStrobePeriodWithPeriod:(float)newPeriod{
	self.period = newPeriod;
}

- (void)setStrobePeriodWithFrequency:(float)newFrequency{
	self.period = 1/newFrequency;
}

- (void)restoreFlashlightState{
	if (self.originalFlashlightState) {
		[[self torch] setTorchState:self.originalFlashlightState];
	}
}

- (void)setIdleTimerDisabled:(BOOL)disabled{
    [UIApplication sharedApplication].idleTimerDisabled = disabled;
}

- (void)dealloc{
	[self killTimer:strobeTimerOff];
	[self killTimer:strobeTimer];
}

@end
#endif
