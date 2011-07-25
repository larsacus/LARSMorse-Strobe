//
//	LARSMorse.h
//  Morse.h
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
#import "StrobeLight.h"

#define kDroidLightMorseDidFinish @"kDroidLightMorseDidFinish"

@class Morse;

@protocol MorseCodeDelegate <NSObject>
@optional
- (void)morseCode:(Morse *)morse willEncodeLetters:(NSString *)nextLetters inWord:(NSString *)currentWord withCode:(NSString *)code withSpeedInWPM:(NSInteger)wpm;
- (void)morseCode:(Morse *)morse didBeginEncodingText:(NSString *)text;
- (BOOL)morseCodeShouldAutoRepeat:(Morse *)morse;
- (void)morseCodeDidEnd:(Morse *)morse withRepeat:(BOOL)willRepeat withError:(NSError *)error;

@end

@interface Morse : StrobeLight {

    id <MorseCodeDelegate> _delegate;
	NSMutableString *morseArray;
    NSArray *_wordArray;
    NSDictionary *_morseCodeDict;
	NSInteger wpm;
	NSInteger morsePlaybackCount;
	NSTimer *morseTimer;
	NSInteger currentCharacterCount;
    NSInteger _currentWordCount;
	UILabel *characterLabel;
	NSString *originalString;
    BOOL _shouldAdvanceLetter;
    BOOL _running;
}

@property(retain) id delegate;

@property(nonatomic,retain) NSMutableString *morseArray;
@property(nonatomic,retain) NSArray *wordArray;
@property(nonatomic,retain) NSDictionary *morseCodeDict;
@property(nonatomic) NSInteger wpm;
@property(nonatomic) NSInteger morsePlaybackCount;
@property(nonatomic,retain) NSTimer *morseTimer;
@property(nonatomic) NSInteger currentCharacterCount;
@property(nonatomic) NSInteger currentWordCount;
@property(nonatomic,retain) UILabel *characterLabel;
@property(nonatomic,retain) NSString *originalString;
@property(nonatomic) BOOL shouldAdvanceLetter;
@property(nonatomic,getter = isRunning) BOOL running;

- (id)initWithLATorch:(LATorch *)torch;
- (void)translateCharacterToMorse:(unichar)character addToArray:(NSMutableString *)characterArray;
- (void)stringToMorse:(NSString *)stringToTranslate;
- (void)stopMorsePlayback;
- (void)stopMorsePlaybackWithError:(NSError *)error shouldNotify:(BOOL)shouldNotify withRepeat:(BOOL)willRepeat;
- (void)playbackMorse;
- (void)unitGap;
- (NSString *)firstValidLetter;
- (float)unitTimeInSeconds;
@end
#endif
