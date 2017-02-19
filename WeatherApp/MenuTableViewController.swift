//
//  MenuTableViewController.swift
//  WeatherApp
//
//  Created by Oleksiy Bilyi on 2/19/17.
//  Copyright © 2017 Oleksiy Bilyi. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {

    // MARK: - Parameters
    private let maps = [ "Default", "Google map", "Open street map"]
    private let tiles = ["Temperature", "Wind speed", "Precipitation", "Pressure"]
    private let alerts = ["Test polygon"]
    private let sections = ["Maps", "Weather tiles", "Polygons"]
    var selectedOption = ""
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3
        case 1:
            return 4
        case 2:
            return 1
        default:
            break
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCellIdentifier", for: indexPath) as! CustomMenuCell
        switch indexPath.section {
        case 0:
            cell.menuLabel.text = maps[indexPath.row]
        case 1:
            cell.menuLabel.text = tiles[indexPath.row]
        case 2:
            cell.menuLabel.text = alerts[indexPath.row]
        default:
            break
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let selectedIndex = tableView.indexPathForSelectedRow {
            switch selectedIndex.section {
            case 0:
                selectedOption =  maps[selectedIndex.row]
            case 1:
                selectedOption = tiles[selectedIndex.row]
            case 2:
                selectedOption = alerts[selectedIndex.row]
            default:
                break
            }
        }
    }

}
