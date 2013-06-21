//
//  CNLayoutConstraintBuilder.m
//  CAN
//
//  Created by Luke Redpath on 21/02/2013.
//  Copyright (c) 2013 LShift. All rights reserved.
//

#import "CNLayoutConstraintBuilder.h"

@implementation CNLayoutConstraintBuilder {
  UIView *_view;
}

+ (id)builderForView:(UIView *)view
{
  return [[self alloc] initWithView:view];
}

- (id)initWithView:(UIView *)view
{
  self = [super init];
  if (self) {
    _view = view;
  }
  return self;
}

#pragma mark - Pinning to edges

- (void)pinSubviewToEdges:(UIView *)subview
{
  [self pinSubview:subview toEdgesWithInsets:UIEdgeInsetsZero];
}

- (void)pinSubview:(UIView *)subview toEdgesWithInsets:(UIEdgeInsets)insets
{
  [self pinSubview:subview toTopEdgeWithOffset:insets.top];
  [self pinSubview:subview toBottomEdgeWithOffset:insets.bottom];
  [self pinSubview:subview toLeadingEdgeWithOffset:insets.left];
  [self pinSubview:subview toTrailingEdgeWithOffset:insets.right];
}

- (void)pinSubview:(UIView *)subview toTopEdgeWithOffset:(CGFloat)offset
{
  [self addOrReplaceExistingConstraintFromConstraint:[NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_view attribute:NSLayoutAttributeTop multiplier:1 constant:offset]];
}

- (void)pinSubview:(UIView *)subview toBottomEdgeWithOffset:(CGFloat)offset
{
  [self addOrReplaceExistingConstraintFromConstraint:[NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_view attribute:NSLayoutAttributeBottom multiplier:1 constant:-offset]];
}

- (void)pinSubview:(UIView *)subview toLeadingEdgeWithOffset:(CGFloat)offset
{
  [self addOrReplaceExistingConstraintFromConstraint:[NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_view attribute:NSLayoutAttributeLeading multiplier:1 constant:offset]];
}

- (void)pinSubview:(UIView *)subview toTrailingEdgeWithOffset:(CGFloat)offset
{
  [self addOrReplaceExistingConstraintFromConstraint:[NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_view attribute:NSLayoutAttributeTrailing multiplier:1 constant:-offset]];
}

- (void)pinSubview:(UIView *)subview toEdge:(NSLayoutAttribute)edgeAttribute
            offset:(CGFloat)offset
       anchorPoint:(NSLayoutAttribute)anchorPointAttribute
{
  [self removeConstraintsForAttribute:anchorPointAttribute onView:subview];
  
  CGFloat adjustedOffset = offset;
  
  if (edgeAttribute == NSLayoutAttributeBottom || edgeAttribute == NSLayoutAttributeTrailing) {
    adjustedOffset = -offset;
  }
  
  [_view addConstraint:[NSLayoutConstraint constraintWithItem:subview attribute:anchorPointAttribute relatedBy:NSLayoutRelationEqual toItem:_view attribute:edgeAttribute multiplier:1.0 constant:adjustedOffset]];
}

#pragma mark - Pinning size

- (void)pinToWidth:(CGFloat)width
{
  [self addOrReplaceExistingConstraintFromConstraint:[NSLayoutConstraint constraintWithItem:_view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:width]];
}

- (void)pinToHeight:(CGFloat)height
{
  [self addOrReplaceExistingConstraintFromConstraint:[NSLayoutConstraint constraintWithItem:_view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:height]];
}

- (void)pinToSize:(CGSize)size
{
  [self pinToWidth:size.width];
  [self pinToHeight:size.height];
}

#pragma mark - Pinning to centre

- (void)pinSubviewToCenter:(UIView *)subview
{
  [self pinSubviewToCenterX:subview];
  [self pinSubviewToCenterY:subview];
}

- (void)pinSubviewToCenterX:(UIView *)subview
{
  [self removeConstraintsForAttribute:NSLayoutAttributeCenterX onView:subview];
  
  [_view addConstraint:[NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
}

- (void)pinSubviewToCenterY:(UIView *)subview
{
  [self pinSubviewToCenterY:subview withOffset:0];
}

- (void)pinSubviewToCenterY:(UIView *)subview withOffset:(CGFloat)offset
{
  [self removeConstraintsForAttribute:NSLayoutAttributeCenterY onView:subview];
  
  [_view addConstraint:[NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:offset]];
}

#pragma mark - Adding constraints

- (void)addOrReplaceExistingConstraintFromConstraint:(NSLayoutConstraint *)constraint
{
  NSLayoutConstraint *existingConstraint = [self existingConstraintForAttribute:constraint.firstAttribute onView:constraint.firstItem];
  
  if (existingConstraint) {
    existingConstraint.constant = constraint.constant;
  }
  else {
    [_view addConstraint:constraint];
  }
}

#pragma mark - Removing constraints

- (void)removeConstraintsForAttribute:(NSLayoutAttribute)attribute
{
  [self removeConstraintsForAttribute:attribute onView:_view];
}

- (void)removeConstraintsForAttribute:(NSLayoutAttribute)attribute onView:(UIView *)viewToMatch
{
  NSMutableArray *matchingConstraints = [NSMutableArray array];
  
  for (NSLayoutConstraint *constraint in _view.constraints) {
    if ((constraint.firstItem == viewToMatch && constraint.firstAttribute == attribute) ||
        (constraint.secondItem == viewToMatch && constraint.secondAttribute == attribute)) {
      [matchingConstraints addObject:constraint];
    }
  }
  [_view removeConstraints:matchingConstraints];
}

#pragma mark - Finding constraints

- (NSLayoutConstraint *)existingConstraintForAttribute:(NSLayoutAttribute)attribute onView:(UIView *)viewToMatch
{
  __block NSLayoutConstraint *matchingConstraint;
  
  [_view.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *constraint, NSUInteger idx, BOOL *stop) {
    if ((constraint.firstItem == viewToMatch && constraint.firstAttribute == attribute) ||
        (constraint.secondItem == viewToMatch && constraint.secondAttribute == attribute)) {
      matchingConstraint = constraint;
      *stop = YES;
    }
  }];
  
  return matchingConstraint;
}

@end
