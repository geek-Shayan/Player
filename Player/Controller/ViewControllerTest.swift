//
//  ViewControllerTest.swift
//  Player
//
//  Created by SHAYANUL HAQ SADI on 12/4/23.
//

import UIKit


class ViewControllerTest: UIViewController {

    @IBOutlet private weak var subtitlesButton: UIButton!
    
    @IBOutlet private weak var subtitlesTableView: UITableView!
    
    var subtitlesLanguage = ["bn", "en", "de", "au", "ru"]
//    var subtitlesLanguage = ["bn", "en", "ru"]
    var selectedSubtitle = String()
    var showCC = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "CC & TableView"
        
        setup()
        
    }
    
    private func setup() {
        subtitlesTableView.delegate = self
        subtitlesTableView.dataSource = self
        subtitlesTableView.isHidden = true
        subtitlesTableView.rowHeight = UITableView.automaticDimension
    
        subtitlesButton.isHidden = !showCC
    }

    @IBAction func subtitlesTapped(_ sender: Any) {
        print("subtitlesTapped")
        subtitlesTableView.isHidden = !subtitlesTableView.isHidden

    }
    
}


extension ViewControllerTest: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subtitlesLanguage.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = subtitlesLanguage[indexPath.row]
        cell.backgroundColor = .green
        
        return cell
    }
    
}


extension ViewControllerTest: UITableViewDelegate {
    func calculateHeightForRowAtIndexPath(_ indexPath: IndexPath) -> CGFloat {
            // Implement your logic to calculate the height based on content
            // You may need to measure the height of your text, images, etc.
//            return calculatedHeight
        return CGFloat( subtitlesLanguage.count * 10)
        
        }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return calculateHeightForRowAtIndexPath(indexPath)
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedSubtitle = subtitlesLanguage[indexPath.row]
        print("selected ", indexPath.row, selectedSubtitle )
        
    }
}
