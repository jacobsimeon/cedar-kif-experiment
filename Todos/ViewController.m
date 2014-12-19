//
//  ViewController.m
//  Todos
//
//  Created by pivotal on 12/18/14.
//  Copyright (c) 2014 pivotal. All rights reserved.
//

#import "ViewController.h"
#import "TaskTableViewCell.h"

@implementation ViewController {
    IBOutlet UITextField *taskNameField;
    IBOutlet UITableView *taskList;
    
    NSMutableArray *tasks;
}

@synthesize tasks;
@synthesize taskNameField;
@synthesize taskList;

- (void)viewDidLoad {
    taskList.accessibilityIdentifier = @"Task List";
    self.taskList.allowsMultipleSelectionDuringEditing = NO;
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 1.0; //seconds
    lpgr.delegate = self;

    [self.taskList addGestureRecognizer:lpgr];
    
    [super viewDidLoad];
    self.tasks = [NSMutableArray array];
}

- (void) handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer {
    CGPoint p = [gestureRecognizer locationInView:self.taskList];
    NSIndexPath *indexPath = [self.taskList indexPathForRowAtPoint:p];
    
    if (indexPath == nil) {
        NSLog(@"long press on table view but not on a row");
    } else if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        [self tableView:self.taskList didLongPressRowAtIndexPath:indexPath];
        NSLog(@"gestureRecognizer.state = %d", (int)gestureRecognizer.state);
    } else {
        NSLog(@"gestureRecognizer.state = %d", (int)gestureRecognizer.state);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.tasks addObject:[Task taskWithTitle:textField.text]];
    [self.taskList reloadData];
    textField.text = @"";

    [textField resignFirstResponder];
    return YES;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    Task *task = [tasks objectAtIndex:indexPath.row];
    TaskTableViewCell *cell = [taskList dequeueReusableCellWithIdentifier:task.title];
    
    if(cell == nil) {
        cell = [TaskTableViewCell taskTableViewCellForTask:task];
        cell.delegate = self;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)view didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Selected");
    Task *task = [tasks objectAtIndex:indexPath.row];
    task.completed = !task.completed;
    
    UITableViewCell *cell = [taskList cellForRowAtIndexPath:indexPath];
    if(task.completed) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
}

- (void) tableView:(UITableView *)view didLongPressRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Starting editing");
    TaskTableViewCell *cell = (TaskTableViewCell *)[self.taskList cellForRowAtIndexPath:indexPath];
    if(!cell.isEditing) {
        NSLog(@"Editing enabled");
        [cell enableEditing];
    }
}

- (void) taskCellViewDidFinishEditing:(TaskTableViewCell *)view {
    NSLog(@"Finished editing");
    NSIndexPath *indexPath = [self.taskList indexPathForCell:view];
    
    [self.taskList reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                         withRowAnimation:UITableViewRowAnimationNone];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return [tasks count];
}

- (IBAction)clearCompletedTasks:(id)sender {
    NSIndexSet *completedTaskIndexes = [tasks indexesOfObjectsPassingTest:^(Task *task, NSUInteger idx, BOOL *stop){
        return task.completed;
    }];
    
    [tasks removeObjectsAtIndexes:completedTaskIndexes];
    [taskList reloadData];
}

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
 forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.tasks removeObjectAtIndex:indexPath.row];
        [self.taskList reloadData];
    }
}

@end