//
//  PKDDomainTableViewController.m
//  PageKiteDemo
//
//  Created by Jay Lyerly on 6/15/14.
//  Copyright (c) 2014 SonicBunny Software. All rights reserved.
//

#import "PKDDomainTableViewController.h"
#import <PageKiteKit/PageKiteKit.h>

@interface PKDDomainTableViewController ()

@end

@implementation PKDDomainTableViewController

#pragma mark - Table view data 

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[PKKManager sharedManager].domains count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Registered Domains";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DomainCell" forIndexPath:indexPath];

    PKKDomain *domain = objc_dynamic_cast(PKKDomain, [PKKManager sharedManager].domains[indexPath.row]);
    
    cell.textLabel.text = domain.name;
    
    return cell;
}

@end
