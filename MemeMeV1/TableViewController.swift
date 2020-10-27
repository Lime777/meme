//
//  TableViewController.swift
//  MemeMeV1
//
//  Created by Emil Haroutunian on 10/12/20.
//  Copyright © 2020 Emil Haroutunian. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    
    private var tableViewCell = "tableViewCell"
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        navigationItem.leftBarButtonItem = editButtonItem
    }
    // MARK: - Table view data source
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return appDelegate.memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCell, for: indexPath) as! TableViewCell
        
        let meme = appDelegate.memes[indexPath.row]
        
        cell.tableViewImage.image = meme.memedImage
        cell.tableViewLabel.text = meme.topText
//        cell.tableViewLabelTwo.text = meme.bottomText
        
        return cell
        
    }
 
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            appDelegate.memes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        }
    }
}


