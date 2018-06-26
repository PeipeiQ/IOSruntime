//
//  ViewController.m
//  IOSruntime
//
//  Created by peipei on 2018/6/13.
//  Copyright © 2018年 peipei. All rights reserved.
//

#import "ViewController.h"
#import "RuntimeManager.h"
#import "TestModel.h"
#import <objc/runtime.h>
#import "NSArray+runtimeTest.h"


@interface ViewController ()
@property(nonatomic,strong) RuntimeManager *manager;
@end

@implementation ViewController

//+(void)load{
//    NSLog(@"load");
//}
//
//+(void)initialize{
//    NSLog(@"vc initialize");
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    _manager = [RuntimeManager manager];
    
    //runtime1:字典转模型
    NSDictionary *dict = @{@"name":@"jack",@"game":@[@1,@2,@3]};
    TestModel *model = [[TestModel alloc]init];
    model = (TestModel*)[_manager objcWithDict:dict modelClass:[TestModel class] mapDict:nil];
    //NSLog(@"%@,%ld,%@,%@",model.name,(long)model.age,model.game,model.country);
    
    //runtime2:方法交换
    [_manager getBlueColor];
    
    NSArray *array = @[@1,@2,@3];
    Class a = object_getClass(array);    //输出__NSArrayI
    NSNumber *num = [array objectAtIndex:3];
    
    //runtime3:对象关联
    array.arrName = @"abc";
    NSString *aName = array.arrName;
    NSLog(@"对象关联：%@",aName);

}

-(void)eat{
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
