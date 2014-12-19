//
//  TaskCellViewTableViewCell.h
//  Todos
//
//  Created by pivotal on 12/19/14.
//  Copyright (c) 2014 pivotal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"

@class TaskTableViewCell;

@protocol TaskTableViewCellDelegate <NSObject>
- (void) taskCellViewDidFinishEditing:(TaskTableViewCell *)view;
@end

@interface TaskTableViewCell : UITableViewCell<UITextFieldDelegate>

@property Task *task;
@property IBOutlet UITextField *editTitleField;
@property IBOutlet id<TaskTableViewCellDelegate> delegate;
@property BOOL isEditing;

- (void)enableEditing;
- (BOOL)isEditing;

+ (TaskTableViewCell*) taskTableViewCellForTask:(Task *)task;

@end
