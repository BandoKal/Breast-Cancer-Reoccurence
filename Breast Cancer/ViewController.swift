//
//  ViewController.swift
//  Breast Cancer
//
//  Created by CORPSRVMCOEDEVOPSBLD on 6/18/18.
//  Copyright © 2018 HCA. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    // Age
    @IBOutlet weak var ageValue: UIButton!
    @IBOutlet weak var agePicker: UIPickerView!
    var ageSource: PickerDelegate!
    
    //Menopause
    @IBOutlet weak var menopauseSegment: UISegmentedControl!
    
    //Tumor
    @IBOutlet weak var tumorValue: UIButton!
    @IBOutlet weak var tumorPickerview: UIPickerView!
    var tumorSource: PickerDelegate!
    
    //INV
    @IBOutlet weak var invValue: UIButton!
    @IBOutlet weak var invPickerview: UIPickerView!
    var invSource: PickerDelegate!
    
    //Others
    @IBOutlet weak var nodeCapSegment: UISegmentedControl!
    @IBOutlet weak var maligSegment: UISegmentedControl!
    @IBOutlet weak var breastSegement: UISegmentedControl!
    @IBOutlet weak var irradiateSegment: UISegmentedControl!

    //quad
    @IBOutlet weak var quadValue: UIButton!
    @IBOutlet weak var quadPickerview: UIPickerView!
    var quadSource: PickerDelegate!
    
    @IBOutlet weak var resultTextView: UITextView!
    
    
    let model = BreastCancer()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialState()
        predict(self)
    }


    @IBAction func togglePicker(_ sender: UIButton) {
        switch sender {
        case ageValue:
            agePicker.isHidden = !agePicker.isHidden
        case tumorValue:
            tumorPickerview.isHidden = !tumorPickerview.isHidden
        case invValue:
            invPickerview.isHidden = !invPickerview.isHidden
        case quadValue:
            quadPickerview.isHidden = !quadPickerview.isHidden
        default:
            fatalError()
        }
        
    }
    
    func hideAllPickers() {
        agePicker.isHidden = true
        tumorPickerview.isHidden = true
        invPickerview.isHidden = true
        quadPickerview.isHidden = true
    }
    
    @IBAction func predict(_ sender: Any) {
        guard let age = ageValue.title(for: .normal),
            let meno = menopauseSegment.titleForSegment(at: menopauseSegment.selectedSegmentIndex),
            let tumor = tumorValue.title(for: .normal),
            let inv = invValue.title(for: .normal),
            let node = nodeCapSegment.titleForSegment(at: nodeCapSegment.selectedSegmentIndex),
            let breast = breastSegement.titleForSegment(at: breastSegement.selectedSegmentIndex),
            let quad = quadValue.title(for: .normal),
            let irradiate = irradiateSegment.titleForSegment(at: irradiateSegment.selectedSegmentIndex),
            let output = try? model.prediction(age: age,
                                               menopause: meno,
                                               tumor_size: tumor,
                                               inv_nodes: inv,
                                               node_caps: node,
                                               deg_malig: Double( maligSegment.selectedSegmentIndex + 1),
                                               breast: breast,
                                               breast_quad: quad,
                                               irradiate: irradiate) else { return }
        
        resultTextView.text = "\((output.recurrence * 100.0).rounded())%"
    }
    
}

private extension ViewController {
    func setupInitialState() {
        ageSource = PickerDelegate(sourceVC: self,
                                   button: ageValue,
                                   data: ["10-19", "20-29", "30-39", "40-49", "50-59", "60-69", "70-79", "80-89", "90-99"])
        agePicker.dataSource = ageSource
        agePicker.delegate = ageSource
        
        tumorSource = PickerDelegate(sourceVC: self,
                                     button: tumorValue,
                                     data: ["0-4", "5-9", "10-14", "15-19", "20-24", "25-29", "30-34", "35-39", "40-44", "45-49", "50-54", "55-59"])
        tumorPickerview.dataSource = tumorSource
        tumorPickerview.delegate = tumorSource
        
        invSource = PickerDelegate(sourceVC: self,
                                   button: invValue,
                                   data: ["0-2", "3-5", "6-8", "9-11", "12-14", "15-17", "18-20", "21-23", "24-26", "27-29", "30-32", "33-35", "36-39"])
        invPickerview.dataSource = invSource
        invPickerview.delegate = invSource
        
        quadSource = PickerDelegate(sourceVC: self,
                                    button: quadValue,
                                    data: [ "left-up", "left-low", "right-up", "right-low", "central"])
        quadPickerview.dataSource = quadSource
        quadPickerview.delegate = quadSource
    }
}

class PickerDelegate : NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
    weak var source: ViewController?
    weak var outPutButton: UIButton?
    var dataSource: [String]
    
    init(sourceVC: ViewController, button: UIButton, data: [String]) {
        dataSource = data
        super.init()
        source = sourceVC
        outPutButton = button
        outPutButton?.setTitle(dataSource[0], for: .normal)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSource.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataSource[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        outPutButton?.setTitle(dataSource[row], for: .normal)
        source?.predict(pickerView)
    }
}
