import UIKit
import Firebase

struct Appointment {
    let appointmentTime:String!
    let doctorName:String!
}

class HomeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    var appointments:DatabaseReference!
    var appointment = [Appointment]()
    var appointmentHandle:DatabaseHandle?
    var patient:DatabaseHandle?
    var uid:String = ""
    var appointmentListReference:DatabaseReference!

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var patientName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Dashboard"
        self.navigationItem.hidesBackButton = true
        tableView.dataSource = self
        tableView.delegate = self
//        key = appointments.childByAutoId().key
        let userID = (Auth.auth().currentUser?.uid)!
        //        getAppointment()
        appointmentListReference = Database.database().reference()
        appointmentListReference?.child("User").child(userID).child("AppointmentsDetails").queryOrderedByKey().observe(.childAdded, with: { (snapshot) in
            guard let value = snapshot.value as? [String:Any] else{return}
            let appTime = value["Time"] as? String
            let doctorName = value["DoctorName"] as? String
            guard let appTime1 = appTime else{return}
            guard let doctorName1 = doctorName else{return}
            self.appointment.append(Appointment(appointmentTime: appTime1, doctorName: doctorName1))
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
        }
        catch let logout{
            print(logout)
        }
        performSegue(withIdentifier: "logoutPatient", sender: self)
    }

    @IBAction func bookAppointment(_ sender: UIButton) {
        
        performSegue(withIdentifier: "confirmAppointment", sender: self)
    }
    
    
    @IBAction func editProfile(_ sender: UIButton) {
//        getAppointment()
        performSegue(withIdentifier: "editProfile", sender: self)
    }
    
    
    @IBAction func showHealthStatus(_ sender: UIButton) {
        performSegue(withIdentifier: "healthStatus", sender: self)
    }
    
    
 
    @IBAction func showHistory(_ sender: UIButton) {
        performSegue(withIdentifier: "patientHistory", sender: self)
    }
    
    @IBAction func cancelAppointments(_ sender: UIButton) {
        performSegue(withIdentifier: "cancelAppointment", sender: self)
    }
    
    @IBAction func logoutPatient(_ sender: UIButton) {
        do{
            try Auth.auth().signOut()
                performSegue(withIdentifier: "logoutPatient", sender: self)
        }
        catch{
            let alert = UIAlertController(title: "Error!", message: "Please check your internet connection", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert,animated: true,completion: nil)
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appointment.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        let label1 = cell?.viewWithTag(1) as! UILabel
        label1.text = appointment[indexPath.row].appointmentTime
        
        let label2 = cell?.viewWithTag(2) as! UILabel
        label2.text = appointment[indexPath.row].doctorName
        
        return cell!
    }
    
}
