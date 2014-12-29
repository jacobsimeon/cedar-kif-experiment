//
//  TaskRepository.m
//  Todos
//
//  Created by pivotal on 12/29/14.
//  Copyright (c) 2014 pivotal. All rights reserved.
//

#import "TaskRepository.h"

@interface TaskRepository ()
@property NSMutableArray *tasks;
@property NSString *fileName;
@end

@implementation TaskRepository

@synthesize fileName, tasks;

+ (TaskRepository *) repositoryWithFilename:(NSString *) fileName {
    TaskRepository *repo = [[TaskRepository alloc] init];
    repo.fileName = fileName;
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:[repo filePath]];
    if (fileExists == NO) {
        [[NSFileManager defaultManager] createFileAtPath:[repo filePath] contents:nil attributes:nil];
    } else {
        [repo loadFromFile];
    }
    
    return repo;
}

- (TaskRepository *) init {
    self = [super init];
    if(self) {
        self.tasks = [NSMutableArray array];
    }
    return self;
}

- (void) save:(Task *) task {
    if(![tasks containsObject:task]) {
        [tasks addObject:task];
    }
    
    [self saveAll];
}

- (void) remove:(Task *) task {
    [tasks removeObject:task];
    [self saveAll];
}

- (NSArray *) readAll{
    return self.tasks;
}

- (NSString *) filePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    return [documentsDirectory stringByAppendingPathComponent:self.fileName];
}

- (void) saveAll {
    [[self taskDictionaries] writeToFile:[self filePath] atomically:YES];
}

- (void) loadFromFile {
    NSArray *tasksProperties = [NSArray arrayWithContentsOfFile:[self filePath]];

    for (NSDictionary *taskAttrs in tasksProperties) {
        [self.tasks addObject:[Task taskWithDictionary:taskAttrs]];
    }
}

- (NSArray *)taskDictionaries {
    NSMutableArray *attributes = [NSMutableArray array];
    for(Task *task in self.tasks) {
        NSNumber *completed = [NSNumber numberWithBool:task.completed];
        [attributes addObject:@{@"title": task.title, @"completed": completed}];
    }
    
    return attributes;
}

@end
