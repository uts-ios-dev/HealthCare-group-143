import UIKit
import Firebase

class DoctorAppointmentsViewController: UIViewController {
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        ref.child("Appointment/-LfFNOYoW-TRajhBWF3q").observeSingleEvent(of: .value) { (snapshot) in
            guard let value = snapshot.value as? [String: Any] else{return}
            let time = value["Appointment Time"] as! String
            print(time)
        }
        
    }
    @IBAction func TappedCancelBtn(_ sender: Any) {
        
        // ref.child("Appointment").child(appointment.Id).removeValue()
        
    }
    
}


