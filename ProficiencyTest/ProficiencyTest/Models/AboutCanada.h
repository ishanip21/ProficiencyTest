//
//  AboutCanada.h
//  ProficiencyTest
//
//  Created by Ishan on 3/12/18.
//  Copyright © 2018 Ishan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AboutCanada : NSObject

@property (nonatomic, strong) NSString *feedTitle;
@property (nonatomic, strong) NSString *feedDescription;
@property (nonatomic, strong) NSString *feedImageUrl;
@property (nonatomic, strong) UIImage  *feedImage;

+ (NSArray *)getFeedList:(NSDictionary *)response;

@end
