import Foundation

class SettingsObject: NSObject {
    
    var displayName: String
    var detailText: String
    var icon: String
    var seg: String
    
    init(name: String, detail: String, icon: String, seg: String) {
        self.displayName = name
        self.detailText = detail
        self.icon = icon
        self.seg = seg
        super.init()
    }
}
