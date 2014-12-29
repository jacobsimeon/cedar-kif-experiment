#import <Cedar/Cedar.h>
#import <KIF.h>
#import "FeatureSpec.h"

#import "AppDelegate.h"
#import "ViewController.h"
#import "TaskRepository.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

FEATURE_SPEC_BEGIN(TaskRepositorySpec)

describe(@"TaskRepository", ^{
    __block NSString *filePath;
    
    beforeEach(^{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        filePath = [documentsDirectory stringByAppendingPathComponent:@"tasks"];
        
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    });
    
    describe(@"#save", ^{
        it(@"saves tasks", ^{
            TaskRepository *repo = [TaskRepository repositoryWithFilename:@"tasks"];
            Task *newTask = [Task taskWithTitle:@"my new task"];
            
            [repo save:newTask];

            NSArray *tasksProperties = [NSArray arrayWithContentsOfFile:filePath];
            tasksProperties.count should equal(1);
            NSDictionary *taskAttributes = [tasksProperties objectAtIndex:0];
            taskAttributes[@"title"] should equal(@"my new task");
            taskAttributes[@"completed"] should equal([NSNumber numberWithInt:0]);
            
            Task *anotherTask = [Task taskWithTitle:@"another task"];
            anotherTask.completed = YES;
            [repo save:anotherTask];
            
            tasksProperties = [NSArray arrayWithContentsOfFile:filePath];
            tasksProperties.count should equal(2);
            taskAttributes = [tasksProperties objectAtIndex:1];
            taskAttributes[@"title"] should equal(@"another task");
            taskAttributes[@"completed"] should equal([NSNumber numberWithInt:1]);
        });
        
        it(@"updates previously saved tasks", ^{
            TaskRepository *repo = [TaskRepository repositoryWithFilename:@"tasks"];
            Task *task = [Task taskWithTitle:@"my new task"];
            [repo save:task];
            task.title = @"my edited task";
            [repo save:task];
            
            NSArray *tasksProperties = [NSArray arrayWithContentsOfFile:filePath];
            tasksProperties.count should equal(1);
            NSDictionary *taskAttributes = [tasksProperties objectAtIndex:0];
            taskAttributes[@"title"] should equal(@"my edited task");
            taskAttributes[@"completed"] should equal([NSNumber numberWithInt:0]);
        });
    });
    
    describe(@"#remove", ^{
        it(@"removes tasks", ^{
            TaskRepository *repo = [TaskRepository repositoryWithFilename:@"tasks"];
            Task *task = [Task taskWithTitle:@"my task"];
            [repo save:task];
            
            [repo remove:task];
            
            NSArray *tasksProperties = [NSArray arrayWithContentsOfFile:filePath];
            tasksProperties.count should equal(0);
        });
        
        it(@"handles tasks not previously saved", ^{
            TaskRepository *repo = [TaskRepository repositoryWithFilename:@"tasks"];
            Task *task = [Task taskWithTitle:@"my task"];
            [repo remove:task];

            NSArray *tasksProperties = [NSArray arrayWithContentsOfFile:filePath];
            tasksProperties.count should equal(0);
        });
    });
    
    describe(@"#readAll", ^{
        it(@"returns an array of tasks, one for each line", ^{
            TaskRepository *repo = [TaskRepository repositoryWithFilename:@"tasks"];

            Task *task = [Task taskWithTitle:@"my task"];
            [repo save:task];
            task = [Task taskWithTitle:@"another task"];
            [repo save: task];
            task = [Task taskWithTitle:@"a third task"];
            [repo save: task];
            
            repo = [TaskRepository repositoryWithFilename:@"tasks"];
            NSArray *tasks = [repo readAll];

            tasks.count should equal(3);
            
            task = [tasks objectAtIndex:0];
            task.title should equal(@"my task");
            
            task = [tasks objectAtIndex:1];
            task.title should equal(@"another task");
            
            task = [tasks objectAtIndex:2];
            task.title should equal(@"a third task");
        });
    });
});


SPEC_END
