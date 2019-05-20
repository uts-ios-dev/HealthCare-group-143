import UIKit
import Firebase

class CancelAppointmentViewController: UIViewController {

    @IBOutlet weak var patientsName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Cancel Appointments"
        let user = Auth.auth().currentUser
        if let user = user{
            patientsName.text = "\(user.email!)"
        }}
    
    @IBAction func cancelAppointment(_ sender: UIButton) {
        performSegue(withIdentifier: "cancelAppointment", sender: self)
    }
    
    
    
    }
