import UIKit

class AnimalViewCell: UITableViewCell {
    static let identifier: String = "AnimalViewCell"
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.imageAnimal, self.nameLabel, self.specieLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.backgroundColor = UIColor(red: 0.784, green: 0.635, blue: 0.784, alpha: 1.0)
        stackView.spacing = 2
        return stackView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    lazy var specieLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    lazy var imageAnimal: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let containerView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configureSubviews()
        self.configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureSubviews() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(stackView)
        
        containerView.layer.cornerRadius = 10
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.black.cgColor
        containerView.layer.masksToBounds = true
        
        addSubview(containerView)
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 250),
            containerView.heightAnchor.constraint(equalToConstant: 200),
            containerView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            
            self.imageAnimal.heightAnchor.constraint(equalToConstant: 100),
            self.imageAnimal.widthAnchor.constraint(equalToConstant: 100),
            self.imageAnimal.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            
            self.nameLabel.topAnchor.constraint(equalTo: imageAnimal.bottomAnchor, constant: 2),
            self.nameLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 5),
            self.specieLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            self.specieLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 5),
            self.specieLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10)
        ])
    }
}

extension UIImageView {
    func load(url: URL?) {
        guard let url = url else {
            self.image = UIImage(named: "image_error.jpg")
            return
        }
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
