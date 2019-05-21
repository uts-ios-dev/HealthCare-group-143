import UIKit
import Firebase

struct AppointmentStruct {
    let appointmentTime:String!
    let doctorName:String!
}

class HistoryViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {


    @IBOutlet weak var tableView: UITableView!
    let userID = (Auth.auth().currentUser?.uid)!
    var appointmentHistory = [AppointmentStruct]()
    var appointmentReference:DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        appointmentReference = Database.database().reference()
            appointmentReference?.child("Appointment History").child(userID).queryOrderedByKey().observe(.childAdded, with: { (snapshot) in
            guard let value = snapshot.value as? [String:Any] else{return}
            let appTime = value["Time"] as? String
            let doctorName = value["Doctor name"] as? String
                guard let appTime1 = appTime else{return}
                guard let doctorName1 = doctorName else{return}
                self.appointmentHistory.append(AppointmentStruct(appointmentTime: appTime1, doctorName: doctorName1))
                self.tableView.reloadData()
            }){(error) in
                print(error.localizedDescription)
        }

    }
    @IBAction func back(_ sender: UIButton) {
        performSegue(withIdentifier: "homeView", sender: self)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appointmentHistory.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        let label1 = cell?.viewWithTag(1) as! UILabel
        label1.text = "Doctor Name: \(appointmentHistory[indexPath.row].doctorName)"
        
        let label2 = cell?.viewWithTag(2) as! UILabel
        label2.text = "Time: \(appointmentHistory[indexPath.row].appointmentTime)"
        
        return cell!
    }
}




