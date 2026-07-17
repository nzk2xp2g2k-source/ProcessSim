import Foundation

/// Процессная диаграмма (PFD)
public class ProcessFlowDiagram: Identifiable, ObservableObject {
    public let id: UUID
    public var name: String
    
    @Published public var equipment: [Equipment] = []
    @Published public var connections: [StreamConnection] = []
    
    public init(name: String = "New Process", id: UUID = UUID()) {
        self.id = id
        self.name = name
    }
    
    /// Добавить оборудование
    public func addEquipment(_ equipment: Equipment) {
        self.equipment.append(equipment)
    }
    
    /// Удалить оборудование
    public func removeEquipment(_ id: UUID) {
        equipment.removeAll { $0.id == id }
        // Удалить все связи с этим оборудованием
        connections.removeAll { $0.fromEquipmentId == id || $0.toEquipmentId == id }
    }
    
    /// Найти оборудование по ID
    public func equipment(withId id: UUID) -> Equipment? {
        equipment.first { $0.id == id }
    }
    
    /// Соединить два оборудования потоком
    public func connect(
        from sourceId: UUID,
        sourcePort: UUID,
        to targetId: UUID,
        targetPort: UUID
    ) -> StreamConnection {
        let connection = StreamConnection(
            id: UUID(),
            fromEquipmentId: sourceId,
            fromPortId: sourcePort,
            toEquipmentId: targetId,
            toPortId: targetPort
        )
        connections.append(connection)
        return connection
    }
    
    /// Удалить соединение
    public func disconnect(_ connectionId: UUID) {
        connections.removeAll { $0.id == connectionId }
    }
}

/// Соединение между оборудованием (поток материала)
public struct StreamConnection: Identifiable, Codable {
    public let id: UUID
    public let fromEquipmentId: UUID
    public let fromPortId: UUID
    public let toEquipmentId: UUID
    public let toPortId: UUID
    
    public var streamData: Stream?
}
