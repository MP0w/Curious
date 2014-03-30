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
        
        [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:1.000 green:0.462 blue:0.000 alpha:1.000]];

        self.title=NSStringFromClass([[objects objectAtIndex:0] class]);
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
    
    defaultAttributes=@{NSForegroundColorAttributeName : [UIColor colorWithRed:1.000 green:0.462 blue:0.000 alpha:1.000], NSFontAttributeName : [UIFont systemFontOfSize:17]};
    normalAttributes=@{NSForegroundColorAttributeName : [UIColor colorWithWhite:0.117 alpha:1.000], NSFontAttributeName : [UIFont systemFontOfSize:17]};
    hierarchyAttributes=@{NSForegroundColorAttributeName : [UIColor colorWithRed:0.019 green:0.694 blue:0.093 alpha:1.000], NSFontAttributeName : [UIFont systemFontOfSize:17]};
    
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
    
    static NSString *identifier=@"Cell";
    
    UITableViewCell *cell=[tableView_ dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.textLabel.numberOfLines=0;
    }
    
    cell.accessoryType=indexPath.row ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
    
    cell.selectionStyle=indexPath.row ? UITableViewCellSelectionStyleGray : UITableViewCellSelectionStyleNone;
    
    
    
    if (indexPath.row==0) {
        id object=[[self objects] objectAtIndex:indexPath.section];
        NSMutableAttributedString *attributedString=[[NSMutableAttributedString alloc] initWithString:[object description] attributes:normalAttributes];

        [attributedString setAttributes:defaultAttributes range:[attributedString.string rangeOfString:NSStringFromClass([object class])]];

        NSRange framerange = [attributedString.string rangeOfString:@"frame = \\((.*?)\\)" options:NSRegularExpressionSearch | NSCaseInsensitiveSearch];
        if(framerange.location != NSNotFound){
            [attributedString setAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:0.236 green:0.517 blue:1.000 alpha:1.000], NSFontAttributeName : [UIFont systemFontOfSize:17]} range:framerange];
        }
        
        cell.textLabel.attributedText=attributedString;
        
        
    }else if (indexPath.row>0 && indexPath.row<[tableView_ numberOfRowsInSection:indexPath.section]-1){
        
        
        NSInteger index=indexPath.row-1;
        id object=[self.objects objectAtIndex:indexPath.section];
        

        if ([object respondsToSelector:@selector(viewControllers)]) {
            
            cell.textLabel.text=[NSString stringWithFormat:@"%i. %@",index,NSStringFromClass([[[(UINavigationController *) object viewControllers] objectAtIndex:index] class])];
            
        }else if ([object respondsToSelector:@selector(rootViewController)]) {
            
            cell.textLabel.text=[NSString stringWithFormat:@"%i. %@",index,NSStringFromClass([[(UIWindow *)object rootViewController] class])];
            
        }else if ([object respondsToSelector:@selector(view)]) {
            
            cell.textLabel.text=[NSString stringWithFormat:@"%i. %@",index,NSStringFromClass([[(UIViewController *)object view] class])];
            
        }else if ([object respondsToSelector:@selector(subviews)]) {
            
            cell.textLabel.text=[NSString stringWithFormat:@"%i. %@",index,NSStringFromClass([[[(UIView *) object subviews] objectAtIndex:index] class])];
            
        }
        
        NSMutableAttributedString *attributedString=[[NSMutableAttributedString alloc] initWithString:cell.textLabel.text attributes:normalAttributes];

        [attributedString addAttributes:hierarchyAttributes range:NSMakeRange(0, [attributedString.string rangeOfString:@". "].length+1)];
        
        cell.textLabel.attributedText=attributedString;
        
        
    }else{
        cell.textLabel.text=@"Methods";
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
