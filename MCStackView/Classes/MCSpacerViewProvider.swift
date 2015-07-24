//
//  MCSpacerView.swift
//  MCStackView
//
//  Created by Miguel Cabeça on 24/07/15.
//  Copyright © 2015 Miguel Cabeça. All rights reserved.
//

import Foundation
import UIKit

class MCSpacerView: UIView {
    weak var firstView : UIView?
    weak var secondView : UIView?

    init(firstView: UIView, secondView: UIView) {
        super.init(frame: CGRect.zeroRect)
        self.firstView = firstView
        self.secondView = secondView
        translatesAutoresizingMaskIntoConstraints = false
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
        return false
    }
}

struct MCSpacerViewProvider {
    weak var stackView: MCStackView?
    var spacerViews = [MCSpacerView]()
    var count : Int {
        get {
            return spacerViews.count
        }
    }

    init(stackView: MCStackView) {
        self.stackView = stackView
    }

    subscript(index: Int) -> MCSpacerView {
        get {
            return spacerViews[index]
        }
    }

    func hasSpacerViewFor(firstView firstView: UIView, secondView: UIView) -> Bool {
        return spacerViewFor(firstView: firstView, secondView: secondView) != nil
    }

    func spacerViewFor(firstView firstView: UIView, secondView: UIView) -> MCSpacerView? {
        for spacerView in spacerViews {
            if spacerView.firstView == firstView && spacerView.secondView == secondView {
                return spacerView
            }
        }
        return nil
    }

    mutating func existingOrNewSpacerViewFor(firstView firstView: UIView, secondView: UIView) -> MCSpacerView {
        if let spacerView = spacerViewFor(firstView: firstView, secondView: secondView) {
            return spacerView
        } else {
            let spacerView = MCSpacerView(firstView: firstView, secondView: secondView)
            stackView?.addSubview(spacerView)
            spacerViews.append(spacerView)
            return spacerView
        }
    }

    mutating func removeAllSpacerViews() {
        spacerViews.map{$0.removeFromSuperview()}
        spacerViews.removeAll()
    }
}
