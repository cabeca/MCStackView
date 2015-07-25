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

        view.addObserver(self, forKeyPath: "hidden", options: [.Old, .New], context: nil)

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
    lazy var spacerViewProvider : MCSpacerViewProvider = MCSpacerViewProvider(stackView: self)

    // MARK: Private

    var visibleArrangedSubviews: [UIView] {
        get {
            return arrangedSubviews.filter { $0.isVisible() }
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

        super.updateConstraints()
    }

    func constraintsForVisibleArrangedSubviews() -> Set<NSLayoutConstraint> {
        return distributionConstraintsProvider.constraintsForVisibleArrangedSubviews()
            .union(alignmentConstraintsProvider.constraintsForVisibleArrangedSubviews())
    }

    public override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "hidden" {
            guard let view = object as? UIView else { return }

            let newValue = (change?[NSKeyValueChangeNewKey] as? Bool) ?? false
            let oldValue = (change?[NSKeyValueChangeOldKey] as? Bool) ?? false

            if newValue == oldValue {
                return
            }

            if view.isAnimatingHidden {
                return
            }

            let frame = view.frame
            setNeedsUpdateConstraints()
            setNeedsLayout()
            layoutIfNeeded()

            if newValue == true {
                if view.hasAnimations() {
                    view.startAnimatingHidden()
                    CATransaction.begin()
                    CATransaction.setCompletionBlock {
                        view.finishAnimatingHidden()
                    }
                    view.frame = frame
                    CATransaction.commit()
                }
            } else {
                view.layer.removeAllAnimations()
            }

        } else {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }
}

import ObjectiveC

private var isAnimatingHiddenAssociationKey: UInt8 = 0

extension UIView {
    var isAnimatingHidden: Bool {
        get {
            if let value = objc_getAssociatedObject(self, &isAnimatingHiddenAssociationKey) as? Bool {
                return value
            } else {
                objc_setAssociatedObject(self, &isAnimatingHiddenAssociationKey, false, .OBJC_ASSOCIATION_ASSIGN)
                return false
            }
        }
        set(newValue) {
            objc_setAssociatedObject(self, &isAnimatingHiddenAssociationKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }

    func hasAnimations() -> Bool {
        return layer.animationKeys() != nil
    }

    func hasNoAnimations() -> Bool {
        return !hasAnimations()
    }

    func isAnimatingHiddenStopped() -> Bool {
        return isAnimatingHidden && hasNoAnimations()
    }

    func startAnimatingHidden() {
        isAnimatingHidden = true
        hidden = false
    }

    func finishAnimatingHidden() {
        hidden = true
        isAnimatingHidden = false
    }

    func isVisible() -> Bool {
        return !(hidden || isAnimatingHidden)
    }

}
