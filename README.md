#LARSMorse & LARSStrobe
##LARSMorse
LARSMorse will enable the LED flash on the back of an iDevice with a flash to be used to encode strings into Morse transmissions.

###Delegate Callback Methods
    - (void)morseCode:(Morse *)morse willEncodeLetters:(NSString *)nextLetters inWord:(NSString *)currentWord withCode:(NSString *)code withSpeedInWPM:(NSInteger)wpm;
    - (void)morseCode:(Morse *)morse didBeginEncodingText:(NSString *)text;
    - (BOOL)morseCodeShouldAutoRepeat:(Morse *)morse;
    - (void)morseCodeDidEnd:(Morse *)morse withRepeat:(BOOL)willRepeat withError:(NSError *)error;
    
    - (void)morseCode:(Morse *)morse willEncodeLetters:(NSString *)nextLetters inWord:(NSString *)currentWord withCode:(NSString *)code withSpeedInWPM:(NSInteger)wpm  
Delegate callback sent before the first symbol in a letter is displayed on the LED.  Identifies the instance that sent the delegate callback (*morse*), the next four letters (*nextLetters*) that are going to be decoded in the future including the current letter, the current word the current letter is in (*currentWord*), the current code of the letter being displayed (*code*) and the speed at which the letters are being transmitted (*wpm*).

    - (void)morseCode:(Morse *)morse didBeginEncodingText:(NSString *)text
Delegate callback sent before the first letter in the *text* that is to be transmitted is transmitted.

    - (BOOL)morseCodeShouldAutoRepeat:(Morse *)morse;
Delegate callback determining whether or not the instance of *morse* should autorepeat.  Value is grabbed just after the last symbol in the last word is transmitted.
    
    - (void)morseCodeDidEnd:(Morse *)morse withRepeat:(BOOL)willRepeat withError:(NSError *)error;
Delegate callback fired when the last symbol on the last letter is transmitted in *morse*.  The method indicates whether *morse* will repeat (*willRepeat*) and if it had an *error* (not yet implemented).
    
###To Use
Create instance of LARSTorch
    LARSTorch *torch = [[LARSTorch alloc] init];

Create instance of LARSMorse and pass in LARSTorch
    LARSMorse *morse = [[LARSMorse alloc] initWithLATorch:torch];
    
Input text to encode
    [morse stringToMorse:@"Hello World"];
    
Start morse transmission
    [morse playbackMorse];
  
*Requires LARSStrobe*

##LARSStrobe
LARSStrobe will enable the LED flash on the back of an iDevice with a flash to be used as a strobe light.  This class is required for LARSMorse to function.

###To Use
Create instance of LARSTorch
    LARSTorch *torch = [[LARSTorch alloc] init];

Create instance of LARSStrobe and pass in LARSTorch
    LARSStrobe *strobe = [[LARSStrobe alloc] initWithLATorch:torch];
    
Start strobe with default settings
    [strobe startStrobe];

*Both classes require LARSTorch to function*