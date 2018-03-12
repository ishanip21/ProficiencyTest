//
//  NSDictionary+NSDictionary.m
//  ProficiencyTest
//
//  Created by Ishan on 3/12/18.
//  Copyright © 2018 Ishan. All rights reserved.
//

#import "NSDictionary+NSDictionary.h"

@implementation NSDictionary (NSDictionary)

- (NSDictionary*)dictionaryRemovingNSNullValues {
    return [self removeNull];
}

#pragma mark - Replace null values to empty string
- (NSDictionary*)removeNull {
    
    NSMutableDictionary *replaced = [NSMutableDictionary dictionaryWithDictionary: self];
    
    const id nul = [NSNull null];
    const NSString *blank = @"";
    
    for (NSString *key in [self allKeys]) {
        
        const id object = [self objectForKey: key];
        if (object == nul) {
            [replaced setObject: blank forKey: key];
        } else if([object isKindOfClass: [NSDictionary class]]) {
            [replaced setObject: [self replaceNull:object] forKey: key];
        } else if([object isKindOfClass: [NSArray class]]) {
            [replaced setObject: [self replaceNullArray:object] forKey: key];
        }
    }
    return [NSDictionary dictionaryWithDictionary: replaced];
}

- (NSArray *)replaceNullArray:(NSArray *)array {
    
    const id nul = [NSNull null];
    const NSString *blank = @"";
    
    NSMutableArray *replaced = [NSMutableArray arrayWithArray:array];
    
    for (int i=0; i < [array count]; i++) {
        const id object = [array objectAtIndex:i];
        if (object == nul) {
            [replaced replaceObjectAtIndex:i withObject:blank];
        } else if([object isKindOfClass: [NSDictionary class]]) {
            [replaced replaceObjectAtIndex:i withObject:[self replaceNull:object]];
        } else if([object isKindOfClass: [NSArray class]]) {
            [replaced replaceObjectAtIndex:i withObject:[self replaceNullArray:object]];
        }
    }
    return replaced;
}

- (NSDictionary *)replaceNull:(NSDictionary *)dict {
    
    const id nul = [NSNull null];
    const NSString *blank = @"";
    
    NSMutableDictionary *replaced = [NSMutableDictionary dictionaryWithDictionary: dict];
    
    for (NSString *key in [dict allKeys]) {
        const id object = [dict objectForKey: key];
        if (object == nul) {
            [replaced setObject: blank forKey: key];
        } else if ([object isKindOfClass: [NSDictionary class]]) {
            [replaced setObject: [self replaceNull:object] forKey: key];
        } else if([object isKindOfClass: [NSArray class]]) {
            [replaced setObject: [self replaceNullArray:object] forKey: key];
        }
    }
    return replaced;
}

@end
