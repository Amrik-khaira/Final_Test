//
//  ViewController.swift
//  BMICalculator
//  Author's name : Amrik Singh
//  Created by Amrik on 13/12/22.
//  StudentID : 301296257
//  BMI Calculator App
//  Version: 1.1
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource {
    //MARK: IBOutlet Connections
    @IBOutlet weak var btnCalculate: UIButton!
    @IBOutlet weak var isMetricSwitch: UISwitch!
    @IBOutlet weak var txtHeight: UITextField!
    @IBOutlet weak var txtWeight: UITextField!
    @IBOutlet weak var txtGender: UITextField!
    @IBOutlet weak var txtAge: UITextField!
    @IBOutlet weak var txtName: UITextField!
    //MARK: Variables
    var pickerView = UIPickerView()
    let gender = ["Male", "Female"]
    var updateBmiArr = [BMIRecords]()
    var isUpdate = Bool()
    var indexval = IndexPath()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtHeight.delegate = self
        txtWeight.delegate = self
        self.pickUp(txtGender)
    }
    
    //MARK: UIPickerView for gender
    func pickUp(_ textField : UITextField) {
        self.pickerView = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.pickerView.backgroundColor = UIColor.white
        textField.inputView = self.pickerView
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        // Adding Button ToolBar
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(ViewController.cancelClick))
        toolBar.setItems([spaceButton,spaceButton,cancelButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
        // ToolBar for text fields
        let toolBarText = UIToolbar()
        toolBarText.barStyle = .default
        toolBarText.isTranslucent = true
        toolBarText.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBarText.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(ViewController.doneClick))
        toolBarText.setItems([spaceButton,spaceButton,doneButton], animated: false)
        toolBarText.isUserInteractionEnabled = true
        txtHeight.inputAccessoryView = toolBarText
        txtWeight.inputAccessoryView = toolBarText
        txtAge.inputAccessoryView = toolBarText
        txtName.inputAccessoryView = toolBarText
    }
    
    //MARK: ToolBar actions
    @objc func doneClick() {
        self.view.endEditing(true)
    }
    
    @objc func cancelClick() {
        txtGender.resignFirstResponder()
    }
    
    //MARK: UIPickerView Delegate & DataSource
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return gender[row]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return gender.count
    }
    
    func pickerView(_ pickerView:UIPickerView,didSelectRow row: Int,inComponent component: Int){
        txtGender.text = gender[row]
        txtGender.resignFirstResponder()
    }
    
    //MARK: Action for tracking screen (to see previous records)
    @IBAction func btnBmiTrackingACt(_ sender: Any) {
        openBMITrackingScreen()
    }
    
    //MARK: Action for clear old data and calculate new one
    @IBAction func resetNewBMIAct(_ sender: Any) {
        self.isUpdate = false
        isMetricSwitch.setOn(false, animated: false)
        txtHeight.text = ""
        txtWeight.text = ""
        txtGender.text = ""
        txtAge.text = ""
        txtName.text =  ""
        btnCalculate.setTitle("Calculate BMI", for: .normal)
    }
    
    //MARK: UISwitch Action for convert metric to imperial OR imperial to metric
    @IBAction func metricConverterSwitch(_ sender: UISwitch) {
        if sender.isOn {
            //If text is already there, convert it to metric
            if txtHeight.text != nil && !((txtHeight.text!).isEmpty) {
                if let heightVal = Double(txtHeight.text!) {
                    txtHeight.text = String(format: "%.2f", heightVal * 0.0254)
                }
            }
            if txtWeight.text != nil && !((txtWeight.text!).isEmpty) {
                if let weightVal = Double(txtWeight.text!) {
                    txtWeight.text = String(format: "%.2f", weightVal * 0.453592)
                }
            }
            if txtHeight.text != nil && !((txtHeight.text!).isEmpty) && txtWeight.text != nil && !((txtWeight.text!).isEmpty) {
                btnCalculateBMIAct(UIButton())
            }
            txtHeight.placeholder = "Height(m)"
            txtWeight.placeholder = "Weight(kg)"
        } else {
            //If text is already there, convert it to imperial
            if txtHeight.text != nil && !((txtHeight.text!).isEmpty) {
                if let heightVal = Double(txtHeight.text!) {
                    txtHeight.text = String(format: "%.2f", heightVal / 0.0254)
                }
            }
            if txtWeight.text != nil && !((txtWeight.text!).isEmpty) {
                if let weightVal = Double(txtWeight.text!) {
                    txtWeight.text = String(format: "%.2f", weightVal / 0.453592)
                }
            }
            if txtHeight.text != nil && !((txtHeight.text!).isEmpty) && txtWeight.text != nil && !((txtWeight.text!).isEmpty) {
                btnCalculateBMIAct(UIButton())
            }
            txtHeight.placeholder = "Height(in)"
            txtWeight.placeholder = "Weight(lbs)"
        }
    }
    
    //MARK: Action for Calculate BMI
    @IBAction func btnCalculateBMIAct(_ sender: UIButton) {
        if txtName.text == "" {
            displayAlertWithCompletion(title: "BMICalculator!", message: "Please enter your name.", control: ["Okay"]) { _ in }
        } else if txtAge.text == "" {
            displayAlertWithCompletion(title: "BMICalculator!", message: "Please enter your age.", control: ["Okay"]) { _ in }
        } else if txtGender.text == "" {
            displayAlertWithCompletion(title: "BMICalculator!", message: "Please choose your gender.", control: ["Okay"]) { _ in }
        } else if txtWeight.text != nil && txtHeight.text != nil, var weight = Double(txtWeight.text!), var height = Double(txtHeight.text!) {
            self.view.endEditing(true)
            // MARK: Calculating BMI using metric, so convert to metric first
            if !isMetricSwitch.isOn {
                (weight) *= 0.453592;
                (height) *= 0.0254;
            }
            let BMI: Double = weight / (height * height)
            let shortBMI = String(format: "%.2f", BMI)
            var resultText = "Your BMI is \(shortBMI): "
            var descriptor = ""
            if(BMI < 16.0) { descriptor = "Severe Thinness" }
            else if(BMI < 16.99) { descriptor = "Moderate Thinness" }
            else if(BMI < 18.49) { descriptor = "Mild Thinness" }
            else if(BMI < 24.99) { descriptor = "Normal" }
            else if(BMI < 29.99) { descriptor = "Overweight" }
            else if(BMI < 34.99) { descriptor = "Obese Class I" }
            else if(BMI < 39.99) { descriptor = "Obese Class II" }
            else { descriptor = "Obese Class III" }
            resultText += descriptor
            print(resultText)
            displayAlertWithCompletion(title: "BMICalculator!", message: resultText, control: ["Okay"]) { str in
                self.saveData(shortBMI: shortBMI,descriptor: descriptor)
                self.openBMITrackingScreen()
            }
        } else {
            displayAlertWithCompletion(title: "BMICalculator!", message: "Please fill out your height and weight.", control: ["Okay"]) { _ in }
        }
    }
    
    //MARK: Function for Save Calculated BMI values in Persistence storage
    func saveData(shortBMI:String,descriptor:String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let currentDate =  dateFormatter.string(from: Date())
        if self.isUpdate {
            self.updateBmiArr[indexval.row] = BMIRecords.init(name: txtName.text ?? "", bmiScore: shortBMI, age: txtAge.text ?? "", height: txtHeight.text ?? "", gender: txtGender.text ?? "", isMatric: isMetricSwitch.isOn, strDate: currentDate, weight: txtWeight.text ?? "", descriptor: descriptor)
            LocalStorage.shared.saveDataInPersistent(BMIArr: self.updateBmiArr)
        } else {
            var tempBmiArr = LocalStorage.shared.GetSavedItems()
            tempBmiArr.append(BMIRecords.init(name: txtName.text ?? "", bmiScore: shortBMI, age: txtAge.text ?? "", height: txtHeight.text ?? "", gender: txtGender.text ?? "", isMatric: isMetricSwitch.isOn, strDate: currentDate, weight: txtWeight.text ?? "", descriptor: descriptor))
            LocalStorage.shared.saveDataInPersistent(BMIArr: tempBmiArr)
        }
    }
    
    
    //MARK: Open Edit Todo List
    func openBMITrackingScreen()  {
        if let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "BmiListVC") as? BmiListVC
        {
            vc.callbackforUpdateRecord = {
                (tempArr,bmiDict,indexval,isUpdate) in
                guard let tempDict = bmiDict else { return  }
                self.updateBmiArr = tempArr
                self.isUpdate = isUpdate
                self.indexval = indexval
                self.setUpUI(updateBmiDict:tempDict)
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK: SetUp UI to update old values
    func setUpUI(updateBmiDict:BMIRecords) {
        isMetricSwitch.setOn(updateBmiDict.isMatric ?? false, animated: false)
        txtHeight.text = updateBmiDict.height ?? ""
        txtWeight.text = updateBmiDict.weight ?? ""
        txtGender.text = updateBmiDict.gender ?? ""
        txtAge.text = updateBmiDict.age ?? ""
        txtName.text = updateBmiDict.name ?? ""
        btnCalculate.setTitle("Re-Calculate BMI", for: .normal)
    }
}

