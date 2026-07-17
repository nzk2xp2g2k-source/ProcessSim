import Foundation

/// Публичный API библиотеки ProcessSim
public struct ProcessSimLib {
    public static let version = "1.0.0"
    public static let author = "ProcessSim Contributors"
    
    public static func initialize() {
        // Инициализация базы данных при первом использовании
        _ = SubstanceDatabase.shared
    }
}
