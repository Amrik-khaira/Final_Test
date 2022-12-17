//
//  Extension.swift
//  BMICalculator
//  Author's name : Amrik Singh
//  Created by Amrik on 14/12/22.
//  StudentID : 301296257
//  BMI Calculator App
//  Version: 1.2
//

import UIKit

//MARK: - Display alert with completion
extension UIViewController
{
    func displayAlertWithCompletion(title:String,message:String,control:[String],completion:@escaping (String)->()){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for str in control{
            let alertAction = UIAlertAction(title: str, style: .default, handler: { (action) in
                completion(str)
            })
            alertController.addAction(alertAction)
        }
        self.present(alertController, animated: true, completion: nil)
    }
}
