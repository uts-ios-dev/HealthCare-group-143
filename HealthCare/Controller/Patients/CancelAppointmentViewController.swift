import UIKit
import Firebase


struct appointment {
    let appointmentTime:String!
    let doctorName:String!
}

class CancelAppointmentViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
   
    

    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var patientsName: UILabel!
    var patient = ""
    var appReference:DatabaseReference = Database.database().reference().child("Appointment")
    var key:String! = ""
    var reference:DatabaseReference!
    var myAppointment = [appointment]()
    override func viewDidLoad() {
        table.dataSource = self
        table.delegate = self
         let userID = (Auth.auth().currentUser?.uid)
        reference = Database.database().reference().child("User").child(userID!).child("Appointments")
        key = appReference.childByAutoId().key
        super.viewDidLoad()
        reference.child("User").child(userID!).observeSingleEvent(of: .value) { (snapshot) in
            guard let value = snapshot.value as? [String:Any] else{return}
                let firstName = value["firstName"] as! String
                let lastName = value["lastName"] as! String
                let patientName =  "\(firstName) " + "\(lastName)"
                self.patient = patientName
                self.patientsName.text = "G'day \(self.patient)"
        }
//        appointmentUser.child(userID).observeSingleEvent(of: .value) { (snapshot) in
//            guard let value = snapshot.value as? [String:Any] else{return}
//            let firstName = value["firstName"] as! String
//            let lastName = value["lastName"] as! String
//            let patientName =  "\(firstName) " + "\(lastName)"
//            self.patient = patientName
//            self.patientsName.text = "Hello \(self.patient)"
//        }

       getData()
    }
    
    @IBAction func cancelAppointment(_ sender: UIButton) {
        performSegue(withIdentifier: "homeView", sender: self)
    }
    func getData(){
//        reference = Database.database().reference().child("User").child(userID!).child("Appointments")
            reference.queryOrderedByKey().observe(.childAdded, with: { (snapshot) in
            guard let value = snapshot.value as? [String:Any] else{return}
            let doctorName = value["DoctorName"] as? String
            let appTime = value["Time"] as? String
                guard let newDoctorName = doctorName else{return}
                guard let newAppTime = appTime else{return}
                self.myAppointment.append(appointment(appointmentTime: newAppTime, doctorName: newDoctorName))
                self.table.reloadData()
            }){
                (error) in
                print(error.localizedDescription)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myAppointment.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "hello")
        let label1 = cell?.viewWithTag(1) as! UILabel
        label1.text = myAppointment[indexPath.row].doctorName
        let label2 = cell?.viewWithTag(2) as! UILabel
        label2.text = myAppointment[indexPath.row].appointmentTime
        
        print("Yo cncel view ma ho hai")
        print("")
        print("")
        print("")
        print(myAppointment[indexPath.row].doctorName)
        print(myAppointment[indexPath.row].appointmentTime)
        
        
        
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle ==  UITableViewCell.EditingStyle.delete{
            myAppointment.remove(at: indexPath.row)
            self.table.reloadData()
            reference.child(key).removeValue()
        }
    }
    
    }
