//
//  PKKXmlRpcClient.h
//  PageKiteKit
//
//  Created by Jay Lyerly on 5/30/14.
//  Copyright (c) 2014 SonicBunny Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XMLRPCResponse;

typedef void (^PKKXmlRpcCompletionBlock)(XMLRPCResponse *response, NSError *error);

@interface PKKXmlRpcClient : NSObject

-(void)callMethod:(NSString*)method withParameters:(NSArray *)params completionBlock:(PKKXmlRpcCompletionBlock)block;

@end
