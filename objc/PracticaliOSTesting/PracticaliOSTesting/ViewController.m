//
//  ViewController.m
//  PracticaliOSTesting
//
//  Created by Nico Prananta on 2017/03/17.
//  Copyright © 2017 DelightfulDev. All rights reserved.
//

#import "ViewController.h"
#import "APIClient.h"
#import "Item.h"
#import "ItemsTableViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didTapFetchItemsButton:(id)sender {
    __weak typeof (self) weakSelf = self;
    [[APIClient defaultClient] fetchItemsWithCallback:^(id result, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                [weakSelf showErrorAlert:error];
            } else {
                [weakSelf showItems:result];
            }
        });
    }];
}

- (void)showErrorAlert:(NSError *)error {
    
}

- (IBAction)showItems:(id)items {
    items = [NSMutableArray arrayWithCapacity:200];
    for (int i = 0; i < 200; i++) {
        Item *item = [[Item alloc] init];
        item.itemName = [NSString stringWithFormat:@"This is item %d", i];
        item.itemDescription = [NSString stringWithFormat:@"This is the description of item %d. This the second sentence of this description.", i];
        item.itemImage = [UIImage imageNamed:@"dummy_image.png"];
        [items addObject:item];
    }
    
    ItemsTableViewController *itemsVC = [[ItemsTableViewController alloc] initWithStyle:UITableViewStylePlain];
    itemsVC.items = items;
    [self.navigationController pushViewController:itemsVC animated:YES];
}

- (void)didTapCancelButton {
    if (self.onCancelCallback) {
        self.onCancelCallback();
    }
}

- (void)didTapSaveItem {
    Item *item = [[Item alloc] init];
    [item saveItem];
}

@end
