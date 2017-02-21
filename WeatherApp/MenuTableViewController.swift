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
    private let maps = [ MapsOptions.DefaultMap, MapsOptions.GoogleMap, MapsOptions.OpenStreetMap]
    private let tiles = [MapsOptions.NoneTile,MapsOptions.TemperatureTile, MapsOptions.WindSpeedTile, MapsOptions.PrecipitationTile, MapsOptions.PressureTile]
    private let annotations = [MapsOptions.NoneAnnotations, MapsOptions.CitiesAnnotations]
    private let sections = ["Maps", "Weather tiles", "Annotations"]
    var selectedOption : MapsOptions = .DefaultMap
    
    override func viewDidLoad() {
        transitioningDelegate = MenuViewAnimator()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dismiss(animated: true, completion: nil)
        switch section {
        case 0:
            return 3
        case 1:
            return 5
        case 2:
            return 2
        default:
            break
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCellIdentifier", for: indexPath) as! CustomMenuCell
        switch indexPath.section {
        case 0:
            cell.menuLabel.text = maps[indexPath.row].rawValue
        case 1:
            cell.menuLabel.text = tiles[indexPath.row].rawValue
        case 2:
            cell.menuLabel.text = annotations[indexPath.row].rawValue
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
                selectedOption = annotations[selectedIndex.row]
            default:
                break
            }
        }
        dismiss(animated: true, completion: nil)
    }

}
