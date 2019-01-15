//
//  ViewController.swift
//  ISRE-FinalProject
//
//  Created by 41 on 2018/12/12.
//  Copyright © 2018 41. All rights reserved.
//

import UIKit
import CoreLocation
import CoreBluetooth
import UserNotifications

class TableViewCellViewController: UITableViewCell {
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var from: UILabel!
    @IBOutlet weak var to: UILabel!
    @IBOutlet weak var cost: UILabel!
    @IBOutlet weak var arrowhead: UILabel!
    @IBOutlet weak var moneyicon: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

class ViewController: UIViewController, CLLocationManagerDelegate, CBCentralManagerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var date = [""]
    var from = [""]
    var to = [""]
    var cost = [""]
    var arrowhead = [""]
    var moneyicon = [""]
    var datetime_in = [""]
    var datetime_out = [""]
    
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var money: UILabel!
    @IBOutlet weak var add: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var logout: UIButton!
    var LM = CLLocationManager()
    
    var can_noti:Bool = false // false = have not notified, true = already notified
    var can_charge:Bool = true // false = charged, true = not charge
    var user_location:Bool = false // false = outside, true = inside
    var cnt:Int = 30
    var from_minor:Int = 0
    
    var myUserDefaults :UserDefaults!
    
    let uuid = UUID(uuidString: "8D15122D-C561-43BB-A123-59A118506D44")
    //let uuid = UUID(uuidString: "D9F08C92-6C39-486F-A245-D65D36695AF3")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        /** logo **/
        logo.image = UIImage(named: "coin.png")

        /** Sync Data **/
        myUserDefaults = UserDefaults.standard
        //removeData()
        if let local_RestMoney = myUserDefaults.object(forKey: "rest_money") as? String {
            money.text = local_RestMoney
        } else {
            money.text = "60"
        }
        if let local_UserLocation = myUserDefaults.object(forKey: "user_location") as? Bool {
            user_location = local_UserLocation
        } else {
            user_location = false
        }
        if let local_date = myUserDefaults.object(forKey: "date") as? [String] {
            date = local_date
        } else {
            date = [""]
        }
        if let local_from = myUserDefaults.object(forKey: "from") as? [String] {
            from = local_from
        } else {
            from = [""]
        }
        if let local_to = myUserDefaults.object(forKey: "to") as? [String] {
            to = local_to
        } else {
            to = [""]
        }
        if let local_cost = myUserDefaults.object(forKey: "cost") as? [String] {
            cost = local_cost
        } else {
            cost = [""]
        }
        if let local_arrowhead = myUserDefaults.object(forKey: "arrowhead") as? [String] {
            arrowhead = local_arrowhead
        } else {
            arrowhead = [""]
        }
        if let local_moneyicon = myUserDefaults.object(forKey: "moneyicon") as? [String] {
            moneyicon = local_moneyicon
        } else {
            moneyicon = [""]
        }
        if let local_datetime_in = myUserDefaults.object(forKey: "datetime_in") as? [String] {
            datetime_in = local_datetime_in
        } else {
            datetime_in = [""]
        }
        if let local_datetime_out = myUserDefaults.object(forKey: "datetime_out") as? [String] {
            datetime_out = local_datetime_out
        } else {
            datetime_out = [""]
        }


        /** button style setting **/
        logout.layer.cornerRadius = 5
        logout.layer.borderColor = UIColor.orange.cgColor
        logout.layer.borderWidth = 2

        add.layer.cornerRadius = 5
        add.layer.borderColor = UIColor.blue.cgColor
        add.layer.borderWidth = 2

        /** location **/
        LM.requestAlwaysAuthorization()
        LM.delegate = self

        let region = CLBeaconRegion(proximityUUID: uuid!, identifier: "Finding")

        LM.startMonitoring(for: region)
    }
    
    /** user defaults functions **/
    func updateData() {
        myUserDefaults.set(money.text, forKey: "rest_money")
        myUserDefaults.synchronize()
        myUserDefaults.set(user_location, forKey: "user_location")
        myUserDefaults.synchronize()
        myUserDefaults.set(date, forKey: "date")
        myUserDefaults.synchronize()
        myUserDefaults.set(from, forKey: "from")
        myUserDefaults.synchronize()
        myUserDefaults.set(to, forKey: "to")
        myUserDefaults.synchronize()
        myUserDefaults.set(cost, forKey: "cost")
        myUserDefaults.synchronize()
        myUserDefaults.set(arrowhead, forKey: "arrowhead")
        myUserDefaults.synchronize()
        myUserDefaults.set(moneyicon, forKey: "moneyicon")
        myUserDefaults.synchronize()
        myUserDefaults.set(datetime_in, forKey: "datetime_in")
        myUserDefaults.synchronize()
        myUserDefaults.set(datetime_out, forKey: "datetime_out")
        myUserDefaults.synchronize()
    }
    
    func removeData() {
        myUserDefaults.removeObject(forKey: "rest_money")
        myUserDefaults.removeObject(forKey: "user_location")
        myUserDefaults.removeObject(forKey: "date")
        myUserDefaults.removeObject(forKey: "from")
        myUserDefaults.removeObject(forKey: "to")
        myUserDefaults.removeObject(forKey: "cost")
        myUserDefaults.removeObject(forKey: "arrowhead")
        myUserDefaults.removeObject(forKey: "moneyicon")
        myUserDefaults.removeObject(forKey: "datetime_in")
        myUserDefaults.removeObject(forKey: "datetime_out")
    }
    
    /** tableView setting **/
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return to.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCellViewController
        
        if let myDate = cell.date {
            myDate.text = "\(date[indexPath.row])"
        }
        if let myFrom = cell.from {
            myFrom.text = "\(from[indexPath.row])"
        }
        if let myTo = cell.to {
            myTo.text = "\(to[indexPath.row])"
        }
        if let myCost = cell.cost {
            myCost.text = "\(cost[indexPath.row])"
        }
        if let myArrowhead = cell.arrowhead {
            myArrowhead.text = "\(arrowhead[indexPath.row])"
        }
        if let myMoneyicon = cell.moneyicon {
            myMoneyicon.text = "\(moneyicon[indexPath.row])"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if date[0] == "" {
            
        } else {
            //設定為 alert action
            let alertController = UIAlertController(title: "\(from[indexPath.row]) → \(to[indexPath.row])", message: "進站:\(datetime_in[indexPath.row])\n出站:\(datetime_out[indexPath.row])\n金額:\(cost[indexPath.row])元", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "關閉", style: .default) {
                (action) in
                self.dismiss (animated: true, completion: nil)
            }
            //增加"OK"按鍵
            alertController.addAction(okAction)
            //顯示提醒
            present(alertController, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    /** Enter CLRegion **/
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("Enter \(region.identifier)")
    }
    
    /** Exit CLRegion **/
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("Exit \(region.identifier)")
    }
    
    /** Monitoring Mode **/
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion){
        print("StartMonitoring")
        let region = CLBeaconRegion(proximityUUID: uuid!, identifier: "MyRegion")
        LM.startRangingBeacons(in: region)
    }
    
    /** didRangeBeacons **/
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        guard beacons.count > 0 else {
            print("no any beacon")
            cnt = 28
            can_noti = true
            return
        }
        for beacon in beacons {
            print("scan: \(beacon)")
        }
        let current_time = DateFormatter()
        current_time.dateFormat = "yyyy/M/d HH:mm:ss"
        let now = current_time.string(from: Date())
        let month = Calendar.current.component(.month, from: Date())
        let day = Calendar.current.component(.day, from: Date())
        cnt = cnt + 1
        print(cnt)
        
        if cnt > 30 {
            can_charge = true
        } else {
            can_charge = false
        }
        
        
        if Int(money.text!)! > 0 {
            if can_charge && Int(truncating: beacons[0].major) == 43 {  // can charge
                if user_location {  // inside
                    user_location = false
                    switch beacons[0].minor {
                        case 1:
                            moneyicon.insert("$", at:0)
                            to.insert("松山", at: 0)
                            datetime_out.insert(now, at: 0)
                            cost.insert(String(abs(Int(truncating: beacons[0].minor)-from_minor)*20), at: 0)
                            money.text = String(Int(money.text!)!-abs(1-from_minor)*20)
                            can_noti = true
                            can_charge = false
                            cnt = 0
                            Notification(to: "松山", time: "\(now)", cost: "\(String(abs(Int(truncating: beacons[0].minor)-from_minor)*20))")
                            // update data
                            updateData()
                            tableView.reloadData()
                        case 2:
                            moneyicon.insert("$", at:0)
                            to.insert("古亭", at: 0)
                            datetime_out.insert(now, at: 0)
                            cost.insert(String(abs(Int(truncating: beacons[0].minor)-from_minor)*20), at: 0)
                            money.text = String(Int(money.text!)!-abs(2-from_minor)*20)
                            can_noti = true
                            can_charge = false
                            cnt = 0
                            Notification(to: "古亭", time: "\(now)", cost: "\(String(abs(Int(truncating: beacons[0].minor)-from_minor)*20))")
                            // update data
                            updateData()
                            tableView.reloadData()
                        default:
                            moneyicon.insert("$", at:0)
                            to.insert("公館", at: 0)
                            datetime_out.insert(now, at: 0)
                            cost.insert(String(abs(Int(truncating: beacons[0].minor)-from_minor)*20), at: 0)
                            money.text = String(Int(money.text!)!-abs(3-from_minor)*20)
                            can_noti = true
                            can_charge = false
                            cnt = 0
                            Notification(to: "公館", time: "\(now)", cost: "\(String(abs(Int(truncating: beacons[0].minor)-from_minor)*20))")
                            // update data
                            updateData()
                            tableView.reloadData()
                    }
                } else {  // outside
                    user_location = true
                    cnt = 0
                    from_minor = Int(truncating: beacons[0].minor)
                    switch beacons[0].minor {
                    case 1:
                        arrowhead.insert("→", at: 0)
                        from.insert("松山", at: 0)
                        datetime_in.insert(now, at: 0)
                        date.insert("\(month)/\(day)", at: 0)
                    case 2:
                        arrowhead.insert("→", at: 0)
                        from.insert("古亭", at: 0)
                        datetime_in.insert(now, at: 0)
                        date.insert("\(month)/\(day)", at: 0)
                    default:
                        arrowhead.insert("→", at: 0)
                        from.insert("公館", at: 0)
                        datetime_in.insert(now, at: 0)
                        date.insert("\(month)/\(day)", at: 0)
                    }
                }
            } else {  // can not charge
                if user_location {  // inside
                    
                } else {  // outside
                    
                }
            }
        } else {
            if can_noti {
                can_noti = false
                add_Notification(time: now)
                let alertController = UIAlertController(title: "餘額不足", message: "請先加值您的卡片", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "關閉", style: .default) {
                    (action) in
                    self.dismiss (animated: true, completion: nil)
                }
                alertController.addAction(okAction)
                present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
    }
    
    @IBAction func add(_ sender: Any) {
        //設定 alert 的標題及訊息
        let alert = UIAlertController(title: "加值系統", message: "請輸入您想要加值的金額", preferredStyle: .alert)
        //設定"加值"按鈕
        let add = UIAlertAction(title: "加值", style: .default){
            (action) in
            let store_money = alert.textFields![0].text
            self.money.text = String(Int(store_money!)!+Int(self.money.text!)!)
            self.updateData()
        }
        //增加 TextField (金額)
        alert.addTextField {
            (textField) in
            //設定 TextField 的預設字
            textField.placeholder = "ex:300"
        }
        //新增"加值"按鈕
        alert.addAction(add)
        //顯示這個 alert
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func logout(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: "isLogin")
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func Notification(to:String, time:String, cost:String) {
        let content = UNMutableNotificationContent()
        content.title = "消費通知"
        content.subtitle = "往 \(to), $\(cost)元"
        content.body = "\(time)"
        content.badge = 1
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let requestIdentifier = "success!"
        let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: {
            error in //handle error
        })
    }
    
    func add_Notification(time:String) {
        let content = UNMutableNotificationContent()
        content.title = "加值通知"
        content.subtitle = "您的餘額不足 請先加值後再搭乘"
        content.body = "\(time)"
        content.badge = 1
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let requestIdentifier = "insufficient!"
        let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: {
            error in //handle error
        })
    }
}
