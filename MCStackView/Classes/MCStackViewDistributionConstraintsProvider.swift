//
//  MCStackViewDistributionConstraintsProvider.swift
//  MCStackView
//
//  Created by Miguel Cabeça on 23/07/15.
//  Copyright © 2015 Miguel Cabeça. All rights reserved.
//

import UIKit

struct MCStackViewDistributionConstraintsProvider: MCStackViewConstraintsProvider {
    weak var stackView: MCStackView?

    init(stackView: MCStackView) {
        self.stackView = stackView
    }

    func constraintsBetweenSuperviewAndViews() -> Set<NSLayoutConstraint> {
        guard let stackView = stackView else { return Set<NSLayoutConstraint>() }
        guard stackView.visibleArrangedSubviews.count > 0 else { return Set<NSLayoutConstraint>() }

        return constraintsBetweenSuperviewAndView(stackView.visibleArrangedSubviews.first!)
    }

    func constraintsBetweenViewsAndSuperview() -> Set<NSLayoutConstraint> {
        guard let stackView = stackView else { return Set<NSLayoutConstraint>() }
        guard stackView.visibleArrangedSubviews.count > 0 else { return Set<NSLayoutConstraint>() }

        return constraintsBetweenViewAndSuperview(stackView.visibleArrangedSubviews.last!)
    }

    func constraintsBetweenViews() -> Set<NSLayoutConstraint> {
        guard let stackView = stackView else { return Set<NSLayoutConstraint>() }
        guard stackView.visibleArrangedSubviews.count > 1 else { return Set<NSLayoutConstraint>() }

        var constraints = Set<NSLayoutConstraint>()
        for index in 0..<stackView.visibleArrangedSubviews.count - 1 {
            constraints = constraints.union(constraintsBetween(view: stackView.visibleArrangedSubviews[index], followingView: stackView.visibleArrangedSubviews[index + 1]))
        }
        return constraints;
    }

    func constraintsBetweenFirstViewAndViews() -> Set<NSLayoutConstraint> {
        guard let stackView = stackView else { return Set<NSLayoutConstraint>() }
        guard stackView.visibleArrangedSubviews.count > 1 else { return Set<NSLayoutConstraint>() }

        var constraints = Set<NSLayoutConstraint>()
        for index in 1..<stackView.visibleArrangedSubviews.count {
            constraints = constraints.union(constraintsBetween(firstView: stackView.visibleArrangedSubviews.first!, view: stackView.visibleArrangedSubviews[index]))
        }
        return constraints
    }

    func constraintsBetweenSuperviewAndView(view: UIView) -> Set<NSLayoutConstraint> {
        guard let stackView = stackView else { return Set<NSLayoutConstraint>() }

        var constraints = Set<NSLayoutConstraint>()
        var constraint: NSLayoutConstraint

        var superviewLayoutAttribute: NSLayoutAttribute
        var viewLayoutAttribute: NSLayoutAttribute

        switch stackView.axis {
        case .Horizontal:
            superviewLayoutAttribute = stackView.layoutMarginsRelativeArrangement ? .LeadingMargin : .Leading
            viewLayoutAttribute = .Leading
        case .Vertical:
            superviewLayoutAttribute = stackView.layoutMarginsRelativeArrangement ? .TopMargin : .Top
            viewLayoutAttribute = .Top
        }

        constraint = NSLayoutConstraint(item: stackView, attribute: superviewLayoutAttribute, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: viewLayoutAttribute, multiplier: 1.0, constant: 0.0)
        constraints.insert(constraint)

        return constraints
    }

    func constraintsBetweenViewAndSuperview(view: UIView) -> Set<NSLayoutConstraint> {
        guard let stackView = stackView else { return Set<NSLayoutConstraint>() }

        var constraints = Set<NSLayoutConstraint>()
        var constraint: NSLayoutConstraint

        var superviewLayoutAttribute: NSLayoutAttribute
        var viewLayoutAttribute: NSLayoutAttribute

        switch stackView.axis {
        case .Horizontal:
            superviewLayoutAttribute = stackView.layoutMarginsRelativeArrangement ? .TrailingMargin : .Trailing
            viewLayoutAttribute = .Trailing
        case .Vertical:
            superviewLayoutAttribute = stackView.layoutMarginsRelativeArrangement ? .BottomMargin : .Bottom
            viewLayoutAttribute = .Bottom
        }

        constraint = NSLayoutConstraint(item: view, attribute: viewLayoutAttribute, relatedBy: NSLayoutRelation.Equal, toItem: stackView, attribute: superviewLayoutAttribute, multiplier: 1.0, constant: 0.0)
        constraints.insert(constraint)

        return constraints
    }

    func constraintsBetween(view view: UIView, followingView: UIView) -> Set<NSLayoutConstraint> {
        guard let stackView = stackView else { return Set<NSLayoutConstraint>() }

        var constraints = Set<NSLayoutConstraint>()
        var constraint: NSLayoutConstraint

        var viewLayoutAttribute: NSLayoutAttribute
        var followingViewLayoutAttribute: NSLayoutAttribute

        switch stackView.axis {
        case .Horizontal:
            viewLayoutAttribute = .Trailing
            followingViewLayoutAttribute = .Leading
        case .Vertical:
            viewLayoutAttribute = .Bottom
            followingViewLayoutAttribute = .Top
        }

        switch stackView.distribution {
        case .Fill:
            constraint = NSLayoutConstraint(item: followingView, attribute: followingViewLayoutAttribute, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: viewLayoutAttribute, multiplier: 1.0, constant: stackView.spacing)
            constraints.insert(constraint)
        default:
            fatalError("Distribution other than Fill has not been implemented")
        }
        
        return constraints
    }
}
