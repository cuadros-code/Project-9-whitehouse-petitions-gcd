//
//  ViewController.swift
//  Project-7-whitehouse-petitions
//
//  Created by Kevin Cuadros on 15/08/24.
//

import UIKit

class ViewController: UITableViewController {
    
    var petitions = [Petition]()
    var filterPetitions = [Petition]()
    var isFilterResult = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Whitehouse News"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let actionFilter = UIAction(
            title: "Filter",
            image: UIImage(systemName: "line.3.horizontal.decrease.circle"
        )) { [ weak self ] _ in
            self?.showFilter()
        }
        
        let creditsFilter = UIAction(
            title: "Credits",
            image: UIImage(systemName: "book.pages")
        ) { [ weak self ] _ in
            self?.showCredits()
        }
        
        let resetFilter = UIAction(
            title: "Reset Filter",
            image: UIImage(systemName: "trash.fill")
        ) { [ weak self ] _ in
            self?.isFilterResult = false
            self?.tableView.reloadData()
        }
        
        let menu = UIMenu(title: "Actions", children: [actionFilter, resetFilter, creditsFilter])
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "",
            image: UIImage(systemName: "list.bullet"),
            menu: menu
        )
        
        let urlString: String

        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
            } else {
                showError()
            }
        } else {
            showError()
        }
        
    }
    
    func showError() {
        let ac = UIAlertController(
            title: "Loading error",
            message: "There was a problem loading the feed; please check your connection and try again.",
            preferredStyle: .alert
        )
        ac.addAction(UIAlertAction(
            title: "OK",
            style: .default
        ))
        present(ac, animated: true)
    }
    
    @objc func showCredits() {
        let ac = UIAlertController(
            title: "We The People de Whitehouse",
            message: nil,
            preferredStyle: .alert
        )
        ac.addAction(UIAlertAction(
            title: "Ok",
            style: .cancel
        ))
        present(ac, animated: true)
    }
    
    @objc func showFilter() {
        let ac = UIAlertController(
            title: "Filter", 
            message: "Find your news",
            preferredStyle: .alert
        )
        
        ac.addTextField()
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [ weak self, weak ac ] _ in
            if let text = ac?.textFields?.first?.text {
                self?.filterPetition(textToFind: text)
            }
        }
        
        ac.addAction(cancelAction)
        ac.addAction(submitAction)
        
        present(ac, animated: true)
    }
    
    func filterPetition(textToFind: String) {
        filterPetitions = petitions.filter({ $0.title.lowercased().contains(textToFind.lowercased()) })
        
        if filterPetitions.count >= 1 {
            isFilterResult = true
            tableView.reloadData()
        }
        
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFilterResult ? filterPetitions.count : petitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = isFilterResult ? filterPetitions[indexPath.row] : petitions[indexPath.row]
        var content = cell.defaultContentConfiguration()
        
        content.text = petition.title
        content.secondaryText = String(petition.body.prefix(100)) + "..."
        cell.contentConfiguration = content
        return cell
    }
    
    override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let shareAction = UIAction(
            title: "Share",
            image: UIImage(systemName: "square.and.arrow.up"),
            identifier: nil
        ) { _ in
            print("hello")
        }
        
        let deleteAction = UIAction(
            title: "Delete",
            image: UIImage(systemName: "trash.fill"),
            identifier: nil,
            attributes: .destructive
        ) { _ in
        }
        
        let menu = UIMenu(title: "Menu", children: [shareAction, deleteAction] )
        
        return UIContextMenuConfiguration(identifier: nil, actionProvider:  { _ in
            return menu
        })
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }


}

