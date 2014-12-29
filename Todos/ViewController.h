//
//  ViewController.h
//  Todos
//
//  Created by pivotal on 12/18/14.
//  Copyright (c) 2014 pivotal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"
#import "TaskTableViewCell.h"
#import "TaskRepository.h"

@interface ViewController : UIViewController<
    UITableViewDelegate,
    UITableViewDataSource,
    UIGestureRecognizerDelegate,
    TaskTableViewCellDelegate
>

@property UITextField *taskNameField;
@property UITableView *taskList;
@property TaskRepository *taskRepository;

@end

