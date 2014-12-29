//
//  Task.h
//  Todos
//
//  Created by pivotal on 12/19/14.
//  Copyright (c) 2014 pivotal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Task : NSObject
@property NSString *title;
@property BOOL completed;

+ taskWithTitle:(NSString *)title;
+ taskWithDictionary:(NSDictionary *)taskAttrs;

@end
