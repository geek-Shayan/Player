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
    var selectedIndexPath: IndexPath? = nil
    
    var onSelection: ((Subtitle, IndexPath) -> Void)?
    var onDeSelection: (() -> Void)?
    
    class func initVC( with subtitles: [Subtitle], selectedIndexPath: IndexPath? = nil) -> ViewControllerPopUp? {
        let board = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = board.instantiateViewController(withIdentifier: "ViewControllerPopUp") as? ViewControllerPopUp else { return nil }
        vc.subtitles = subtitles
        vc.selectedIndexPath = selectedIndexPath
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let selectedIndexPath = selectedIndexPath {
            subtitlesTableView.selectRow(at: selectedIndexPath, animated: false, scrollPosition: .none)
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if (super.view.frame.size.height/3) > (subtitlesTableView.contentSize.height) {
            containerViewHeightConstant.constant = subtitlesTableView.contentSize.height + 32 + 44 //frame.size.height
        } else {
            containerViewHeightConstant.constant = view.frame.size.height/3
        }
    }
    
    @objc func dismissModal() {
        self.dismiss(animated: true)
    }
    
    private func setupUI() {
        subtitlesTableView.delegate = self
        subtitlesTableView.dataSource = self
        subtitlesTableView.rowHeight = UITableView.automaticDimension
        subtitlesTableView.estimatedRowHeight = 100 // Provide an estimated row height
        subtitlesTableView.register(UINib(nibName: "BottomSheetSubtitlesTableViewCell", bundle: nil), forCellReuseIdentifier: BottomSheetSubtitlesTableViewCell.identifier)
        
//        containerView.layer.cornerRadius = 20
    }

}

extension ViewControllerPopUp: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subtitles.count + 1
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
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
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
                self.onSelection?(selectedSubtitle!, indexPath)
                
            }
        }
    }
}
