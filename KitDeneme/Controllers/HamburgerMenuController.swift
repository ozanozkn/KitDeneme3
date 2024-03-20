import UIKit

class HamburgerMenuController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let menuItems = ["Main Menu", "Bus Locations", "Bus Stops", "Dealers Locations", "User's Balance", "User Settings", "Share App", "Change Language"]
    let tableView = UITableView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        
        
        self.setupUI()
        
        
    }
    
    // MARK: - UITableViewDataSource

    private func setupUI() {
        
        tableView.backgroundColor = .white
        tableView.layer.cornerRadius = 20
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MenuItemCell")
        
        self.view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 75), // Adjust the top constraint as needed
            
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20), // Adjust the leading constraint as needed
            tableView.widthAnchor.constraint(equalToConstant: 200), // Set a fixed width or adjust as needed
            tableView.heightAnchor.constraint(equalToConstant: CGFloat(menuItems.count) * 44.25) // Height based on number of rows

            
        ])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuItemCell", for: indexPath)
        cell.textLabel?.text = menuItems[indexPath.row]
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // Handle menu item selection
        switch indexPath.row {
        case 0:
            if let sceneDelegate = self.view.window?.windowScene?.delegate as?
                SceneDelegate {
                sceneDelegate.checkAuthentication()
            }
            break
        case 1:
            // Navigate to Bus Locations view
            // Example:
            // let busLocationsViewController = BusLocationsViewController()
            // navigationController?.pushViewController(busLocationsViewController, animated: true)
            break
        case 2:
            // Navigate to Station Locations view
            let busStopsMapViewController = BusStopsMapViewController()
            navigationController?.pushViewController(busStopsMapViewController, animated: true)
            break
        case 3:
            // Navigate to Dealers Locations view
            break
        case 4:
            // Navigate to User's Balance view
            break
        case 5:
            // User Settings
            let userSettingsController = UserSettingsController()
            navigationController?.pushViewController(userSettingsController, animated: true)
            break
        case 6:
            // Share App functionality
            shareApp()
            break
        case 7:
            // Change Language functionality
            break
        default:
            break
        }
    }
    
    private func shareApp() {
            
            
            let shareText = "check this app!"
            if let link = NSURL(string: "https://example.com") {
                
                let objectsToShare = [shareText,link] as [Any]
                let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
                self.present(activityVC, animated: true, completion: nil)
                
            }
        }

}
