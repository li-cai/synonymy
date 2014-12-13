//
//  DataStore.h
//  National Parks
//
//  Created by Student on 10/14/14.
//  Copyright (c) 2014 Cailin Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataStore : NSObject
@property (nonatomic) NSMutableArray *history;

+ (instancetype) sharedStore;

@end
