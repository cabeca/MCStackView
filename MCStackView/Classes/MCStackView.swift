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
        return distributionConstraintsForVisibleArrangedSubviews().union(alignmentConstraintsForVisibleArrangedSubviews())
    }

    func distributionConstraintsForVisibleArrangedSubviews() -> Set<NSLayoutConstraint> {
        let visibleArrangedSubviews = self.visibleArrangedSubviews
        guard !visibleArrangedSubviews.isEmpty else { return Set<NSLayoutConstraint>() }

        var distributionConstraints = Set<NSLayoutConstraint>()
        var constraints = Set<NSLayoutConstraint>()

        for var i = 0; i < visibleArrangedSubviews.count - 1; i++ {
            constraints = distributionConstraintsBetween(firstView: visibleArrangedSubviews[i], secondView: visibleArrangedSubviews[i+1])
            distributionConstraints.unionInPlace(constraints)
        }

        constraints = distributionConstraintsBetweenSuperviewAndView(visibleArrangedSubviews.first!)
        distributionConstraints.unionInPlace(constraints)
        constraints = distributionConstraintsBetweenViewAndSuperview(visibleArrangedSubviews.last!)
        distributionConstraints.unionInPlace(constraints)

        return distributionConstraints
    }

    func distributionConstraintsBetween(firstView firstView: UIView, secondView: UIView) -> Set<NSLayoutConstraint> {
        var constraints = Set<NSLayoutConstraint>()
        var constraint: NSLayoutConstraint

        var previousViewLayoutAttribute: NSLayoutAttribute
        var nextViewLayoutAttribute: NSLayoutAttribute

        switch axis {
        case .Horizontal:
            previousViewLayoutAttribute = .Trailing
            nextViewLayoutAttribute = .Leading
        case .Vertical:
            previousViewLayoutAttribute = .Bottom
            nextViewLayoutAttribute = .Top
        }

        switch distribution {
        case .Fill:
            constraint = NSLayoutConstraint(item: secondView, attribute: nextViewLayoutAttribute, relatedBy: NSLayoutRelation.Equal, toItem: firstView, attribute: previousViewLayoutAttribute, multiplier: 1.0, constant: spacing)
            constraints.insert(constraint)
        default:
            fatalError("Distribution other than Fill has not been implemented")
        }

        return constraints
    }

    func distributionConstraintsBetweenSuperviewAndView(view: UIView) -> Set<NSLayoutConstraint> {
        var constraints = Set<NSLayoutConstraint>()
        var constraint: NSLayoutConstraint

        var superviewLayoutAttribute: NSLayoutAttribute
        var viewLayoutAttribute: NSLayoutAttribute

        switch axis {
        case .Horizontal:
            superviewLayoutAttribute = layoutMarginsRelativeArrangement ? .LeadingMargin : .Leading
            viewLayoutAttribute = .Leading
        case .Vertical:
            superviewLayoutAttribute = layoutMarginsRelativeArrangement ? .TopMargin : .Top
            viewLayoutAttribute = .Top
        }

        constraint = NSLayoutConstraint(item: self, attribute: superviewLayoutAttribute, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: viewLayoutAttribute, multiplier: 1.0, constant: 0.0)
        constraints.insert(constraint)

        return constraints
    }

    func distributionConstraintsBetweenViewAndSuperview(view: UIView) -> Set<NSLayoutConstraint> {
        var constraints = Set<NSLayoutConstraint>()
        var constraint: NSLayoutConstraint

        var superviewLayoutAttribute: NSLayoutAttribute
        var viewLayoutAttribute: NSLayoutAttribute

        switch axis {
        case .Horizontal:
            superviewLayoutAttribute = layoutMarginsRelativeArrangement ? .TrailingMargin : .Trailing
            viewLayoutAttribute = .Trailing
        case .Vertical:
            superviewLayoutAttribute = layoutMarginsRelativeArrangement ? .BottomMargin : .Bottom
            viewLayoutAttribute = .Bottom
        }

        constraint = NSLayoutConstraint(item: view, attribute: viewLayoutAttribute, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: superviewLayoutAttribute, multiplier: 1.0, constant: 0.0)
        constraints.insert(constraint)

        return constraints
    }

    func alignmentConstraintsForVisibleArrangedSubviews() -> Set<NSLayoutConstraint> {
        let alignmentConstraintsBetweenSuperviewAndViews = visibleArrangedSubviews.map{ alignmentConstraintsBetweenSuperviewAndView($0) }.reduce(Set<NSLayoutConstraint>()){ $0.union($1)}

        var alignmentConstraintsBetweenFirstViewAndViews = Set<NSLayoutConstraint>()
        if visibleArrangedSubviews.count > 1 {
            alignmentConstraintsBetweenFirstViewAndViews = visibleArrangedSubviews.map{ alignmentConstraintsBetween(firstView: visibleArrangedSubviews.first!, view: $0) }.reduce(Set<NSLayoutConstraint>()){ $0.union($1)}
        }
        return alignmentConstraintsBetweenSuperviewAndViews.union(alignmentConstraintsBetweenFirstViewAndViews)
    }

    func alignmentConstraintsBetweenSuperviewAndView(view: UIView) -> Set<NSLayoutConstraint> {
        var constraints = Set<NSLayoutConstraint>()
        var constraint: NSLayoutConstraint

        var perpendicularAxisSelfLeadingLayoutAttribute: NSLayoutAttribute
        var perpendicularAxisViewLeadingLayoutAttribute: NSLayoutAttribute
        var perpendicularAxisSelfTrailingLayoutAttribute: NSLayoutAttribute
        var perpendicularAxisViewTrailingLayoutAttribute: NSLayoutAttribute
        var axisViewCenterLayoutAttribute: NSLayoutAttribute
        var axisSelfCenterLayoutAttribute: NSLayoutAttribute

        switch axis {
        case .Horizontal:
            perpendicularAxisSelfLeadingLayoutAttribute = layoutMarginsRelativeArrangement ? .TopMargin : .Top
            perpendicularAxisViewLeadingLayoutAttribute = .Top
            perpendicularAxisSelfTrailingLayoutAttribute = layoutMarginsRelativeArrangement ? .BottomMargin : .Bottom
            perpendicularAxisViewTrailingLayoutAttribute = .Bottom
            axisSelfCenterLayoutAttribute = layoutMarginsRelativeArrangement ? .CenterYWithinMargins : .CenterY
            axisViewCenterLayoutAttribute = .CenterY
        case .Vertical:
            perpendicularAxisSelfLeadingLayoutAttribute = layoutMarginsRelativeArrangement ? .LeadingMargin : .Leading
            perpendicularAxisViewLeadingLayoutAttribute = .Leading
            perpendicularAxisSelfTrailingLayoutAttribute = layoutMarginsRelativeArrangement ? .TrailingMargin : .Trailing
            perpendicularAxisViewTrailingLayoutAttribute = .Trailing
            axisSelfCenterLayoutAttribute = layoutMarginsRelativeArrangement ? .CenterXWithinMargins : .CenterX
            axisViewCenterLayoutAttribute = .CenterX
        }

        switch alignment {
        case .Fill:
            constraint = NSLayoutConstraint(item: self, attribute: perpendicularAxisSelfLeadingLayoutAttribute, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: perpendicularAxisViewLeadingLayoutAttribute, multiplier: 1.0, constant: 0.0)
            constraints.insert(constraint)
            constraint = NSLayoutConstraint(item: view, attribute: perpendicularAxisViewTrailingLayoutAttribute, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: perpendicularAxisSelfTrailingLayoutAttribute, multiplier: 1.0, constant: 0.0)
            constraints.insert(constraint)
        case .Leading:
            constraint = NSLayoutConstraint(item: self, attribute: perpendicularAxisSelfLeadingLayoutAttribute, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: perpendicularAxisViewLeadingLayoutAttribute, multiplier: 1.0, constant: 0.0)
            constraints.insert(constraint)
            constraint = NSLayoutConstraint(item: view, attribute: perpendicularAxisViewTrailingLayoutAttribute, relatedBy: NSLayoutRelation.LessThanOrEqual, toItem: self, attribute: perpendicularAxisSelfTrailingLayoutAttribute, multiplier: 1.0, constant: 0.0)
            constraints.insert(constraint)
        case .Trailing:
            constraint = NSLayoutConstraint(item: self, attribute: perpendicularAxisSelfLeadingLayoutAttribute, relatedBy: NSLayoutRelation.LessThanOrEqual, toItem: view, attribute: perpendicularAxisViewLeadingLayoutAttribute, multiplier: 1.0, constant: 0.0)
            constraints.insert(constraint)
            constraint = NSLayoutConstraint(item: view, attribute: perpendicularAxisViewTrailingLayoutAttribute, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: perpendicularAxisSelfTrailingLayoutAttribute, multiplier: 1.0, constant: 0.0)
            constraints.insert(constraint)
        case .Center:
            constraint = NSLayoutConstraint(item: self, attribute: perpendicularAxisSelfLeadingLayoutAttribute, relatedBy: NSLayoutRelation.LessThanOrEqual, toItem: view, attribute: perpendicularAxisViewLeadingLayoutAttribute, multiplier: 1.0, constant: 0.0)
            constraints.insert(constraint)
            constraint = NSLayoutConstraint(item: view, attribute: perpendicularAxisViewTrailingLayoutAttribute, relatedBy: NSLayoutRelation.LessThanOrEqual, toItem: self, attribute: perpendicularAxisSelfTrailingLayoutAttribute, multiplier: 1.0, constant: 0.0)
            constraints.insert(constraint)
            constraint = NSLayoutConstraint(item: self, attribute: axisSelfCenterLayoutAttribute, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: axisViewCenterLayoutAttribute, multiplier: 1.0, constant: 0.0)
            constraints.insert(constraint)
        case .FirstBaseline:
            constraint = NSLayoutConstraint(item: self, attribute: perpendicularAxisSelfLeadingLayoutAttribute, relatedBy: NSLayoutRelation.LessThanOrEqual, toItem: view, attribute: perpendicularAxisViewLeadingLayoutAttribute, multiplier: 1.0, constant: 0.0)
            constraints.insert(constraint)
            constraint = NSLayoutConstraint(item: view, attribute: perpendicularAxisViewTrailingLayoutAttribute, relatedBy: NSLayoutRelation.LessThanOrEqual, toItem: self, attribute: perpendicularAxisSelfTrailingLayoutAttribute, multiplier: 1.0, constant: 0.0)
            constraints.insert(constraint)
        case .LastBaseline:
            constraint = NSLayoutConstraint(item: self, attribute: perpendicularAxisSelfLeadingLayoutAttribute, relatedBy: NSLayoutRelation.LessThanOrEqual, toItem: view, attribute: perpendicularAxisViewLeadingLayoutAttribute, multiplier: 1.0, constant: 0.0)
            constraints.insert(constraint)
            constraint = NSLayoutConstraint(item: view, attribute: perpendicularAxisViewTrailingLayoutAttribute, relatedBy: NSLayoutRelation.LessThanOrEqual, toItem: self, attribute: perpendicularAxisSelfTrailingLayoutAttribute, multiplier: 1.0, constant: 0.0)
            constraints.insert(constraint)
        }
        return constraints
    }

    func alignmentConstraintsBetween(firstView firstView: UIView, view: UIView) -> Set<NSLayoutConstraint> {
        var constraints = Set<NSLayoutConstraint>()
        var constraint: NSLayoutConstraint

        guard axis == .Horizontal else { return constraints }

        switch alignment {
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

    public override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "hidden" {
            setNeedsUpdateConstraints()
        } else {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }
}
