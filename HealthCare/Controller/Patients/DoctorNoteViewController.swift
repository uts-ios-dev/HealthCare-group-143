//
//  DoctorNoteViewController.swift
//  HealthCare
//
//  Created by user154004 on 5/31/19.
//  Copyright © 2019 Pramish Luitel. All rights reserved.
//

import UIKit
import Firebase

class DoctorNoteViewController: UIViewController , UIPickerViewDataSource, UIPickerViewDelegate {
    var historyReference:DatabaseReference!
    var appointmentReference:DatabaseReference!
    var userID:String = ""
    var appointmentsList:[Appointments?] = []
    var historyList:[History?] = []
    var pickerList = [""]

    @IBOutlet weak var lastHistoryLabel: UILabel!
    @IBOutlet weak var appointmentListPicker: UIPickerView!
    @IBOutlet weak var historyTextView: UITextView!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var medicationTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appointmentListPicker.dataSource = self
        appointmentListPicker.delegate = self
        
        userID = Auth.auth().currentUser!.uid
        historyReference = Database.database().reference().child("History")
        appointmentReference = Database.database().reference().child("Appointment History").child(userID)
        getAppointments()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String {
        let appointment = appointmentsList[row]
        return appointment!.DoctorName+" "+appointment!.Time
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return appointmentsList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let appointment = appointmentsList[row]
        lastHistoryLabel.text = appointment!.DoctorName+" "+appointment!.Time
        if(lastHistoryLabel.text != ""){
            getHistory(aID: appointment!.Id)
        }
    }
    
    func getAppointments(){
        appointmentReference?.observe(.value, with: { snapshot in
            print(snapshot.value as Any)
            for child in (snapshot.children.allObjects as? [DataSnapshot])!{
                if let value = child.value as? [String:Any],
                    let uid = value["User ID"] as? String,
                    let time = value["Time"] as? String,
                    let doctorName = value["Doctor name"] as? String{
                    
                    let appointment = Appointments(Uid: uid, Id: child.key, Time: time, DoctorName: doctorName)
                    self.appointmentsList.append(appointment)
                }
            }
            if(self.appointmentsList.count>0){
                for appointment in self.appointmentsList{
                    self.pickerList.append(appointment!.DoctorName + " " + appointment!.Time)
                    self.appointmentListPicker.reloadAllComponents()
                }
            }
            
            }
        )
    }
    
    func getHistory(aID:String){
        historyReference?.observe(.value, with: {snapshot in
            print(snapshot.value as? Any)
            for child in (snapshot.children.allObjects as? [DataSnapshot])!{
                if let value = child.value as? [String:Any],
                    let appointmentID = value["appointmentID"] as? String,
                    let date = value["date"] as? String,
                    let time = value["time"] as? String,
                    let history = value["history"] as? String,
                    let message = value["message"] as? String,
                    let medication = value["medication"] as? String,
                    let uid = value["userID"] as? String{
                    let history = History(userID: uid, history: history, message: message, medication: medication, date: date, time: time, appointmentID: appointmentID)
                    if(history.appointmentID == aID){
                            self.historyTextView.text = history.history
                            self.messageTextView.text = history.message
                            self.medicationTextView.text = history.medication
                    }
                    else{
                        self.historyTextView.text = "The history are not available yet"
                        self.messageTextView.text = "The message are not available yet"
                        self.medicationTextView.text = "The medication are not available yet"
                    }
                }
            }
        })
    }
    

}
