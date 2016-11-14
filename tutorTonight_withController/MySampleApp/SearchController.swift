////
////  SearchController.swift
////  MySampleApp
////
////  Created by Arzaan Irani on 2016-11-13.
////
////
//
//import UIKit
//
//class SearchController: UIViewController{
//    
//    let searchDisplayController: UISearchController(searchResultsController: UIViewController)
//    
//    var filteredCourses = [Course]()
//
//    
//    searchController.searchResultsUpdater = self
//    searchController.dimsBackgroundDuringPresentation = false
//    definesPresentationContext = true
//    tableView.tableHeaderView = searchController.searchBar
//    
//    func filterContentForSearchText(searchText: String, scope: String = "All") {
//        filteredCourses = courses.filter { course in
//            return course.name.lowercaseString.containsString(searchText.lowercaseString)
//        }
//        
//        tableView.reloadData()
//    }
//    
//}
