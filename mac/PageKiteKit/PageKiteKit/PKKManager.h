//
//  PKKManager.h
//  PageKiteKit
//
//  Created by Jay Lyerly on 5/29/14.
//

#import <Foundation/Foundation.h>

typedef void (^PKKManagerCompletionBlock)(BOOL success);


@interface PKKManager : NSObject

@property (nonatomic, readonly) NSArray *kites;
@property (nonatomic, readonly) NSArray *domains;
@property (nonatomic, readonly) NSString *lastError;

+ (instancetype) sharedManager;

- (void)loginWithUser:(NSString *)user password:(NSString *)password completionBlock:(PKKManagerCompletionBlock)block;
- (void)retrieveKitesWithCompletionBlock:(PKKManagerCompletionBlock)block;
- (void)retrieveDomainsWithCompletionBlock:(PKKManagerCompletionBlock)block;
- (void)addKite:(NSString*)name completionBlock:(PKKManagerCompletionBlock)block;
- (void)getAccountInfoWithCompletionBlock:(PKKManagerCompletionBlock)block;

@end
