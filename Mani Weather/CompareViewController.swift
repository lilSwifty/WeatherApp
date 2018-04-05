//
//  CompareViewController.swift
//  Mani Weather
//
//  Created by Mani Sedighi on 2018-04-05.
//  Copyright © 2018 Mani Sedighi. All rights reserved.
//

import UIKit
import GraphKit

class CompareViewController: UIViewController, GKBarGraphDataSource, UIPickerViewDelegate, 
UIPickerViewDataSource {
    
    

    
    @IBOutlet weak var leftGraph: GKBarGraph!
    @IBOutlet weak var rightGraph: GKBarGraph!
    @IBOutlet weak var leftPicker: UIPickerView!
    @IBOutlet weak var rightPicker: UIPickerView!
    @IBOutlet weak var compareButton: UIButton!
    
    let defaults = UserDefaults.standard
    let key = "FavoriteCities"
    
    var loadedCities : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadedCities = defaults.stringArray(forKey: key) ?? [String]()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        leftPicker.dataSource = self
        leftPicker.delegate = self
        rightPicker.dataSource = self
        rightPicker.delegate = self
        
        leftGraph.dataSource = self
        rightGraph.dataSource = self
        
        leftGraph.draw()
        rightGraph.draw()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfBars() -> Int {
        return 3
    }
    
    func valueForBar(at index: Int) -> NSNumber! {
        //gör en webrequest ?
        return index * 10 as NSNumber
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return loadedCities.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return loadedCities[row]
    }
    
    func titleForBar(at index: Int) -> String! {
        return "\(index)"
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
