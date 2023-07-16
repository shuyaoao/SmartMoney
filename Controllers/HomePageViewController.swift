
//  SmartMoney
//
//  Created by Shuyao Li on 19/5/23.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import SwiftUI

class HomePageViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBSegueAction func MonthlyChart(_ coder: NSCoder) -> UIViewController? {
        return UIHostingController(coder: coder, rootView: MainChartView())
    }
}





