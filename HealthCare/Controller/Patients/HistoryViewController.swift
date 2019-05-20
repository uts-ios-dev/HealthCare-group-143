import UIKit
import Firebase

class HistoryTableViewController: UITableViewController {

    var uid:String = ""
    var appointmentHistory:DatabaseReference!
    var randomAppointmentKey = Database.database().reference().child("Appointment").childByAutoId()
    
    var appointmentsHistory = [AppointmentHistory]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let user = (Auth.auth().currentUser?.uid)!
        appointmentHistory = Database.database().reference().child("Appointment History").child(user).child("Appointments")
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }

    
    func getData(){
        appointmentHistory.queryOrderedByKey().observe(.childAdded, with:  {
            snapshot in
            let appTime = snapshot.value(forKey: "Appointment Time") as! String
            let doctorName = snapshot.value(forKey: "Doctor Name") as! String
//            let appStatus = snapshot.value("Appointed")
            self.appointmentsHistory.insert(AppointmentHistory(appointmentTime: appTime, doctorName: doctorName, appointmentStatus: "Appointed"), at:  0)
        } )
    }
    }



