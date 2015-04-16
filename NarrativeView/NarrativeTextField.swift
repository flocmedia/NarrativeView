//
//  NarrativeTextField.swift
//  Benny
//
//  Created by Robert Manson on 4/13/15.
//  Copyright (c) 2015 Benny, Inc. All rights reserved.
//

import UIKit

@objc public enum NarrativeTextFieldAppearance: Int {
    case Ready
    case Invalid
    case Valid
}

@objc public protocol NarrativeTextFieldSettableAppearance {
    var appearance: NarrativeTextFieldAppearance {get set}
}
