//
//  NSObject+MethodSwizzing.m
//  IOSruntime
//
//  Created by peipei on 2018/6/13.
//  Copyright © 2018年 peipei. All rights reserved.
//

#import "NSObject+MethodSwizzing.h"
#import <objc/runtime.h>

@implementation NSObject (MethodSwizzing)

+(void)load{
    Method originMethod = class_getInstanceMethod([self class], @selector(setValue:forKey:));
    Method myMethod = class_getInstanceMethod([self class], @selector(pp_setValue:forKey:));
    method_exchangeImplementations(originMethod, myMethod);
}

-(void)pp_setValue:(id)value forKey:(NSString *)key{
    NSLog(@"value:%@,key:%@",value,key);
    [self pp_setValue:value forKey:key];
}

@end
