import UIKit

class HomeViewController: UIViewController {
    private let service = Service()
    
    var currentPage = 1
    
    lazy var homeView: HomeView = {
        let homeView = HomeView()
        homeView.delegate = self
        return homeView
    }()
    
    lazy var logoPage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = homeView
        navigationItem.titleView = logoPage
        self.fetchList()
    }
    
    func fetchList() {
        service.fetchAnimals(currentPage: currentPage, { animals in
            guard let dataAnimals = animals else { return }
            
            print(dataAnimals)
            DispatchQueue.main.async {
                self.currentPage += 1
                self.homeView.updateView(with: dataAnimals.animals)
            }
        })
    }
}


extension HomeViewController: HomeViewDelegate {
    func didFetchAnimals() {
        self.fetchList()
    }
}
