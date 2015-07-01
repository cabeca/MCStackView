//
//  ViewController.swift
//  MCStackView
//
//  Created by Miguel Cabeça on 01/07/15.
//  Copyright © 2015 Miguel Cabeça. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let aSwitch = UISwitch()
    let aLabel = UILabel();
    let anotherLabel = UILabel();

    override func viewDidLoad() {
        super.viewDidLoad()
        setupStackViews()
    }

    func setupStackViews() {
        //        let aSwitch = UISwitch()
        aSwitch.backgroundColor = UIColor.blueColor()
        aSwitch.on = true;
        aSwitch.addTarget(self, action: Selector("switchIt"), forControlEvents: UIControlEvents.ValueChanged)
        //        let aLabel = UILabel();
        aLabel.backgroundColor = UIColor.redColor()
        aLabel.text = "Great!"
        let bLabel = UILabel();
        bLabel.backgroundColor = UIColor.purpleColor()
        bLabel.text = "Great!2"

        if #available(iOS 9.0, *) {
            let firstStackView = UIStackView(arrangedSubviews: [aSwitch, aLabel, bLabel])
            firstStackView.translatesAutoresizingMaskIntoConstraints = false;
            firstStackView.axis = .Horizontal
            firstStackView.alignment = .Fill
            firstStackView.spacing = 10
            view.addSubview(firstStackView);
            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(20)-[firstStackView]-(20)-|", options: .DirectionLeadingToTrailing, metrics: nil, views: ["firstStackView":firstStackView]))
            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-20-[firstStackView(100)]", options: .DirectionLeadingToTrailing, metrics: nil, views: ["firstStackView":firstStackView]))
        } else {
            // Fallback on earlier versions
        }

        let anotherSwitch = UISwitch()
        anotherSwitch.backgroundColor = UIColor.blueColor()
        anotherSwitch.on = true;
        //        let anotherLabel = UILabel();
        anotherLabel.backgroundColor = UIColor.redColor()
        anotherLabel.text = "Great!"
        let yetAnotherLabel = UILabel();
        yetAnotherLabel.backgroundColor = UIColor.purpleColor()
        yetAnotherLabel.text = "Great!2"

        let secondStackView = MCStackView(arrangedSubviews: [anotherSwitch, anotherLabel, yetAnotherLabel])
        secondStackView.translatesAutoresizingMaskIntoConstraints = false;
        secondStackView.axis = .Horizontal
        secondStackView.alignment = .Fill
        secondStackView.spacing = 10

        view.addSubview(secondStackView);

        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(20)-[secondStackView]-(20)-|", options: .DirectionLeadingToTrailing, metrics: nil, views: ["secondStackView": secondStackView]))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-140-[secondStackView(100)]", options: .DirectionLeadingToTrailing, metrics: nil, views: ["secondStackView": secondStackView]))


    }

    func switchIt() {
        UIView.animateWithDuration(1.0) {
            self.aLabel.hidden = !self.aSwitch.on
            self.anotherLabel.hidden = !self.aSwitch.on
        }
    }
}

