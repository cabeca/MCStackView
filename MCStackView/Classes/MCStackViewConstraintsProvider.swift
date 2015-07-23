//
//  MCStackViewConstraintsProvider.swift
//  MCStackView
//
//  Created by Miguel Cabeça on 23/07/15.
//  Copyright © 2015 Miguel Cabeça. All rights reserved.
//

import UIKit

protocol MCStackViewConstraintsProvider {
    weak var stackView: MCStackView? {get set}
    init(stackView: MCStackView)

    func constraintsForVisibleArrangedSubviews() -> Set<NSLayoutConstraint>

    func constraintsBetweenSuperviewAndViews() -> Set<NSLayoutConstraint>
    func constraintsBetweenViewsAndSuperview() -> Set<NSLayoutConstraint>
    func constraintsBetweenViews() -> Set<NSLayoutConstraint>
    func constraintsBetweenFirstViewAndViews() -> Set<NSLayoutConstraint>

    func constraintsBetweenSuperviewAndView(view: UIView) -> Set<NSLayoutConstraint>
    func constraintsBetweenViewAndSuperview(view: UIView) -> Set<NSLayoutConstraint>
    func constraintsBetween(view view: UIView, followingView: UIView) -> Set<NSLayoutConstraint>
    func constraintsBetween(firstView firstView: UIView, view: UIView) -> Set<NSLayoutConstraint>
}

extension MCStackViewConstraintsProvider {
    func constraintsForVisibleArrangedSubviews() -> Set<NSLayoutConstraint> {
        guard let stackView = stackView else { return Set<NSLayoutConstraint>() }
        guard stackView.visibleArrangedSubviews.count > 0 else { return Set<NSLayoutConstraint>() }

        return constraintsBetweenSuperviewAndViews()
            .union(constraintsBetweenViewsAndSuperview())
            .union(constraintsBetweenViews())
            .union(constraintsBetweenFirstViewAndViews())
    }


    func constraintsBetweenSuperviewAndViews() -> Set<NSLayoutConstraint> {
        return Set<NSLayoutConstraint>()
    }

    func constraintsBetweenViewsAndSuperview() -> Set<NSLayoutConstraint> {
        return Set<NSLayoutConstraint>()
    }

    func constraintsBetweenViews() -> Set<NSLayoutConstraint> {
        return Set<NSLayoutConstraint>()
    }

    func constraintsBetweenFirstViewAndViews() -> Set<NSLayoutConstraint> {
        return Set<NSLayoutConstraint>()
    }


    func constraintsBetweenSuperviewAndView(view: UIView) -> Set<NSLayoutConstraint> {
        return Set<NSLayoutConstraint>()
    }

    func constraintsBetweenViewAndSuperview(view: UIView) -> Set<NSLayoutConstraint> {
        return Set<NSLayoutConstraint>()
    }

    func constraintsBetween(view view: UIView, followingView: UIView) -> Set<NSLayoutConstraint> {
        return Set<NSLayoutConstraint>()
    }

    func constraintsBetween(firstView firstView: UIView, view: UIView) -> Set<NSLayoutConstraint> {
        return Set<NSLayoutConstraint>()
    }
}
