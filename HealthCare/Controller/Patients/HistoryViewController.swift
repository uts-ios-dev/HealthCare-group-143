import UIKit
import Firebase

struct AppointmentStruct {
    let appointmentTime:String!
    let doctorName:String!
}

class HistoryViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {


    @IBOutlet weak var patientName: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var patient = ""
    let userID = (Auth.auth().currentUser?.uid)!
    var appointmentHistory = [Appointments]()
    var appointmentReference:DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        appointmentReference = Database.database().reference().child("Appointment")
        appointmentReference?.queryOrdered(byChild: "Appointment Time").observe(.childAdded, with: {(snapshot) in
            guard let value = snapshot.value as? [String:Any] else {return}
            let time = value["Appointment Time"] as? String
            let doctorName = value["Doctor Name"] as? String
            let id = value["Appointment ID"] as? String
            let Uid = value["UserID"] as? String
            if(Uid == self.userID){
            self.appointmentHistory.append(Appointments(Uid: Uid!, Id: id!, Time: time!, DoctorName: doctorName!))
            }
            self.tableView.reloadData()
        }){(error) in
            print(error.localizedDescription)
        }
 
        appointmentReference.child("User").child(userID).observeSingleEvent(of: .value) { (snapshot) in
            guard let value = snapshot.value as? [String:Any] else{return}
            let firstName = value["firstName"] as! String
            let lastName = value["lastName"] as! String
            let patientsName = "\(firstName)" + "\(lastName)"
            self.patient = patientsName
            self.patientName.text = "G'day \(self.patient)"
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
        label1.text = appointmentHistory[indexPath.row].DoctorName
        
        let label2 = cell?.viewWithTag(2) as! UILabel
        label2.text = appointmentHistory[indexPath.row].Time
        
        return cell!
    }
}




