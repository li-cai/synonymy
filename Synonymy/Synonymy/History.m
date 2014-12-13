//
//  History.m
//  Synonymy
//
//  Created by Student on 12/12/14.
//  Copyright (c) 2014 Cailin Li. All rights reserved.
//

#import "History.h"

@implementation History

- (instancetype) initWithSentence:(NSString *)sentence {
    if (self) {
        _sentence = sentence;
    }
    
    return self;
}

@end
