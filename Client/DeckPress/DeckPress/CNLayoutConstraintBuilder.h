//
//  CNLayoutConstraintBuilder.h
//  CAN
//
//  Created by Luke Redpath on 21/02/2013.
//  Copyright (c) 2013 LShift. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CNLayoutConstraintBuilder : NSObject

+ (id)builderForView:(UIView *)view;

#pragma mark - Pinning to edges

- (void)pinSubviewToEdges:(UIView *)subview;
- (void)pinSubview:(UIView *)subview toEdgesWithInsets:(UIEdgeInsets)insets;
- (void)pinSubview:(UIView *)subview toTopEdgeWithOffset:(CGFloat)offset;
- (void)pinSubview:(UIView *)subview toBottomEdgeWithOffset:(CGFloat)offset;
- (void)pinSubview:(UIView *)subview toLeadingEdgeWithOffset:(CGFloat)offset;
- (void)pinSubview:(UIView *)subview toTrailingEdgeWithOffset:(CGFloat)offset;

/* Gives a bit more flexibility in terms of how a subview is pinned to it's parent view.
 
 All of the above methods pin the same edge of the subview to it's parent view.
 
 If you need to pin a subview to an edge of it's parent view using a different anchor point
 (e.g. pin it's center to it's parent's bottom edge), you'll want to use this method.
 
 @param subview The subview to pin within it's parent view.
 @param edgeAttribute The edge of the parent view to pin to.
 @param offset The offset from the parent view edge. Generally a positive number unless positioning off-screen.
 @param anchorPointAttribute The edge of the subview that will be pinned to the superview.
 */
- (void)pinSubview:(UIView *)subview toEdge:(NSLayoutAttribute)edgeAttribute
            offset:(CGFloat)offset
       anchorPoint:(NSLayoutAttribute)anchorPointAttribute;

#pragma mark - Pinning size

- (void)pinToWidth:(CGFloat)width;
- (void)pinToHeight:(CGFloat)height;
- (void)pinToSize:(CGSize)size;

#pragma mark - Pinning to centre

- (void)pinSubviewToCenter:(UIView *)subview;
- (void)pinSubviewToCenterX:(UIView *)subview;
- (void)pinSubviewToCenterY:(UIView *)subview;
- (void)pinSubviewToCenterY:(UIView *)subview withOffset:(CGFloat)offset;

#pragma mark - Removing constraints

/* Removes any constraints from the builder's view where either the first item/attribute 
   or the second item/attribute matches the builder's view and the given attribute.
 */
- (void)removeConstraintsForAttribute:(NSLayoutAttribute)attribute;

/* Removes any constraints from the builder's view where either the first item/attribute
   or the second item/attribute matches the given view and attribute.
 */
- (void)removeConstraintsForAttribute:(NSLayoutAttribute)attribute onView:(UIView *)viewToMatch;

@end
