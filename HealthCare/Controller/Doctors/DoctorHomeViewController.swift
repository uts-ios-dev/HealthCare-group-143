import UIKit
import Firebase

struct appointmentStruct {
    let Uid : String!
    let Id : String!
    let Time : String!
}

class DoctorHomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var appointmentTv: UITableView!
    @IBOutlet weak var doctorNameLbl: UILabel!
    
    var ref: DatabaseReference!
    var appointments = [appointmentStruct]()
    var myIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationItem.title = "Update Schedules"
        appointmentTv.dataSource = self
        appointmentTv.delegate = self
        ref = Database.database().reference()
        
        //get doctor name
        
        let authUI = Auth.auth().currentUser?.uid
        print("------")
        print(authUI!)
        ref.child("User/\(authUI!)").observeSingleEvent(of: .value) { (snapshot) in
            guard let value = snapshot.value as? [String: Any] else{return}
            let firstName = value["firstName"] as! String
            let lastName = value["lastName"] as! String
            let doctorName =  "\(firstName) " + "\(lastName)"
            
            self.doctorNameLbl.text = doctorName
            
            self.fetchAppointmentByDoctor(doctorName: doctorName)
            
        }
        
    }
    
    @IBAction func logout(_ sender: UIButton) {
        do{
            try Auth.auth().signOut()
            performSegue(withIdentifier: "logOutDoctor", sender: self)
        }
        catch let logout{
            print(logout)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appointments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
    
        
        //get user name by uid from firebase
        let label1 = cell?.viewWithTag(1) as! UILabel
        let uid = appointments[indexPath.row].Uid
        ref.child("User/\(uid!)").observeSingleEvent(of: .value) { (snapshot) in
            guard let value = snapshot.value as? [String: Any] else{return}
            let firstName = value["firstName"] as! String
            let lastName = value["lastName"] as! String
            let patientName = "\(firstName) " + "\(lastName)"
            label1.text = patientName
        }
        
        let label2 = cell?.viewWithTag(2) as! UILabel
        label2.text = appointments[indexPath.row].Time
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myIndex = indexPath.row
        //createAlert()
        let vc = storyboard?.instantiateViewController(withIdentifier: "DoctorDetailsViewController") as! DoctorDetailsViewController
        vc.aID = self.appointments[myIndex].Id
        self.present(vc, animated: true, completion: nil)
    }
    
    func createAlert(){
        let title = "Reminder"
        let message = "Are you sure to Cancel the Appointment"
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Write Note", style: UIAlertAction.Style.default) { (action) in
            alert.dismiss(animated: true, completion: nil)
        })
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) { (action) in
            alert.dismiss(animated: true, completion: nil)
            
        self.ref.child("Appointment").child(self.appointments[self.myIndex].Id).removeValue()
            self.appointments.remove(at:self.myIndex)
            self.appointmentTv.reloadData()
        })
        
        self.present(alert,animated: true, completion: nil)
    }
    
    
    func fetchAppointmentByDoctor(doctorName: String){
        self.ref?.child("Appointment").queryOrderedByKey().observe(.childAdded, with: { (snapshot) in
            guard let value = snapshot.value as? [String: Any] else{return}
            let time = value["Appointment Time"] as? String
            let id = value["Appointment ID"] as? String
            let uid = value["UserID"] as? String
            let docName = value["Doctor Name"] as? String
            
            guard let time1 = time else{return}
            guard let id1 = id else{return}
            guard let uid1 = uid else{return}
            guard let doctorName1 = docName else{return}
            
            if doctorName1 == doctorName{
                self.appointments.append(appointmentStruct(Uid: uid1, Id: id1, Time: time1))
                self.appointmentTv.reloadData()
            }
        })
    }
}

    



