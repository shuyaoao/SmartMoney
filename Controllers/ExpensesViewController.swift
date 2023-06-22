import UIKit
import SwiftUI
import MonthYearPicker

class ExpensesViewController: UIViewController {
    // PickerView
    var picker : MonthYearPickerView?
    
    // Buttons
    @IBOutlet var confirmButton: UIButton!
    @IBOutlet weak var yearMonthButton2: UIButton!
    @IBOutlet weak var totalSpentLabel: UILabel!
    @IBOutlet weak var totalIncomeLabel: UILabel!
    @IBOutlet weak var monthlySpendingLimitLeftLabel: UILabel!
    
    @IBOutlet weak var balanceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Updating all of TransactionDataSource components.
        transactionDataModel.updateFilteredList()
        transactionDataModel.updateTotalIncome()
        transactionDataModel.updateTotalExpenses()
        
        // Setting Labels
        totalSpentLabel.text = "$\(transactionDataModel.totalExpenses)"
        totalIncomeLabel.text = "$\(transactionDataModel.totalIncome)"
        
        let (color, balanceString) = getBalance()
        balanceLabel.text = balanceString
        balanceLabel.textColor = color
        
        monthlySpendingLimitLeftLabel.text = "$\(transactionDataModel.totalExpenses)"

        self.yearMonthButton2.setTitle(formatDate(date: Date()), for: .normal)
        
        
        // Initialise of Datepicker (remained hidden)
        confirmButton = initConfirmButton()
        picker = initYearMonthPicker()
    }
    
    // When YearMonth Button is pressed
    @IBAction func yearMonthButton2Pressed(_ sender: UIButton) {
        // Unhide picker and confirmation button
        picker?.isHidden = false
        confirmButton.isHidden = false
        
    }
    
    // Functionality when Date is Changed
    @objc func dateChanged(_ picker: MonthYearPickerView) {
        let calendarDate = formatDate(date: picker.date)
        yearMonthButton2.setTitle("\(calendarDate)", for: .normal)
        let (pickedYear, pickedMonth) = extractYearAndMonth(from: picker.date)
        
        // Update dateModel
        dateModel.changeYearandMonth(year: pickedYear, month: pickedMonth)
        
        transactionDataModel.updateFilteredList()
        transactionDataModel.updateTotalIncome()
        transactionDataModel.updateTotalExpenses()

    }
    
    // Date Formatter to Display Month and Year
    func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"
        return formatter.string(from: date)
    }
    
    // Initialising YearMonthPicker View
    func initYearMonthPicker() -> MonthYearPickerView {
        picker = MonthYearPickerView(frame: CGRect(origin: CGPoint(x: 0, y: 500), size: CGSize(width: view.bounds.width, height: 216)))
        picker!.backgroundColor = .white
        picker!.minimumDate = Calendar.current.date(byAdding: .year, value: -10, to: Date())
        picker!.maximumDate = Calendar.current.date(byAdding: .year, value: 10, to: Date())
        picker!.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        
        // Add Year Month Picker to the main View
        view.addSubview(picker!)
        
        // Hide Picker Button
        picker!.isHidden = true
        return picker!
    }
    
    // Confirm Button Functionality
    func initConfirmButton() -> UIButton {
        let confirmButton = UIButton(type: .system)
        
        confirmButton.setTitle("Confirm", for: .normal)
        confirmButton.addTarget(self, action: #selector(confirmButtonTapped(_:)), for: .touchUpInside)
        
        // Customize the button's appearance
        confirmButton.backgroundColor = .white
        confirmButton.setTitleColor(.black, for: .normal)
        confirmButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        // Set the frame for the button
        confirmButton.frame = CGRect(x: 155, y: 470, width: 100, height: 40)
        
        view.addSubview(confirmButton)
        confirmButton.isHidden = true
        
        return confirmButton
    }
    
    // Confirm Button Pressed
    @IBAction func confirmButtonTapped(_ sender: UIButton) {
        // Close all subviews
        picker?.isHidden = true
        confirmButton.isHidden = true
    }
    
    
    @IBSegueAction func TransactionsScrollView(_ coder: NSCoder) -> UIViewController? {
        return UIHostingController(coder: coder, rootView: TransactionScrollView(transactionDataModel: transactionDataModel, pickedYear: dateModel.pickedYear, pickedMonth: dateModel.pickedMonth))
    }
    
    // Circular Budget Progress View
    @IBSegueAction func embedBudgetProgressBarView(_ coder: NSCoder) -> UIViewController? {
        return UIHostingController(coder: coder, rootView: CircularProgressView(progress: 0.7).frame(width: 45, height: 45))
    }
    
    func refresh() {
        // Perform the refresh logic here...
        totalSpentLabel.text = "$\(transactionDataModel.totalExpenses)"
        totalIncomeLabel.text = "$\(transactionDataModel.totalIncome)"
        monthlySpendingLimitLeftLabel.text = "$\(transactionDataModel.totalExpenses)"
        let (color, balanceString) = getBalance()
        balanceLabel.text = balanceString
        balanceLabel.textColor = color
    }
}


class CustomSegue: UIStoryboardSegue {
    override func perform() {
        // Get the source and destination view controllers
        guard let sourceViewController = source as? ExpensesViewController,
              let destinationViewController = destination as? CreateNewExpenseViewController else {
            return
        }
        
        // Set the reference to the main view controller in the destination view controller
        destinationViewController.mainViewController = sourceViewController
        
        // Perform the segue
        sourceViewController.present(destinationViewController, animated: true, completion: nil)
    }
}


func extractYearAndMonth(from date: Date) -> (year: Int, month: Int) {
    let calendar = Calendar.current
    let year = calendar.component(.year, from: date)
    let month = calendar.component(.month, from: date)
    
    return (year, month)
}



func getBalance() -> (UIColor, String) {
    var balance = Int(transactionDataModel.totalIncome - transactionDataModel.totalExpenses)
    let color : UIColor
    
    if balance >= 0 {
        color = UIColor(.black)
    } else {
        color = UIColor(.red)
    }
    
    balance = abs(balance)
    return (color, "$\(balance)")
}
