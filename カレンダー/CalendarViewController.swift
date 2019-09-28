//
//  CalendarViewController.swift
//  カレンダー
//
//  Created by 松丸真 on 2019/09/28.
//  Copyright © 2019 松丸真. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FSCalendar
import CalculateCalendarLogic

class CalendarViewController: UIViewController, FSCalendarDelegate,FSCalendarDataSource,FSCalendarDelegateAppearance {
  @IBOutlet weak var calendar: FSCalendar!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    weekdays()

    // デリゲートの設定
    self.calendar.dataSource = self
    self.calendar.delegate = self
  }
  
  // 曜日日本語化
  func weekdays() {
    self.calendar.calendarWeekdayView.weekdayLabels[0].text = "日"
    self.calendar.calendarWeekdayView.weekdayLabels[1].text = "月"
    self.calendar.calendarWeekdayView.weekdayLabels[2].text = "火"
    self.calendar.calendarWeekdayView.weekdayLabels[3].text = "水"
    self.calendar.calendarWeekdayView.weekdayLabels[4].text = "木"
    self.calendar.calendarWeekdayView.weekdayLabels[5].text = "金"
    self.calendar.calendarWeekdayView.weekdayLabels[6].text = "土"
  }
  
  fileprivate let gregorian: Calendar = Calendar(identifier: .gregorian)
  fileprivate lazy var dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter
  }()

  // 祝日判定を行い結果を返すメソッド(True:祝日)
  func judgeHoliday(_ date : Date) -> Bool {
    //祝日判定用のカレンダークラスのインスタンス
    let tmpCalendar = Calendar(identifier: .gregorian)

    // 祝日判定を行う日にちの年、月、日を取得
    let year = tmpCalendar.component(.year, from: date)
    let month = tmpCalendar.component(.month, from: date)
    let day = tmpCalendar.component(.day, from: date)

    // CalculateCalendarLogic()：祝日判定のインスタンスの生成
    let holiday = CalculateCalendarLogic()

    return holiday.judgeJapaneseHoliday(year: year, month: month, day: day)
  }
  // date型 -> 年月日をIntで取得
  func getDay(_ date:Date) -> (Int,Int,Int){
    let tmpCalendar = Calendar(identifier: .gregorian)
    let year = tmpCalendar.component(.year, from: date)
    let month = tmpCalendar.component(.month, from: date)
    let day = tmpCalendar.component(.day, from: date)
    return (year,month,day)
  }

  //曜日判定(日曜日:1 〜 土曜日:7)
  func getWeekIdx(_ date: Date) -> Int{
    let tmpCalendar = Calendar(identifier: .gregorian)
    return tmpCalendar.component(.weekday, from: date)
  }

  // 土日や祝日の日の文字色を変える
  func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
    //祝日判定をする（祝日は赤色で表示する）
    if self.judgeHoliday(date){
        return UIColor.red
    }

    //土日の判定を行う（土曜日は青色、日曜日は赤色で表示する）
    let weekday = self.getWeekIdx(date)
    if weekday == 1 {   //日曜日
        return UIColor.red
    }
    else if weekday == 7 {  //土曜日
        return UIColor.blue
    }

    return nil
  }
  
  // ログアウト
  @IBAction func logoutButton(_ sender: Any) {
    try? Auth.auth().signOut()
    UserDefaults.standard.removeObject(forKey: "login")
    // login遷移
    let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    let nextView = storyboard.instantiateInitialViewController()
    nextView!.modalPresentationStyle = .fullScreen
    self.present(nextView!, animated: true, completion: nil)
  }
  
}
