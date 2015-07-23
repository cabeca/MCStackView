//
//  MCStackView.swift
//  Pods
//
//  Created by Miguel Cabeça on 28/06/15.
//
//

import UIKit

public class MCStackView: UIView {

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
    public init(arrangedSubviews views: [UIView]) {
        super.init(frame: CGRectZero)
        for view in views {
            addArrangedSubview(view)
        }
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        fatalError("init(coder:) has not been implemented")
    }

    //MARK: Managing Arranged Subviews
    func addArrangedSubview(view: UIView) {
        insertArrangedSubview(view, atIndex: arrangedSubviews.count)
    }

    var arrangedSubviews: [UIView] = []

    func insertArrangedSubview(view: UIView, atIndex stackIndex: Int) {
        guard stackIndex <= arrangedSubviews.count else {
            // throw NSInternalInconsistencyException
            return
        }

        view.addObserver(self, forKeyPath: "hidden", options: NSKeyValueObservingOptions.New, context: nil)

        if stackIndex == arrangedSubviews.count {
            arrangedSubviews.append(view)
        } else {
            arrangedSubviews[stackIndex] = view
        }
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
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
    var spacing: CGFloat = 0.0 {
        didSet {
            setNeedsUpdateConstraints()
        }
    }

    // MARK: Private properties

    var arrangedSubviewsConstraints = Set<NSLayoutConstraint>()

    lazy var distributionConstraintsProvider: MCStackViewConstraintsProvider = MCStackViewDistributionConstraintsProvider(stackView: self)
    lazy var alignmentConstraintsProvider: MCStackViewConstraintsProvider = MCStackViewAlignmentConstraintsProvider(stackView: self)

    // MARK: Private

    var visibleArrangedSubviews: [UIView] {
        get {
            return arrangedSubviews.filter { !$0.hidden }
        }
    }

    override public func updateConstraints() {
        let currentConstraints = arrangedSubviewsConstraints
        let newConstraints = constraintsForVisibleArrangedSubviews()

        let constraintsToRemove = currentConstraints.subtract(newConstraints)
        let constraintsToAdd = newConstraints.subtract(currentConstraints)

        removeConstraints(Array(constraintsToRemove))
        addConstraints(Array(constraintsToAdd))

        arrangedSubviewsConstraints = newConstraints

        print(constraints)
        super.updateConstraints()
    }

    func constraintsForVisibleArrangedSubviews() -> Set<NSLayoutConstraint> {
        return distributionConstraintsProvider.constraintsForVisibleArrangedSubviews()
            .union(alignmentConstraintsProvider.constraintsForVisibleArrangedSubviews())
    }

    public override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "hidden" {
            setNeedsUpdateConstraints()
        } else {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }
}
