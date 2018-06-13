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

#pragma -mark runtime应用三：对象关联



@end
