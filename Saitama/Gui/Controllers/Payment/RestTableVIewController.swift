//
//  RestTableVIewController.swift
//  Saitama
//
//  Created by Marcos Hass Wakamatsu on 24/08/17.
//  Copyright © 2017 Marcos Hass Wakamatsu. All rights reserved.
//

//#import "RestTableViewController.h"
//
//static NSString * const kLoadingRowIdentifier = @"loadingRowIdentifier";
//
//@interface RestTableViewController()
//
//@property (nonatomic, strong) UIActivityIndicatorView *spinner;
//
//@end
//
//@implementation RestTableViewController
//
//- (instancetype) initWithStore:(RestStore *)store cell:(id<IBaseCell>)cell {
//    if (self = [super init]) {
//        _store = store;
//        _cellInfo = cell;
//    }
//    return self;
//    }
//    
//    - (instancetype) initWithCoder:(NSCoder *)aDecoder restStore:(RestStore *)store cell:(id<IBaseCell>)cell {
//        if (self = [super initWithCoder:aDecoder]) {
//            _store = store;
//            _cellInfo = cell;
//        }
//        return self;
//        }
//        
//        - (void)viewDidLoad {
//            [super viewDidLoad];
//            
//            // register cells
//            UINib *cellNib = [_cellInfo nib];
//            if (cellNib != nil) {
//                [self.tableView registerNib:[_cellInfo nib] forCellReuseIdentifier:[_cellInfo identifier]];
//            } else {
//                [self.tableView registerClass:[_cellInfo class] forCellReuseIdentifier:[_cellInfo identifier]];
//            }
//            
//            [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kLoadingRowIdentifier];
//            
//            // avoid empty rows
//            self.tableView.tableFooterView = [[UIView alloc] init];
//            }
//            
//            - (void)viewWillAppear:(BOOL)animated {
//                [super viewWillAppear:animated];
//                [self.tableView reloadData];
//                }
//                
//                - (void)reloadData {
//                    [_store loadData:^(NSData *data, NSURLResponse *resp, NSError *error) {
//                        dispatch_async(dispatch_get_main_queue(), ^{
//                        if (_spinner) {
//                        [_spinner stopAnimating];
//                        }
//                        
//                        if (error) {
//                        // in production a badge indicating the error is exhibited
//                        NSLog(@"Error occured: %@", error.debugDescription);
//                        } else {
//                        [self.tableView reloadData];
//                        }
//                        });
//                        }];
//                    }
//                    
//                    - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//                        if (_store.nextLink == nil) {
//                            return _store.count;
//                        } else {
//                            return _store.count + 1; // line for loading row
//                        }
//                        }
//                        
//                        - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//                            UITableViewCell *cell;
//                            
//                            if (indexPath.row == _store.count) {
//                                cell = [tableView dequeueReusableCellWithIdentifier:kLoadingRowIdentifier forIndexPath:indexPath];
//                                
//                                // loading
//                                _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//                                _spinner.translatesAutoresizingMaskIntoConstraints = false;
//                                
//                                [cell addSubview:_spinner];
//                                
//                                [NSLayoutConstraint constraintWithItem:_spinner attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:cell attribute:NSLayoutAttributeCenterX multiplier:1 constant:1].active = true;
//                                [NSLayoutConstraint constraintWithItem:_spinner attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:cell attribute:NSLayoutAttributeCenterY multiplier:1 constant:1].active = true;
//                                
//                                [_spinner startAnimating];
//                            } else {
//                                cell = [tableView dequeueReusableCellWithIdentifier:[_cellInfo identifier] forIndexPath:indexPath];
//                                [((id<IBaseCell>)cell) configureWithDictionary:_store.items[indexPath.row]];
//                            }
//                            
//                            return cell;
//                            }
//                            
//                            - (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//                                /* If there is a link to next page and we're at least in the last row */
//                                if (_store.nextLink != nil && indexPath.row >= _store.count - 1) {
//                                    [self reloadData];
//                                }
//}
//
//@end

