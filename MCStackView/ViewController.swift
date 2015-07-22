//
//  ViewController.swift
//  MCStackView
//
//  Created by Miguel Cabeça on 01/07/15.
//  Copyright © 2015 Miguel Cabeça. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var uiStackView: UIView!
    @IBOutlet weak var mcStackView: MCStackView!
    @IBOutlet weak var widthSlider: UISlider!
    @IBOutlet weak var uiStackViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var mcStackViewTrailingConstraint: NSLayoutConstraint!

    let aSwitch = UISwitch()
    let aLabel = UILabel();
    let anotherLabel = UILabel();

    override func viewDidLoad() {
        super.viewDidLoad()
        setupStackViews()
        setupWidthSlider()
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
            let firstStackView = UIStackView()
            firstStackView.translatesAutoresizingMaskIntoConstraints = false;
            firstStackView.addArrangedSubview(aSwitch)
            firstStackView.addArrangedSubview(aLabel)
            firstStackView.addArrangedSubview(bLabel)
            firstStackView.axis = .Horizontal
            firstStackView.alignment = .Fill
            firstStackView.spacing = 10
            uiStackView.addSubview(firstStackView);
            uiStackView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[firstStackView]|", options: .DirectionLeadingToTrailing, metrics: nil, views: ["firstStackView":firstStackView]))
            uiStackView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[firstStackView]|", options: .DirectionLeadingToTrailing, metrics: nil, views: ["firstStackView":firstStackView]))
        } else {
            let notSupportedLabel = UILabel()
            notSupportedLabel.numberOfLines = 0
            notSupportedLabel.text = NSLocalizedString("UIStackView is not suported on this iOS version", comment: "")
            uiStackView.addSubview(notSupportedLabel)
            uiStackView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[firstStackView]|", options: .DirectionLeadingToTrailing, metrics: nil, views: ["firstStackView":notSupportedLabel]))
            uiStackView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[firstStackView]|", options: .DirectionLeadingToTrailing, metrics: nil, views: ["firstStackView":notSupportedLabel]))
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

        let secondStackView = mcStackView
        secondStackView.addArrangedSubview(anotherSwitch)
        secondStackView.addArrangedSubview(anotherLabel)
        secondStackView.addArrangedSubview(yetAnotherLabel)
        secondStackView.axis = .Horizontal
        secondStackView.alignment = .Fill
        secondStackView.spacing = 10

    }

    func setupWidthSlider() {
        widthSlider.value = 1.0
        widthSlider.addTarget(self, action: Selector("changeWidth"), forControlEvents: UIControlEvents.ValueChanged)
    }

    func switchIt() {
        UIView.animateWithDuration(1.0) {
            self.aLabel.hidden = !self.aSwitch.on
            self.anotherLabel.hidden = !self.aSwitch.on
        }
    }

    func changeWidth() {
        let totalWidth = widthSlider.bounds.width
        let newWidth = totalWidth * CGFloat(widthSlider.value)

        uiStackViewTrailingConstraint.constant = totalWidth - newWidth
        mcStackViewTrailingConstraint.constant = totalWidth - newWidth
    }

    @IBAction func changeAlignement(sender: UISegmentedControl) {
        if #available(iOS 9.0, *) {
            let firstStackView = uiStackView.subviews.first as! UIStackView
            firstStackView.alignment = UIStackViewAlignment(rawValue: sender.selectedSegmentIndex)!
        } else {

        }
        let secondStackView = mcStackView
        secondStackView.alignment = MCStackView.MCStackViewAlignment(rawValue: sender.selectedSegmentIndex)!
    }

    @IBAction func changeAxis(sender: UISegmentedControl) {
        if #available(iOS 9.0, *) {
            let firstStackView = uiStackView.subviews.first as! UIStackView
            firstStackView.axis = UILayoutConstraintAxis(rawValue: sender.selectedSegmentIndex)!
        } else {

        }
        let secondStackView = mcStackView
        secondStackView.axis = UILayoutConstraintAxis(rawValue: sender.selectedSegmentIndex)!

    }
}

