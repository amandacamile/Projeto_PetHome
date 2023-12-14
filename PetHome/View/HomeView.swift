import UIKit

protocol HomeViewDelegate: AnyObject {
    func didFetchAnimals()
}

class HomeView: UIView {
    private var listAnimals: [AnimalDetails] = []
    weak var delegate: HomeViewDelegate?
    
    lazy var activityIndicator: UIActivityIndicatorView = {
       let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = self.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    lazy var titlePage: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 1
        label.text = "PetHome"
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(AnimalViewCell.self, forCellReuseIdentifier: AnimalViewCell.identifier)
        table.dataSource = self
        table.delegate = self
        table.separatorStyle = .none
        return table
    }()
    
    init() {
        super.init(frame: .zero)
        self.setupViews()
        self.backgroundColor = .purple
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateView(with listAnimals: [AnimalDetails]) {
        activityIndicator.stopAnimating()
        self.listAnimals.append(contentsOf: listAnimals)
        tableView.reloadData()
    }
    
    func setupViews() {
        self.addSubview(self.titlePage)
        self.addSubview(tableView)
        self.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            self.titlePage.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            self.titlePage.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            self.tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.tableView.topAnchor.constraint(equalTo: titlePage.bottomAnchor, constant: 10),
            self.tableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            
            self.activityIndicator.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 25),
            self.activityIndicator.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -30),
            self.activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
}

extension HomeView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listAnimals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: AnimalViewCell.identifier, for: indexPath) as? AnimalViewCell {
            let animal = listAnimals[indexPath.row]
            if animal.photos.count != 0, let image = animal.photos.first?.medium {
                cell.imageAnimal.load(url: URL(string: image))
            } else {
                cell.imageAnimal.load(url: nil)
            }
            cell.nameLabel.text = animal.name
            cell.specieLabel.text = animal.species
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(listAnimals[indexPath.row].name)
    }
}

extension HomeView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height

        if offsetY > contentHeight - height {
            self.activityIndicator.startAnimating()
            self.delegate?.didFetchAnimals()
        }
    }
}
