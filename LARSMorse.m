//
//  Morse.m
//
//	LARSMorse.m
//  RealLED
//
//  Created by Lars Anderson on 12/7/10.
//  Copyright 2010 Lars Anderson. All rights reserved.

// Copyright (c) 2011 Lars Anderson, drink&apple
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

//
#if !TARGET_IPHONE_SIMULATOR
#import "LARSMorse.h"

#ifndef DLog
#if DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(fmt, ...) /* */
#endif
#endif


@implementation LARSMorse

- (id)initWithLARSTorch:(LARSTorch *)torch{
	if (self = [super initWithLARSTorch:torch]) {
		
	}
	self.wpm = 5;
	self.morsePlaybackCount = 0;
	self.morseArray = [NSMutableString stringWithString:@""];
	self.currentCharacterCount = 0;
    self.currentWordCount = 0;
    self.shouldAdvanceLetter = YES;  //for first letter
    self.running = NO;
	
	return self;
}

- (void)translateCharacterToMorse:(unichar)character addToArray:(NSMutableString *)characterArray{
    if(!self.morseCodeDict){
        NSBundle *morseBundle = [NSBundle bundleForClass:[LARSMorse class]];
        NSString *dictPath = [morseBundle pathForResource:@"MorseDict"
                                                   ofType:@"plist"];
        _morseCodeDict = [[NSDictionary alloc] initWithContentsOfFile:dictPath];
    }
    //DLog(@"Number of items in dict: %i", [[self morseCodeDict] count]);
    DLog(@"Current Letter: %C", character);
    NSString *appendString;

    NSString *key = [NSString stringWithFormat:@"%C",character];
    NSString *code = [[self morseCodeDict] valueForKey:key];
    if (code != nil) {
        appendString = [NSString stringWithString:code];
        if (character != ' ') {
            appendString = [NSString stringWithString:[appendString stringByAppendingString:@"+"]];
        }
    }
    else{
        //not a coded character; skip
        DLog(@"Not a coded character: %C", character);
        appendString = @"+";
    }
    
    [characterArray appendString:appendString];
}

- (void)stringToMorse:(NSString *)stringToTranslate{

	[[self morseArray] setString:@""];
	[self setOriginalString:stringToTranslate];
    
    if ([[stringToTranslate componentsSeparatedByString:@" "] count] > 0) {
        DLog(@"string has more than one word: %@", stringToTranslate);
        _wordArray = [[NSArray alloc] initWithArray:[stringToTranslate componentsSeparatedByString:@" "]];
    }
    else{
        //only one word
        DLog(@"string only has one word... %@", stringToTranslate);
        _wordArray = [[NSArray alloc] initWithObjects:stringToTranslate, nil];
    }
	
	for (int i = 0; i<[stringToTranslate length]; i++) {
		//[stringToTranslate characterAtIndex:i];
        
		[self translateCharacterToMorse:[[stringToTranslate uppercaseString] characterAtIndex:i] addToArray:[self morseArray]];
	}
	
	DLog(@"Morse String (%d): \"%@\"", [[self morseArray] length],[self morseArray]);
}

- (void)playbackMorse{
    if ([self currentCharacterCount] == 0 &&
        [self currentWordCount] == 0 &&
        [self morsePlaybackCount] == 0 &&
        [[self delegate] respondsToSelector:@selector(morseCode:didBeginEncodingText:)]) {
        [[self delegate] morseCode:self didBeginEncodingText:[self originalString]];
    }
    self.running = YES;
	 //reset for new character
    float units = 0.0;
    BOOL shouldSkipForeignLetter = NO;
    
    if (self.currentWordCount < [self.wordArray count]
        && self.currentCharacterCount < [self.originalString length]) {
        
        if ([[self delegate] respondsToSelector:@selector(morseCode:willEncodeLetters:inWord:withCode:withSpeedInWPM:)] && self.shouldAdvanceLetter) {
            
            NSString *nextLetters = [[[self originalString] substringFromIndex:self.currentCharacterCount] uppercaseString];
            
            NSString *nextLetter = [[NSString stringWithFormat:@"%C", [[self originalString] characterAtIndex:self.currentCharacterCount]] uppercaseString];
            
            if ([self.morseCodeDict objectForKey:nextLetter] == nil) {
                shouldSkipForeignLetter = YES;
            }
            
            DLog(@"Before capturing word for current word count %i", self.currentWordCount);
            NSString *wordWithLetter = [NSString stringWithFormat:@"%@",[[self wordArray] objectAtIndex:self.currentWordCount]];
            DLog(@"Captured word \"%@\" with next letters \"%@\"", wordWithLetter,nextLetters);
            
            [[self delegate] morseCode:self
                      willEncodeLetters:nextLetters
                                inWord:wordWithLetter
                                withCode:[[self morseCodeDict] objectForKey:nextLetter]
                        withSpeedInWPM:self.wpm
             ];
            DLog(@"Letter: %@   Code: %@   Symbol: %C   MorseCount: %i",
                 nextLetter, 
                 [[self morseCodeDict] objectForKey:nextLetter],
                 [self.morseArray characterAtIndex:[self morsePlaybackCount]],
                 [self morsePlaybackCount]);
        }
        
        self.shouldAdvanceLetter = NO;
        
        [self killTimer:self.morseTimer];
        
        if (((self.morsePlaybackCount < [self.morseArray length]-1)
             && ([self.morseArray length] > 0)
             && self.currentCharacterCount < [[self originalString] length])
             && shouldSkipForeignLetter == NO) {
            switch ([self.morseArray characterAtIndex:[self morsePlaybackCount]]) {
                case '.'://dot = 1 unit on
                    [self turnOn];
                    units = 1;
                    
                    break;
                case '-'://dash = 3 units on
                    [self turnOn];
                    units = 3;
                    
                    break;
                case '+':;//letter gap = 3 units off
                    [self turnOff];
                    self.currentCharacterCount++;
                    self.shouldAdvanceLetter = YES;
                    units = 3;
                    
                    break;
                case ' '://word gap = 7 units off - standard letter gap (3) = 4 unit additional off time
                    [self turnOff];
                    self.currentCharacterCount++;
                    self.currentWordCount++;
                    self.shouldAdvanceLetter = YES;
                    units = 4;
                    
                    break;
                default:
                    break;
            }
            
            self.morseTimer = [NSTimer scheduledTimerWithTimeInterval:(1.2/self.wpm)*units
                                                               target:self
                                                             selector:@selector(unitGap)
                                                             userInfo:nil
                                                              repeats:NO
                               ];
        }
        else if(shouldSkipForeignLetter == YES){
            DLog(@"Skipping foreign letter");
            self.currentCharacterCount++;
            //self.currentWordCount++;
            self.shouldAdvanceLetter = YES;
            
            self.morseTimer = [NSTimer scheduledTimerWithTimeInterval:(1.2/self.wpm)*1.0
                                                               target:self
                                                             selector:@selector(unitGap)
                                                             userInfo:nil
                                                              repeats:NO
                               ];
        }
        else {
            if ([[self delegate] respondsToSelector:@selector(morseCodeShouldAutoRepeat:)]) {
                //morse code did finish
                if ([[self delegate] morseCodeShouldAutoRepeat:self]) {
                    //should autorepeat
                    [self stopMorsePlaybackWithError:nil shouldNotify:YES withRepeat:YES];
                    
                    self.morseTimer = [NSTimer scheduledTimerWithTimeInterval:2.5
                                                                       target:self
                                                                     selector:@selector(playbackMorse)
                                                                     userInfo:nil
                                                                      repeats:NO
                                       ];
                }
                else{
                    [self stopMorsePlaybackWithError:nil shouldNotify:YES withRepeat:NO];
                }
            }
            else{
                //defaults to no
                [self stopMorsePlaybackWithError:nil shouldNotify:YES withRepeat:NO];
            }
        }
    }
    else{
        //end morse
        NSError *playbackError = [NSError errorWithDomain:@"LARSMorseError" code:500 userInfo:nil];
        [self stopMorsePlaybackWithError:playbackError shouldNotify:YES withRepeat:NO];
    }
}

- (void)unitGap{
	self.morsePlaybackCount++;
	[self turnOff]; //gap is off for one unit
	
	[self killTimer:self.morseTimer];
	
	self.morseTimer = [NSTimer scheduledTimerWithTimeInterval:(1.2/self.wpm)*1 
													   target:self
													 selector:@selector(playbackMorse)
													 userInfo:nil
													  repeats:NO
					   ];
}

- (void)stopMorsePlayback{
    [self stopMorsePlaybackWithError:nil shouldNotify:YES withRepeat:NO];
}

- (void)stopMorsePlaybackWithError:(NSError *)error shouldNotify:(BOOL)shouldNotify withRepeat:(BOOL)willRepeat{
	[self killTimer:self.morseTimer];
	[self setMorsePlaybackCount:0];
	[self setCurrentCharacterCount:0];
    [self setCurrentWordCount:0];
    [self setShouldAdvanceLetter:YES];//for first letter
    if (shouldNotify) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kLARSMorseDidFinish object:nil];
        if ([[self delegate] respondsToSelector:@selector(morseCodeDidEnd:withRepeat:withError:)]) {
            [[self delegate] morseCodeDidEnd:self withRepeat:willRepeat withError:error];
        }
        self.running = NO;
    }
    
}

- (NSString *)firstValidLetter{
    for (int i=0; i<[[self originalString] length]; i++) {
        if ([[self morseCodeDict] valueForKey:[NSString stringWithFormat:@"%C", [[self originalString] characterAtIndex:i]]]) {
            return [NSString stringWithFormat:@"%C", [[self originalString] characterAtIndex:i]];
        }
    }
    return nil;
}

- (float)unitTimeInSeconds{
    return (float)(1.20/self.wpm);
}

- (void)dealloc{
	[self killTimer:self.morseTimer];
}

@end
#endif
