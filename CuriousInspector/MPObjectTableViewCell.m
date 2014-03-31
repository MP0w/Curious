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


-(void)layoutSubviews{
    [super layoutSubviews];
    
    if(snapshotView.image)
        self.textLabel.height=snapshotView.y-15;

}

-(NSString *)cellText{
    return self.textLabel.attributedText.string;
}

-(void)setSnapshot:(UIImage *)snapshot{
    
    if(!snapshot){
        
        [snapshotView removeFromSuperview]; snapshotView=nil;
        
        return;
    }
    
    if (!snapshotView) {
        snapshotView=[[UIImageView alloc] initWithFrame:CGRectMake(15, self.height-15, self.width-30, 0)];
        snapshotView.autoresizingMask=UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        snapshotView.layer.borderColor=[UIColor darkGrayColor].CGColor;
        snapshotView.layer.borderWidth=.5;
        [self addSubview:snapshotView];
    }
    
    snapshotView.image=snapshot;
    
    CGSize imageScaled;
    
    
    if(snapshot.size.width>self.width-200)
        imageScaled=CGSizeMake(self.width-200, snapshot.size.height/snapshot.size.width*(self.width-200));
    else imageScaled=snapshot.size;
    
    snapshotView.frame=CGRectMake((self.width-imageScaled.width)/2, self.height-15-imageScaled.height, imageScaled.width, imageScaled.height);
}

-(UIImage *)snapshot{
    return snapshotView.image;
}

@end
