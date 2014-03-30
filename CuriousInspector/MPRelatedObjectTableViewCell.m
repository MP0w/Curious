//
//  MPRelatedObjectsTableViewCell.m
//  CuriosInspectorTestApp
//
//  Created by Alex Manzella on 30/03/14.
//  Copyright (c) 2014 Alex Manzella. All rights reserved.
//

#import "MPRelatedObjectTableViewCell.h"

@implementation MPRelatedObjectTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        self.selectionStyle=UITableViewCellSelectionStyleGray;
        self.textLabel.numberOfLines=1;

    }
    return self;
}

-(void)setCellText:(NSString *)cellText{
    
    NSDictionary *normalAttributes=@{NSForegroundColorAttributeName : [UIColor colorWithRed:0.238 green:0.409 blue:0.705 alpha:1.000], NSFontAttributeName : [UIFont systemFontOfSize:17]};
    NSDictionary *hierarchyAttributes=@{NSForegroundColorAttributeName : [UIColor colorWithRed:0.019 green:0.694 blue:0.093 alpha:1.000], NSFontAttributeName : [UIFont systemFontOfSize:17]};

    
    NSMutableAttributedString *attributedString=[[NSMutableAttributedString alloc] initWithString:cellText attributes:normalAttributes];
    
    [attributedString addAttributes:hierarchyAttributes range:NSMakeRange(0, [attributedString.string rangeOfString:@". "].length+1)];
    
    self.textLabel.attributedText=attributedString;
}

-(NSString *)cellText{
    return self.textLabel.attributedText.string;
}

@end
