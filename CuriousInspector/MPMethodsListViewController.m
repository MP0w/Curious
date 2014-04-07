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

static NSString *nameKey = @"methodName";
static NSString *methodKey = @"method";
static NSString *methodType =@"type";

@implementation MPMethodsListViewController

- (instancetype)initWithObjects:(NSObject *)object{
    
    self = [super init];
    if (self) {
        
        self.object=object;

        self.title=NSStringFromClass([object class]);

        unsigned int classMethodCount;
        unsigned int count;
        
        Method *classMethodsList = class_copyMethodList(objc_getMetaClass([NSStringFromClass([object class]) UTF8String]), &classMethodCount);

        Method *methodsList = class_copyMethodList([object class], &count);

        methodsNames=[[NSMutableArray alloc] init];

        for (NSUInteger i=0; i<classMethodCount; i++) {
            [methodsNames addObject:@{nameKey: NSStringFromSelector(method_getName(classMethodsList[i])),methodKey:[NSValue valueWithPointer:classMethodsList[i]],methodType : @(MPClassMethod)}];
        }
        for (NSUInteger i=0; i<count; i++) {
            [methodsNames addObject:@{nameKey: NSStringFromSelector(method_getName(methodsList[i])),methodKey:[NSValue valueWithPointer:methodsList[i]],methodType : @(MPInstanceMethod)}];
        }
        
        returnTypeAttributes=@{NSForegroundColorAttributeName : [UIColor colorWithRed:1.000 green:0.462 blue:0.000 alpha:1.000], NSFontAttributeName : [UIFont systemFontOfSize:17]};
        normalAttributes=@{NSForegroundColorAttributeName : [UIColor colorWithWhite:0.117 alpha:1.000], NSFontAttributeName : [UIFont systemFontOfSize:17]};
        detailAttributes=@{NSForegroundColorAttributeName : [UIColor colorWithRed:0.236 green:0.517 blue:1.000 alpha:1.000], NSFontAttributeName : [UIFont systemFontOfSize:17]};
        
        
        free(methodsList);
        free(classMethodsList);

        
        

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
        cell.detailTextLabel.adjustsFontSizeToFitWidth=YES;
    }
    
    NSDictionary *methodDict=[[self arrayForTable:tableView_] objectAtIndex:indexPath.row];
    
    Method currentMethod=[(NSValue *)[methodDict objectForKey:methodKey] pointerValue];
    
    char *type=method_copyReturnType(currentMethod);
    
    NSAttributedString *returnTypeString=[[NSAttributedString alloc] initWithString:[NSObject codeToReadableType:type] attributes:returnTypeAttributes];
    
    
    NSMutableAttributedString *attributedString=[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ()",[[methodDict objectForKey:methodType] integerValue]== MPClassMethod ? @"+" : @"-" ] attributes:normalAttributes];
    
    [attributedString insertAttributedString:returnTypeString atIndex:3];
    [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:[methodDict objectForKey:nameKey] attributes:detailAttributes]];
    cell.textLabel.attributedText=attributedString;
    
    NSUInteger numberOfArguments=method_getNumberOfArguments(currentMethod);
    NSString *detailString=[NSString stringWithFormat:@"Number of Arguments: %i ",numberOfArguments-2];
    
    for (NSUInteger i=2; i<numberOfArguments; i++) {
        detailString=[detailString stringByAppendingString:[NSString stringWithFormat:@" / (%@)",[NSObject codeToReadableType:method_copyArgumentType(currentMethod, i)]]];
    }
         
    cell.detailTextLabel.text=detailString;

    free(type);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView_ didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView_ deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *methodDict=[[self arrayForTable:tableView_] objectAtIndex:indexPath.row];

    Method currentMethod=[(NSValue *)[methodDict objectForKey:methodKey] pointerValue];
    
    NSUInteger numberOfArguments=method_getNumberOfArguments(currentMethod);

    if(numberOfArguments-2>0){
        
        MPMessageSenderViewController* messageSenderVC=[[MPMessageSenderViewController alloc] initWithClass:[self.object class] method:currentMethod methodType:[[methodDict objectForKey:methodType] integerValue]];
        messageSenderVC.method=currentMethod;
        [self.navigationController pushViewController:messageSenderVC animated:YES];
        
        
    }else{ // I will see later, during the creation of MPMessageSenderViewController

        
        
//        char *type=method_copyReturnType(currentMethod);
//        
//        
//        if (numberOfArguments-2>0) {
//            MPMessageSenderViewController * messageSender=[[MPMessageSenderViewController alloc] init];
//            messageSender.method=currentMethod;
//            [self.navigationController pushViewController:messageSender animated:YES];
//        }else{
//
//            id sender=([[methodDict objectForKey:methodType] integerValue]== MPClassMethod) ? [[self object] class] : self.object;
//
//                
//            NSString *returnTypeString=[NSObject codeToReadableType:type];
//
//            if ([returnTypeString isEqualToString:@"id"]) {
//                
//                id returnedValue = (objc_msgSend(sender, method_getName([[methodDict objectForKey:methodKey] pointerValue])));
//
//                [[[UIAlertView alloc] initWithTitle:@"Returned Value" message:[returnedValue description] complentionBlock:^(NSInteger clickedButton) {
//                
//                    
//                } cancelButtonTitle:@"Cancel" otherButtonTitles:@"Continue"]show];
//                MPLogHighlited(@"return %@",returnedValue);
//                
//            }else if ([returnTypeString isEqualToString:@"void"]){
//                objc_msgSend(sender, method_getName([[methodDict objectForKey:methodKey] pointerValue]));
//
//            }else if (type[0]=='{'){
//                objc_msgSend_stret(sender, method_getName([[methodDict objectForKey:methodKey] pointerValue]));
//            }else{
//                objc_msgSend_fpret(sender, method_getName([[methodDict objectForKey:methodKey] pointerValue]));
//            }
//        
//        }
    }
    
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
    NSArray *tmp=[methodsNames filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"SELF.%@ CONTAINS[c] '%@'",nameKey,searchText]]];
    filteredArray=tmp;
    [searchDisplayController.searchResultsTableView reloadData];
}



- (NSArray *)arrayForTable:(UITableView *)table{
    
    if (table==tableView) {
        return methodsNames;
    }else return filteredArray;
}


@end
