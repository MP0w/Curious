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

- (void)dealloc{
    
    free(methodsList);
    
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

- (NSInteger)tableView:(UITableView *)tableView_ numberOfRowsInSection:(NSInteger)section{
    
    return [self arrayForTable:tableView_].count;
    
}


- (CGFloat)tableView:(UITableView *)tableView_ heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}


- (UITableViewCell *)tableView:(UITableView *)tableView_ cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell=[tableView_ dequeueReusableCellWithIdentifier:methodCellID];
    
    if (!cell) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:methodCellID];
    }
    
    char *type=method_copyReturnType(methodsList[indexPath.row]);
    
    NSAttributedString *returnTypeString=[[NSAttributedString alloc] initWithString:[NSObject codeToReadableType:type] attributes:returnTypeAttributes];
    
    
    NSMutableAttributedString *attributedString=[[NSMutableAttributedString alloc] initWithString:@"- ()" attributes:normalAttributes];
    
    [attributedString insertAttributedString:returnTypeString atIndex:3];
    [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:[[self arrayForTable:tableView_] objectAtIndex:indexPath.row] attributes:detailAttributes]];
    cell.textLabel.attributedText=attributedString;
    
    cell.detailTextLabel.text=[NSString stringWithFormat:@"Number of Arguments: %i",method_getNumberOfArguments(methodsList[indexPath.row])];

    free(type);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView_ didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    
    searchDisplayController=[[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    
    searchDisplayController.searchResultsTableView.delegate=self;
    searchDisplayController.searchResultsTableView.dataSource=self;
    searchDisplayController.delegate=self;

    [searchDisplayController setActive:YES animated:YES];
}

-(void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller{
    [searchDisplayController setActive:NO animated:YES];
    searchDisplayController=nil;
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    NSArray *tmp=[methodsNames filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"SELF CONTAINS[c] '%@'",searchText]]];
    filteredArray=tmp;
    [searchDisplayController.searchResultsTableView reloadData];
}



- (NSArray *)arrayForTable:(UITableView *)table{
    
    if (table==tableView) {
        return methodsNames;
    }else return filteredArray;
}

@end
