//
//  EpisodeViewController.swift
//  GOT-StudentVersion
//
//  Created by C4Q on 11/3/17.
//  Copyright © 2017 C4Q . All rights reserved.
//
import UIKit

class EpisodeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    var episodes: [GOTEpisode] = []
    var sectionName: [String] = []
    var rightCellImage = RightAlignedTableViewCell()
    
    @IBOutlet weak var gOTTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadEpisodeData()
        //rightCellImage.episodePosterImage.layer.borderWidth = 2
        //rightCellImage.episodePosterImage.layer.borderColor = UIColor.white.cgColor
        self.rightCellImage.layer.borderWidth = 1
        self.rightCellImage.layer.borderColor = UIColor.white.cgColor
        gOTTableView.delegate = self
        gOTTableView.dataSource = self
    }
    func loadEpisodeData(){
        let allEpisodes = EpisodeData.allEpisodes
        let sortedEpisodeBySeason = allEpisodes.sorted{$0.season < $1.season}
        self.episodes = sortedEpisodeBySeason
        self.gOTTableView.rowHeight = UITableViewAutomaticDimension
        self.gOTTableView.estimatedRowHeight = 200.0
        //adding season number into the sectionname array = [1,2,3,4,5,6,7]
        for episode in episodes{
            if !sectionName.contains(String(episode.season)){
                sectionName.append(String(episode.season))
            }
        }
    }
    ///Optional DataSource Methods
    //setting up number of section headers
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionName.count
    }
    //customizing titles for sections
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
        return theseEpisodes.count // tells you how many episodes there in the allEpisodes array
    }
    
    ///HOW TO ALTERNATE ON EVERY SEASON...RIGHT NOW IT IS ALTERNATING
    
    
    ///Downcasting
    // Used to describe the cell at a specific row/section in a UITableView
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let leftAlignedCell = indexPath.section % 2 == 0
        if leftAlignedCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Left Episode Cell", for: indexPath)
            if let cell = cell as? LeftAlignedTableViewCell {
                let theseEpisodes = episodes.filter{String($0.season) == sectionName[indexPath.section]}
                let thisEpisode = theseEpisodes[indexPath.row]
//                let rowToSetUp = indexPath.row
//                let episodeToSetUp = episodes[rowToSetUp]
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
    //Preparing segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        //where you are going and see if its infact where you are trying to go
        if let destination = segue.destination as? DetailedEpisodeViewController{
            ///go to VC you are changing things to and 1. check for nil and 2. set up the properties
            //what you want to give to the DEVC:
            ///take your episode property and set it to whatever user has selected
            let selectedRow =  self.gOTTableView.indexPathForSelectedRow!.row
            let selectedEpisode = self.episodes[selectedRow]
            destination.episode = selectedEpisode
        }
    }
}
