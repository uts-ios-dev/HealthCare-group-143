import UIKit
import Firebase

struct Appointment {
    let appointmentTime:String!
    let doctorName:String!
    let appID:String!
}

class HomeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    var appointments:DatabaseReference!
    var appointment = [Appointment]()
    var appointmentHandle:DatabaseHandle?
    var patient:DatabaseHandle?
    var uid:String = ""
    var myIndex = 0
    var appointmentListReference:DatabaseReference!
    var myAppointment:DatabaseReference!
    
    
    let userID = Auth.auth().currentUser?.uid
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var patientName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
//        key = appointments.childByAutoId().key
        //        getAppointment()
        appointmentListReference = Database.database().reference();
    
         appointmentListReference?.child("User").child(userID!).child("Appointments").queryOrderedByKey().observe(.childAdded, with: { (snapshot) in
            guard let value = snapshot.value as? [String:Any] else{return}
            let appID = value["Appointment ID"] as? String
            let appTime = value["Time"] as? String
            let doctorName = value["DoctorName"] as? String
            guard let appTime1 = appTime else{return}
            guard let doctorName1 = doctorName else{return}
            self.appointment.append(Appointment(appointmentTime: appTime1, doctorName: doctorName1,appID: appID))
            self.tableView.reloadData()
        }){(error) in
            print(error.localizedDescription)
        }
        let user = Auth.auth().currentUser
        if let user = user{
            patientName.text = "\(user.email!)"
        }
    }

    
    @objc func handleLogout(){
        do{
            try Auth.auth().signOut()
            performSegue(withIdentifier: "logoutPatient", sender: self)
        }
        catch let logout{
            print(logout)
        }
        
    }

    @IBAction func bookAppointment(_ sender: UIButton) {
        
        performSegue(withIdentifier: "confirmAppointment", sender: self)
    }
    
    
    @IBAction func editProfile(_ sender: UIButton) {
//        getAppointment()
        performSegue(withIdentifier: "editProfile", sender: self)
    }
    
    
 
    @IBAction func showHistory(_ sender: UIButton) {
        performSegue(withIdentifier: "patientHistory", sender: self)
    }

    
    @IBAction func logoutPatient(_ sender: UIButton) {
        do{
            try Auth.auth().signOut()
            performSegue(withIdentifier: "logout", sender: self)
        }
        catch let logout{
            print(logout)
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appointment.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        let label1 = cell?.viewWithTag(1) as! UILabel
        print("Yo home view ma ho hai")
        print("")
        print("")
        print("")
        
        print(appointment[indexPath.row].appointmentTime)
        print(appointment[indexPath.row].doctorName)
        label1.text = appointment[indexPath.row].appointmentTime
        
        let label2 = cell?.viewWithTag(2) as! UILabel
        label2.text = appointment[indexPath.row].doctorName
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myIndex = indexPath.row
        createAlert()
    }
    func createAlert(){
        
        let title = "Reminder"
        let message = "Are you sure to Cancel the Appointment"
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default) { (action) in
            alert.dismiss(animated: true, completion: nil)
        })
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) { (action) in
            alert.dismiss(animated: true, completion: nil)
                self.appointmentListReference.child("User").child(self.userID!).child("Appointments").child(self.appointment[self.myIndex].appID).removeValue()
            self.appointment.remove(at: self.myIndex)
            self.tableView.reloadData()
//            self.myAppointment.child("Appointment").child(self.appointment[self.myIndex].appID).removeValue()
//            self.appointment.remove(at: self.myIndex)
//            self.tableView.reloadData()
//            self.ref.child("Appointment").child(self.appointments[self.myIndex].Id).removeValue()
//            self.appointments.remove(at:self.myIndex)
//            self.appointmentTv.reloadData()
        })
        
        self.present(alert,animated: true, completion: nil)
    }
    
}
