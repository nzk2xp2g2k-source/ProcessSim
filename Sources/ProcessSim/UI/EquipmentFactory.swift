import Foundation

/// Фабрика для создания оборудования
public class EquipmentFactory {
    public static func create(_ type: EquipmentType, at position: CanvasPosition) -> Equipment {
        switch type {
        case .inlet:
            return InletStream(position: position)
        case .outlet:
            return OutletStream(position: position)
        case .mixer:
            return Mixer(position: position)
        case .splitter:
            return Splitter(position: position)
        case .heater:
            return Heater(position: position)
        case .cooler:
            return Cooler(position: position)
        case .flashSeparator:
            return FlashSeparator(position: position)
        case .cstr:
            return CSTRReactor(position: position)
        case .pfr:
            return Equipment(type: .pfr, name: "PFR Reactor", position: position)
        }
    }
    
    public static func defaultEquipmentLibrary() -> [EquipmentLibraryItem] {
        [
            EquipmentLibraryItem(type: .inlet, category: "Streams", icon: "arrow.right.circle"),
            EquipmentLibraryItem(type: .outlet, category: "Streams", icon: "arrow.left.circle"),
            EquipmentLibraryItem(type: .mixer, category: "Separators & Mixers", icon: "plus.circle"),
            EquipmentLibraryItem(type: .splitter, category: "Separators & Mixers", icon: "minus.circle"),
            EquipmentLibraryItem(type: .heater, category: "Heat Transfer", icon: "flame.circle"),
            EquipmentLibraryItem(type: .cooler, category: "Heat Transfer", icon: "snowflake.circle"),
            EquipmentLibraryItem(type: .flashSeparator, category: "Separators & Mixers", icon: "bolt.circle"),
            EquipmentLibraryItem(type: .cstr, category: "Reactors", icon: "cube.circle"),
            EquipmentLibraryItem(type: .pfr, category: "Reactors", icon: "cylinder.circle")
        ]
    }
}

/// Элемент библиотеки оборудования
public struct EquipmentLibraryItem: Identifiable {
    public let id = UUID()
    public let type: EquipmentType
    public let category: String
    public let icon: String
    
    public var displayName: String { type.rawValue }
}
