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

