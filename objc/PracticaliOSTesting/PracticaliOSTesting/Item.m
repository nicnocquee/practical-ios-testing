//
//  Item.m
//  PracticaliOSTesting
//
//  Created by Nico Prananta on 2017/03/18.
//  Copyright © 2017 DelightfulDev. All rights reserved.
//

#import "Item.h"

#import <FirebaseAnalytics/FirebaseAnalytics.h>

@implementation Item

- (void)saveItem {
    // save this item to file or something
    
    [FIRAnalytics logEventWithName:kFIREventSelectContent
                        parameters:@{
                                     
                                     kFIRParameterItemName:self.itemName,
                                     kFIRParameterItemID:[NSString stringWithFormat:@"id-%@", self.itemName],
                                     kFIRParameterContentType:@"image"
                                     }];
}

@end
