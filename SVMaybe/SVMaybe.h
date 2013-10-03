/*
 * The MIT License (MIT)
 *
 * Copyright (c) 2013 Sean Voisen
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to
 * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
 * the Software, and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
 * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#define Maybe(x)                   [SVMaybe maybe:x]
#define Nothing                    [SVMaybe nothing]
#define MapMaybe(something, value) ^SVMaybe *(id something) { return Maybe(value); }

#import <Foundation/Foundation.h>

@interface SVMaybe : NSObject
+ (SVMaybe *)nothing;
+ (SVMaybe *)maybe:(id)value;
- (SVMaybe *)andMaybe:(SVMaybe *)maybe;
- (SVMaybe *)whenSomething:(SVMaybe *(^)(id))block;
- (SVMaybe *)whenNothing:(SVMaybe *)defaultValue else:(SVMaybe *(^)(id))block;
- (SVMaybe *)whenNothing:(SVMaybe *)defaultValue;
- (id)whenNothingReturn:(id)defaultValue elseReturn:(id(^)(id))block;
- (id)whenNothingReturn:(id)defaultValue;
- (BOOL)isNothing;
- (BOOL)isSomething;
- (id)justValue;
@end