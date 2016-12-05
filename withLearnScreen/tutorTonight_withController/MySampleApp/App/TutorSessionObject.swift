import Foundation

class TutorSessionObject: NSObject {
    
//    {
//    \"sessionID\": \"80246b78-370b-496d-90fa-d2af1f99d91e|~~|8\",
//    \"sessionDate\": \"Nov 12,
//    2016\",
//    \"courseName\": \"HIST1001\",
//    \"startTime\": \"10: 00\",
//    \"studentID\": \"80246b78-370b-496d-90fa-d2af1f99d91e\",
//    \"endTime\": \"14: 00\"
//    }

    var name: String
    var date: String
    var startTime: String
    var endTime: String
    var icon: String
    var seg: String
    
    init(name: String, date: String, startTime: String, endTime: String, icon: String, seg: String) {
        self.name = name
        self.date = date
        self.startTime = startTime
        self.endTime = endTime
        self.icon = icon
        self.seg = seg
        super.init()
    }
}
