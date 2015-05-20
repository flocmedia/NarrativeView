//
//  ViewController.swift
//  Example
//
//  Created by Robert Manson on 5/5/15.
//  Copyright (c) 2015 Benny. All rights reserved.
//

import UIKit
import NarrativeView

class TextField: UITextField, NarrativeTextFieldSettableAppearance {
    private let contentInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    var appearance: NarrativeTextFieldAppearance = .Ready {
        didSet {
            setNeedsDisplay()
        }
    }
    override func drawRect(rect: CGRect) {
        let bottomPath = UIBezierPath(rect: CGRectMake(rect.minX, rect.maxY - 4, rect.maxX , rect.maxY - 2))
        switch appearance {
        case .Invalid:
            UIColor.redColor().setFill()
        case .Ready:
            UIColor.blackColor().setFill()
        case .Valid:
            UIColor.greenColor().setFill()
        }
        bottomPath.fill()
    }
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, contentInsets)
    }
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, contentInsets)
    }
}

class ViewController: UIViewController, NarrativeViewDelegate {
    @IBOutlet weak var allDoneLabel: UILabel!
    @IBOutlet weak var narrativeView: NarrativeView!
    let tagger = NSLinguisticTagger(tagSchemes: NSLinguisticTagger.availableTagSchemesForLanguage("en"), options: Int(NSLinguisticTaggerOptions.OmitWhitespace.rawValue))
    private func newField(placeholder: String) -> () -> UITextField {
        return {
            let field = TextField()
            field.placeholder = placeholder
            field.sizeToFit()
            return field
        }
    }
    let newLabel: () -> UILabel = {
        let label =  UILabel()
        label.textColor = UIColor.blackColor()
        return label
    }
    var allDone = false {
        didSet {
            allDoneLabel.hidden = !allDone
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        narrativeView.label(createLabel: newLabel, text: "One Valentines's")
            .textField(createTextField: newField("noun")) { field in
                return self.isNoun(field.text)
            }
            .label(createLabel: newLabel, text: "I was")
            .textField(createTextField: newField("-ing verb")) { field in
                return self.isIngVerb(field.text)
            }
            .label(createLabel: newLabel, text: ", when I looked in my")
            .textField(createTextField: newField("noun")) { field in
                return self.isNoun(field.text)
            }
            .label(createLabel: newLabel, text: "and saw a")
            .textField(createTextField: newField("adjective")) { field in
                return self.isAdjective(field.text)
            }
            .textField(createTextField: newField("noun")) { field in
                return self.isNoun(field.text)
            }
            .label(createLabel: newLabel, text: "!")
            .initialLayout()
        narrativeView.narrativeViewDelegate = self
        narrativeView.backgroundColor = UIColor.yellowColor().colorWithAlphaComponent(0.5)
        narrativeView.rowHeight = 40.0
        narrativeView.rowVerticalPadding = 4.0
        narrativeView.setNeedsDisplay()
    }
    //MARK: - Helpers
    func isNoun(s: String) -> Bool {
        let sentence = "The \(s)" // tagger only works with more than one word?
        let options = NSLinguisticTaggerOptions.OmitWhitespace | NSLinguisticTaggerOptions.OmitOther | NSLinguisticTaggerOptions.OmitPunctuation | NSLinguisticTaggerOptions.JoinNames
        tagger.string = sentence
        var ret = false
        tagger.enumerateTagsInRange(NSMakeRange(0, count(sentence)), scheme: NSLinguisticTagSchemeLexicalClass, options: options) { (tag:String!, tokenRange:NSRange, _, _) in
            if tag == NSLinguisticTagNoun {
                ret = true
            }
        }
        return ret
    }
    func isIngVerb(s: String) -> Bool {
        if let range = s.rangeOfString("ing$", options: .RegularExpressionSearch){
            return true
        }
        return false
    }
    func isAdjective(s: String) -> Bool {
        let sentence = "The \(s)" // tagger only works with more than one word?
        let options = NSLinguisticTaggerOptions.OmitWhitespace | NSLinguisticTaggerOptions.OmitOther | NSLinguisticTaggerOptions.OmitPunctuation | NSLinguisticTaggerOptions.JoinNames
        tagger.string = sentence
        var ret = false
        tagger.enumerateTagsInRange(NSMakeRange(0, count(sentence)), scheme: NSLinguisticTagSchemeLexicalClass, options: options) { (tag:String!, tokenRange:NSRange, _, _)  in
            if tag == NSLinguisticTagAdjective {
                ret = true
            }
        }
        return ret
    }
    //MARK: - NarrativeViewDelegate
    func narrativeViewDidValidate(allWereValid: Bool) {
        allDone = allWereValid
    }
    func narrativeViewDoneButtonPressed(allWereValid: Bool) -> Bool {
        if allWereValid {
            allDone = true
            return false
        } else {
            return true
        }
    }
}

