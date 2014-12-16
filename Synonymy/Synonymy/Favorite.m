//
//  Favorite.m
//  Synonymy
//
//  Created by Student on 12/16/14.
//  Copyright (c) 2014 Cailin Li. All rights reserved.
//

#import "Favorite.h"

@implementation Favorite

- (instancetype) initWithSentence:(Sentence *)sentence attrText:(NSAttributedString *)text {
    if (self) {
        _sentence = sentence;
        _highlighted = text;
    }
    
    return self;
}

@end
