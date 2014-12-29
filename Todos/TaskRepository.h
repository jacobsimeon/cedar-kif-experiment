//
//  TaskRepository.h
//  Todos
//
//  Created by pivotal on 12/29/14.
//  Copyright (c) 2014 pivotal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Task.h"

@interface TaskRepository : NSObject

+ (TaskRepository *)repositoryWithFilename:(NSString *) filename;

- (void) save:(Task *)task;

- (void) remove:(Task *) task;

- (NSArray *) readAll;

@end
