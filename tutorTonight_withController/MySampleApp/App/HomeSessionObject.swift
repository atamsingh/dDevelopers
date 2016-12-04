import Foundation

class HomeSessionObject: NSObject {
    
    var course: String
    var date: String
    var icon: String

    init(course: String, date: String, icon: String) {
        self.course = course
        self.date = date
        self.icon = icon
        super.init()
    }
}
