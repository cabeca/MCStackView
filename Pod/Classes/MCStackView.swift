//
//  MCStackView.swift
//  Pods
//
//  Created by Miguel Cabeça on 28/06/15.
//
//

import UIKit

class MCStackView: UIView {

    enum MCStackViewAlignment : Int {
        case Fill
        case Leading
        static var Top: MCStackViewAlignment {
            get {

            }
        }
        case FirstBaseline
        case Center
        case Trailing
        static var Bottom: MCStackViewAlignment {
            get {

            }
        }
        case LastBaseline
    }

    enum MCStackViewDistribution : Int {
        case Fill
        case FillEqually
        case FillProportionally
        case EqualSpacing
        case EqualCentering
    }

    // MARK: Creating Stack Views
    init(arrangedSubviews views: [UIView]) {

    }

    //MARK: Managing Arranged Subviews
    func addArrangedSubview(view: UIView) {

    }

    var arrangedSubviews: [UIView] {
        get {

        }
    }

    func insertArrangedSubview(view: UIView, atIndex stackIndex: Int) {

    }

    func removeArrangedSubview(view: UIView) {

    }

    // MARK: Configuring The Layout
    var alignment = MCStackViewAlignment.Fill
    var axis = UILayoutConstraintAxisHorizontal
    var baselineRelativeArrangement = false
    var distribution = MCStackViewDistribution.Fill
    var layoutMarginsRelativeArrangement = false
    var spacing = 0.0

    
}
