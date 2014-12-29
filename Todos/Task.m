//
//  Task.m
//  Todos
//
//  Created by pivotal on 12/19/14.
//  Copyright (c) 2014 pivotal. All rights reserved.
//

#import "Task.h"

@implementation Task
@synthesize title;
@synthesize completed;

+ taskWithTitle:(NSString *)title {
    Task *task = [[self alloc] init];
    task.title  = title;

    return task;
}

+ (id)taskWithDictionary:(NSDictionary *)taskAttrs {
    Task *task = [[self alloc] init];
    task.title  = taskAttrs[@"title"];
    task.completed  = [taskAttrs[@"completed"] boolValue];
    
    return task;
}

@end
