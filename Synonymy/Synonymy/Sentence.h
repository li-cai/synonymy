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
@property (nonatomic, strong) NSArray *words;
@property (nonatomic, strong) NSMutableDictionary *synonyms;
@property (nonatomic, strong) NSMutableDictionary *syncount;
@property (nonatomic, strong) NSMutableDictionary *origin;
@property (nonatomic, strong) NSMutableDictionary *rangeToWord;
@property (nonatomic) BOOL isFavorite;
@property (nonatomic, copy) NSString *currentword;
@property (nonatomic, copy) NSString *originalrange;

- (instancetype) initWithSentence:(NSString *)sentence;

- (void) addSynonyms:(NSMutableArray *)synonyms ofWord:(NSString *)word;

@end
