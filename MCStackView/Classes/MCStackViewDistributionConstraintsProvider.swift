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

        stackView.spacerViewProvider.removeAllSpacerViews()
        return constraintsBetweenSuperviewAndFirstView()
            .union(constraintsBetweenLastViewAndSuperview())
            .union(constraintsBetweenViews())
            .union(constraintsBetweenFirstViewAndViews())
            .union(constraintsBetweenViewsAndSuperview())
            .union(constraintsBetweenSpacerViews())
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
            viewLayoutAttribute = stackView.baselineRelativeArrangement ? .FirstBaseline : .Top
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
            viewLayoutAttribute = stackView.baselineRelativeArrangement ? .LastBaseline : .Bottom
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
        var spacerWidthOrHeightLayoutAttribute : NSLayoutAttribute
        var spacerCenterLayoutAttribute : NSLayoutAttribute
        var viewCenterLayoutAttribute : NSLayoutAttribute

        switch stackView.axis {
        case .Horizontal:
            viewLayoutAttribute = .Trailing
            followingViewLayoutAttribute = .Leading
            spacerWidthOrHeightLayoutAttribute = .Height
            spacerCenterLayoutAttribute = .CenterY
            viewCenterLayoutAttribute = .CenterX
        case .Vertical:
            viewLayoutAttribute = stackView.baselineRelativeArrangement ? .LastBaseline : .Bottom
            followingViewLayoutAttribute = stackView.baselineRelativeArrangement ? .FirstBaseline : .Top
            spacerWidthOrHeightLayoutAttribute = .Width
            spacerCenterLayoutAttribute = .CenterX
            viewCenterLayoutAttribute = .CenterY
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
        case .EqualSpacing:
            constraint = NSLayoutConstraint(item: followingView, attribute: followingViewLayoutAttribute, relatedBy: .GreaterThanOrEqual, toItem: view, attribute: viewLayoutAttribute, multiplier: 1.0, constant: stackView.spacing)
            constraints.insert(constraint)

            let spacerView = stackView.spacerViewProvider.existingOrNewSpacerViewFor(firstView: view, secondView: followingView)

            constraint = NSLayoutConstraint(item: view, attribute: viewLayoutAttribute, relatedBy: .Equal, toItem: spacerView, attribute: followingViewLayoutAttribute, multiplier: 1.0, constant: 0.0)
            constraints.insert(constraint)
            constraint = NSLayoutConstraint(item: spacerView, attribute: viewLayoutAttribute, relatedBy: .Equal, toItem: followingView, attribute: followingViewLayoutAttribute, multiplier: 1.0, constant: 0.0)
            constraints.insert(constraint)
            constraint = NSLayoutConstraint(item: spacerView, attribute: spacerWidthOrHeightLayoutAttribute, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 0.0)
            constraints.insert(constraint)
            constraint = NSLayoutConstraint(item: spacerView, attribute: spacerCenterLayoutAttribute, relatedBy: .Equal, toItem: stackView, attribute: spacerCenterLayoutAttribute, multiplier: 1.0, constant: 0.0)
            constraints.insert(constraint)

        case .EqualCentering:
            constraint = NSLayoutConstraint(item: followingView, attribute: followingViewLayoutAttribute, relatedBy: .GreaterThanOrEqual, toItem: view, attribute: viewLayoutAttribute, multiplier: 1.0, constant: stackView.spacing)
            constraints.insert(constraint)

            let spacerView = stackView.spacerViewProvider.existingOrNewSpacerViewFor(firstView: view, secondView: followingView)

            constraint = NSLayoutConstraint(item: view, attribute: viewCenterLayoutAttribute, relatedBy: .Equal, toItem: spacerView, attribute: followingViewLayoutAttribute, multiplier: 1.0, constant: 0.0)
            constraints.insert(constraint)
            constraint = NSLayoutConstraint(item: spacerView, attribute: viewLayoutAttribute, relatedBy: .Equal, toItem: followingView, attribute: viewCenterLayoutAttribute, multiplier: 1.0, constant: 0.0)
            constraints.insert(constraint)
            constraint = NSLayoutConstraint(item: spacerView, attribute: spacerWidthOrHeightLayoutAttribute, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 0.0)
            constraints.insert(constraint)
            constraint = NSLayoutConstraint(item: spacerView, attribute: spacerCenterLayoutAttribute, relatedBy: .Equal, toItem: stackView, attribute: spacerCenterLayoutAttribute, multiplier: 1.0, constant: 0.0)
            constraints.insert(constraint)
            
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

    func constraintsBetweenSpacerViews() -> Set<NSLayoutConstraint> {
        guard let stackView = stackView else { return Set<NSLayoutConstraint>() }
        guard stackView.spacerViewProvider.count > 1 else { return Set<NSLayoutConstraint>() }

        var constraints = Set<NSLayoutConstraint>()
        for index in 0..<stackView.spacerViewProvider.count - 1 {
            constraints = constraints.union(constraintsBetween(spacerView: stackView.spacerViewProvider[index], followingSpacerView: stackView.spacerViewProvider[index + 1]))
        }
        return constraints;
    }

    func constraintsBetween(spacerView spacerView: UIView, followingSpacerView: UIView) -> Set<NSLayoutConstraint> {
        guard let stackView = stackView else { return Set<NSLayoutConstraint>() }

        var constraints = Set<NSLayoutConstraint>()
        var constraint: NSLayoutConstraint

        var spacerViewLayoutAttribute: NSLayoutAttribute
        var followingSpacerViewLayoutAttribute: NSLayoutAttribute

        switch stackView.axis {
        case .Horizontal:
            spacerViewLayoutAttribute = .Width
            followingSpacerViewLayoutAttribute = .Width
        case .Vertical:
            spacerViewLayoutAttribute = .Height
            followingSpacerViewLayoutAttribute = .Height
        }

        switch stackView.distribution {
        case .EqualSpacing:
            constraint = NSLayoutConstraint(item: spacerView, attribute: spacerViewLayoutAttribute, relatedBy: .Equal, toItem: followingSpacerView, attribute: followingSpacerViewLayoutAttribute, multiplier: 1.0, constant: 0.0)
            constraints.insert(constraint)
        case .EqualCentering:
            constraint = NSLayoutConstraint(item: spacerView, attribute: spacerViewLayoutAttribute, relatedBy: .Equal, toItem: followingSpacerView, attribute: followingSpacerViewLayoutAttribute, multiplier: 1.0, constant: 0.0)
            constraint.priority = UILayoutPriorityDefaultHigh - 1
            constraints.insert(constraint)
        default:
            break
        }
        return constraints
    }
}
