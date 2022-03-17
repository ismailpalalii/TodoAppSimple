//
//  ViewController.swift
//  TodoAppSimple
//
//  Created by ismail palali on 17.03.2022.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var taskStore = [[TaskEntity](),[TaskEntity]()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
    }
    
    func getData() {
        let tasks = DatabaseHelper.shareInstance.fetch()
        
        taskStore = [tasks.filter{$0.isdone == false},tasks.filter{$0.isdone == true}]
        
        tableView.reloadData()
    }
    @IBAction func btnAdd(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add Task", message: nil, preferredStyle: .alert)
        
        let add = UIAlertAction(title: "Add", style: .default) { _ in
            
            // save
            guard let name = alert.textFields?.first?.text else  {return}
            print(name)
            DatabaseHelper.shareInstance.save(name: name, isDone: false)
            self.getData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addTextField { textField in
            textField.placeholder = "Enter task name..."
        }
        
        alert.addAction(add)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskStore[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = taskStore[indexPath.section] [indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "To-do" : "Done"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return taskStore.count
    }
}

extension ViewController {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = UIContextualAction(style: .normal, title: nil) {(action,sourceView,completionHander)in
        
            let row = self.taskStore[indexPath.section][indexPath.row]
            DatabaseHelper.shareInstance.delete(name: row.name!)
            self.getData()
        }
        
        delete.image = UIImage(named: "trash-24.png")
        delete.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let done = UIContextualAction(style: .normal, title: nil) {(action,sourceView,completionHander)in
        
            let row = self.taskStore[0][indexPath.row]
            DatabaseHelper.shareInstance.update(name: row.name!, isDone: true)
            self.getData()
        }
        
        done.image = UIImage(named: "checkmark-24.png")
        done.backgroundColor = #colorLiteral(red: 0.1843137255, green: 0.7529411765, blue: 0.6588235294, alpha: 1)
        
        return indexPath.section == 0 ? UISwipeActionsConfiguration(actions: [done]) : nil
    }
}

