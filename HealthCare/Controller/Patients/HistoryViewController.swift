import UIKit
import Firebase

struct AppointmentStruct {
    let appointmentTime:String!
    let doctorName:String!
    let appointmentStatus:String!
}

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var ref :DatabaseReference!
    var appointmentsList = [AppointmentStruct]()
    
    @IBOutlet weak var appointmentTv: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
//        let user = (Auth.auth().currentUser?.uid)!
//        appointmentHistory = Database.database().reference().child("Appointment History").child(user).child("Appointments")
        appointmentTv.dataSource = self
        appointmentTv.delegate = self
        
        ref = Database.database().reference()
        ref?.child("Appointment History/FEmkRzUGKva6VQqcg2hc1Y039t92/Appointments").queryOrderedByKey().observe(.childAdded, with: { (snapshot) in
            guard let value = snapshot.value as? [String: Any] else{return}
            let time = value["Appointment Time"] as? String
            let name = value["Doctor Name"] as? String
            
            guard let time1 = time else{return}
            //guard let id1 = id else{return}
            guard let name1 = name else{return}
            
            self.appointmentsList.append(AppointmentStruct(appointmentTime: time1, doctorName: name1, appointmentStatus: "true"))
            self.appointmentTv.reloadData()
            
        }) {(error) in
            print(error.localizedDescription)
        }
        
    }
        
        
        
    
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return appointmentsList.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
            
            let label1 = cell?.viewWithTag(1) as! UILabel
            label1.text = appointmentsList[indexPath.row].doctorName
            let label2 = cell?.viewWithTag(2) as! UILabel
            label2.text = appointmentsList[indexPath.row].appointmentTime
            let label3 = cell?.viewWithTag(3) as! UILabel
            label3.text = appointmentsList[indexPath.row].appointmentStatus
            
            return cell!
        }
   
    }



