//
//  APIClient.h
//  PracticaliOSTesting
//
//  Created by Nico Prananta on 2017/03/17.
//  Copyright © 2017 DelightfulDev. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^RequestCallback)(id result, NSError *error);

@interface APIClient : NSObject <NSURLSessionDelegate>

+ (instancetype)defaultClient;
- (void)fetchItemsWithCallback:(RequestCallback)callback;

@end
