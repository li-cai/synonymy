//
//  Sentence.m
//  Synonymy
//
//  Created by Student on 12/1/14.
//  Copyright (c) 2014 Cailin Li. All rights reserved.
//

#import "Sentence.h"

@implementation Sentence

- (instancetype) initWithSentence:(NSString *)sentence {
    if (self) {
        _fullsentence = [self removeNonLettersFrom:sentence];
        
        _words = [_fullsentence componentsSeparatedByString:@" "];
        
        _synonyms = [NSMutableDictionary dictionary];
    }
    
    return self;
}

- (NSString *) removeNonLettersFrom:(NSString *)string {
    NSCharacterSet *lettersCharSet = [NSCharacterSet letterCharacterSet];
    NSCharacterSet *punctuationCharSet = [NSCharacterSet punctuationCharacterSet];
    
    NSMutableCharacterSet *validationCharSet = [lettersCharSet mutableCopy];
    [validationCharSet formUnionWithCharacterSet:punctuationCharSet];
                                                
    return [[string componentsSeparatedByCharactersInSet:
           [validationCharSet invertedSet]] componentsJoinedByString:@" "];
}

@end
