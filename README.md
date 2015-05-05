# NarrativeView
Madlib style form view

![](https://github.com/bennyinc/NarrativeView/blob/master/madlib.gif)

# Features
1. Text fields expand while users are entering text, reflowing to the next line if necessary
2. Labels are broken up as individual words
3. All text fields are validated via passed in lambda and appearance is updatable via the `NarrativeTextFieldSettableAppearance` protocol

# Usage

1. Create an instance of Narrative view via either IB or programatically.
2. Implement the NarrativeViewDelegate delegate on your VC and set `narrativeViewDelegate`
3. Describe your view by chaining together `label`, `textfield` or `button` methods followed by a call to `initialLayout`

e.g.

        narrativeView.label(createLabel: newLabel, text: "Enter your")
            .textField(createTextField: newField("user name")) { field in
                return self.validateUsername(field.text)
            }
            .label(createLabel: newLabel, text: "and")
            .textField(createTextField: newField("password")) { field in
                return self.validatePassword(field.text)
            }
            .label(createLabel: newLabel, text: "to log in.")
            .initialLayout()
            

# Example Madlib app
Simple Madlib style form with primitive field validation.  After you complete the madlib the view is updated to congratulate you.


