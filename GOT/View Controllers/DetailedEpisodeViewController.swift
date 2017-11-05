//
//  DetailedEpisodeViewController.swift
//  GOT-StudentVersion
//
//  Created by C4Q on 11/3/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class DetailedEpisodeViewController: UIViewController {
    
    @IBOutlet weak var detailedPosterImageView: UIImageView!
    @IBOutlet weak var airDateLabel: UILabel!
    @IBOutlet weak var seasonLabel: UILabel!
    @IBOutlet weak var runTimeLabel: UILabel!
    @IBOutlet weak var episodeLabel: UILabel!
    @IBOutlet weak var summaryTextView: UITextView!
    
    //before loaded: episodes are nil
    var episode: GOTEpisode? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ///Check to see if you have a movie
        //make sure you have an episode....if you do set up properties
        guard let episode = episode else {
            return
        }
        //set-up properties of what you want to appear in new VC
        seasonLabel.text = "Season: \(String(episode.season))"
        episodeLabel.text = "Episode: \(String(episode.number))"
        runTimeLabel.text = "Runtime: \(String(episode.runtime))"
        airDateLabel.text = "Airdate: \(episode.airdate)"
        detailedPosterImageView.image = UIImage(named: episode.originalImageID)
        summaryTextView.text = episode.summary
    }
}
