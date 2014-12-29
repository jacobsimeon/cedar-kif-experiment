//
//  FeatureSpec.m
//  Todos
//
//  Created by pivotal on 12/29/14.
//  Copyright (c) 2014 pivotal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cedar/Cedar.h>
#import <KIF.h>
#import "FeatureSpec.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

@implementation FeatureSpec
- (void)failWithException:(NSException *)exception stopTest:(BOOL)stop {
    NSLog(@"%@", exception);
    id failure = [CDRSpecFailure specFailureWithReason: exception.reason
                                              fileName: exception.userInfo[@"SenTestFilenameKey"]
                                            lineNumber: [exception.userInfo[@"SenTestLineNumberKey"] intValue]];
    [failure raise];
    
    return;
}

- (void)failWithExceptions:(NSArray *)exceptions stopTest:(BOOL)stop {
    [self failWithException:exceptions[0] stopTest:stop];
    return;
}

- (void)declareBehaviors{
    
}
@end
