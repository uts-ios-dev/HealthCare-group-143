import UIKit
import FirebaseDatabase
import Firebase

class HomeViewController: UIViewController{
    
    let appointmentData = Database.database().reference()
    var appointment = [String]()
    var appointmentHandle:DatabaseHandle?
    var patient:DatabaseHandle?
    @IBOutlet weak var patientName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Dashboard"
        self.navigationItem.hidesBackButton = true
        getAppointment()
        let user = Auth.auth().currentUser
        if let user = user{
            patientName.text = "\(user.email!)"
        }
    }
    
    func getAppointment(){
        appointmentHandle =  appointmentData.child("User").child((Auth.auth().currentUser?.uid)!).child("AppointmentsDetails").observe(.childAdded) { (snapshot) in
            let appointment = snapshot.value as? String
            if let actualAppointment = appointment{
                    self.appointment.append(actualAppointment)
//                    print(actualAppointment)
            }
            
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
        getAppointment()
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
    
}
