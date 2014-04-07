//
//  MPMessageSenderViewController.m
//  CuriosInspectorTestApp
//
//  Created by Alex Manzella on 06/04/14.
//  Copyright (c) 2014 Alex Manzella. All rights reserved.
//

#import "MPMessageSenderViewController.h"

@interface MPMessageSenderViewController ()

@end

@implementation MPMessageSenderViewController

- (instancetype)initWithClass:(Class)objClass method:(Method)method methodType:(MPMethodType)methodType{
    
    if (self=[super init]) {
        
        self.method=method;
        self.objClass=objClass;
        self.methodType=methodType;
        
        self.title=NSStringFromSelector(method_getName(method));
        
        methodComponents=[self.title componentsSeparatedByString:@":"];
        
        numberOfArguments=methodComponents.count-1;
        
        parameters=[[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    
}

#pragma mark - UITableView Delegate & DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return numberOfArguments;
    
}


- (CGFloat)tableView:(UITableView *)tableView_ heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
}


- (UITableViewCell *)tableView:(UITableView *)tableView_ cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MPTableViewCell *cell=[tableView_ dequeueReusableCellWithIdentifier:methodCellID];
    
    if (!cell) {
        cell=[[MPTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:methodCellID];
    }
    
    cell.textLabel.text=[methodComponents[indexPath.row] stringByAppendingString:@":"];
    
    cell.detailTextLabel.text=[NSString stringWithFormat:@"%@ - %@",[NSObject codeToReadableType:method_copyArgumentType(self.method, indexPath.row+2) ],[parameters objectForKey:@(indexPath.row)]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView_ didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Parameter %i : %@",indexPath.row,[NSObject codeToReadableType:method_copyArgumentType(self.method, indexPath.row+2) ]] message:@"" complentionBlock:^(NSInteger clickedButton) {
        
        if (clickedButton==1) {
            // set the parameter that we will use to call the method...
        }
        
    } cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK"];
    
    alert.alertViewStyle=UIAlertViewStylePlainTextInput;
    [alert show];
}


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    char *type=method_copyReturnType(self.method);
    
    return [NSString stringWithFormat:@"%@ (%@)",self.methodType==MPClassMethod ? @"+" : @"-", [NSObject codeToReadableType:type]];
}


@end
