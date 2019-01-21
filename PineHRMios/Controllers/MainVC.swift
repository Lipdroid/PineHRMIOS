//
//  MainVCViewController.swift
//  PineHRMios
//
//  Created by Md Munir Hossain on 1/21/19.
//  Copyright © 2019 Md Munir Hossain. All rights reserved.
//

import UIKit
import Alamofire
import SwiftKeychainWrapper

class MainVC: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    @IBOutlet weak var left_nav_btn_view: UIView!
    @IBOutlet weak var left_nav_menu: UIView!
    var left_nav_view_isShown = false
    @IBOutlet weak var left_nav_leading_constraint: NSLayoutConstraint!
    @IBOutlet weak var tranparent_overlay: UIVisualEffectView!
    @IBOutlet weak var collectionView: UICollectionView!
    var items = [ItemObject]()
    @IBOutlet weak var name_lbl: UILabel!
    @IBOutlet weak var email_lbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        if let accesstoken = KeychainWrapper.standard.string(forKey: Constants.KEY_TOKEN){
            //validate access token
            validateToken(token: accesstoken)
        }
        
        if let name = KeychainWrapper.standard.string(forKey: Constants.KEY_NAME){
            name_lbl.text = name
        }
        
        if let email = KeychainWrapper.standard.string(forKey: Constants.KEY_EMAIL){
            email_lbl.text = email
        }
        
        parseItems()
    }
    
    private func parseItems(){
        items.append(ItemObject(name: "Attendance", icon: "icon_attendence",url:"https://www.pinehrm.com/cna/client/employee/attendance/accesstoken/"))
        items.append(ItemObject(name: "PaySlip", icon: "icon_payslip",url:"https://www.pinehrm.com/cna/client/employee/index/accesstoken/"))
        items.append(ItemObject(name: "Leave", icon: "icon_leave",url:"https://www.pinehrm.com/cna/client/employee/leave/accesstoken/"))
        items.append(ItemObject(name: "Investment Scheme", icon: "icon_investment",url:"https://www.pinehrm.com/cna/client/employee/invSch/accesstoken/"))
        items.append(ItemObject(name: "Documents", icon: "icon_document",url:"https://www.pinehrm.com/cna/client/employee/document/accesstoken/"))
        items.append(ItemObject(name: "Outpatient", icon: "icon_outpatient",url:"https://www.pinehrm.com/cna/client/employee/outPatient/accesstoken/"))
        items.append(ItemObject(name: "Salary Card", icon: "icon_card",url:"https://www.pinehrm.com/cna/client/employee/salaryCard/accesstoken/"))
        items.append(ItemObject(name: "Tax", icon: "icon_tax",url:"https://www.pinehrm.com/cna/client/employee/taxslip/accesstoken/"))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func nav_left_icon_pressed(_ sender: Any) {
        toggleLeftMenu()
    }
    @IBAction func logout_pressed(_ sender: Any) {
        toggleLeftMenu()
        logout()
    }
    @IBAction func profile_pressed(_ sender: Any) {
        toggleLeftMenu()
        let item = ItemObject(name: "Profile", icon: "icon_tax",url:"https://www.pinehrm.com/cna/client/employee/profile/accesstoken/   ")
        performSegue(withIdentifier: "itemDetails", sender: item)
    }
    @IBAction func transparent_view_touched(_ sender: Any) {
        //depending on whicn view is open it will toggle
        if(left_nav_view_isShown){
            toggleLeftMenu()
        }
    }
    
    private func toggleLeftMenu(){
        if !left_nav_view_isShown{
            left_nav_leading_constraint.constant = 0
            left_nav_menu.layer.shadowOpacity = 1
            left_nav_menu.layer.shadowRadius = 6.0
            tranparent_overlay.isHidden = false
            left_nav_btn_view.isHidden = true
            
        }else{
            left_nav_leading_constraint.constant = -280
            
        }
        
        UIView.animate(withDuration: 0.4, animations: {
            self.view.layoutIfNeeded()
            
        }){(true) in
            if !self.left_nav_view_isShown{
                self.left_nav_menu.layer.shadowOpacity = 0
                self.tranparent_overlay.isHidden = true
                self.left_nav_btn_view.isHidden = false
            }else{
                self.left_nav_btn_view.isHidden = true
                
            }
            
        }
        
        left_nav_view_isShown = !left_nav_view_isShown
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.MAINVC_TO_DETAILS{
            if let detailsVC = segue.destination as? ItemDetailsVC{
                if let item = sender as? ItemObject{
                    detailsVC.item = item
                }
            }
        }
    }
    
    func validateToken(token: String) {
        let parameters: Parameters = ["accesstoken": token]
        print(Constants.validate_token_url)
        Alamofire.request(Constants.validate_token_url, method: .post, parameters: parameters)
            .responseString { response in
                print("String:\(response.result.value)")
                switch(response.result) {
                case .success(_):
                    if let data = response.result.value{
                        print(data)
                        do{
                            if let json = data.data(using: String.Encoding.utf8){
                                if let jsonData = try JSONSerialization.jsonObject(with: json, options: .allowFragments) as? [String:AnyObject]{
                                    
                                    let token_validate = jsonData["token_validate"] as! Bool
                                    if !token_validate {
                                        //log out
                                        self.logout()
                                    }
                                }
                            }
                        }catch {
                            print(error.localizedDescription)
                            
                        }
                    }
                    
                case .failure(_):
                    print("Error message:\(response.result.error)")
                    break
                }
        }
        
    }
    
    func logout(){
        //clear keychain
        KeychainWrapper.standard.removeObject(forKey: Constants.KEY_TOKEN)
        KeychainWrapper.standard.removeObject(forKey: Constants.KEY_NAME)
        KeychainWrapper.standard.removeObject(forKey: Constants.KEY_EMAIL)
        //go to login page
        go_to_login_page()
    }
    func go_to_login_page(){
        //
        performSegue(withIdentifier: Constants.MAINVC_TO_LOGINVIEW, sender: nil)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCell", for: indexPath) as? ItemCell{
            let item = items[indexPath.row]
            cell.configureCell(item)
            return cell;
        }else{
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        performSegue(withIdentifier: "itemDetails", sender: item)
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat =  20
        let collectionViewSize = collectionView.frame.size.width - padding
        
        return CGSize(width: collectionViewSize/2, height: collectionViewSize/2)
    }
}
