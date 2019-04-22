//
//  HWController.swift
//  Tracker
//
//  Created by Harshil Patel on 4/20/19.
//  Copyright © 2019 Harshil Patel. All rights reserved.
//

import UIKit

class HWController : UITableViewController {
    
    
    @IBAction func addAction(_ sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: "Add Task", message: nil, preferredStyle: .alert)
        
        let addAction = UIAlertAction(title: "Add", style: .default, handler: nil)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addTextField { textfield in
            textfield.placeholder = "Enter Task Name"
        }
    
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    @IBOutlet weak var addButton: UIBarButtonItem!
    
   var taskData = HWData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
}

extension HWController {
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return section == 0 ? "TO - DO" : "Completed"
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return taskData.tasks.count
    }
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return taskData.tasks[section].count;
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = taskData.tasks[indexPath.section][indexPath.row].taskName
        
        return cell
        
    }
}
