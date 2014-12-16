//
//  Favorite.h
//  Synonymy
//
//  Created by Student on 12/16/14.
//  Copyright (c) 2014 Cailin Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Sentence.h"

@interface Favorite : NSObject

@property (nonatomic, strong) Sentence *sentence;
@property (nonatomic, strong) NSAttributedString *highlighted;

- (instancetype) initWithSentence:(Sentence *)sentence attrText:(NSAttributedString *)text;

@end
