//
//  MPViewController.m
//  curious
//
//  Created by Alex Manzella on 28/03/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "MPInspectorViewController.h"

@interface MPInspectorViewController ()

@end

@implementation MPInspectorViewController

- (instancetype)initWithObjects:(NSArray *)objects{
    
    if (self=[super init]) {
     
        self.objects=objects;
        
        self.title=NSStringFromClass([[objects objectAtIndex:0] class]);

        
    }
    
    return self;
}

- (void)viewDidAppear:(BOOL)animated{
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
    return self.objects.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    id object=[self.objects objectAtIndex:section];
    
    if ([object respondsToSelector:@selector(viewControllers)]) {
        
        return [(UINavigationController *) object viewControllers].count + 2;
        
    }else if ([object respondsToSelector:@selector(rootViewController)]) {
        
        return 3;
        
    }else if ([object respondsToSelector:@selector(view)]) {
        
        return  3;
        
    }else if ([object respondsToSelector:@selector(subviews)]) {
        
        return [(UIView *) object subviews].count + 2;
        
    }else return 2;
    
}


- (CGFloat)tableView:(UITableView *)tableView_ heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row==0) {
        NSString *text=[[[self objects] objectAtIndex:indexPath.section] description];
        return [text sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(tableView_.width-20, CGFLOAT_MAX)].height+20;
        
    }
    
    return 100;
}


- (UITableViewCell *)tableView:(UITableView *)tableView_ cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier=@"Cell";
    
    UITableViewCell *cell=[tableView_ dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.textLabel.numberOfLines=0;

    }
    
    
    if (indexPath.row==0) {
        
        cell.textLabel.text=[[[self objects] objectAtIndex:indexPath.section] description];
        
    }else if (indexPath.row>0 && indexPath.row<[tableView_ numberOfRowsInSection:indexPath.section]-1){
        
        NSInteger index=indexPath.row-1;
        id object=[self.objects objectAtIndex:indexPath.section];
        

        if ([object respondsToSelector:@selector(viewControllers)]) {
            
            cell.textLabel.text=[[[(UINavigationController *) object viewControllers] objectAtIndex:index] description];
            
        }else if ([object respondsToSelector:@selector(rootViewController)]) {
            
            cell.textLabel.text=[(UIWindow *)object rootViewController].description;
            
        }else if ([object respondsToSelector:@selector(view)]) {
            
            cell.textLabel.text=[(UIViewController *)object view].description;
            
        }else if ([object respondsToSelector:@selector(subviews)]) {
            
            cell.textLabel.text=[[[(UIView *) object subviews] objectAtIndex:index] description];
            
        }
    }

    
    return cell;
}

- (void)tableView:(UITableView *)tableView_ didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *objects;

    
    if (indexPath.row>0 && indexPath.row<[tableView_ numberOfRowsInSection:indexPath.section]-1){
        
        NSInteger index=indexPath.row-1;
        id object=[self.objects objectAtIndex:indexPath.section];
        
        if ([object respondsToSelector:@selector(viewControllers)]) {
            
            objects = @[[[(UINavigationController *) object viewControllers] objectAtIndex:index]];

        }else if ([object respondsToSelector:@selector(rootViewController)]) {
            
            objects = @[[(UIWindow *)object rootViewController]];
            
        }else if ([object respondsToSelector:@selector(view)]) {
            
            objects = @[[(UIViewController *)object view]];
            
        }else if ([object respondsToSelector:@selector(subviews)]) {
            
            objects = @[[[(UIView *) object subviews] objectAtIndex:index]];
            
        }
    }
    
    if (objects) {
        MPInspectorViewController *detailVC=[[MPInspectorViewController alloc] initWithObjects:objects];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{

    return NSStringFromClass([[self.objects objectAtIndex:section] class]);
}


@end
