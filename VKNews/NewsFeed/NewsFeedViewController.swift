//
//  NewsFeedViewController.swift
//  VKNews
//
//  Created by Глеб on 13.10.2019.
//  Copyright (c) 2019 Глеб. All rights reserved.
//

import UIKit

protocol NewsFeedDisplayLogic: class {
  func displayData(viewModel: NewsFeed.Model.ViewModel.ViewModelData)
}

class NewsFeedViewController: UIViewController, NewsFeedDisplayLogic {

  var interactor: NewsFeedBusinessLogic?
  var router: (NSObjectProtocol & NewsFeedRoutingLogic)?
    
    private var feedViewModel = FeedViewModel.init(cells: [])
    
    
    @IBOutlet weak var table: UITableView!
    
  // MARK: Setup
  
  private func setup() {
    let viewController        = self
    let interactor            = NewsFeedInteractor()
    let presenter             = NewsFeedPresenter()
    let router                = NewsFeedRouter()
    viewController.interactor = interactor
    viewController.router     = router
    interactor.presenter      = presenter
    presenter.viewController  = viewController
    router.viewController     = viewController
  }
  
  // MARK: Routing
  

  
  // MARK: View lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setup()
    
    table.register(UINib(nibName: "NewsFeedCell", bundle: nil), forCellReuseIdentifier: NewsFeedCell.reuseID)
    table.separatorStyle = .none
    table.backgroundColor = .clear
    view.backgroundColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
    interactor?.makeRequest(request: NewsFeed.Model.Request.RequestType.getNewsFeed)
  }
  
  func displayData(viewModel: NewsFeed.Model.ViewModel.ViewModelData) {
    switch viewModel {

    case .displayNewsFeed(let feedViewModel):
        self.feedViewModel = feedViewModel
        table.reloadData()
    }
  }
}

extension NewsFeedViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedViewModel.cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsFeedCell.reuseID, for: indexPath) as! NewsFeedCell
        let cellViewModel = feedViewModel.cells[indexPath.row]
        cell.set(viewModel: cellViewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 212
    }
    
    
}
