

import UIKit
import SnapKit


class AddContactViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "연락처 추가"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "적용", style: .plain, target: nil, action: nil)
        
    }
    
}
