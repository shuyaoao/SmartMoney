//
//  GroupDetailsViewController.swift
//  SmartMoney
//
//  Created by Shuyao Li on 19/5/23.
//

import UIKit
import MonthYearPicker

class GroupDetailsViewController: UIViewController {

    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var navigationBar: UINavigationItem!
    var picker : MonthYearPickerView?
    
    override func viewDidLoad() {
        //adds a scroll selector to allow users to select a specific month and year to display expenses in that selected timeframe
        super.viewDidLoad()
        dateTextField.delegate = self
        picker = MonthYearPickerView(frame: CGRect(origin: CGPoint(x: 0, y: (view.bounds.height - 216) / 2), size: CGSize(width: view.bounds.width, height: 216)))
        picker!.minimumDate = Date.distantPast
        picker!.maximumDate = Calendar.current.date(byAdding: .year, value: 10, to: Date())
        picker!.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        //view.addSubview(picker)
        dateTextField.inputView = picker!
        dateTextField.text = formatDate(date: Date())
    }
    
    @objc func dateChanged(_ datePicker: MonthYearPickerView) {
        dateTextField.text = formatDate(date: datePicker.date)
        datePicker.resignFirstResponder()
    }

    func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"
        return formatter.string(from: date)
    }

}

extension GroupDetailsViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.view.endEditing(true)
        }
}
