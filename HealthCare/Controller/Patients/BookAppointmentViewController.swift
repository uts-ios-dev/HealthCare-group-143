import UIKit
import Firebase
import FirebaseDatabase

class BookAppointmentViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    
    
    var appointmentUser:DatabaseReference!
    var appointment:DatabaseReference!
    var appointmentHistory:DatabaseReference!
    
    var doctors:[String] = ["Atif Gill","Sharad Ghimire","Rohit Gurung","Hadrian Lee"]
    @IBOutlet weak var doctorPicker: UIPickerView!
    @IBOutlet weak var doctorName: UILabel!
    @IBOutlet weak var patientsName: UILabel!
    @IBOutlet weak var datePic: UITextField!
    private var mydatePicked:UIDatePicker?
    
    var patient:String = ""
    var doctorname:String = ""
    var appointTime:String = ""
    var userID:String = ""
    var key:String! = ""
    
    override func viewDidLoad() {
        mydatePicked = UIDatePicker()
        mydatePicked?.datePickerMode = .dateAndTime
        datePic.inputView = mydatePicked
        
        //This is to pick a date and time for the appointment
        mydatePicked?.addTarget(self, action: #selector(BookAppointmentViewController.dateChanged(mydatePicked:)), for: .valueChanged)
        //This is for when you tap outside screen, then your date picker will disappear.
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(BookAppointmentViewController.viewTap(gesture:)))
        view.addGestureRecognizer(tapGesture)
        
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
    @objc func dateChanged(mydatePicked:UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.short
        let currentDate = NSDate()
        mydatePicked.minimumDate = currentDate as Date
        mydatePicked.date = currentDate as Date
        datePic.text = dateFormatter.string(from: mydatePicked.date)
    }
    
    @objc func viewTap(gesture:UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    @IBAction func cancelAppointment(_ sender: UIButton) {
        performSegue(withIdentifier: "bookAppointment", sender: self)
    }
    
    func userAppointment(){

    self.appointmentUser.child(userID).child("Appointments").child(key).child("DoctorName").setValue(doctorName.text)
    self.appointmentUser.child(userID).child("Appointments").child(key).child("Time").setValue(datePic.text)
        self.appointmentUser.child(userID).child("Appointments").child(key).child("Appointment ID").setValue(key) 
    }
    func addAppointment(){

        let appointments = ["Appointment Time":datePic.text!,"Doctor Name":doctorName.text,"UserID":userID,"Appointment ID":key]

        appointment.child(key!).setValue(appointments)

    }
    
    func appointmentsHistory(){
        self.appointmentHistory.child(userID).child(key).child("Doctor name").setValue(doctorName.text)
        self.appointmentHistory.child(userID).child(key).child("Time").setValue(datePic.text)
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
    
}
