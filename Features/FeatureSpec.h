//
//  FeatureSpec.h
//  Todos
//
//  Created by pivotal on 12/29/14.
//  Copyright (c) 2014 pivotal. All rights reserved.
//

#ifndef Todos_FeatureSpec_h
#define Todos_FeatureSpec_h

@interface FeatureSpec : CDRSpec <KIFTestActorDelegate>
@end

#endif

#define FEATURE_SPEC_BEGIN(name)     \
@interface name : FeatureSpec        \
-(void)declareBehaviors;             \
@end                                 \
@implementation name                 \
- (void)declareBehaviors {           \
self.fileName = [NSString stringWithUTF8String:__FILE__];