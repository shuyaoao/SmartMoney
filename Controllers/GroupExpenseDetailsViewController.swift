//
//  GroupExpenseDetailsViewController.swift
//  SmartMoney
//
//  Created by Shuyao Li on 22/6/23.
//

import UIKit

class GroupExpenseDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var expense: GroupExpense?
    var prevVC: GroupDetailsViewController?

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryImage.image = UIImage(systemName: "fork.knife.circle.fill")
        //to update when category selector is fixed
        descriptionLabel.text = expense?.description
        descriptionLabel.textColor = UIColor(named: "Dark Blue")
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        self.dateLabel.text = formatter.string(from: expense!.date)
        table.delegate = self
        table.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    @IBAction func dismissButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //update with the number of debts owed/being owed
        return expense?.splits.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExpenseDetailsCell", for: indexPath) as! ExpenseDetailsTableViewCell
        cell.label.text = String(format: "%@ owes $%.2f", (expense?.splits[indexPath.row].user.name)!, (expense?.splits[indexPath.row].amount)!)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //sets the headers of each section to group members' names
        let label = UILabel()
        label.text = String(format: "%@ paid $%.2f", (expense?.payer.name)!, (expense?.amount)!)
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        return label
    }
    
    

}
