//
//  ViewController.swift
//  Storyly_UICustomization_Demo_App
//
//  Created by Emre Kılınç on 21.06.2022.
//

import UIKit
import Storyly

class ViewController: UIViewController {
    
//    DEFAULT PICKER VIEW VALUES NEED TO BE UPDATED TO DEFAULT OF STORYLY.
    @IBOutlet weak var defaultView: StorylyView!
    @IBOutlet weak var containerToCustom: UIView!
    var customizedView = StorylyView()
    let STORYLY_INSTANCE_TOKEN = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhY2NfaWQiOjc2MCwiYXBwX2lkIjo0MDUsImluc19pZCI6NDA0fQ.1AkqOy_lsiownTBNhVOUKc91uc9fDcAxfQZtpm3nj40"
//    Story Group Text Styling
    var storyGroupTextIsVisible = true
    @IBOutlet weak var textVisibleButton: UIButton!
    @IBOutlet weak var fontPicker: UIPickerView!
    @IBOutlet weak var lineNumberPicker: UIPickerView!
    let groupTextFontDict: [String:UIFont] = ["System Font": UIFont.systemFont(ofSize: 12),"Bold System Font" : UIFont.boldSystemFont(ofSize: 12)]
    var lineNumber = 2
    var fontSize = 12
    var font = UIFont.systemFont(ofSize: CGFloat(12))
//    STORY GROUP COLORS
    @IBOutlet weak var stylesAndColors: UIPickerView!
    var properties = ["Background":"#000000","Pin Icon":"#000000","Ivod Icon":"#000000","Text Color":"#000000", ]
    var propertiesNames = ["Background","Pin Icon","Ivod Icon","Text Color"]
     //needs to be updated with default values
    var currentPropertyIndex = "Background" //change this to property name
    @IBOutlet weak var colorShowcase: UIView!
    @IBOutlet weak var colorField: UITextField!
//Seen - Not seen system
    @IBOutlet weak var seenColorView: UIView!
    @IBOutlet weak var notSeenColorView: UIView!
    var seenStack = UIStackView()
    var notSeenStack = UIStackView()
    var colorsOfSeenState : [Int:UIColor] = [:]
    var colorsOfNotSeenSate: [Int:UIColor] = [:]
    @IBOutlet weak var viewsContainer: UIView!
    @IBOutlet weak var notSeenColorsLabel: UILabel!
    @IBOutlet weak var seenColorsLabel: UILabel!
    @IBOutlet weak var borderColorField: UITextField!
    let widthOfStack = 60
    var availableIndexesNotSeen = [0,2,4,6,8]
    var availableIndexesSeen = [1,3,5,7,9]
    var frontItem = "x"
    var pickedSize = "large"
//    Story Group Size element
    @IBOutlet weak var smallButton: UIButton!
    @IBOutlet weak var largeButton: UIButton!
    @IBOutlet weak var customButton: UIButton!
    @IBOutlet weak var heightTextF: UITextField!
    @IBOutlet weak var widthTextF: UITextField!
    @IBOutlet weak var cornerRadiusTextF: UITextField!
    @IBOutlet weak var customDesignView: UIStackView!
    //    NEEDS TO BE UPDATED WITH DEFAULT SIZES
    var height = 12
    var width = 12
    var cRadius = 10
//    Story Group List Styling
    @IBOutlet weak var edgePadding: UITextField!
    @IBOutlet weak var paddingBetweenItems: UITextField!
    var edgePadValue = 20 //needs to be updated with default values
    var padBetweenItemsValue = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
         reset button and viewDidLoad have similar view setup
         can create method as: setupViews() and include view setup there to reduce redundancy and clearity
         */
        
        //default
        defaultView.storylyInit = StorylyInit(storylyId: STORYLY_INSTANCE_TOKEN)
        defaultView.rootViewController = self
        defaultView.delegate = self
        //customized
        customizedView.storylyInit = StorylyInit(storylyId: STORYLY_INSTANCE_TOKEN)
        customizedView.rootViewController = self
        customizedView.delegate = self
        containerToCustom.addSubview(customizedView)
        customizedView.translatesAutoresizingMaskIntoConstraints = false
        customizedView.heightAnchor.constraint(equalTo: containerToCustom.heightAnchor).isActive = true
        customizedView.widthAnchor.constraint(equalTo: containerToCustom.widthAnchor).isActive = true
        customizedView.centerXAnchor.constraint(equalTo: containerToCustom.centerXAnchor).isActive = true
        customizedView.centerYAnchor.constraint(equalTo: containerToCustom.centerYAnchor).isActive = true
        //Story Group Text Styling
        fontPicker.delegate = self
        fontPicker.dataSource = self
        fontPicker.selectRow(11, inComponent: 1, animated: true)
        lineNumberPicker.delegate = self
        lineNumberPicker.dataSource = self
        lineNumberPicker.selectRow(1, inComponent: 0, animated: true)
//        property and color system
        stylesAndColors.delegate = self
        stylesAndColors.dataSource = self
        colorShowcase.layer.cornerRadius = colorShowcase.frame.size.width/2
        colorShowcase.clipsToBounds = true
        colorShowcase.backgroundColor = UIColor.black
        colorField.delegate = self
        colorField.tag = 0
        customDesignView.isUserInteractionEnabled = false
//        Seen and not Seen border color system
        /*
            - stack is reinitializing unnecessary => for resetting added seen/notseen views can remove subviews from stacks
                - example:
                    seenStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
                        
            - if you want to use programmatic approach can add different programmatic views with lazy to minize time on first load and to create views when needed
                https://docs.swift.org/swift-book/LanguageGuide/Properties.html => Lazy Stored Properties section
                - example:
                 private lazy var seenStack = {
                     let _seenStack = UIStackView()
                     _seenStack.translatesAutoresizingMaskIntoConstraints = false
                     _seenStack.spacing = CGFloat(10)
                     return _seenStack
                 }
                            
         */
        seenColorView.addSubview(seenStack)
        notSeenColorView.addSubview(notSeenStack)
        seenStack.translatesAutoresizingMaskIntoConstraints = false
        seenStack.leftAnchor.constraint(equalTo: seenColorsLabel.rightAnchor,constant: CGFloat(10)).isActive = true
        seenStack.spacing = CGFloat(10)
        notSeenStack.translatesAutoresizingMaskIntoConstraints = false
        notSeenStack.leftAnchor.constraint(equalTo: notSeenColorsLabel.rightAnchor,constant: CGFloat(10)).isActive = true
        notSeenStack.spacing = CGFloat(10)
        borderColorField.tag = 1
        borderColorField.delegate = self
    }
    
    @IBAction func resetButtonAction(_ sender: Any) {
        
        /*
            default value set and view reseting can be seperated into multiple methods for clearity
         */
        lineNumber = 2
        fontSize = 12
        fontPicker.selectRow(11, inComponent: 1, animated: true)
        fontPicker.selectRow(0, inComponent: 0, animated: true)
        lineNumberPicker.selectRow(1, inComponent: 0, animated: true)
        font = UIFont.systemFont(ofSize: CGFloat(12))
        properties = ["Background":"#000000","Pin Icon":"#000000","Ivod Icon":"#000000","Text Color":"#000000"]
        currentPropertyIndex = "Background"
//        border color stacks
        stylesAndColors.selectRow(0, inComponent: 0, animated: true)
        colorsOfSeenState = [:]
        colorsOfNotSeenSate = [:]
        availableIndexesNotSeen = [0,2,4,6,8]
        availableIndexesSeen = [1,3,5,7,9]
        seenStack.removeFromSuperview()
        notSeenStack.removeFromSuperview()
        seenStack = UIStackView()
        notSeenStack = UIStackView()
        seenColorView.addSubview(seenStack)
        notSeenColorView.addSubview(notSeenStack)
        seenStack.translatesAutoresizingMaskIntoConstraints = false
        seenStack.leftAnchor.constraint(equalTo: seenColorsLabel.rightAnchor,constant: CGFloat(10)).isActive = true
        seenStack.spacing = CGFloat(10)
        notSeenStack.translatesAutoresizingMaskIntoConstraints = false
        notSeenStack.leftAnchor.constraint(equalTo: notSeenColorsLabel.rightAnchor,constant: CGFloat(10)).isActive = true
        notSeenStack.spacing = CGFloat(10)
        height = 12
        width = 12
        cRadius = 10
        edgePadValue = 20 //needs to be updated with default values
        padBetweenItemsValue = 20
        storyGroupTextIsVisible = true
        /*
             re-used UIImage's can be used from properties
                example:
                private lazy let icon = UIImage(systemName: "circle.inset.filled",withConfiguration: UIImage.SymbolConfiguration(scale: .large)
         */
        textVisibleButton.setImage(UIImage(systemName: "circle.inset.filled",withConfiguration: UIImage.SymbolConfiguration(scale: .large))?.withTintColor(UIColor.tintColor), for: UIControl.State.normal)
        pickedSize = "large"
        customizedView.removeFromSuperview()
        customizedView = StorylyView()
        customizedView.storylyInit = StorylyInit(storylyId: STORYLY_INSTANCE_TOKEN)
        customizedView.rootViewController = self
        customizedView.delegate = self
        containerToCustom.addSubview(customizedView)
        customizedView.translatesAutoresizingMaskIntoConstraints = false
        customizedView.heightAnchor.constraint(equalTo: containerToCustom.heightAnchor).isActive = true
        customizedView.widthAnchor.constraint(equalTo: containerToCustom.widthAnchor).isActive = true
        customizedView.centerXAnchor.constraint(equalTo: containerToCustom.centerXAnchor).isActive = true
        customizedView.centerYAnchor.constraint(equalTo: containerToCustom.centerYAnchor).isActive = true
        
    }
    @IBAction func textVisibilityChange(_ sender: Any) {
        if(storyGroupTextIsVisible){
            storyGroupTextIsVisible = false
            textVisibleButton.setImage(UIImage(systemName: "circle",withConfiguration: UIImage.SymbolConfiguration(scale: .large))?.withTintColor(UIColor.tintColor), for: UIControl.State.normal)
            
            
        }
        else{
            storyGroupTextIsVisible = true
            textVisibleButton.setImage(UIImage(systemName: "circle.inset.filled",withConfiguration: UIImage.SymbolConfiguration(scale: .large))?.withTintColor(UIColor.tintColor), for: UIControl.State.normal)
            
        }
        let currentColor = properties["Text Color"]
        self.customizedView.storyGroupTextStyling = StoryGroupTextStyling(isVisible: self.storyGroupTextIsVisible, color: UIColor.init(hexString: currentColor ?? "#000000"), font: font, lines: lineNumber)
        
    }
    
    @IBAction func applyColorToProperty(_ sender: Any) {
        colorShowcase.backgroundColor = UIColor(hexString: colorField.text ?? "#000000")
        switch currentPropertyIndex{
            case "Background":
            //Background
                self.customizedView.storyGroupIconBackgroundColor = UIColor(hexString: colorField.text ?? "#000000")
                properties["Background"] = colorField.text ?? "#000000"
                break
            case "Pin Icon":
                self.customizedView.storyGroupPinIconColor = UIColor(hexString: colorField.text ?? "#000000" )
                properties["Pin Icon"] = colorField.text ?? "#000000"
                break
            case "Ivod Icon":
                self.customizedView.storyGroupIVodIconColor = UIColor(hexString: colorField.text ?? "#000000")
                properties["Ivod Icon"] = colorField.text ?? "#000000"
                
                break
            case "Text Color":
                self.customizedView.storyGroupTextStyling =  StoryGroupTextStyling(isVisible: self.storyGroupTextIsVisible, color:UIColor(hexString: colorField.text  ?? "#000000"), font: self.font, lines: self.lineNumber)
                properties["Text Color"] =  colorField.text ?? "#000000"
                break
        default:
            break
        }
        
        
    }
    
    /*
     - using nested stack -> stack -> button with notSeen/seen color can be reduced to stack (colors container) -> button (color)
        - for performance and simplicity
     - rather than using availableIndexesNotSeen and color button tags, from stack can access to button views (color) to simplify
        to access and check which button clicked in buttonActionForStateColors method
            find index of the subview button with checking is sender equal to color from stack
                => use that index to remove from colorsOfNotSeenSate/colorsOfSeenSate
     */
    
    @IBAction func notSeenAddButton(_ sender: Any) {
        if(availableIndexesNotSeen.isEmpty){
            return
        }
        let myStack = UIStackView() // will be convertted to stack
        myStack.translatesAutoresizingMaskIntoConstraints = false
        notSeenStack.addArrangedSubview(myStack)
        myStack.widthAnchor.constraint(equalToConstant: CGFloat(widthOfStack)).isActive = true
        myStack.heightAnchor.constraint(equalToConstant: CGFloat(30)).isActive = true
        myStack.centerYAnchor.constraint(equalTo: notSeenColorsLabel.centerYAnchor).isActive = true
        let button = UIButton()
        button.tag = availableIndexesNotSeen[0]
        availableIndexesNotSeen.remove(at: 0)
        colorsOfNotSeenSate[button.tag] = UIColor(hexString: borderColorField.text ?? "#FFFFFF")
        
        //index for removing the color
        button.addTarget(self, action: #selector(buttonActionForStateColors), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(borderColorField.text ?? "#FFFFFF", for: UIControl.State.normal)
        button.titleLabel?.font = .systemFont(ofSize: 10)
        button.backgroundColor = UIColor(hexString: borderColorField.text ?? "#FFFFFF")
        myStack.addSubview(button)
        button.widthAnchor.constraint(equalToConstant: CGFloat(widthOfStack)).isActive = true
        button.heightAnchor.constraint(equalToConstant: CGFloat(30)).isActive = true
        button.centerYAnchor.constraint(equalTo: myStack.centerYAnchor).isActive = true
        button.rightAnchor.constraint(equalTo: myStack.rightAnchor,constant: CGFloat(-3)).isActive = true
        button.layer.cornerRadius = 8
        let v = Array(colorsOfNotSeenSate.values)
        customizedView.storyGroupIconBorderColorNotSeen = v
        
    }
    
    @IBAction func seenAddButton(_ sender: Any) {
        if(availableIndexesSeen.isEmpty){
            return
        }
        let myStack = UIStackView() // will be convertted to stack
        myStack.translatesAutoresizingMaskIntoConstraints = false
        seenStack.addArrangedSubview(myStack)
        myStack.widthAnchor.constraint(equalToConstant: CGFloat(widthOfStack)).isActive = true
        myStack.heightAnchor.constraint(equalToConstant: CGFloat(30)).isActive = true
        myStack.centerYAnchor.constraint(equalTo: seenColorsLabel.centerYAnchor).isActive = true
    
        let button = UIButton()
        button.tag = availableIndexesSeen[0]
        availableIndexesSeen.remove(at: 0)
        colorsOfSeenState[button.tag] = UIColor(hexString: borderColorField.text ?? "#FFFFFF")
        
        button.addTarget(self, action: #selector(buttonActionForStateColors), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setTitle(borderColorField.text ?? "#FFFFFF", for: UIControl.State.normal)
        button.titleLabel?.font = .systemFont(ofSize: 10)
        button.backgroundColor = UIColor(hexString: borderColorField.text ?? "#FFFFFF")
        myStack.addSubview(button)
        button.widthAnchor.constraint(equalToConstant: CGFloat(widthOfStack)).isActive = true
        button.heightAnchor.constraint(equalToConstant: CGFloat(30)).isActive = true
        button.centerYAnchor.constraint(equalTo: myStack.centerYAnchor).isActive = true
        button.rightAnchor.constraint(equalTo: myStack.rightAnchor,constant: CGFloat(-3)).isActive = true
        button.layer.cornerRadius = 8
        let v = Array(colorsOfSeenState.values)
        customizedView.storyGroupIconBorderColorSeen = v
    }
    
    @objc func buttonActionForStateColors(_ sender: UIButton){
        
        sender.superview?.removeFromSuperview()
        let keysNotSeen = Array(colorsOfNotSeenSate.keys)
        if(keysNotSeen.contains(sender.tag)){//it means func called from notSeenState button
            colorsOfNotSeenSate.removeValue(forKey: sender.tag)
            let v = Array(colorsOfNotSeenSate.values)
            customizedView.storyGroupIconBorderColorNotSeen = v
            availableIndexesNotSeen.append(sender.tag)
        }
        else{
            colorsOfSeenState.removeValue(forKey: sender.tag)
            let v = Array(colorsOfSeenState.values)
            customizedView.storyGroupIconBorderColorSeen = v
            availableIndexesSeen.append(sender.tag)
        }
        
    }
//    Story Group Size functions
    @IBAction func convertToSmall(_ sender: Any) {
        
        smallButton.setImage(UIImage(systemName: "circle.inset.filled",withConfiguration: UIImage.SymbolConfiguration(scale: .large))?.withTintColor(UIColor.black), for: UIControl.State.normal)
        if(pickedSize == "custom"){
            customButton.setImage(UIImage(systemName: "circle",withConfiguration: UIImage.SymbolConfiguration(scale: .large))?.withTintColor(UIColor.black), for: UIControl.State.normal)
            pickedSize = "small"
            bringBackOldProperties()
        }
        else if(pickedSize == "large"){
            largeButton.setImage(UIImage(systemName: "circle",withConfiguration: UIImage.SymbolConfiguration(scale: .large))?.withTintColor(UIColor.black), for: UIControl.State.normal)
            pickedSize = "small"
            bringBackOldProperties()
        }
        customDesignView.isUserInteractionEnabled = false
    }
    @IBAction func convertToLarge(_ sender: Any) {
        largeButton.setImage(UIImage(systemName: "circle.inset.filled",withConfiguration: UIImage.SymbolConfiguration(scale: .large))?.withTintColor(UIColor.black), for: UIControl.State.normal)
        if(pickedSize == "custom"){
            customButton.setImage(UIImage(systemName: "circle",withConfiguration: UIImage.SymbolConfiguration(scale: .large))?.withTintColor(UIColor.black), for: UIControl.State.normal)
            pickedSize = "large"
            bringBackOldProperties()
        }
        else if(pickedSize == "small"){
            smallButton.setImage(UIImage(systemName: "circle",withConfiguration: UIImage.SymbolConfiguration(scale: .large))?.withTintColor(UIColor.black), for: UIControl.State.normal)
            pickedSize = "large"
            bringBackOldProperties()
        }
        customDesignView.isUserInteractionEnabled = false
    }
    @IBAction func converToCustom(_ sender: Any) {
        customButton.setImage(UIImage(systemName: "circle.inset.filled",withConfiguration: UIImage.SymbolConfiguration(scale: .large))?.withTintColor(UIColor.black), for: UIControl.State.normal)
        if(pickedSize == "small"){
            smallButton.setImage(UIImage(systemName: "circle",withConfiguration: UIImage.SymbolConfiguration(scale: .large))?.withTintColor(UIColor.black), for: UIControl.State.normal)
        }
        else{
            largeButton.setImage(UIImage(systemName: "circle",withConfiguration: UIImage.SymbolConfiguration(scale: .large))?.withTintColor(UIColor.black), for: UIControl.State.normal)
        }
        pickedSize = "custom"
        customDesignView.isUserInteractionEnabled = true
    }


    @IBAction func applyCustomSizes(_ sender: Any) {
//      12 needs to be changed to default values of storyly
        if(pickedSize == "custom"){
            bringBackOldProperties()
            print("applied")
        }
    }
    func bringBackOldProperties()
    {
        customizedView.removeFromSuperview()
        customizedView = StorylyView()
        customizedView.storylyInit = StorylyInit(storylyId: STORYLY_INSTANCE_TOKEN)
        customizedView.storyGroupSize = pickedSize
        if(pickedSize == "custom"){
            let h = Int(heightTextF.text ?? "12")
            let w = Int(widthTextF.text  ?? "12")
            let c = Int(cornerRadiusTextF.text  ?? "12")
            height = h ?? 10
            width = w ?? 10
            cRadius = c ?? 10
            customizedView.storyGroupIconStyling = StoryGroupIconStyling(height: CGFloat(h ?? 40), width: CGFloat(w ?? 40), cornerRadius: CGFloat(c ?? 30))
        }
        let currentValues = properties["Text Color"]
        customizedView.storyGroupTextStyling =  StoryGroupTextStyling(isVisible: self.storyGroupTextIsVisible, color:UIColor(hexString: currentValues ?? "#000000"), font: self.font, lines: self.lineNumber)
        
        let currentValues2 = properties["Ivod Icon"]
        customizedView.storyGroupIVodIconColor = UIColor(hexString: currentValues2 ?? "#000000")
        
        let currentValues3 = properties["Pin Icon"]
        customizedView.storyGroupPinIconColor = UIColor(hexString: currentValues3 ?? "#000000")
        
        let currentValues4 = properties["Background"]
        customizedView.storyGroupIconBackgroundColor = UIColor(hexString: currentValues4 ?? "#000000")
        let valuesSeen = Array(colorsOfSeenState.values)
        let valuesNotSeen = Array(colorsOfNotSeenSate.values)
        customizedView.storyGroupListStyling = StoryGroupListStyling(edgePadding: CGFloat(edgePadValue), paddingBetweenItems: CGFloat(padBetweenItemsValue))
       
        customizedView.storyGroupIconBorderColorSeen = valuesSeen
        customizedView.storyGroupIconBorderColorNotSeen = valuesNotSeen
        customizedView.rootViewController = self
        customizedView.delegate = self
        containerToCustom.addSubview(customizedView)
        customizedView.translatesAutoresizingMaskIntoConstraints = false
        customizedView.heightAnchor.constraint(equalTo: containerToCustom.heightAnchor).isActive = true
        customizedView.widthAnchor.constraint(equalTo: containerToCustom.widthAnchor).isActive = true
        customizedView.centerXAnchor.constraint(equalTo: containerToCustom.centerXAnchor).isActive = true
        customizedView.centerYAnchor.constraint(equalTo: containerToCustom.centerYAnchor).isActive = true
    }
    
    @IBAction func applyListStyling(_ sender: Any) {
        edgePadValue = Int(edgePadding.text ?? "12") ?? 10
        padBetweenItemsValue = Int(paddingBetweenItems.text ?? "12") ?? 10
        bringBackOldProperties()
    }
    
}
//-
extension ViewController: StorylyDelegate{
    
}
extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if(pickerView == fontPicker){
            return 2
        }
        else if (pickerView == stylesAndColors){
            return 1
        }
    
        else if(pickerView == lineNumberPicker){
            return 1
        }
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(component == 0){
            switch pickerView{
            case fontPicker:
                return self.groupTextFontDict.count
            case lineNumberPicker:
                return 5
            case stylesAndColors:
                return properties.count
            default:
                return 1
            }
        }
        else if(component == 1 && pickerView == fontPicker) {
            return 50
        }
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if(component == 0) {
            switch pickerView{
                case fontPicker:
                    let key = Array(groupTextFontDict.keys)
                    return key[row]
                case lineNumberPicker:
                    return  (row+1).description
                case stylesAndColors:
                    return propertiesNames[row]
    
                default:
                    return "x"
            }
        }
        else if(pickerView == fontPicker && component == 1){
            return (row+1).description
        }
        return "x"
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let currentColor = properties["Text Color"]
        if(component == 0){
            switch pickerView{
                case fontPicker:
                    let values = Array(groupTextFontDict.values)
                    font = values[row]
                    self.customizedView.storyGroupTextStyling =  StoryGroupTextStyling(isVisible:  self.storyGroupTextIsVisible, color: UIColor(hexString: currentColor ?? "#000000"), font: self.font, lines: self.lineNumber)
                    break
                    
            case lineNumberPicker:
                lineNumber = row + 1
                self.customizedView.storyGroupTextStyling =  StoryGroupTextStyling(isVisible: self.storyGroupTextIsVisible, color:UIColor(hexString: currentColor ?? "#000000"), font: self.font, lines: self.lineNumber)
                break
            case stylesAndColors:
                currentPropertyIndex = propertiesNames[row]
                print(currentPropertyIndex)
                let currentValue = properties[currentPropertyIndex]
                colorShowcase.backgroundColor = UIColor(hexString: currentValue ?? "#000000")
                colorField.text = currentValue
                break
            default:
                break
            }
        }
        else if(pickerView == fontPicker && component == 1){
            var refreshBar = false
            if((row + 1) > fontSize){
                refreshBar = true
            }
            fontSize = row + 1
            font = font.withSize(CGFloat(fontSize))
            self.customizedView.storyGroupTextStyling =  StoryGroupTextStyling(isVisible: self.storyGroupTextIsVisible, color:UIColor(hexString: currentColor ?? "#000000"), font: self.font, lines: self.lineNumber)
            if(refreshBar){
                bringBackOldProperties()
                
            }
        }
    }

    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        let w = pickerView.frame.size.width
        
        switch pickerView{
            case stylesAndColors:
                return w
            
            case fontPicker:
                return w/2
            case lineNumberPicker:
                return w
        default:
            return w
        }
    }
}

// Extension for UIImage for hex values
extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

extension ViewController: UITextFieldDelegate{
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
            if let toCheck = textField.text{
                if(toCheck.count == 7 && textField.tag == 0){
                    return true
                }
                else if(toCheck.count == 7 && textField.tag == 1){
                    return true
                }
            }
        return false
    }
    public func textFieldDidEndEditing(_ textField: UITextField) {
        if(textField == colorField){
            colorShowcase.backgroundColor = UIColor(hexString: textField.text ?? "#000000")
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}

