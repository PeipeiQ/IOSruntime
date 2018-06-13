//
//  RuntimeManager.h
//  IOSruntime
//
//  Created by peipei on 2018/6/13.
//  Copyright © 2018年 peipei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RuntimeManager : NSObject
+(instancetype)manager;
- (instancetype)objcWithDict:(NSDictionary *)dict modelClass:(Class)modelClass mapDict:(NSDictionary *)mapDict;
-(void)getBlueColor;
@end
