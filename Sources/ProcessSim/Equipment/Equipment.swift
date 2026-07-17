import Foundation

/// Типы оборудования
public enum EquipmentType: String, Codable {
    case inlet = "Inlet"
    case outlet = "Outlet"
    case mixer = "Mixer"
    case splitter = "Splitter"
    case heater = "Heater"
    case cooler = "Cooler"
    case flashSeparator = "Flash Separator"
    case cstr = "CSTR Reactor"
    case pfr = "PFR Reactor"
}

/// Базовый класс для оборудования
public class Equipment: Identifiable, Codable {
    public let id: UUID
    public let type: EquipmentType
    public var name: String
    
    // Позиция на canvas (для UI)
    public var position: CanvasPosition
    
    // Входные и выходные потоки
    public var inputStreams: [UUID] = []
    public var outputStreams: [UUID] = []
    
    // Параметры оборудования
    public var parameters: [String: Double] = [:]
    
    public init(
        type: EquipmentType,
        name: String,
        position: CanvasPosition = CanvasPosition(x: 0, y: 0),
        id: UUID = UUID()
    ) {
        self.id = id
        self.type = type
        self.name = name
        self.position = position
    }
    
    public func addInputPort() -> UUID {
        let portId = UUID()
        inputStreams.append(portId)
        return portId
    }
    
    public func addOutputPort() -> UUID {
        let portId = UUID()
        outputStreams.append(portId)
        return portId
    }
}

/// Позиция на canvas
public struct CanvasPosition: Codable {
    public var x: Double
    public var y: Double
    
    public init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }
}

// MARK: - Specific Equipment Types

/// Входной поток
public class InletStream: Equipment {
    public var outputStream: Stream?
    
    public init(name: String = "Inlet", position: CanvasPosition = CanvasPosition(x: 0, y: 0)) {
        super.init(type: .inlet, name: name, position: position)
        _ = addOutputPort()
    }
    
    required public init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
}

/// Выходной поток
public class OutletStream: Equipment {
    public var inputStream: Stream?
    
    public init(name: String = "Outlet", position: CanvasPosition = CanvasPosition(x: 0, y: 0)) {
        super.init(type: .outlet, name: name, position: position)
        _ = addInputPort()
    }
    
    required public init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
}

/// Смеситель потоков
public class Mixer: Equipment {
    public init(name: String = "Mixer", position: CanvasPosition = CanvasPosition(x: 0, y: 0)) {
        super.init(type: .mixer, name: name, position: position)
        _ = addInputPort()
        _ = addInputPort()
        _ = addOutputPort()
    }
    
    required public init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
}

/// Делитель потока
public class Splitter: Equipment {
    public init(name: String = "Splitter", position: CanvasPosition = CanvasPosition(x: 0, y: 0)) {
        super.init(type: .splitter, name: name, position: position)
        _ = addInputPort()
        _ = addOutputPort()
        _ = addOutputPort()
    }
    
    required public init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
}

/// Нагреватель
public class Heater: Equipment {
    public init(name: String = "Heater", position: CanvasPosition = CanvasPosition(x: 0, y: 0)) {
        super.init(type: .heater, name: name, position: position)
        _ = addInputPort()
        _ = addOutputPort()
        
        // Параметры
        parameters["duty"] = 0.0  // J/s (кВт)
    }
    
    required public init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
}

/// Охладитель
public class Cooler: Equipment {
    public init(name: String = "Cooler", position: CanvasPosition = CanvasPosition(x: 0, y: 0)) {
        super.init(type: .cooler, name: name, position: position)
        _ = addInputPort()
        _ = addOutputPort()
        
        parameters["duty"] = 0.0  // J/s
    }
    
    required public init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
}

/// Flash сепаратор
public class FlashSeparator: Equipment {
    public init(name: String = "Flash", position: CanvasPosition = CanvasPosition(x: 0, y: 0)) {
        super.init(type: .flashSeparator, name: name, position: position)
        _ = addInputPort()
        _ = addOutputPort()  // Пар
        _ = addOutputPort()  // Жидкость
    }
    
    required public init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
}

/// CSTR реактор
public class CSTRReactor: Equipment {
    public init(name: String = "CSTR", position: CanvasPosition = CanvasPosition(x: 0, y: 0)) {
        super.init(type: .cstr, name: name, position: position)
        _ = addInputPort()
        _ = addOutputPort()
        
        parameters["volume"] = 1.0  // m³
        parameters["temperature"] = 298.15  // K
    }
    
    required public init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
}
