//
//  NarrativeLayout.swift
//  Benny
//
//  Created by Robert Manson on 4/13/15.
//  Copyright (c) 2015 Benny, Inc. All rights reserved.
//

import UIKit

/**
Types of UIViews supported by this layout.

- Field:      Resizing text field
- Label:      Stylized UILabel
*/

enum NarrativeItem {
    case Field(textField: UITextField, valueChangedClosure: UITextField -> Bool)
    case Label(UILabel)
    case Button(UIButton, buttonPressedClosure: () -> Void)
}

/**
*  Helper to determine layout location of the subviews
*/
struct NarrativeLayout {
    let origin: CGPoint
    let rowWidth: CGFloat
    let rowHeight: CGFloat
    let rowVerticalPadding: CGFloat
    /**
    Layout items inside the given frame.
    
    - parameter layoutItems: The items to be laid out
    
    - returns: Array of UIViews with their frames laid out to be contained inside the frame
    */
    func layout(layoutItems: [NarrativeItem]) -> [UIView] {
        func resizeTextField(textField: UITextField) {
            let widthThatFits = textField.sizeThatFits(CGSize(width: rowWidth, height: 40)).width
            let newWidth = (widthThatFits > rowWidth ? rowWidth : widthThatFits)
            textField.frame.size = CGSize(width: newWidth , height: rowHeight)
        }
        func resizeButton(button: UIButton) {
            let widthThatFits = button.sizeThatFits(CGSize(width: rowWidth, height: 40)).width
            let newWidth = (widthThatFits > rowWidth ? rowWidth : widthThatFits)
            button.frame.size = CGSize(width: newWidth , height: rowHeight)
        }
        func resizeLabel(label: UILabel) {
            let widthThatFits = label.sizeThatFits(CGSize(width: 999, height: 40)).width
            label.frame.size = CGSize(width: widthThatFits , height: rowHeight)
        }
        func positionView(view: UIView, currentRow: CGFloat, currentOffset: CGFloat, previousView: UIView?) -> (CGFloat, CGFloat) {
            var row = currentRow
            var xOffset = currentOffset + leadSpacing(view: view, currentOffset: currentOffset, previousView: previousView)
            if view.frame.width > calculateSpaceRemaining(rowWidth: rowWidth, currentOffset: currentOffset) {
                row++
                xOffset = origin.x
            }
            view.frame.origin.x = xOffset
            let verticalPadding = (row == 0 ? 0 : rowVerticalPadding)
            view.frame.origin.y = origin.y + (row * (rowHeight + verticalPadding))
            xOffset += view.frame.width
            return (row, xOffset)
        }
        var xOffset = origin.x
        var row = 0 as CGFloat
        var laidOut: Array<UIView> = []
        for item in layoutItems {
            switch item {
            case let .Field(textField, _):
                resizeTextField(textField)
                (row, xOffset) = positionView(textField, currentRow: row, currentOffset: xOffset, previousView: laidOut.last)
                laidOut.append(textField)
            case .Label(let label):
                resizeLabel(label)
                (row, xOffset) = positionView(label, currentRow: row, currentOffset: xOffset, previousView: laidOut.last)
                laidOut.append(label)
                label.isAccessibilityElement = false
            case let .Button(button, _):
                resizeButton(button)
                (row, xOffset) = positionView(button, currentRow: row, currentOffset: xOffset, previousView: laidOut.last)
                laidOut.append(button)
            }
        }
        return laidOut
    }
    //MARK: - Private
    private func calculateSpaceRemaining(rowWidth rowWidth: CGFloat, currentOffset: CGFloat) -> CGFloat {
        let space = rowWidth - currentOffset
        return space > 0 ? space : 0
    }
    private func leadSpacing(view view: UIView, currentOffset: CGFloat, previousView: UIView?) -> CGFloat{
        if previousView == nil {
            return 0
        } else if view.frame.width > calculateSpaceRemaining(rowWidth: rowWidth, currentOffset: currentOffset) {
            return 0
        } else {
            return 4
        }
    }
}
