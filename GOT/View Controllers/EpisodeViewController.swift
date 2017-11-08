//
//  EpisodeViewController.swift
//  GOT-StudentVersion
//
//  Created by C4Q on 11/3/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

//How to round and outline buttons:
//https://stackoverflow.com/questions/38874517/how-to-make-a-simple-rounded-button-in-storyboard


import UIKit
//UISearchBarDelegate, UISearchResultsUpdating

class EpisodeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var episodes: [GOTEpisode] = []
    var sectionName: [String] = []
    var rightCellImage = RightAlignedTableViewCell()
    let searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet weak var gOTTableView: UITableView!
    
//    var filteredEpisodeArr: [GOTEpisode] {
//        //make sure there is a searchterm
//        guard let searchTerm = searchTerm, searchTerm != "" else {
//            return episodes
//        }
//        //make sure there are scope titles in the searchBar
//        guard let scopeTitles = self.searchController.searchBar.scopeButtonTitles else {
//            return episodes
//        }
//        //set up search bar button titles
//        let selectedIndex = self.searchController.searchBar.selectedScopeButtonIndex
//        let filteringCriteria = scopeTitles[selectedIndex]
//        //switch on filteringCriteria
//        switch filteringCriteria{
//        case "Titles":
//            return episodes.filter{(episode) in
//                episode.name.lowercased().contains(searchTerm.lowercased())
//            }
//        case "Summaries":
//            return episodes.filter{(episode) in
//                episode.summary.lowercased().contains(searchTerm.lowercased())
//            }
//        default:
//            return episodes
//        }
//    }
    override func viewDidLoad() {
        super.viewDidLoad()
        loadEpisodeData()
        //delegates
        gOTTableView.delegate = self
        gOTTableView.dataSource = self
//        searchController.searchBar.delegate = self
//        searchController.searchResultsUpdater = self
//        searchController.isActive = true
//        searchController.obscuresBackgroundDuringPresentation = true
//        searchController.hidesNavigationBarDuringPresentation = false
//        navigationItem.searchController = searchController
//        definesPresentationContext = true
//        ///filter button bar set up
//        searchController.searchBar.scopeButtonTitles = ["Title", "Summary"]
    }
    func loadEpisodeData(){
        let allEpisodes = EpisodeData.allEpisodes
        let sortedEpisodeBySeason = allEpisodes.sorted{$0.season < $1.season}
        self.episodes = sortedEpisodeBySeason
        self.gOTTableView.rowHeight = UITableViewAutomaticDimension
        self.gOTTableView.estimatedRowHeight = 200.0
        //adding season number into the sectionName array = [1,2,3,4,5,6,7]
        for episode in episodes{
            if !sectionName.contains(String(episode.season)){
                sectionName.append(String(episode.season))
            }
        }
    }
    //Instantiating searchTerm for searchBar
    var searchTerm: String? {
        didSet{
            self.gOTTableView.reloadData()
        }
    }
    ///Optional DataSource Methods
    //number of section headers
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionName.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Season One"
        case 1:
            return "Season Two"
        case 2:
            return "Season Three"
        case 3:
            return "Season Four"
        case 4:
            return "Season Five"
        case 5:
            return "Season Six"
        case 6:
            return "Season Seven"
        default:
            break
        }
        return sectionName[section]
    }
    ///Required Datasource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let theseEpisodes = episodes.filter{String($0.season) == sectionName[section]}
        return theseEpisodes.count // returns the count of the episodes filteres by season
        //filteredEpisodeArr.count
    }
    ///Downcasting
    // Used to describe the cell at a specific row/section in a UITableView
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let leftAlignedCell = indexPath.section % 2 == 0
        if leftAlignedCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Left Episode Cell", for: indexPath)
            if let cell = cell as? LeftAlignedTableViewCell {
                let theseEpisodes = episodes.filter{String($0.season) == sectionName[indexPath.section]}
                let thisEpisode = theseEpisodes[indexPath.row]//filteredEpisodeArr.count
                //setting text and images
                cell.episodePosterImage.image = UIImage(named: thisEpisode.mediumImageID)
                cell.titleLabel.text = thisEpisode.name
                cell.episodeIdentifier.text = "S: \(thisEpisode.season)  E: \(thisEpisode.number)"
                return cell
            }
        } else {
            //right aligned cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "Right Episode Cell", for: indexPath)
            if let cell = cell as? RightAlignedTableViewCell{
                let theseEpisodes = episodes.filter{String($0.season) == sectionName[indexPath.section]}
                let thisEpisode = theseEpisodes[indexPath.row]
                cell.episodePosterImage.image = UIImage(named: thisEpisode.mediumImageID)
                cell.titleLabel.text = thisEpisode.name
                cell.episodeIdentifier.text = "S: \(thisEpisode.season) E: \(thisEpisode.number)"
                return cell
            }
        }
        return UITableViewCell()
    }
//  /// Searchbar Methods
//    //UISearchResultsUpdating
//    func updateSearchResults(for searchController: UISearchController) {
//        self.searchTerm = searchController.searchBar.text
//    }
//    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
//        gOTTableView.reloadData()
//    }

    //Preparing segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var currentSeason = episodes.filter{$0.season == gOTTableView.indexPathForSelectedRow!.section + 1}
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        //where you are going and see if its infact where you are trying to go
        if let destination = segue.destination as? DetailedEpisodeViewController{
            ///go to VC you are changing things to and 1. check for nil and 2. set up the properties
            //what you want to give to the DEVC:
            ///take your episode property and set it to whatever user has selected
            let selectedRow =  self.gOTTableView.indexPathForSelectedRow!.row
            //let selectedSeason = self.gOTTableView.indexPathForSelectedRow!.section
            let selectedEpisode = currentSeason[selectedRow]
            destination.episode = selectedEpisode
        }
    }
}
