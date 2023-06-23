import UIKit
import SwiftUI
import MonthYearPicker

class ExpensesViewController: UIViewController {
    // PickerView
    var picker : MonthYearPickerView?
    var numberTextField = UITextField()
    
    // Buttons
    @IBOutlet var confirmButton: UIButton!
    @IBOutlet weak var yearMonthButton2: UIButton!
    @IBOutlet weak var totalSpentLabel: UILabel!
    @IBOutlet weak var totalIncomeLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    
    var alertController: UIAlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker = initYearMonthPicker()
        initNumberTextField()
        
        // Updating all of TransactionDataSource components.
        transactionDataModel.updateFilteredList()
        transactionDataModel.updateTotalIncome()
        transactionDataModel.updateTotalExpenses()
        
        budgetProgressModel.budgetProgressRefresh()
        // Setting Labels
        totalSpentLabel.text = "$\(transactionDataModel.totalExpenses)"
        totalIncomeLabel.text = "$\(transactionDataModel.totalIncome)"
        
        let (color, balanceString) = getBalance()
        balanceLabel.text = balanceString
        balanceLabel.textColor = color
        
        // Set Date of YearMonthPicker
        self.yearMonthButton2.setTitle(formatDate(date: Date()), for: .normal)
        
        // Initialise of Datepicker (remained hidden)
        confirmButton = initConfirmButton()
        
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
        
        refresh()
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
        refresh()
        return UIHostingController(coder: coder, rootView: TransactionScrollView(transactionDataModel: transactionDataModel, pickedYear: dateModel.pickedYear, pickedMonth: dateModel.pickedMonth))
    }
    
    // Circular Budget Progress View
    @IBSegueAction func embedBudgetProgressBarView(_ coder: NSCoder) -> UIViewController? {
        return UIHostingController(coder: coder, rootView: CircularProgressView(budgetProgress : budgetProgressModel).frame(width: 45, height: 45))
    }
    
    func refresh() {
        budgetProgressModel.budgetProgressRefresh()
        transactionDataModel.updateFilteredList()
        transactionDataModel.updateTotalIncome()
        transactionDataModel.updateTotalExpenses()
        
        // Refresh totalExpenses and totalIncome
        totalSpentLabel.text = "$\(transactionDataModel.totalExpenses)"
        totalIncomeLabel.text = "$\(transactionDataModel.totalIncome)"
        
        // Refresh Balance
        let (color, balanceString) = getBalance()
        balanceLabel.text = balanceString
        balanceLabel.textColor = color
        
        // Re-initialise Budget Text field
        initNumberTextField()
    }
    
    // Initialising the BudgetCustomizable Text Field (Found below Budget Button)
    func initNumberTextField() {
        // Extract Year and Month from Picker
        let pickedYear = dateModel.pickedYear
        let pickedMonth = dateModel.pickedMonth
        
        // Set up Number Text Field
        numberTextField.frame = CGRect(x: 187, y: 204, width: 100, height: 35)
        numberTextField.borderStyle = .roundedRect
        numberTextField.textAlignment = .center
        numberTextField.placeholder = "Enter number"
        numberTextField.keyboardType = .numberPad
        numberTextField.addTarget(self, action: #selector(numberDidChange(_:)), for: .editingChanged)
        
        // Obtain Budget Numbers from budgetModel
        let searchedBudget = budgetModel.searchBudget(year: pickedYear, month: pickedMonth)
        
        // Set a default value
        numberTextField.text = String(searchedBudget.budgetAmount)
        
        view.addSubview(numberTextField)
    }
    
    // Tracks the Budget Text Field when it is editted by the user
    @objc func numberDidChange(_ textField: UITextField) {
        let (pickedYear, pickedMonth) = extractYearAndMonth(from: picker!.date)
        // Handle number value changes
        if let text = textField.text, let number = Int(text) {
            // Modify budget with new amount
            let newBudget = Budget(budgetAmount: number, year: pickedYear, month: pickedMonth)
            budgetModel.addBudget(budget: newBudget)
            budgetModel.editBudget(budget: newBudget)
            // Refresh the BudgetProgress for UI Update
            budgetProgressModel.budgetProgressRefresh()
        } else {
            showAlert()
        }
    }
    
    // Budget Numbers Only Alert Warning Popup
    func showAlert() {
        alertController = UIAlertController(title: "Invalid Inputs", message: "Please check that you have filled in a Number", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            // Handle OK button action (if needed)
            self?.dismissAlert()
        }
        
        alertController?.addAction(okAction)
        
        // Present the alert controller
        present(alertController!, animated: true, completion: nil)
    }

    func dismissAlert() {
        alertController?.dismiss(animated: true, completion: nil)
        alertController = nil
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





