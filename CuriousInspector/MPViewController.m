//
//  MPViewController.m
//  CuriosInspectorTestApp
//
//  Created by Alex Manzella on 30/03/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "MPViewController.h"

@interface MPViewController ()

@end

@implementation MPViewController

- (id)init{
    
    if (self=[super init]) {
        
        
        [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:1.000 green:0.462 blue:0.000 alpha:1.000]];
        
        self.view.tintColor=[UIColor colorWithRed:1.000 green:0.462 blue:0.000 alpha:1.000];
        
        
    }
    
    return self;
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    UIBarButtonItem *button=[[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:[MPInspectorManager sharedManager] action:@selector(dismiss)];
    
    [self.navigationItem setRightBarButtonItem:button animated:YES];
    
}

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    
    tableView=[[UITableView alloc] initWithFrame:self.view.bounds];
    tableView.autoresizingMask=UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    tableView.dataSource=self;
    tableView.delegate=self;
    [self.view addSubview:tableView];
    
}


#pragma mark - UITableView Delegate & DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 0;
    
}


- (CGFloat)tableView:(UITableView *)tableView_ heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView_ cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return nil;
}

- (void)tableView:(UITableView *)tableView_ didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    
}






@end
