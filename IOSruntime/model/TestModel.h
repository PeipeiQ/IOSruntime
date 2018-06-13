//
//  TestModel.h
//  IOSruntime
//
//  Created by peipei on 2018/6/13.
//  Copyright © 2018年 peipei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestModel : NSObject
@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *city;
@property(nonatomic,assign) NSInteger age;
@property(nonatomic,strong) NSString *country;
@property(nonatomic,strong) NSArray *game;

@end
