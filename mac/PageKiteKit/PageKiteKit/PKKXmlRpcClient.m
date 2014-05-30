//
//  PKKXmlRpcClient.m
//  PageKiteKit
//
//  Created by Jay Lyerly on 5/30/14.
//  Copyright (c) 2014 SonicBunny Software. All rights reserved.
//

#import "PKKXmlRpcClient.h"
#import <xmlrpc/XMLRPC.h>

NSString * const PKKXmlEndpoint = @"https://pagekite.net/xmlrpc/";
NSString * const PKKHttpHeaderField = @"Client-Request-ID";

@interface PKKXmlRpcClient () <XMLRPCConnectionDelegate>


@property (nonatomic, retain) NSMutableDictionary *blocks;

@end

@implementation PKKXmlRpcClient

- (instancetype) init {
    self = [super init];
    if (self){
        _blocks = [@{} mutableCopy];
    }
    return self;
}

-(void)callMethod:(NSString*)method withParameters:(NSArray *)params completionBlock:(PKKXmlRpcCompletionBlock)block {
    NSURL *URL = [NSURL URLWithString:PKKXmlEndpoint];
    
    XMLRPCRequest *request = [[XMLRPCRequest alloc] initWithURL: URL];
    XMLRPCConnectionManager *manager = [XMLRPCConnectionManager sharedManager];
    
    [request setMethod:method withParameters:params];
    
    NSLog(@"Request body: %@", [request body]);
    
    [manager spawnConnectionWithXMLRPCRequest:request delegate:self];

    NSString *idString = [[NSUUID UUID] UUIDString];
    [request setValue:idString forHTTPHeaderField:PKKHttpHeaderField];
    
    self.blocks[idString] = block;
    
}



#pragma mark - XMLRPC delegates

- (PKKXmlRpcCompletionBlock)blockForRequest:(XMLRPCRequest *)req {
    NSDictionary *headers = [[req request] allHTTPHeaderFields];
    NSString *idString = headers[PKKHttpHeaderField];
    
    PKKXmlRpcCompletionBlock block = self.blocks[idString];
    return block;
}

- (void)request: (XMLRPCRequest *)request didReceiveResponse: (XMLRPCResponse *)response{
    PKKXmlRpcCompletionBlock block = [self blockForRequest:request];
    
    if (block){
        block (response, nil);
    }
    
//    NSLog(@"received XML response");
//    NSLog(@"body: %@", response.body);
//    NSLog(@"object: %@", response.object);
}

//@optional
//- (void)request: (XMLRPCRequest *)request didSendBodyData: (float)percent;

- (void)request: (XMLRPCRequest *)request didFailWithError: (NSError *)error{
    PKKXmlRpcCompletionBlock block = [self blockForRequest:request];
    
    if (block){
        block (nil, error);
    }

    NSLog(@"xmlrpc request failed");
}


- (BOOL)request: (XMLRPCRequest *)request canAuthenticateAgainstProtectionSpace: (NSURLProtectionSpace *)protectionSpace {
    return NO;
}

- (void)request: (XMLRPCRequest *)request didReceiveAuthenticationChallenge: (NSURLAuthenticationChallenge *)challenge{
}

- (void)request: (XMLRPCRequest *)request didCancelAuthenticationChallenge: (NSURLAuthenticationChallenge *)challenge{
    
}



@end
