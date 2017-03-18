//
//  APIClient+UnitTests.h
//  PracticaliOSTesting
//
//  Created by Nico Prananta on 2017/03/17.
//  Copyright © 2017 DelightfulDev. All rights reserved.
//

#import "APIClient.h"

@interface APIClient (UnitTests)

/**
 Mock APIClient singleton.
 
 @return Mockable APIClient
 */
+ (id)testable;

@end
