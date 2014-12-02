//
//  Sentence.h
//  Synonymy
//
//  Created by Student on 12/1/14.
//  Copyright (c) 2014 Cailin Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Sentence : NSObject

@property (nonatomic, copy) NSString *fullsentence;
@property (nonatomic, strong) NSMutableDictionary *synonyms;

- (instancetype) initWithSentence:(NSString *)sentence;

@end
