//
//  APIClient.m
//  PracticaliOSTesting
//
//  Created by Nico Prananta on 2017/03/17.
//  Copyright © 2017 DelightfulDev. All rights reserved.
//

#import "APIClient.h"

@implementation APIClient

+ (instancetype)defaultClient {
    static APIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[APIClient alloc] init];
    });
    
    return _sharedClient;
}

- (void)fetchItemsWithCallback:(RequestCallback)callback {
    [self GET:@"/items" callback:callback];
}

- (void)GET:(NSString *)path callback:(RequestCallback)callback {
    [self callAPIPath:path method:@"GET" callback:callback];
}

- (void)callAPIPath:(NSString *)path method:(NSString *)method callback:(RequestCallback)callback {
    NSString *urlString = [NSString stringWithFormat:@"https://someserver.com%@", path];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:15];
    request.HTTPMethod = method;
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            if (callback) {
                callback(nil, error);
            }
        } else {
            if (callback) {
                NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                callback(responseString, nil);
            }
        }
    }];
    [dataTask resume];
}

@end
