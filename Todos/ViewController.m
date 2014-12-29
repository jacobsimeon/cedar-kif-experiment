//
//  ViewController.m
//  Todos
//
//  Created by pivotal on 12/18/14.
//  Copyright (c) 2014 pivotal. All rights reserved.
//

#import "ViewController.h"
#import "TaskTableViewCell.h"
#import "TaskRepository.h"

@interface ViewController ()
@end

@implementation ViewController {
    IBOutlet UITextField *taskNameField;
    IBOutlet UITableView *taskList;
}

@synthesize taskRepository;
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
    self.taskRepository = [TaskRepository repositoryWithFilename:@"tasks"];
}

- (void) handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer {
    CGPoint p = [gestureRecognizer locationInView:self.taskList];
    NSIndexPath *indexPath = [self.taskList indexPathForRowAtPoint:p];
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        [self tableView:self.taskList didLongPressRowAtIndexPath:indexPath];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.taskRepository save:[Task taskWithTitle:textField.text]];
    [self.taskList reloadData];

    textField.text = @"";
    [textField resignFirstResponder];
    return YES;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSArray *tasks = [self.taskRepository readAll];
    Task *task = [tasks objectAtIndex:indexPath.row];
    TaskTableViewCell *cell = [taskList dequeueReusableCellWithIdentifier:task.title];
    
    if(cell == nil) {
        cell = [TaskTableViewCell taskTableViewCellForTask:task];
        cell.delegate = self;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)view didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TaskTableViewCell *cell = (TaskTableViewCell *)[self tableView:view cellForRowAtIndexPath:indexPath];
    Task *task = cell.task;
    
    task.completed = !task.completed;
    [self.taskRepository save:task];
}

- (void) tableView:(UITableView *)view didLongPressRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Starting editing");
    TaskTableViewCell *cell = (TaskTableViewCell *)[self.taskList cellForRowAtIndexPath:indexPath];
    if(!cell.isEditing) {
        [cell enableEditing];
    }
}

- (void) taskCellViewDidFinishEditing:(TaskTableViewCell *)view {
    NSIndexPath *indexPath = [self.taskList indexPathForCell:view];
    [self.taskRepository save:view.task];
    [self.taskList reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                         withRowAnimation:UITableViewRowAnimationNone];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    NSArray *tasks = [self.taskRepository readAll];
    return [tasks count];
}

- (IBAction)clearCompletedTasks:(id)sender {
    NSArray *tasks = [[self.taskRepository readAll] copy];
    for (Task *task in tasks) {
        if(task.completed) {
            [self.taskRepository remove:task];
        }
    }

    [taskList reloadData];
}

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
 forRowAtIndexPath:(NSIndexPath *)indexPath {    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSArray *tasks = [self.taskRepository readAll];
        Task *task = [tasks objectAtIndex:indexPath.row];

        if(task != nil) {
            [self.taskRepository remove:task];
            [self.taskList reloadData];
        }
    }
}

@end