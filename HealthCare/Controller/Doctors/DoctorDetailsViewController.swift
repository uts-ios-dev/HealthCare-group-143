//
//  DoctorDetailsViewController.swift
//  HealthCare
//
//  Created by user154004 on 5/28/19.
//  Copyright © 2019 Pramish Luitel. All rights reserved.
//

import UIKit
import Firebase

class DoctorDetailsViewController: UIViewController {
    @IBOutlet weak var historyTextView: UITextView!
    @IBOutlet weak var doctorNameLabel: UILabel!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var medicationTextView: UITextView!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var appointmentIDLabel: UILabel!
    var aID = ""
    var appointmentReference: DatabaseReference!
    var historyReference:DatabaseReference!
    var appointments = [Appointment]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appointmentIDLabel.text = aID
        appointmentReference = Database.database().reference().child("Appointment")
        historyReference = Database.database().reference().child("History")
        
        
        self.hideKeyboard()
        setTextView()
            }
    
    func setTextView(){
        historyTextView.isEditable = true
        messageTextView.isEditable = true
        medicationTextView.isEditable = true
    }
    
    func uploadHistory(){
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "dd-MM-yyyy"
        let formattedDate = format.string(from: date)
        let time = Date()
        let timeFormat = DateFormatter()
        timeFormat.dateFormat = "HH:mm"
        let formattedTime = format.string(from: time)
        
        let userID = Auth.auth().currentUser?.uid
        
        let history = ["userID": userID, "history": historyTextView.text!, "message": messageTextView.text!, "medication": medicationTextView.text!, "date": formattedDate, "time": formattedTime, "appointmentID": aID]
        historyReference.child(aID).setValue(history)
    }

    @IBAction func submitBtn(_ sender: UIButton) {
        uploadHistory()
        
    }
    @IBAction func closeBtn(_ sender: UIButton) {
        performSegueToReturnBack()
    }
}


extension UIViewController {
    func performSegueToReturnBack()  {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
