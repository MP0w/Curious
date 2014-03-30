//
//  MPObjectTableViewCell.m
//  CuriosInspectorTestApp
//
//  Created by Alex Manzella on 30/03/14.
//  Copyright (c) 2014 Alex Manzella. All rights reserved.
//

#import "MPObjectTableViewCell.h"

@implementation MPObjectTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.accessoryType=UITableViewCellAccessoryNone;
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        self.textLabel.numberOfLines=0;
        
    }
    return self;
}


-(void)setCellText:(NSString *)cellText{
    
    NSDictionary * defaultAttributes=@{NSForegroundColorAttributeName : [UIColor colorWithRed:1.000 green:0.462 blue:0.000 alpha:1.000], NSFontAttributeName : [UIFont systemFontOfSize:17]};
    NSDictionary *normalAttributes=@{NSForegroundColorAttributeName : [UIColor colorWithWhite:0.117 alpha:1.000], NSFontAttributeName : [UIFont systemFontOfSize:17]};
    NSDictionary *frameAttributes=@{NSForegroundColorAttributeName : [UIColor colorWithRed:0.236 green:0.517 blue:1.000 alpha:1.000], NSFontAttributeName : [UIFont systemFontOfSize:17]};
    
    NSMutableAttributedString *attributedString=[[NSMutableAttributedString alloc] initWithString:cellText attributes:normalAttributes];
    
    [attributedString setAttributes:defaultAttributes range:[attributedString.string rangeOfString:self.objectClass]];
    
    NSRange framerange = [attributedString.string rangeOfString:@"frame = \\((.*?)\\)" options:NSRegularExpressionSearch | NSCaseInsensitiveSearch];
    if(framerange.location != NSNotFound){
        [attributedString setAttributes:frameAttributes range:framerange];
    }
    
    self.textLabel.attributedText=attributedString;
}

-(NSString *)cellText{
    return self.textLabel.attributedText.string;
}



@end
