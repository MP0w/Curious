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
        
        [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:1.000 green:0.462 blue:0.000 alpha:1.000]];

        self.title=NSStringFromClass([[objects firstObject] class]);
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
    
    return 50;
}


- (UITableViewCell *)tableView:(UITableView *)tableView_ cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *identifier=relatedObjectCellID;
    
    if (indexPath.row==0) {
        identifier=objectCellID;
    }else if (indexPath.row==[tableView_ numberOfRowsInSection:indexPath.section]-1){
        identifier=methodCellID;
    }
    
     MPTableViewCell *cell=[tableView_ dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        
        if (indexPath.row==0) {
            cell=[[MPObjectTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            
        }else if(indexPath.row==[tableView_ numberOfRowsInSection:indexPath.section]-1){
            cell=[[MPTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:
                  identifier];
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;

        }else{
            cell=[[MPRelatedObjectTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
    }
    

    
    
    if (indexPath.row==0) {
        
        id object=[[self objects] objectAtIndex:indexPath.section];
        if ([object respondsToSelector:@selector(frame)]) {
            cell.imageView.image=[snapshotsCache objectForKey:[NSString stringWithFormat:@"%p",object]];
            if(!cell.imageView.image)
            cell.imageView.image=[self getSnapshotOfView:(UIView *)object];
        }
        [cell setObjectClass:NSStringFromClass([object class])];
        [cell setCellText:[object description]];
        
        
    }else if (indexPath.row==[tableView_ numberOfRowsInSection:indexPath.section]-1){

        cell.textLabel.text=@"Methods";
   
    }else{
        
        NSInteger index=indexPath.row-1;
        id object=[self.objects objectAtIndex:indexPath.section];
        
        cell.objectClass=NSStringFromClass([object class]);

        if ([object respondsToSelector:@selector(viewControllers)]) {
            
            cell.cellText=[NSString stringWithFormat:@"%i. %@",index,NSStringFromClass([[[(UINavigationController *) object viewControllers] objectAtIndex:index] class])];
            
        }else if ([object respondsToSelector:@selector(rootViewController)]) {
            
            cell.cellText=[NSString stringWithFormat:@"%i. %@",index,NSStringFromClass([[(UIWindow *)object rootViewController] class])];
            
        }else if ([object respondsToSelector:@selector(view)]) {
            
            cell.cellText=[NSString stringWithFormat:@"%i. %@",index,NSStringFromClass([[(UIViewController *)object view] class])];
            
        }else if ([object respondsToSelector:@selector(subviews)]) {
            
            cell.cellText=[NSString stringWithFormat:@"%i. %@",index,NSStringFromClass([[[(UIView *) object subviews] objectAtIndex:index] class])];
            
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


- (UIImage *)getSnapshotOfView:(UIView *)view{
    
    UIGraphicsBeginImageContextWithOptions(view.frame.size,YES,0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:context];
    UIImage *capturedScreen = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if (!snapshotsCache) {
        snapshotsCache=[[NSCache alloc] init];
    }
    
    // put in a NSCache instead of a single UIImage ivar because we can have multiple objects in a single MPInspectorVC
    if(capturedScreen)
    [snapshotsCache setObject:capturedScreen forKey:[NSString stringWithFormat:@"%p",view]];
    
    MPLogHighlited(@"Cached %p",view);
    
    return capturedScreen;
}

@end
