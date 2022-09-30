//
//  TabsTBC.swift
//  Planet
//
//  Created by Kovs on 09.09.2022.
//

import UIKit
import RealmSwift

class TabsTBC: UITableViewController {
    
    var tabs = [Tab]()
    var delegate: ViewController!
    var selectedTab: Int!
    @IBOutlet var tabTable: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        tabTable.register(UINib(nibName: "TabTableViewCell", bundle: nil), forCellReuseIdentifier: "Tab")
        
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    
    @IBAction func addTab(_ sender: UIBarButtonItem) {
        let realm = try! Realm()
        let newTab: Tab = Tab()
        
        try! realm.write {
            realm.add(newTab)
        }
        tabs.append(newTab)
        selectedTab = tabs.count - 1
        tabTable.reloadData()
        
        delegate.addTab(newTab)
        navigationController?.popViewController(animated: true)
    }
    

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tabs.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tab = tabs[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Tab", for: indexPath) as! TabTableViewCell
    
        if tab.title.isEmpty {
            cell.title.text = "New Tab"
            cell.url.text = ""
        } else {
            cell.title.text = tab.title
            cell.url.text = tab.url
        }
        
        // check rows index with selected index:
        if indexPath.row == selectedTab {
            cell.layer.borderWidth = 1
            cell.layer.borderColor = UIColor.green.cgColor
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != selectedTab {
            delegate.selectedTab = indexPath.row
            delegate.loadWebView()
        }
        navigationController?.popViewController(animated: true)
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
