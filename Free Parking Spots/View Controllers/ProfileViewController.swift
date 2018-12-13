//
//  ProfileViewController.swift
//  FreeParkingSpots
//
//  Created by Ilgar Ilyasov on 12/12/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var profileTableView: UITableView!
    private let settings = ["Your Places", "Settings"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileTableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        profileTableView.reloadData()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let settingsCell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath)
        settingsCell.textLabel?.text = settings[indexPath.row]
        return settingsCell
    }
}
