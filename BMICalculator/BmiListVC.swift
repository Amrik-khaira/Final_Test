//
//  BmiListVC.swift
//  BMICalculator
//  Author's name : Amrik Singh
//  Created by Amrik on 16/12/22.
//  StudentID : 301296257
//  BMI Calculator App
//  Version: 1.3
//

import UIKit

class BmiListVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    //MARK: IBOutlet Connections
    @IBOutlet weak var bmiTblViw: UITableView!
    //MARK: Variables
    var callbackforUpdateRecord:(([BMIRecords],BMIRecords?,IndexPath,Bool) -> Void)?
    //MARK: - Array to get stored data
    var BMIRecordsArr = [BMIRecords]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //MARK: Get old saved data
        BMIRecordsArr = LocalStorage.shared.GetSavedItems()
    }
    
    //MARK: - tableView datasource and delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BMIRecordsArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BmiCell", for: indexPath) as? BmiCell else {return UITableViewCell()}
        cell.selectionStyle = .none
        let objBmi = BMIRecordsArr[indexPath.row]
        cell.lblBMI.text = "BMI Score: \(objBmi.bmiScore ?? "")"
        cell.lblDate.text = objBmi.strDate  ?? ""
        cell.lblWeight.text = "\(objBmi.weight  ?? "") \(objBmi.isMatric == true ? "Kg" : "Lbs"), \(objBmi.descriptor ?? "")"
        cell.callbackforEditTask = { cell in
            self.displayAlertWithCompletion(title: "BMICalculator!", message: "Are you sure want to edit BMI ?", control: ["Cancel","Okay"]) { str in
                if str == "Okay" {
                    self.openEditTodoList(index: indexPath)
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            //MARK: handle delete (by removing the data from your array and updating the tableview)
            displayAlertWithCompletion(title: "BMICalculator!", message: "Are you sure want to delete BMI result?", control: ["Cancel","Okay"]) { str in
                if str == "Okay"
                {
                    self.BMIRecordsArr.remove(at: indexPath.row)
                    LocalStorage.shared.saveDataInPersistent(BMIArr: self.BMIRecordsArr)
                    self.bmiTblViw.reloadData()
                }
            }
            
        }
    }
    
    //MARK: Action for Back button
    @IBAction func btnBackAct(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Open Edit Todo List
    func openEditTodoList(index:IndexPath)  {
        self.navigationController?.popViewController(animated: true)
        callbackforUpdateRecord?(BMIRecordsArr,BMIRecordsArr[index.row],index,true)
    }
}

//MARK: - TableView Cell class
class BmiCell: UITableViewCell {
    //MARK: - connections
    var callbackforEditTask: ((BmiCell) -> Void)?
    @IBOutlet weak var lblBMI: UILabel!
    @IBOutlet weak var lblWeight: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    //MARK: - Add more item action
    @IBAction func BtnEditTaskAct(_ sender: UIButton) {
        callbackforEditTask?(self)
    }
}
