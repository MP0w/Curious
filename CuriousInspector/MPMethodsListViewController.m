//
//  MPMethodsListViewController.m
//  CuriosInspectorTestApp
//
//  Created by Alex Manzella on 31/03/14.
//  Copyright (c) 2014 Alex Manzella. All rights reserved.
//

#import "MPMethodsListViewController.h"

@interface MPMethodsListViewController ()

@end

@implementation MPMethodsListViewController

- (instancetype)initWithObjects:(NSObject *)object{
    
    self = [super init];
    if (self) {

        self.title=NSStringFromClass([object class]);

        unsigned int count;
        
        methodsList = class_copyMethodList([object class], &count);

        methodsNames=[[NSMutableArray alloc] init];
        
        for (NSUInteger i=0; i<count; i++) {
            [methodsNames addObject:NSStringFromSelector(method_getName(methodsList[i]))];
        }
        
        returnTypeAttributes=@{NSForegroundColorAttributeName : [UIColor colorWithRed:1.000 green:0.462 blue:0.000 alpha:1.000], NSFontAttributeName : [UIFont systemFontOfSize:17]};
        normalAttributes=@{NSForegroundColorAttributeName : [UIColor colorWithWhite:0.117 alpha:1.000], NSFontAttributeName : [UIFont systemFontOfSize:17]};
        detailAttributes=@{NSForegroundColorAttributeName : [UIColor colorWithRed:0.236 green:0.517 blue:1.000 alpha:1.000], NSFontAttributeName : [UIFont systemFontOfSize:17]};
        
        

    }
    return self;
}

- (void)viewDidLoad{
    
    [super viewDidLoad];
 
    UISearchBar *searchbar=[[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 40)];
    searchbar.delegate=self;
    
    tableView.tableHeaderView=searchbar;
}

#pragma mark - UITableView Delegate & DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return methodsNames.count;
    
}


- (CGFloat)tableView:(UITableView *)tableView_ heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}


- (UITableViewCell *)tableView:(UITableView *)tableView_ cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell=[tableView_ dequeueReusableCellWithIdentifier:methodCellID];
    
    if (!cell) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:methodCellID];
    }
    
    char name[20];
    
    method_getReturnType(methodsList[indexPath.row], name, 20);
    
    struct objc_method_description desc=*method_getDescription(methodsList[indexPath.row]);

    
    NSString *methodName=[NSString stringWithFormat:@"%s %@",name,[methodsNames objectAtIndex:indexPath.row]];
    
    NSMutableAttributedString *attributedString=[[NSMutableAttributedString alloc] initWithString:methodName attributes:normalAttributes];
    
    cell.textLabel.attributedText=attributedString;
    
    cell.detailTextLabel.text=[NSString stringWithFormat:@"Number of Arguments: %i",method_getNumberOfArguments(methodsList[indexPath.row])];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView_ didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

@end
