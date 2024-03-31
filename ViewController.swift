//
//  ViewController.swift
//  SwiftAppMake
//
//  Created by uwhami on 3/18/24.
//

import UIKit    //First Party
import FSCalendar   //Third Party

class ViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate {
    
    var calendar = FSCalendar()
    var korDate: String? = nil
    var datesWithEvent = Dictionary<String, Dictionary<String,String>>()
    
    @IBOutlet weak var viewMain: UIView!
    
    @IBOutlet weak var mImgMain: UIImageView!
    
    @IBOutlet weak var mTextMain: UITextView!
    
    //1. 신규 실제로 주소 뽑아온다.
    //2. 이미 주소가 있으면 호출.
    @IBAction func onClickSave(_ sender: Any) {
        //if let 은 null이면 제외 기능 포함.(optional binding)
        if let dateStr = korDate, let txt = mTextMain.text, txt.count > 0 {
            
            
            if let dic = self.datesWithEvent[dateStr] {
                self.datesWithEvent[dateStr]!["txt"] = txt
                
                //api call
                if dic["url"] == nil || dic["url"]?.count == 0 {
                    let arrayWord = txt.components(separatedBy: " ")
                    //배열[0], [1]
                    //랜덤하게 단어를 뽑기.
                    let word = arrayWord.joined(separator: "+")
                    getImageUrl(dateStr: dateStr, word: word)
                }
                
            }
            else {
                var dic = Dictionary<String, String>()
                dic["txt"] = txt
                self.datesWithEvent[dateStr] = dic
                let arrayWord = txt.components(separatedBy: " ")
                //배열[0], [1]
                //랜덤하게 단어를 뽑기.
                let word = arrayWord.joined(separator: "+")
                getImageUrl(dateStr: dateStr, word: word)
            }
        }
        
    }
    
    //1. 신규 실제로 주소 뽑아온다.
    func getImageUrl(dateStr: String, word: String){
        //data network
        //URL-Session //URLRequest //JSON->Dictionary
        
        let url = "https://pixabay.com/api/?key=43116906-ba87ab03ae9e62b3d50bb08c4&q=\(word)&image_type=photo"
        
        URLSession.shared.dataTask(with: URLRequest(url: URL(string: url)!)) { data, response, error in
            if let d = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: d, options: []) as? Dictionary<String, Any> {
                        if json["hits"] as? Array<Dictionary<String,Any>> != nil {
                            let hits = json["hits"] as! Array<Dictionary<String,Any>>
                            if hits.count > 0 {
                                let imgUrl = hits[0]["previewURL"]
                                //image data
                                DispatchQueue.global().async {
                                    if let url = URL(string: imgUrl as! String) {
                                        if let urlData = try? Data(contentsOf: url){
                                            DispatchQueue.main.async {
                                                self.mImgMain.image = UIImage(data: urlData)
                                                self.datesWithEvent[dateStr]!["url"] = (imgUrl as! String)
                                                UserDefaults.standard.set(self.datesWithEvent, forKey: "dates")
                                                
                                                self.calendar.reloadData()
                                            }
                                        }
                                    }
                                }
                            }
                            
                        }
                    }
                }
                catch {
                    
                }
            }
        }.resume()
        
    }
    


    /*
     "dates" { "2100-10-01" : {"txt" : "txt", "url" : "https://---.jpg" }
     */

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mTextMain.text = ""
        
        //self.LabelResult.text = "0"
        // Do any additional setup after loading the view.
        
        calendar = FSCalendar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.viewMain.bounds.height))
        
        calendar.dataSource = self  //내가 처리하겠다.
        calendar.delegate = self    //내가 처리하겠다.
        calendar.locale = Locale(identifier: "ko_KR")
        //formating
        korDate = Date().toStringKST(dateFormat: "yyyy-MM-dd")
        
        if let dic = UserDefaults.standard.dictionary(forKey: "dates"), dic as? Dictionary<String, Dictionary<String,String>> != nil {
            self.datesWithEvent = dic as! Dictionary<String, Dictionary<String,String>>
        }
        //let korDate = Date().toStringKST(dateFormat: "yyyy-MM-dd")
        setText(korDate!)
        calendar.select(calendar.today)
        calendar.reloadData()
        //pixabay api
        
        self.viewMain.addSubview(calendar)
    }
    
    func setText(_ korDate: String?){
        if let dateStr = korDate, let txt = self.datesWithEvent[dateStr]?["txt"]{
            self.mTextMain.text = txt
        }
        else{
            self.mTextMain.text = ""
        }
        setImg(korDate!)
    }
    
    func setImg(_ korDate: String){
        self.mImgMain.image = nil
        DispatchQueue.global().async {
            if let url = self.datesWithEvent[korDate]?["url"], url.count > 0 {
                if let urlData = URL(string: url) {
                    if let data = try? Data(contentsOf: urlData) {
                        DispatchQueue.main.async{
                            self.mImgMain.image = UIImage(data: data)
                        }
                    }
                }
            }
        }
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        //yyyy-MM-dd
        
        korDate = date.toStringKST(dateFormat: "yyyy-MM-dd")
        setText(korDate)
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let dateString = date.toStringKST(dateFormat: "yyyy-MM-dd")
        if self.datesWithEvent.keys.contains(dateString) {
            return 1
        }
        else{
            return 0
        }
    }


    
    
    
}

extension Date{
    
    func toString(dateFormat format: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: self)
    }
    
    func toStringKST(dateFormat format: String) -> String {
        return self.toString(dateFormat: format)
    }
}

