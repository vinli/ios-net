//
//  SettingsViewController.m
//  Commute
//
//  Created by Jai Ghanekar on 4/12/16.
//  Copyright © 2016 Vinli. All rights reserved.
//

#import "SettingsViewController.h"
#import "HomeScreenViewController.h"
#import "DummyService.h"

@interface SettingsViewController ()
@property NSArray *dummiesArray;
@end

@implementation SettingsViewController


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.button.delegate = self;
    self.dummyTableView.dataSource = self;
    self.dummyTableView.delegate = self;
    [self addHeaderToTable];
    self.dummyTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.dummyTableView.scrollEnabled = NO;
    self.dummyTableView.allowsSelection = NO;
    [DummyService getAllDummyDevicesOnSuccess:^(NSDictionary *dummies, NSHTTPURLResponse *response) {
        self.dummiesArray = dummies[@"dummies"];
        [self.dummyTableView reloadData];
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        NSLog(@"Could not get Dummies");
    }];

}




- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.dummyTableView reloadData];

    
}




- (void)addHeaderToTable{
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(193.0f, 47.0f, 215.0f, 21.0f)];
    nameLabel.text = @"Your Dummy Devices";
    nameLabel.font = [UIFont fontWithName:@"Arial" size:22.0f];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    self.dummyTableView.tableHeaderView = nameLabel;
}






- (void)didButtonLogout {
    if (self.tabBarController) {
        self.tabBarController.selectedIndex = 0;
    }
    
    
}




#pragma TableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dummiesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    NSDictionary *dummy = self.dummiesArray[indexPath.row];
    if (dummy) {
        NSString *dummyName = [dummy objectForKey:@"name"];
        NSString *caseId = [dummy objectForKey:@"caseId"];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ CaseID: %@", dummyName, caseId];
        cell.textLabel.font = [UIFont fontWithName:@"Arial" size:12.0];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.dummyTableView.frame.size.height / self.dummiesArray.count;
}


- (void)sendDummyOnRun:(NSString *)routeId {
    [DummyService getAllDummyDevicesOnSuccess:^(NSDictionary *dummies, NSHTTPURLResponse *response) {
        
        if ([dummies[@"dummies"] count] >= 5) {
            [DummyService deleteDummyWithId:[[dummies[@"dummies"] firstObject] objectForKey:@"id"] onSuccess:^(NSHTTPURLResponse *response) {
                NSLog(@"Deleted extra dummy");
            } onFailure:nil];
        }
        [DummyService createDummyWithName:@"CommuteDummy" onSuccess:^(NSDictionary *dummy, NSHTTPURLResponse *response) {
            NSLog(@"%@", dummy);
            [DummyService createRunForDummyWithId:[dummy[@"dummy"] objectForKey:@"id"] vin:[DummyService currentVin] routeId:routeId onSuccess:^(NSDictionary *run, NSHTTPURLResponse *response) {
                NSLog(@"Sent dummy on run %@", run); //change this to transition back to mapview showing dummy run
            } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
                NSLog(@"Failed to create dummy route %@", bodyString);
            }];
        } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
            NSLog(@"%@", error);
        }];
        
        
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        NSLog(@"Couldn't get any dummies %@", bodyString);
    }];
}








@end
