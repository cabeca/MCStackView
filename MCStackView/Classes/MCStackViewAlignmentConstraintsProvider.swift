//
//  MCStackViewAlignmentConstraintsProvider.swift
//  MCStackView
//
//  Created by Miguel Cabeça on 23/07/15.
//  Copyright © 2015 Miguel Cabeça. All rights reserved.
//

import UIKit

struct MCStackViewAlignmentConstraintsProvider: MCStackViewConstraintsProvider {
    weak var stackView: MCStackView?

    init(stackView: MCStackView) {
        self.stackView = stackView
    }

    func constraintsBetweenSuperviewAndViews() -> Set<NSLayoutConstraint> {
        guard let stackView = stackView else { return Set<NSLayoutConstraint>() }
        guard stackView.visibleArrangedSubviews.count > 0 else { return Set<NSLayoutConstraint>() }

        return stackView.visibleArrangedSubviews.map{ constraintsBetweenSuperviewAndView($0) }.reduce(Set<NSLayoutConstraint>()){ $0.union($1)}
    }

    func constraintsBetweenViewsAndSuperview() -> Set<NSLayoutConstraint> {
        guard let stackView = stackView else { return Set<NSLayoutConstraint>() }
        guard stackView.visibleArrangedSubviews.count > 0 else { return Set<NSLayoutConstraint>() }

        return stackView.visibleArrangedSubviews.map{ constraintsBetweenViewAndSuperview($0) }.reduce(Set<NSLayoutConstraint>()){ $0.union($1)}
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

        var perpendicularAxisSelfLeadingLayoutAttribute: NSLayoutAttribute
        var perpendicularAxisViewLeadingLayoutAttribute: NSLayoutAttribute
        var perpendicularAxisLeadingLayoutRelation: NSLayoutRelation
        var axisViewCenterLayoutAttribute: NSLayoutAttribute
        var axisSelfCenterLayoutAttribute: NSLayoutAttribute

        switch stackView.axis {
        case .Horizontal:
            perpendicularAxisSelfLeadingLayoutAttribute = stackView.layoutMarginsRelativeArrangement ? .TopMargin : .Top
            perpendicularAxisViewLeadingLayoutAttribute = .Top
            axisSelfCenterLayoutAttribute = stackView.layoutMarginsRelativeArrangement ? .CenterYWithinMargins : .CenterY
            axisViewCenterLayoutAttribute = .CenterY
        case .Vertical:
            perpendicularAxisSelfLeadingLayoutAttribute = stackView.layoutMarginsRelativeArrangement ? .LeadingMargin : .Leading
            perpendicularAxisViewLeadingLayoutAttribute = .Leading
            axisSelfCenterLayoutAttribute = stackView.layoutMarginsRelativeArrangement ? .CenterXWithinMargins : .CenterX
            axisViewCenterLayoutAttribute = .CenterX
        }

        switch stackView.alignment {
        case .Fill:
            perpendicularAxisLeadingLayoutRelation = .Equal
        case .Leading:
            perpendicularAxisLeadingLayoutRelation = .Equal
        case .Trailing:
            perpendicularAxisLeadingLayoutRelation = .LessThanOrEqual
        case .Center:
            perpendicularAxisLeadingLayoutRelation = .LessThanOrEqual
        case .FirstBaseline:
            perpendicularAxisLeadingLayoutRelation = .LessThanOrEqual
        case .LastBaseline:
            perpendicularAxisLeadingLayoutRelation = .LessThanOrEqual
        }

        constraint = NSLayoutConstraint(item: stackView, attribute: perpendicularAxisSelfLeadingLayoutAttribute, relatedBy: perpendicularAxisLeadingLayoutRelation, toItem: view, attribute: perpendicularAxisViewLeadingLayoutAttribute, multiplier: 1.0, constant: 0.0)
        constraints.insert(constraint)

        if stackView.alignment == .Center {
            constraint = NSLayoutConstraint(item: stackView, attribute: axisSelfCenterLayoutAttribute, relatedBy: .Equal, toItem: view, attribute: axisViewCenterLayoutAttribute, multiplier: 1.0, constant: 0.0)
            constraints.insert(constraint)
        }

        return constraints
    }

    func constraintsBetweenViewAndSuperview(view: UIView) -> Set<NSLayoutConstraint> {
        guard let stackView = stackView else { return Set<NSLayoutConstraint>() }

        var constraints = Set<NSLayoutConstraint>()
        var constraint: NSLayoutConstraint

        var perpendicularAxisSelfTrailingLayoutAttribute: NSLayoutAttribute
        var perpendicularAxisViewTrailingLayoutAttribute: NSLayoutAttribute
        var perpendicularAxisTrailingLayoutRelation: NSLayoutRelation


        switch stackView.axis {
        case .Horizontal:
            perpendicularAxisSelfTrailingLayoutAttribute = stackView.layoutMarginsRelativeArrangement ? .BottomMargin : .Bottom
            perpendicularAxisViewTrailingLayoutAttribute = .Bottom
        case .Vertical:
            perpendicularAxisSelfTrailingLayoutAttribute = stackView.layoutMarginsRelativeArrangement ? .TrailingMargin : .Trailing
            perpendicularAxisViewTrailingLayoutAttribute = .Trailing
        }

        switch stackView.alignment {
        case .Fill:
            perpendicularAxisTrailingLayoutRelation = .Equal
        case .Leading:
            perpendicularAxisTrailingLayoutRelation = .LessThanOrEqual
        case .Trailing:
            perpendicularAxisTrailingLayoutRelation = .Equal
        case .Center:
            perpendicularAxisTrailingLayoutRelation = .LessThanOrEqual
        case .FirstBaseline:
            perpendicularAxisTrailingLayoutRelation = .LessThanOrEqual
        case .LastBaseline:
            perpendicularAxisTrailingLayoutRelation = .LessThanOrEqual
        }

        constraint = NSLayoutConstraint(item: view, attribute: perpendicularAxisViewTrailingLayoutAttribute, relatedBy: perpendicularAxisTrailingLayoutRelation, toItem: stackView, attribute: perpendicularAxisSelfTrailingLayoutAttribute, multiplier: 1.0, constant: 0.0)
        constraints.insert(constraint)

        return constraints
    }

    func constraintsBetween(firstView firstView: UIView, view: UIView) -> Set<NSLayoutConstraint> {
        guard let stackView = stackView else { return Set<NSLayoutConstraint>() }
        guard stackView.axis == .Horizontal else { return Set<NSLayoutConstraint>() }

        var constraints = Set<NSLayoutConstraint>()
        var constraint: NSLayoutConstraint

        switch stackView.alignment {
        case .FirstBaseline:
            constraint = NSLayoutConstraint(item: firstView, attribute: .FirstBaseline, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: .FirstBaseline, multiplier: 1.0, constant: 0.0)
            constraints.insert(constraint)
        case .LastBaseline:
            constraint = NSLayoutConstraint(item: firstView, attribute: .LastBaseline, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: .LastBaseline, multiplier: 1.0, constant: 0.0)
            constraints.insert(constraint)
        default:
            break
        }
        
        return constraints
    }
    
}
