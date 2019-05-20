import UIKit
import FirebaseDatabase
import Firebase

class HomeViewController: UIViewController{
    
    
    var appointment = [String]()
    var appointmentHandle:DatabaseHandle?
    var patient:DatabaseHandle?
    var uid:String = ""
    
    var userReference:DatabaseReference!
    @IBOutlet weak var patientName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Dashboard"
        self.navigationItem.hidesBackButton = true
        checkLoggedUser()
        
        let userID = (Auth.auth().currentUser?.uid)!
        userReference = Database.database().reference().child("User").child(userID)
        getAppointment()
        getProfile()
        let user = Auth.auth().currentUser
        if let user = user{
            patientName.text = "\(user.email!)"
        }
    }
    func checkLoggedUser(){
        if Auth.auth().currentUser?.uid == nil{
            //go to login page
        }
        else{
            //get profile to identify whether doctor or user
//            getProfile()
            if(UserDefaults.standard.string(forKey: "role") != nil){
                let roleString = UserDefaults.standard.string(forKey: "role")
                if(roleString == "doctor"){
                    
                    //Go to doctor view
                    print("I am a doctor")
                    let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DoctorView") as UIViewController
                    // .instantiatViewControllerWithIdentifier() returns AnyObject! this must be downcast to utilize it
                    
                    self.present(viewController, animated: false, completion: nil)
                }
                else{
                    //Stay on this view.
                    print("I am a user")
                }
            }
        }
    }
    
    
    func getProfile(){
        var userProfile:User?
        
        
        
        userReference?.observe(.value, with: { snapshot in
            
            print(snapshot.value as Any)
            //            print((snapshot.childSnapshot(forPath: "email").value)!) // I was testing here - By Pramish
            if let dict = snapshot.value as? [String:Any],
                let uid = dict["uid"] as? String,
                let firstName = dict["firstName"] as? String,
                let lastName = dict["lastName"] as? String,
                let dateOfBirth = dict["dateOfBirth"] as? String,
                let gender = dict["gender"] as? String,
                let address = dict["address"] as? String,
                let phone = dict["phone"] as? String,
                let email = dict["email"] as? String,
                let role = dict["role"] as? String
            {
                
                userProfile = User(uid: snapshot.key, firstName: firstName, lastName: lastName, dateOfBirth: dateOfBirth, gender: gender, address: address, phone: phone, email: email,role:role)
                print(userProfile as Any)
                if(userProfile != nil){
                    if(userProfile?.role == "doctor"){
                        UserDefaults.standard.set("Doctor", forKey: "role")
                        //Go to doctor view
                        print("I am a doctor")
                        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DoctorView") as UIViewController
                        // .instantiatViewControllerWithIdentifier() returns AnyObject! this must be downcast to utilize it
                        
                        self.present(viewController, animated: false, completion: nil)
                    }
                    else{
                        //Stay on this view.
                        print("I am a user")
                    }
                    
//                    print(self.roleString)
                }
                
            }
        })
        
        
    }
    
    
    
  
    
    func getAppointment(){
        let appointmentData = Database.database().reference()
        appointmentHandle =  appointmentData.child("User").child((Auth.auth().currentUser?.uid)!).child("AppointmentsDetails").observe(.childAdded) { (snapshot) in
            let appointment = snapshot.value as? String
            if let actualAppointment = appointment{
                    self.appointment.append(actualAppointment)
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
