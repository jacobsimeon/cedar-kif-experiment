//
//  TaskCellViewTableViewCell.m
//  Todos
//
//  Created by pivotal on 12/19/14.
//  Copyright (c) 2014 pivotal. All rights reserved.
//

#import "TaskTableViewCell.h"

@implementation TaskTableViewCell {
    UITextField *editTitleField;
}

@synthesize task, editTitleField, delegate, isEditing;

+ (TaskTableViewCell*) taskTableViewCellForTask:(Task *)task {
    TaskTableViewCell *cell = [[TaskTableViewCell alloc]
                               initWithStyle:UITableViewCellStyleDefault
                               reuseIdentifier:task.title];
    
    [[NSBundle mainBundle] loadNibNamed:@"TaskCell" owner:cell options:nil];

    cell.task = task;
    cell.textLabel.text = task.title;
    if(task.completed) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.accessibilityLabel = task.title;
    
    return cell;
}

- (void) enableEditing{
    self.editTitleField.text = self.task.title;
    self.editTitleField.frame = self.frame;

    self.textLabel.hidden = YES;
    [self insertSubview:editTitleField aboveSubview:self.textLabel];
    
    [self.editTitleField becomeFirstResponder];
    [self.editTitleField selectAll:nil];
    self.isEditing = YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    self.textLabel.text = self.task.title;
    self.task.title = self.editTitleField.text;

    self.textLabel.hidden = NO;
    [self.editTitleField removeFromSuperview];

    [self.editTitleField resignFirstResponder];
    [self.delegate taskCellViewDidFinishEditing:self];
    self.isEditing = NO;
    return YES;
}

@end
