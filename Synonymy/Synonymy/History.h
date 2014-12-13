//
//  History.h
//  Synonymy
//
//  Created by Student on 12/12/14.
//  Copyright (c) 2014 Cailin Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface History : NSObject
@property (nonatomic, copy) NSString *sentence;

- (instancetype) initWithSentence:(NSString *)sentence;

@end
