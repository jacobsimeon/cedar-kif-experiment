#import <Cedar/Cedar.h>
#import <KIF.h>
#import "FeatureSpec.h"

#import "AppDelegate.h"
#import "ViewController.h"
#import "TaskRepository.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

int taskCount = 0;
NSString* nextTaskName(){
    return [NSString stringWithFormat:@"My Task #%d", taskCount++];
}

FEATURE_SPEC_BEGIN(TodosSpec)

beforeEach(^{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"tasks"];
    
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    ViewController *vc = (ViewController*)delegate.window.rootViewController;
    vc.taskRepository = [TaskRepository repositoryWithFilename:@"tasks"];
    
    [vc.taskList reloadData];
});

describe(@"creating a new task", ^{
    it(@"adds the task to the task list", ^{
        NSString *taskName = nextTaskName();
        
        [tester tapViewWithAccessibilityLabel:@"New Task Name"];
        [tester waitForSoftwareKeyboard];
        [tester enterTextIntoCurrentFirstResponder: taskName];
        [tester tapViewWithAccessibilityLabel:@"done"];
        [tester waitForAbsenceOfSoftwareKeyboard];
        
        NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
        [tester waitForCellAtIndexPath:path inTableViewWithAccessibilityIdentifier:@"Task List"];
        
        AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
        ViewController *vc = (ViewController*)delegate.window.rootViewController;
        UIView *view = vc.view;
        
        [tester expectView: view toContainText:taskName];
        vc.taskNameField.text should equal(@"");
    });
    
    it(@"shows the task as incomplete", ^{
        NSString *taskName = nextTaskName();
        [tester tapViewWithAccessibilityLabel:@"New Task Name"];
        [tester waitForSoftwareKeyboard];
        [tester enterTextIntoCurrentFirstResponder:taskName];
        [tester tapViewWithAccessibilityLabel:@"done"];
        [tester waitForAbsenceOfSoftwareKeyboard];
        
        NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
        [tester waitForCellAtIndexPath: path inTableViewWithAccessibilityIdentifier:@"Task List"];
        
        AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
        ViewController *vc = (ViewController*)delegate.window.rootViewController;
        UITableViewCell *cell = [vc.taskList cellForRowAtIndexPath:path];
        cell.accessoryType should equal(UITableViewCellAccessoryNone);
    });
});

describe(@"toggling the completion status of a todo", ^{
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    beforeEach(^{
        [tester tapViewWithAccessibilityLabel:@"New Task Name"];
        [tester waitForSoftwareKeyboard];
        [tester enterTextIntoCurrentFirstResponder:nextTaskName()];
        [tester tapViewWithAccessibilityLabel:@"done"];
        [tester waitForAbsenceOfSoftwareKeyboard];

        [tester waitForCellAtIndexPath: path inTableViewWithAccessibilityIdentifier:@"Task List"];
        [tester tapRowAtIndexPath:path inTableViewWithAccessibilityIdentifier:@"Task List"];
    });
    
    it(@"Shows a green check mark when setting as complete", ^{
        AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
        ViewController *vc = (ViewController*)delegate.window.rootViewController;
        UITableViewCell *cell = [vc.taskList cellForRowAtIndexPath:path];
        cell.accessoryType should equal(UITableViewCellAccessoryCheckmark);
    });

    it(@"Hides the green check mark when setting as incomplete", ^{
        [tester tapRowAtIndexPath:path inTableViewWithAccessibilityIdentifier:@"Task List"];
        
        AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
        ViewController *vc = (ViewController*)delegate.window.rootViewController;
        UITableViewCell *cell = [vc.taskList cellForRowAtIndexPath:path];
        cell.accessoryType should equal(UITableViewCellAccessoryNone);
    });

});

describe(@"Deleting a task", ^{
    it(@"Removes the task from the list", ^{
        NSString *taskName = nextTaskName();
        
        [tester tapViewWithAccessibilityLabel:@"New Task Name"];
        [tester waitForSoftwareKeyboard];
        [tester enterTextIntoCurrentFirstResponder:taskName];
        [tester tapViewWithAccessibilityLabel:@"done"];
        [tester waitForAbsenceOfSoftwareKeyboard];

        [tester swipeViewWithAccessibilityLabel:taskName inDirection:KIFSwipeDirectionLeft];
        [tester tapViewWithAccessibilityLabel:@"Delete"];
        [tester waitForAbsenceOfViewWithAccessibilityLabel:taskName];
    });
});

describe(@"Editing the title of a task", ^{
    it(@"Changes the title of the task", ^{
        NSString *taskName = nextTaskName();
        [tester tapViewWithAccessibilityLabel:@"New Task Name"];
        [tester waitForSoftwareKeyboard];
        [tester enterTextIntoCurrentFirstResponder:taskName];
        [tester tapViewWithAccessibilityLabel:@"done"];
        [tester waitForAbsenceOfSoftwareKeyboard];

        [tester longPressViewWithAccessibilityLabel:taskName duration:1];
        [tester enterTextIntoCurrentFirstResponder:@"Edited task!"];
        [tester tapViewWithAccessibilityLabel:@"done"];

        AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
        ViewController *vc = (ViewController*)delegate.window.rootViewController;
        UITableViewCell *cell = [vc.taskList cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];

        [tester expectView:cell toContainText:@"Edited task!"];
    });
});

describe(@"Clearing completed todos", ^{
    beforeEach(^{
        for(int i = 0; i <= 3; i++) {
            [tester tapViewWithAccessibilityLabel:@"New Task Name"];
            [tester waitForSoftwareKeyboard];
            [tester enterTextIntoCurrentFirstResponder:nextTaskName()];
            [tester tapViewWithAccessibilityLabel:@"done"];
            [tester waitForAbsenceOfSoftwareKeyboard];
        }
    });
    
    it(@"clears any completed todos", ^{
        for(int i = 0; i <= 2; i++){
            NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:0];
            [tester tapRowAtIndexPath:path inTableViewWithAccessibilityIdentifier:@"Task List"];
        }

        AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
        ViewController *vc = (ViewController*)delegate.window.rootViewController;
        [vc tableView:vc.taskList numberOfRowsInSection:0] should equal(4);
        
        [tester tapViewWithAccessibilityLabel:@"Clear Completed"];
        [vc tableView:vc.taskList numberOfRowsInSection:0] should equal(1);
    });
});

SPEC_END