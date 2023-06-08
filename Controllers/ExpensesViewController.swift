//import UIKit
//import SwiftUI
//import MonthYearPicker
//
//class ExpensesViewController: UIViewController {
//
//    @IBOutlet weak var yearMonthButton: UIButton!
//    @IBOutlet var confirmButton: UIButton!
//    var picker : MonthYearPickerView?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Initialise Confirm button (Hidden from Main View)
//        yearMonthButton.setTitle(formatDate(date: Date()), for: .normal)
//        confirmButton = initConfirmButton()
//    }
//
//
//    // PickDateButton
//    @IBAction func yearMonthButtonPressed(_ sender: UIButton) {
//        picker = MonthYearPickerView(frame: CGRect(origin: CGPoint(x: 0, y: 500), size: CGSize(width: view.bounds.width, height: 216)))
//        picker!.minimumDate = Date()
//        picker!.maximumDate = Calendar.current.date(byAdding: .year, value: 10, to: Date())
//        picker!.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
//
//        // Add Year Month Picker to the main View
//        view.addSubview(picker!)
//
//        // Add the button to the view
//        view.addSubview(confirmButton)
//
//    }
//
//    // Functionality when Date is Changed
//    @objc func dateChanged(_ picker: MonthYearPickerView) {
//        print("date changed: \(picker.date)")
//
//        // Implement Functionality to Store Year and Month
//    }
//
//    // Date Formatter to Display Month and Year
//    func formatDate(date: Date) -> String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "MMM yyyy"
//        return formatter.string(from: date)
//    }
//
//    // Confirm Button Functionality
//    func initConfirmButton() -> UIButton {
//        let confirmButton = UIButton(type: .system)
//
//        confirmButton.setTitle("Confirm", for: .normal)
//        confirmButton.addTarget(self, action: #selector(confirmButtonTapped(_:)), for: .touchUpInside)
//
//        // Customize the button's appearance
//        confirmButton.backgroundColor = .white
//        confirmButton.setTitleColor(.black, for: .normal)
//        confirmButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
//
//        // Set the frame for the button
//        confirmButton.frame = CGRect(x: 155, y: 470, width: 100, height: 40)
//
//        return confirmButton
//    }
//
//    // Confirm Button Pressed
//    @IBAction func confirmButtonTapped(_ sender: UIButton) {
//        // Close all subviews
//        picker?.isHidden = true
//        confirmButton.isHidden = true
//    }
//
//    // Circular Budget Progress View
//    @IBSegueAction func embedCircularProgressBarView(_ coder: NSCoder) -> UIViewController? {
//        return UIHostingController(coder: coder, rootView: CircularProgressView(progress: 0.7).frame(width: 120, height: 120))
//    }
//}
//
