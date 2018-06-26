//
//  NSArray+runtimeTest.m
//  IOSruntime
//
//  Created by 沛沛 on 2018/6/15.
//  Copyright © 2018年 peipei. All rights reserved.
//

#import "NSArray+runtimeTest.h"
#import <objc/runtime.h>

static void *ArrayName = @"ArrayName";

@implementation NSArray (runtimeTest)
#pragma -mark runtime应用二：方法交换
+(void)load{
    Method m1 = class_getInstanceMethod(NSClassFromString(@"__NSArrayI"), @selector(objectAtIndex:));
    Method m2 = class_getInstanceMethod(self, @selector(pp_objectAtIndex:));
    method_exchangeImplementations(m1, m2);
}

-(id)objectAtIndex:(NSUInteger)index{
    /*这个警告说明, 类目中添加的这个方法和原类的方法名一致, 运行的时候会执行这个方法, 而且也会执行原类中方法. 苹果官方文档中又说明,如果在类别中声明的方法的名称与原始类中的方法相同，或者在同一类（或甚至超类）上的另一类中的方法相同，那么该行为对于使用哪种方法实现是未定义的运行。 如果您使用自己的类使用类别，那么这不太可能成为问题，但是在使用类别添加标准Cocoa或Cocoa Touch类的方法时可能会导致问题。
     */
    /*
     解决方案
     用继承的方式重写父类方法
     用类目重写原类的方法, 需要通过runtime的method swizzling来进行方法IMP的交换处理.
     */
    NSLog(@"%s",__func__);
    return nil;
}

-(id)pp_objectAtIndex:(NSUInteger)index{
    if (index>self.count-1) {
        NSLog(@"__%@__数组越界",self);
        return nil;
    }else{
        return [self pp_objectAtIndex:index];
    }
}

#pragma -mark runtime应用三：对象关联
-(void)setArrName:(NSString *)arrName{
    objc_setAssociatedObject(self, ArrayName, arrName, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(NSString *)arrName{
    return objc_getAssociatedObject(self, ArrayName);
}



@end
