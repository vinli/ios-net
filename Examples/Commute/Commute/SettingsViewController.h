//
//  SettingsViewController.h
//  Commute
//
//  Created by Jai Ghanekar on 4/12/16.
//  Copyright © 2016 Vinli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <VinliNet/VinliSDK.h>

@interface SettingsViewController : UIViewController<VLLoginButtonDelegate, VLLoginButtonDelegate, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet VLLoginButton *button;
@property (weak, nonatomic) IBOutlet UITableView *dummyTableView;

- (void) didButtonLogout;

#pragma mark - TableView data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
#pragma mark - Table View delegate





@end
