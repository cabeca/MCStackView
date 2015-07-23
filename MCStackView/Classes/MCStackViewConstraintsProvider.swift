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
}
