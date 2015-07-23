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
        aLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        let bLabel = UILabel();
        bLabel.backgroundColor = UIColor.purpleColor()
        bLabel.text = "Great! It works!"
        bLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleFootnote)

        if #available(iOS 9.0, *) {
            let firstStackView = UIStackView()
            firstStackView.translatesAutoresizingMaskIntoConstraints = false;
            firstStackView.addArrangedSubview(aSwitch)
            firstStackView.addArrangedSubview(aLabel)
            firstStackView.addArrangedSubview(bLabel)
            firstStackView.axis = .Horizontal
            firstStackView.alignment = .Fill
            firstStackView.spacing = 0
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
        anotherLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        let yetAnotherLabel = UILabel();
        yetAnotherLabel.backgroundColor = UIColor.purpleColor()
        yetAnotherLabel.text = "Great! It works!"
        yetAnotherLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleFootnote)


        let secondStackView = mcStackView
        secondStackView.addArrangedSubview(anotherSwitch)
        secondStackView.addArrangedSubview(anotherLabel)
        secondStackView.addArrangedSubview(yetAnotherLabel)
        secondStackView.axis = .Horizontal
        secondStackView.alignment = .Fill
        secondStackView.spacing = 0

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

    @IBAction func changeDistribution(sender: AnyObject) {
        if #available(iOS 9.0, *) {
            let firstStackView = uiStackView.subviews.first as! UIStackView
            firstStackView.distribution = UIStackViewDistribution(rawValue: sender.selectedSegmentIndex)!
        } else {

        }
        let secondStackView = mcStackView
        secondStackView.distribution = MCStackView.MCStackViewDistribution(rawValue: sender.selectedSegmentIndex)!
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

    @IBAction func changeMargins(sender: AnyObject) {
        if #available(iOS 9.0, *) {
            let firstStackView = uiStackView.subviews.first as! UIStackView
            switch sender.selectedSegmentIndex {
            case 1:
                firstStackView.layoutMarginsRelativeArrangement = true
                firstStackView.layoutMargins = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
            case 2:
                firstStackView.layoutMarginsRelativeArrangement = true
                firstStackView.layoutMargins = UIEdgeInsets(top: 10, left: 20, bottom: 30, right: 40)
            default:
                firstStackView.layoutMarginsRelativeArrangement = false
            }
        } else {

        }
        let secondStackView = mcStackView
        switch sender.selectedSegmentIndex {
        case 1:
            secondStackView.layoutMarginsRelativeArrangement = true
            secondStackView.layoutMargins = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        case 2:
            secondStackView.layoutMarginsRelativeArrangement = true
            secondStackView.layoutMargins = UIEdgeInsets(top: 10, left: 20, bottom: 30, right: 40)
        default:
            secondStackView.layoutMarginsRelativeArrangement = false
        }

    }

    @IBAction func changeSpacing(sender: AnyObject) {
        if #available(iOS 9.0, *) {
            let firstStackView = uiStackView.subviews.first as! UIStackView
            switch sender.selectedSegmentIndex {
            case 1:
                firstStackView.spacing = 10
            case 2:
                firstStackView.spacing = 20
            default:
                firstStackView.spacing = 0
            }
        } else {

        }
        let secondStackView = mcStackView
        switch sender.selectedSegmentIndex {
        case 1:
            secondStackView.spacing = 10
        case 2:
            secondStackView.spacing = 20
        default:
            secondStackView.spacing = 0
        }
    }

    @IBAction func printAllConstraints() {
        if #available(iOS 9.0, *) {
            let firstStackView = uiStackView.subviews.first as! UIStackView
            printConstraints(firstStackView.constraints)
        }
        let secondStackView = mcStackView
        printConstraints(secondStackView.constraints)
    }

    func printConstraints(constraints: Array<NSLayoutConstraint>) {
        constraints.map { print($0) }
    }
}

