import UIKit

class HamburgerMenuController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let menuItems = [String(localized: "Bus Locations", table: "Localizable"), 
                     String(localized: "Bus Stops", table: "Localizable"),
                     String(localized: "Dealers Locations", table: "Localizable"),
                     String(localized: "User's Balance", table: "Localizable"),
                     String(localized: "User Settings", table: "Localizable"),
                     String(localized: "Share App", table: "Localizable"),
                     String(localized: "Change Language", table: "Localizable")]
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
            // Navigate to Bus Locations view
            let busLocationsViewController = BusLocationsViewController()
            navigationController?.pushViewController(busLocationsViewController, animated: true)
            break
            
        case 1:
            // Navigate to Station Locations view
            let busStopsMapViewController = BusStopsViewController()
            navigationController?.pushViewController(busStopsMapViewController, animated: true)
            break
            
        case 2:
            // Navigate to Dealers Locations view
//            if let sceneDelegate = self.view.window?.windowScene?.delegate as?
//                SceneDelegate {
//                sceneDelegate.goToController(with: DealerLocationsViewController())
//            }
            let dealerLocationsViewController = DealerLocationsViewController()
            navigationController?.pushViewController(dealerLocationsViewController, animated: true)
            break
            
        case 3:
            // Navigate to User's Balance view
            let userBalanceViewController = UserBalanceViewController()
            navigationController?.pushViewController(userBalanceViewController, animated: true)
            break
            
        case 4:
            // User Settings
            let userSettingsController = UserSettingsController()
            navigationController?.pushViewController(userSettingsController, animated: true)
            break
            
        case 5:
            // Share App functionality
            shareApp()
            break
            
        case 6:
            // Change Language functionality
            let changeLanguageViewController = ChangeLanguageViewController()
            navigationController?.pushViewController(changeLanguageViewController, animated: true)
            break
            
        default:
            break
        }
    }
    
    private func shareApp() {
        let shareText = String(localized: "Check out this app!", table: "Localizable")
        if let link = URL(string: "https://example.com") {
            let objectsToShare: [Any] = [shareText, link]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityVC.excludedActivityTypes = [.airDrop, .addToReadingList]
            
            // Customize completion handler to handle specific activities
            activityVC.completionWithItemsHandler = { activityType, completed, returnedItems, error in
                if let activityType = activityType {
                    if activityType == UIActivity.ActivityType.message {
                        // The user selected Messages app
                        let messageBody = shareText // Use shareText directly
                        
                        // Create message URL with the message body
                        let messageURL = URL(string: "sms:&body=\(messageBody.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)")
                        
                        
                        if let url = messageURL {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }
                    }
                }
            }
            
            // Present the activity view controller
            present(activityVC, animated: true, completion: nil)
        }
    }



}
