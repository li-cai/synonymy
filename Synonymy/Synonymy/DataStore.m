//
//  DataStore.m
//  National Parks
//
//  Created by Student on 10/14/14.
//  Copyright (c) 2014 Cailin Li. All rights reserved.
//

#import "DataStore.h"

@implementation DataStore

+ (id) sharedStore {
    static DataStore *sharedStore = nil;
    
    if (!sharedStore) {
        sharedStore = [[self alloc] initPrivate];
    }
    
    return sharedStore;
}

- (instancetype) init {
    @throw [NSException exceptionWithName:@"Singleton" reason:@"Use+[DataStore sharedStore]!" userInfo:nil];
}

-(instancetype) initPrivate {
    self = [super init];
    
    if (self) {
        self.history = [[NSMutableArray alloc] init];
        self.favorites = [[NSMutableArray alloc] init];
    }
    
    return self;
}

@end
