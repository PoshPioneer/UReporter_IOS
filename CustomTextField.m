//
//  MYTextField.m
//  LeadTransformed
//
//  Created by Justin Mohit on 21/05/14.
//  Copyright (c) 2014 Justin Mohit. All rights reserved.
//

#import "CustomTextField.h"

@implementation CustomTextField

static CGFloat leftMargin = 10;

- (CGRect)textRectForBounds:(CGRect)bounds
{
    bounds.origin.x += leftMargin;
    
    return bounds;
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    bounds.origin.x += leftMargin;
    
    return bounds;
}


-(void) drawPlaceholderInRect:(CGRect)rect  {
    
    if (self.placeholder)
        {
        
            // color of placeholder text
            UIColor *placeHolderTextColor = [UIColor colorWithRed:138.0/255.0 green:138.0/255.0 blue:138.0/255.0 alpha:1.0];
        
        CGSize drawSize = [self.placeholder sizeWithAttributes:[NSDictionary dictionaryWithObject:self.font forKey:NSFontAttributeName]];
        CGRect drawRect = rect;
        
            // verticially align text
        drawRect.origin.y = (rect.size.height - drawSize.height) * 0.5;
        
            // set alignment
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = self.textAlignment;
        
            // dictionary of attributes, font, paragraphstyle, and color
        NSDictionary *drawAttributes = @{NSFontAttributeName: self.font,
                                         NSParagraphStyleAttributeName : paragraphStyle,
                                         NSForegroundColorAttributeName : placeHolderTextColor};
        
        
            // draw
        [self.placeholder drawInRect:drawRect withAttributes:drawAttributes];
        
        }
}

@end
