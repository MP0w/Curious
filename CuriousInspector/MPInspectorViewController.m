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


        self.title=NSStringFromClass([[objects firstObject] class]);
        
        
    }
    
    return self;
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
        
        id object=[[self objects] objectAtIndex:indexPath.section];
        
        NSString *text=[object description];
        
        UIImage *image=[snapshotsCache objectForKey:[NSString stringWithFormat:@"%p",object]];
        
        return [text sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(tableView_.width-30, CGFLOAT_MAX)].height+30+(image!=nil ? (image.size.width>tableView_.width-200 ? (image.size.height/image.size.width)*(tableView_.width-200)+15 : image.size.height+15) : 0);
        
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
            [(MPObjectTableViewCell *)cell setSnapshot:[snapshotsCache objectForKey:[NSString stringWithFormat:@"%p",object]]];
            if(!cell.imageView.image){
                [(MPObjectTableViewCell *)cell setSnapshot:[self getSnapshotOfView:(UIView *)object]];
                [tableView_ reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
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
        
        
        if (objects) {
            MPInspectorViewController *detailVC=[[MPInspectorViewController alloc] initWithObjects:objects];
            [self.navigationController pushViewController:detailVC animated:YES];
        }
        
    }else if (indexPath.row==[tableView_ numberOfRowsInSection:indexPath.section]-1){
        MPMethodsListViewController *methodsListVC=[[MPMethodsListViewController alloc] initWithObjects:[self.objects objectAtIndex:indexPath.section]];
        [self.navigationController pushViewController:methodsListVC animated:YES];

    }
    

    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{

    return NSStringFromClass([[self.objects objectAtIndex:section] class]);
}


- (UIImage *)getSnapshotOfView:(UIView *)view{
    
    UIGraphicsBeginImageContextWithOptions(view.frame.size,NO,0.0f);
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
