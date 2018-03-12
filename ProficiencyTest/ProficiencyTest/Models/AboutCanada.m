//
//  AboutCanada.m
//  ProficiencyTest
//
//  Created by Ishan on 3/12/18.
//  Copyright © 2018 Ishan. All rights reserved.
//

#import "AboutCanada.h"
#import "NSDictionary+NSDictionary.h"

@implementation AboutCanada

- (id)initWithList:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self) {
        for (NSString *key in dictionary) {
            
            if ([key isEqualToString:@"title"]) {
                self.feedTitle = [dictionary objectForKey:@"title"];
                
            } else if ([key isEqualToString:@"description"]) {
                self.feedDescription = [dictionary objectForKey:@"description"];
                
            } else if ([key isEqualToString:@"imageHref"]) {
                self.feedImageUrl = [dictionary objectForKey:@"imageHref"];
            }
        }
    }
    return self;
}

+ (NSArray *)getFeedList:(NSDictionary *)response {
    NSMutableArray *feedArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary *object in [response objectForKey:@"rows"]) {
        NSDictionary *customObject = [object dictionaryRemovingNSNullValues];
        
        [feedArray addObject:[[AboutCanada alloc] initWithList:customObject]];
    }
    
    return feedArray;
}

@end
