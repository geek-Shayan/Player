//
//  ViewControllerPopUp.swift
//  Player
//
//  Created by SHAYANUL HAQ SADI on 12/17/23.
//

import UIKit

class ViewControllerPopUp: UIViewController {

    @IBOutlet weak var dismissView: UIView!
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet private weak var subtitlesTableView: UITableView!
    
    @IBOutlet weak var containerViewHeightConstant: NSLayoutConstraint!
    
    var subtitles: [Subtitle] = []
    
    var selectedSubtitle: Subtitle? = nil
    
    var onSelection: ((Subtitle) -> Void)?
    var onDeSelection: (() -> Void)?
    
    class func initVC( with subtitles: [Subtitle]) -> ViewControllerPopUp? {
        let board = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = board.instantiateViewController(withIdentifier: "ViewControllerPopUp") as? ViewControllerPopUp else { return nil }
        vc.subtitles = subtitles
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let hideTap = UITapGestureRecognizer.init(target: self, action: #selector(dismissModal))
        dismissView.addGestureRecognizer(hideTap)
        
        let hidePan = UIPanGestureRecognizer.init(target: self, action: #selector(dismissModal))
//        verticalGesture.delegate = self
        dismissView.addGestureRecognizer(hidePan)
        
        setupUI()
    }
    
    override func viewWillLayoutSubviews() {
        
//        if super.view.fra
        
//        containerViewHeightConstant.constant = subtitlesTableView.contentSize.height + 32 + 44 //frame.size.height

    }
    
    @objc func dismissModal() {
        self.dismiss(animated: true)
    }
    
    private func setupUI() {
        subtitlesTableView.delegate = self
        subtitlesTableView.dataSource = self
        subtitlesTableView.rowHeight = UITableView.automaticDimension
        subtitlesTableView.estimatedRowHeight = 100 // Provide an estimated row height
        
//        subtitlesTableView.register(UINib(nibName: "SubtitlesTableViewCell", bundle: nil), forCellReuseIdentifier: SubtitlesTableViewCell.identifier)
        subtitlesTableView.register(UINib(nibName: "BottomSheetSubtitlesTableViewCell", bundle: nil), forCellReuseIdentifier: BottomSheetSubtitlesTableViewCell.identifier)
        
        containerView.layer.cornerRadius = 20
        
        view.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
    }

}

extension ViewControllerPopUp: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subtitles.count + 1
//        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BottomSheetSubtitlesTableViewCell.identifier, for: indexPath) as? BottomSheetSubtitlesTableViewCell else { return UITableViewCell() }
        if indexPath.row == 0 {
            cell.subtitleLabel.text = "Off"
        } else {
            cell.subtitleLabel.text = subtitles[indexPath.row - 1].language
        }
        return cell
    }
    
}

extension ViewControllerPopUp: UITableViewDelegate {
//    func calculateHeightForRowAtIndexPath(_ indexPath: IndexPath) -> CGFloat {
//            // Implement your logic to calculate the height based on content
//            // You may need to measure the height of your text, images, etc.
////            return calculatedHeight
//        return CGFloat( subtitles.count * 10)
//    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
////        return calculateHeightForRowAtIndexPath(indexPath)
//        return 30
//    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "Subtitle"
//    }
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 30
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return UITableView.automaticDimension
//            return 25
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) as? BottomSheetSubtitlesTableViewCell {
            
            if indexPath.row == 0 {
                selectedSubtitle = nil
                print("selected ", indexPath.row, selectedSubtitle )
                
                self.onDeSelection?()
            } else {
                selectedSubtitle = subtitles[indexPath.row - 1]
                print("selected ", indexPath.row, selectedSubtitle )
                
                self.onSelection?(selectedSubtitle!)
            }
        }

        
    }
}
