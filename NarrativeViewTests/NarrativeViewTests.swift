//
//  NarrativeViewTests.swift
//  NarrativeViewTests
//
//  Created by Robert Manson on 4/16/15.
//  Copyright (c) 2015 Benny. All rights reserved.
//

import UIKit
import XCTest
import NarrativeView


class TextField: UITextField, NarrativeTextFieldSettableAppearance {
    private let contentInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    var appearance: NarrativeTextFieldAppearance = .Ready {
        didSet {
            setNeedsDisplay()
        }
    }
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, contentInsets)
    }
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, contentInsets)
    }
    override func sizeThatFits(size: CGSize) -> CGSize {
        return CGSize(width: 20, height: 20)
    }
}

class NarrativeViewTests: XCTestCase {
    private func newField(placeholder: String) -> () -> UITextField {
        return {
            let field = TextField()
            field.placeholder = placeholder
            field.sizeToFit()
            return field
        }
    }
    /// Ensure view is created to be the right size
    func testViewBounds() {
        let view = NarrativeView(frame: CGRect(x: 0, y: 0, width: 200, height: 200), rowHeight: 20, rowVerticalPadding: 4)
        view.layoutSubviews()
        let viewHeight = view.bounds.height
        XCTAssert(viewHeight == 200)
    }
    /// Two text fields are stacked right on top of each other with 4 pts padding
    func testStackedRowsAndPadding() {
        let valChanged: UITextField -> Bool = {  textField in
            return true
        }
        let view = NarrativeView(frame: CGRect(x: 0, y: 0, width: 20, height: 200), rowHeight: 20, rowVerticalPadding: 4)
        view.textField(createTextField: newField("Test"), valueChanged: valChanged)
        view.textField(createTextField: newField("Test"), valueChanged: valChanged)
        view.initialLayout()
        view.layoutSubviews()
        let items = view.testingGetFlowItems()
        XCTAssert(items[0].frame.origin.x == 0)
        XCTAssert(items[0].frame.origin.y == 0)
        XCTAssert(items[1].frame.origin.x == 0)
        XCTAssert(items[1].frame.origin.y == 24)
    }
    /// Two text fields are places on same line with 4 pts padding between items
    func testSideBySideItems() {
        let valChanged: UITextField -> Bool = {  textField in
            return true
        }
        let view = NarrativeView(frame: CGRect(x: 0, y: 0, width: 44, height: 200), rowHeight: 20, rowVerticalPadding: 4)
        view.textField(createTextField: newField("Test"), valueChanged: valChanged)
        view.textField(createTextField: newField("Test"), valueChanged: valChanged)
        view.initialLayout()
        view.layoutSubviews()
        let items = view.testingGetFlowItems()
        XCTAssert(items[0].frame.origin.x == 0)
        XCTAssert(items[0].frame.origin.y == 0)
        XCTAssert(items[0].frame.width == 20)
        XCTAssert(items[1].frame.origin.x == 24)
        XCTAssert(items[1].frame.origin.y == 0)
        XCTAssert(items[1].frame.width == 20)
    }
}
