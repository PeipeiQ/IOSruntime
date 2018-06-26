//
//  RuntimeManager.m
//  IOSruntime
//
//  Created by peipei on 2018/6/13.
//  Copyright © 2018年 peipei. All rights reserved.
//

#import "RuntimeManager.h"
#import <objc/runtime.h>
@interface RuntimeManager()
@property(nonatomic,strong) NSString *name;
@end

@implementation RuntimeManager

+(void)load{
    Method originMethod = class_getInstanceMethod([self class], @selector(getBlueColor));
    Method myMethod = class_getInstanceMethod([self class], @selector(getOrangeColor));
    method_exchangeImplementations(originMethod, myMethod);
}

+(instancetype)manager{
    static RuntimeManager *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc]init];
    });
    return _instance;
    
}

#pragma -mark runtime应用一：字典转模型
-(void)getPropertyByRuntimeWith:(Class)desClass{
    unsigned int count;
    //属性
    objc_property_t *pro = class_copyPropertyList(desClass, &count);
    for (unsigned int i=0; i<count; i++) {
        const char *propertyName = property_getName(pro[i]);
        NSLog(@"property----="">%@", [NSString stringWithUTF8String:propertyName]);
    }
}

-(void)getIVarByRuntimeWith:(Class)desClass{
    unsigned int count;
    //获取成员变量列表
    Ivar *ivarList = class_copyIvarList(desClass, &count);
    for (unsigned int i = 0; i<count; i++) {
        Ivar myIvar = ivarList[i];
        const char *ivarName = ivar_getName(myIvar);
        NSLog(@"ivar----="">%@", [NSString stringWithUTF8String:ivarName]);
    }
}

-(void)getMethodByRuntimeWith:(Class)desClass{
    unsigned int count;
    //获取方法列表
    Method *methodList = class_copyMethodList(desClass, &count);
    for (unsigned int i = 0; i<count; i++) {
        Method method = methodList[i];
        NSLog(@"method----="">%@", NSStringFromSelector(method_getName(method)));
    }
}

-(void)getprotocolByRuntimeWith:(Class)desClass{
    unsigned int count;
    //获取协议列表
    __unsafe_unretained Protocol **protocolList = class_copyProtocolList(desClass, &count);
    for (unsigned int i = 0; i<count; i++) {
        Protocol *myProtocal = protocolList[i];
        const char *protocolName = protocol_getName(myProtocal);
        NSLog(@"protocol----="">%@", [NSString stringWithUTF8String:protocolName]);
    }
}

//利用runtime进行手动的setValuesForKeysWithDictionary:方法。可以根据一个映射表来处理未知key
- (instancetype)objcWithDict:(NSDictionary *)dict modelClass:(Class)modelClass mapDict:(NSDictionary *)mapDict
{
    id objc = [[modelClass alloc] init];
    
    
    // 遍历模型中成员变量
    unsigned int outCount = 0;
    Ivar *ivars = class_copyIvarList(modelClass, &outCount);
    
    for (int i = 0 ; i < outCount; i++) {
        Ivar ivar = ivars[i];
        
        // 成员变量名称
        NSString *ivarName = @(ivar_getName(ivar));
        
        // 获取出来的是`_`开头的成员变量名，需要截取`_`之后的字符串
        ivarName = [ivarName substringFromIndex:1];
        
        id value = dict[ivarName];
        // 由外界通知内部，模型中成员变量名对应字典里面的哪个key
        // ID -> id
        if (value == nil) {
            if (mapDict) {
                NSString *keyName = mapDict[ivarName];
                value = dict[keyName];
            }
        }
        
        if(value) {
            [objc setValue:value forKeyPath:ivarName];
        }else{
            //NSLog(@"%@实例变量在字典中找不到匹配的值",ivarName);
        }
    }
    return objc;
}

#pragma -mark runtime应用二：方法交换
//大部分情况下可以使用方法重写来解决问题。当使用方法重写无效时再考虑方法交换
-(void)getBlueColor{
    NSLog(@"blue");
}

-(void)getOrangeColor{
    NSLog(@"orange");
}
//使用场景一：在一些系统方法中动态添加一些操作。例如在setvalue:forkey:中输出value和key的值
//使用场景二：需要在category中重写一些方法


#pragma -mark runtime应用三：对象关联
/*
 主要解决的问题：分类不能添加属性
 我们知道在一个类中用@property声明属性，编译器会自动帮我们生成_成员变量和setter/getter，但分类的指针结构体中，根本没有属性列表。所以
 在分类中用@property声明属性，既无法生成_成员变量也无法生成setter/getter。
 因此结论是：我们可以用@property声明属性，编译和运行都会通过，只要不使用程序也不会崩溃。但如果调用了_成员变量和setter/getter方法，报
 错就在所难免了。
 由于OC是动态语言，方法真正的实现是通过runtime完成的，虽然系统不给我们生成setter/getter，但我们可以通过runtime手动添加setter/getter
 方法。
 */

/*
 Category
 Category 是表示一个指向分类的结构体的指针，其定义如下：
 typedef struct objc_category *Category;
 struct objc_category {
 char *category_name                          OBJC2_UNAVAILABLE; // 分类名
 char *class_name                             OBJC2_UNAVAILABLE; // 分类所属的类名
 struct objc_method_list *instance_methods    OBJC2_UNAVAILABLE; // 实例方法列表
 struct objc_method_list *class_methods       OBJC2_UNAVAILABLE; // 类方法列表
 struct objc_protocol_list *protocols         OBJC2_UNAVAILABLE; // 分类所实现的协议列表
 }
 通过上面我们可以发现，这个结构体主要包含了分类定义的实例方法与类方法，其中instance_methods 列表是 objc_class 中方法列表的一个子集，而class_methods列表是元类方法列表的一个子集。
 但这个结构体里面根本没有属性列表.
 */




@end
