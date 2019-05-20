import UIKit
import Firebase

struct appointmentStruct {
    let Uid : String!
    let Id : String!
    let Time : String!
}

class DoctorHomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var appointmentTv: UITableView!
    var ref: DatabaseReference!
    var appointments = [appointmentStruct]()
    var myIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationItem.title = "Update Schedules"
        appointmentTv.dataSource = self
        appointmentTv.delegate = self
        
        ref = Database.database().reference()
        ref?.child("Appointment").queryOrderedByKey().observe(.childAdded, with: { (snapshot) in
            guard let value = snapshot.value as? [String: Any] else{return}
            let time = value["Appointment Time"] as? String
             let id = value["id"] as? String
            let uid = value["UserID"] as? String
            
            guard let time1 = time else{return}
            guard let id1 = id else{return}
            guard let uid1 = uid else{return}
            
            self.appointments.append(appointmentStruct(Uid: uid1, Id: id1, Time: time1))
            self.appointmentTv.reloadData()
        }) {(error) in
            print(error.localizedDescription)
        }
        
    }
    
    @IBAction func logout(_ sender: UIButton) {
        performSegue(withIdentifier: "logOutDoctor", sender: self)
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
            let patientName = "\(lastName) " + "\(firstName)"
            label1.text = patientName
        }
        
        let label2 = cell?.viewWithTag(2) as! UILabel
        label2.text = appointments[indexPath.row].Time
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
            
            self.ref.child("Appointment").child(self.appointments[self.myIndex].Id).removeValue()
            self.appointments.remove(at:self.myIndex)
            self.appointmentTv.reloadData()
        })
        
        self.present(alert,animated: true, completion: nil)
    }
}


    

    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let vc = segue.destination as! DoctorAppointmentsViewController
//        vc.appointment = appointments[myIndex]
//    }
    
    // get Patient Name By Uid
    //    func getPatientName(uid: String) -> String{
    //        var patientName = ""
    //        ref = Database.database().reference()
    //        ref.child("User/\(uid)").observeSingleEvent(of: .value) { (snapshot) in
    //            guard let value = snapshot.value as? [String: Any] else{return}
    //            let firstName = value["firstName"] as! String
    //            let lastName = value["lastName"] as! String
    //            patientName = "\(lastName) " + "\(firstName)"
    //        }
    //
    //        return patientName
    //    }
    



