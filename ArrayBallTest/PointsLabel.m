//
//  PointsLabel.m
//  ArrayBallTest
//
//  Created by Garrett Crawford on 10/31/14.
//  Copyright (c) 2014 Noox. All rights reserved.
//

#import "PointsLabel.h"

@implementation PointsLabel

+(id)pointsLabelWithFontNamed:(NSString *)fontName
{
    PointsLabel *pointsLabel = [PointsLabel labelNodeWithFontNamed:@"CoolveticaRg-Regular"];
    pointsLabel.text = @"0";
    pointsLabel.number = 0;
    return pointsLabel;
}

-(void)increment
{
    self.number++;
    self.text = [NSString stringWithFormat:@"%i", self.number];
}

-(void)setPoints:(int)points
{
    self.number = points;
    self.text = [NSString stringWithFormat:@"%i", self.number];
}

@end
