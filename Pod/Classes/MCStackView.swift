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

    // MARK: Private

    var visibleArrangedSubviews: [UIView] {
        get {
            return arrangedSubviews.filter { !$0.hidden }
        }
    }

    override func updateConstraints() {



        super.updateConstraints()
    }


    func alignmentConstraintsForVisibleArrangedSubviews() -> Set<NSLayoutConstraint> {
        return visibleArrangedSubviews.map{ alignmentConstraintsForView($0) }.reduce([]){ $0.union($1)}
    }

    func alignmentConstraintsForView(view: UIView) -> Set<NSLayoutConstraint> {
        var constraints = Set<NSLayoutConstraint>()
        var constraint: NSLayoutConstraint

        var axisPerpendicularLeadingLayoutAttribute: NSLayoutAttribute;
        var axisPerpendicularTrailingLayoutAttribute: NSLayoutAttribute;
        var axisCenterLayoutAttribute: NSLayoutAttribute;

        switch axis {
        case .Horizontal:
            axisPerpendicularLeadingLayoutAttribute = .Top
            axisPerpendicularTrailingLayoutAttribute = .Bottom
            axisCenterLayoutAttribute = .CenterY
        case .Vertical:
            axisPerpendicularLeadingLayoutAttribute = .Leading
            axisPerpendicularTrailingLayoutAttribute = .Trailing
            axisCenterLayoutAttribute = .CenterX
        }

        switch alignment {
        case .Fill:
            constraint = NSLayoutConstraint(item: self, attribute: axisPerpendicularLeadingLayoutAttribute, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: axisPerpendicularLeadingLayoutAttribute, multiplier: 1.0, constant: 0.0);
            constraints.insert(constraint)
            constraint = NSLayoutConstraint(item: self, attribute: axisPerpendicularTrailingLayoutAttribute, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: axisPerpendicularTrailingLayoutAttribute, multiplier: 1.0, constant: 0.0);
            constraints.insert(constraint)
        case .Leading:
            constraint = NSLayoutConstraint(item: self, attribute: axisPerpendicularLeadingLayoutAttribute, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: axisPerpendicularLeadingLayoutAttribute, multiplier: 1.0, constant: 0.0);
            constraints.insert(constraint)
        case .Trailing:
            constraint = NSLayoutConstraint(item: self, attribute: axisPerpendicularTrailingLayoutAttribute, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: axisPerpendicularTrailingLayoutAttribute, multiplier: 1.0, constant: 0.0);
            constraints.insert(constraint)
        case .Center:
            constraint = NSLayoutConstraint(item: self, attribute: axisCenterLayoutAttribute, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: axisCenterLayoutAttribute, multiplier: 1.0, constant: 0.0);
            constraints.insert(constraint)
        case .FirstBaseline, .LastBaseline:
            fatalError("Alignment by FirstBaseline and LastBaseline has not been implemented")
        }

        return constraints;
    }

    // MARK: KVO
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [NSObject : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "hidden" {
            setNeedsUpdateConstraints()
        }
    }
}
