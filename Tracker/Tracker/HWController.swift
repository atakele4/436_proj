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
        
        let addAction = UIAlertAction(title: "Add", style: .default){
            
            _ in
            
            guard let name = alertController.textFields?.first?.text else {return }
            
            let newTask = HWTask(name: name)
            self.taskData.add(newTask, at: 0)
            let indexPath = IndexPath(row: 0, section: 0)
            self.tableView.insertRows(at: [indexPath], with: .automatic)
            
        }
        addAction.isEnabled = false;
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addTextField { textfield in
            textfield.placeholder = "Enter Task Name"
            textfield.addTarget(self, action: #selector(self.handleTextChange), for: .editingChanged)
        
        }
    
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    var taskData = HWData()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let todo = [HWTask(name: "Run")]
        let complete = [HWTask(name: "Eat")]
        self.taskData.tasks = [todo,complete]
        
    }
    
    @objc private func handleTextChange(_ sender: UITextField){
        guard let alertController = presentedViewController as? UIAlertController,
        let addAction = alertController.actions.first,
        let text = sender.text
            else {
                return
        }
        addAction.isEnabled = !text.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
}
// MARK: - DataSource

extension HWController {
    
    
    
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
    
    // MARK: - DataSource

}

extension HWController {
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
}
    
//    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        <#code#>
//    }
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive , title: nil) { (action, sourceView, completionHandler) in
            
            let isDone = self.taskData.tasks[indexPath.section][indexPath.row].isDone
            
            self.taskData.remove(at: indexPath.row,isDone: isDone)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            completionHandler(true)
        }
//        deleteAction.image = delete
//        deleteAction.image = delete
        
        let deleteImage = #imageLiteral(resourceName: "delete")
        deleteAction.image = deleteImage
        deleteAction.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

