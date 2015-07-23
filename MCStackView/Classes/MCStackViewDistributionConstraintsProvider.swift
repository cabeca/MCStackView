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

    func constraintsForVisibleArrangedSubviews() -> Set<NSLayoutConstraint> {
        guard let stackView = stackView else { return Set<NSLayoutConstraint>() }
        guard stackView.visibleArrangedSubviews.count > 0 else { return Set<NSLayoutConstraint>() }

        return constraintsBetweenSuperviewAndFirstView()
            .union(constraintsBetweenLastViewAndSuperview())
            .union(constraintsBetweenViews())
            .union(constraintsBetweenFirstViewAndViews())
            .union(constraintsBetweenViewsAndSuperview())
    }

    func constraintsBetweenSuperviewAndFirstView() -> Set<NSLayoutConstraint> {
        guard let stackView = stackView else { return Set<NSLayoutConstraint>() }
        guard stackView.visibleArrangedSubviews.count > 0 else { return Set<NSLayoutConstraint>() }
        let view = stackView.visibleArrangedSubviews.first!

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

    func constraintsBetweenLastViewAndSuperview() -> Set<NSLayoutConstraint> {
        guard let stackView = stackView else { return Set<NSLayoutConstraint>() }
        guard stackView.visibleArrangedSubviews.count > 0 else { return Set<NSLayoutConstraint>() }
        let view = stackView.visibleArrangedSubviews.last!

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

    func constraintsBetweenViews() -> Set<NSLayoutConstraint> {
        guard let stackView = stackView else { return Set<NSLayoutConstraint>() }
        guard stackView.visibleArrangedSubviews.count > 1 else { return Set<NSLayoutConstraint>() }

        var constraints = Set<NSLayoutConstraint>()
        for index in 0..<stackView.visibleArrangedSubviews.count - 1 {
            constraints = constraints.union(constraintsBetween(view: stackView.visibleArrangedSubviews[index], followingView: stackView.visibleArrangedSubviews[index + 1]))
        }
        return constraints;
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
            constraint = NSLayoutConstraint(item: followingView, attribute: followingViewLayoutAttribute, relatedBy: .Equal, toItem: view, attribute: viewLayoutAttribute, multiplier: 1.0, constant: stackView.spacing)
            constraints.insert(constraint)
        case .FillEqually:
            constraint = NSLayoutConstraint(item: followingView, attribute: followingViewLayoutAttribute, relatedBy: .Equal, toItem: view, attribute: viewLayoutAttribute, multiplier: 1.0, constant: stackView.spacing)
            constraints.insert(constraint)
        case .FillProportionally:
            constraint = NSLayoutConstraint(item: followingView, attribute: followingViewLayoutAttribute, relatedBy: .Equal, toItem: view, attribute: viewLayoutAttribute, multiplier: 1.0, constant: stackView.spacing)
            constraints.insert(constraint)
        default:
            fatalError("Distribution other than Fill has not been implemented")
        }

        return constraints
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

    func constraintsBetween(firstView firstView: UIView, view: UIView) -> Set<NSLayoutConstraint> {
        guard let stackView = stackView else { return Set<NSLayoutConstraint>() }

        var constraints = Set<NSLayoutConstraint>()
        var constraint: NSLayoutConstraint

        var firstViewLayoutAttribute: NSLayoutAttribute
        var viewLayoutAttribute: NSLayoutAttribute

        switch stackView.axis {
        case .Horizontal:
            firstViewLayoutAttribute = .Width
            viewLayoutAttribute = .Width
        case .Vertical:
            firstViewLayoutAttribute = .Height
            viewLayoutAttribute = .Height
        }

        switch stackView.distribution {
        case .FillEqually:
            constraint = NSLayoutConstraint(item: firstView, attribute: firstViewLayoutAttribute, relatedBy: .Equal, toItem: view, attribute: viewLayoutAttribute, multiplier: 1.0, constant: 0.0)
            constraints.insert(constraint)
        default:
            break
        }

        return constraints
    }

    func constraintsBetweenViewsAndSuperview() -> Set<NSLayoutConstraint> {
        guard let stackView = stackView else { return Set<NSLayoutConstraint>() }
        guard stackView.visibleArrangedSubviews.count > 0 else { return Set<NSLayoutConstraint>() }

        let sumOfWidths = stackView.visibleArrangedSubviews.reduce(0.0) { $0 + $1.intrinsicContentSize().width } + stackView.spacing * CGFloat(stackView.visibleArrangedSubviews.count - 1)
        let sumOfHeights = stackView.visibleArrangedSubviews.reduce(0.0) { $0 + $1.intrinsicContentSize().height } + stackView.spacing * CGFloat(stackView.visibleArrangedSubviews.count - 1)

        func constraintsBetweenViewAndSuperview(view view: UIView, index: Int) -> Set<NSLayoutConstraint> {

            var constraints = Set<NSLayoutConstraint>()
            var constraint: NSLayoutConstraint

            var viewLayoutAttribute: NSLayoutAttribute
            var superviewLayoutAttribute: NSLayoutAttribute
            var multiplier: CGFloat

            switch stackView.axis {
            case .Horizontal:
                viewLayoutAttribute = .Width
                superviewLayoutAttribute = .Width
                multiplier = view.intrinsicContentSize().width / sumOfWidths
            case .Vertical:
                viewLayoutAttribute = .Height
                superviewLayoutAttribute = .Height
                multiplier = view.intrinsicContentSize().height / sumOfHeights
            }

            switch stackView.distribution {
            case .FillProportionally:
                constraint = NSLayoutConstraint(item: view, attribute: viewLayoutAttribute, relatedBy: .Equal, toItem: stackView, attribute: superviewLayoutAttribute, multiplier: multiplier, constant: 0.0)
                constraint.priority = UILayoutPriority(999 - index)
                constraints.insert(constraint)
            default:
                break
            }
            
            return constraints
        }

        var constraints = Set<NSLayoutConstraint>()
        for index in 0..<stackView.visibleArrangedSubviews.count {
            constraints = constraints.union(constraintsBetweenViewAndSuperview(view: stackView.visibleArrangedSubviews[index], index: index))
        }
        return constraints
    }
}
