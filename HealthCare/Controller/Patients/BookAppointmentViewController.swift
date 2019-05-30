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
    @IBOutlet weak var patientsName: UILabel!
    @IBOutlet weak var patientName: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
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
        appointmentUser.child(userID).observeSingleEvent(of: .value) { (snapshot) in
            guard let value = snapshot.value as? [String:Any] else{return}
            let firstName = value["firstName"] as! String
            let lastName = value["lastName"] as! String
            let patientName =  "\(firstName) " + "\(lastName)"
            self.patient = patientName
            self.patientsName.text = "G'day \(self.patient)"
        }
    }
    @IBAction func cancelAppointment(_ sender: UIButton) {
        performSegue(withIdentifier: "bookAppointment", sender: self)
    }
    
    func userAppointment(){

    self.appointmentUser.child(userID).child("Appointments").child(key).child("DoctorName").setValue(doctorName.text)
    self.appointmentUser.child(userID).child("Appointments").child(key).child("Time").setValue(patientName.text)
        self.appointmentUser.child(userID).child("Appointments").child(key).child("Appointment ID").setValue(key) 
    }
    func addAppointment(){

        let appointments = ["Appointment Time":patientName.text!,"Doctor Name":doctorName.text,"UserID":userID,"Appointment ID":key]

        appointment.child(key!).setValue(appointments)

    }
    
    func appointmentsHistory(){
        self.appointmentHistory.child(userID).child(key).child("Doctor name").setValue(doctorName.text)
        self.appointmentHistory.child(userID).child(key).child("Time").setValue(patientName.text)
        self.appointmentHistory.child(userID).child(key).child("User ID").setValue(userID)
    }
    
    @IBAction func bookAppointment(_ sender: UIButton) {
        addAppointment()
        userAppointment()
        appointmentsHistory()
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
    
    //Pick the date for the appointment
    @IBAction func applintmentDatePicker(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.short
        let appDate = dateFormatter.string(from: datePicker.date)
        patientName.text = appDate
    }
    
}
