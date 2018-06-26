//
//  NSArray+runtimeTest.h
//  IOSruntime
//
//  Created by 沛沛 on 2018/6/15.
//  Copyright © 2018年 peipei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (runtimeTest)

//尝试为分类添加一个属性，并用runtime的对象关联去实现它的getter，setter方法
@property(nonatomic,copy) NSString *arrName;

@end
