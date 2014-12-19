#import <Cedar/Cedar.h>
#import <KIF.h>

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

@interface FeatureSpec : CDRSpec <KIFTestActorDelegate>
@end

@implementation FeatureSpec
- (void)failWithException:(NSException *)exception stopTest:(BOOL)stop {
    NSLog(@"%@", exception);
    id failure = [CDRSpecFailure specFailureWithReason: exception.reason
                       fileName: exception.userInfo[@"SenTestFilenameKey"]
                     lineNumber: [exception.userInfo[@"SenTestLineNumberKey"] intValue]
                  ];
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

#define FEATURE_SPEC_BEGIN(name)     \
@interface name : FeatureSpec        \
-(void)declareBehaviors;             \
@end                                 \
@implementation name                 \
- (void)declareBehaviors {           \
self.fileName = [NSString stringWithUTF8String:__FILE__];