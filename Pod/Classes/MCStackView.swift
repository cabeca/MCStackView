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
            get { return .Leading }
        }
        case FirstBaseline
        case Center
        case Trailing
        static var Bottom: MCStackViewAlignment {
            get { return .Trailing }
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
        super.init(frame: CGRectZero)
        for view in views {
            addArrangedSubview(view);
        }
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: Managing Arranged Subviews
    func addArrangedSubview(view: UIView) {
        insertArrangedSubview(view, atIndex: arrangedSubviews.count)
    }

    var arrangedSubviews: [UIView] = []

    func insertArrangedSubview(view: UIView, atIndex stackIndex: Int) {
        guard stackIndex <= arrangedSubviews.count else {
            // throw NSInternalInconsistencyException
            return;
        }

        view.addObserver(self, forKeyPath: "hidden", options: NSKeyValueObservingOptions.New, context: nil)

        if stackIndex == arrangedSubviews.count {
            arrangedSubviews.append(view)
        } else {
            arrangedSubviews[stackIndex] = view
        }
        addSubview(view)
        setNeedsUpdateConstraints()
    }

    func removeArrangedSubview(view: UIView) {
        if let viewIndex = arrangedSubviews.indexOf(view) {
            view.removeObserver(self, forKeyPath: "hidden")
            arrangedSubviews.removeAtIndex(viewIndex)
            setNeedsUpdateConstraints()
        }
    }

    // MARK: Configuring The Layout
    var alignment = MCStackViewAlignment.Fill {
        didSet {
            setNeedsUpdateConstraints()
        }
    }
    var axis = UILayoutConstraintAxis.Horizontal {
        didSet {
            setNeedsUpdateConstraints()
        }
    }
    var baselineRelativeArrangement = false {
        didSet {
            setNeedsUpdateConstraints()
        }
    }
    var distribution = MCStackViewDistribution.Fill {
        didSet {
            setNeedsUpdateConstraints()
        }
    }
    var layoutMarginsRelativeArrangement = false {
        didSet {
            setNeedsUpdateConstraints()
        }
    }
    var spacing = 0.0 {
        didSet {
            setNeedsUpdateConstraints()
        }
    }

    func insertArrangedSubview(view: UIView, atIndex stackIndex: Int) {

    }

    func removeArrangedSubview(view: UIView) {

    }

    // MARK: KVO
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [NSObject : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "hidden" {
            setNeedsUpdateConstraints()
        }
    }
}
