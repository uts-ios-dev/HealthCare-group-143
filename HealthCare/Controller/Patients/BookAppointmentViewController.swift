import UIKit
import Firebase
import FirebaseDatabase

class BookAppointmentViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    
    
    var appointmentUser:DatabaseReference!
    var appointment:DatabaseReference!
    var appointmentHistory:DatabaseReference!
    
    var doctors:[String] = ["Atif Gill","Sharad Ghimire","Rohit Gurung"]
    @IBOutlet weak var doctorPicker: UIPickerView!
    @IBOutlet weak var doctorName: UILabel!
    @IBOutlet weak var datePickered: UIDatePicker!
    @IBOutlet weak var datePicked: UILabel!
    @IBOutlet weak var patientsName: UILabel!
    var patient:String = ""
    var doctorname:String = ""
    var appointTime:String = ""
    var userID:String = ""
    var key:String! = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Book Appointment"
        appointmentUser = Database.database().reference().child("User")
        appointment = Database.database().reference().child("Appointment")
        appointmentHistory = Database.database().reference().child("Appointment History")
        key = appointment.childByAutoId().key
        userID = (Auth.auth().currentUser?.uid)!
        let user = Auth.auth().currentUser
        if let user = user{
            patientsName.text = "\(user.email!)"
            patient = patientsName.text!
        }
    }
    
    @IBAction func cancelAppointment(_ sender: UIButton) {
        performSegue(withIdentifier: "bookAppointment", sender: self)
    }
    
    func userAppointment(){
        // This will add on the user database
//        let userID = (Auth.auth().currentUser?.uid)!
    self.appointmentUser.child(userID).child("AppointmentsDetails").child("DoctorName").setValue(doctorName.text)
    self.appointmentUser.child(userID).child("AppointmentsDetails").child("Time").setValue(datePicked.text)
    }
    func addAppointment(){
        // This will add to the appointment database
        
        
//        let userID = (Auth.auth().currentUser?.uid)!
        let appointments = ["Appointment Time":datePicked.text,"Doctor Name":doctorName.text,"UserID: ":userID]
//        appointment.child(key!).setValue(appointments)
        appointment.child(key!).setValue(appointments)
//        userAppointment()
//        addToHistory()
    }
    
    func addToHistory(){
//        let userID = (Auth.auth().currentUser?.uid)!
        self.appointmentHistory.child(userID).child("Appointments").child(key).child("User Email").setValue(patient)
        self.appointmentHistory.child(userID).child("Appointments").child(key).child("Appointment Time").setValue(datePicked.text)
        self.appointmentHistory.child(userID).child("Appointments").child(key).child("Doctor Name").setValue(doctorName.text)
//        self.appointmentHistory.child(userID).child("Status:").setValue("Appointed")// This value must depemd upon the user interaction with the appointment. (Appointed, Cancelled or Deleted)
    }
    @IBAction func datePicker(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.short
        let dateString = dateFormatter.string(from: datePickered.date)
        datePicked.text = dateString
        
    }
    
    @IBAction func bookAppointment(_ sender: UIButton) {
        addAppointment()
        userAppointment()
        addToHistory()
        performSegue(withIdentifier: "bookAppointment", sender: self)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return doctors.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        doctorName.text = doctors[row]
        return doctors[row]
    }
    
}
