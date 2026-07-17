import SwiftUI
import ProcessSim

class ProcessSimViewModel: ObservableObject {
    @Published var pfd: ProcessFlowDiagram
    @Published var selectedEquipmentId: UUID?
    @Published var isSimulating = false
    @Published var simulationResults: String = ""
    
    private let simulator: ProcessSimulator
    private let database = SubstanceDatabase.shared
    
    init() {
        self.pfd = ProcessFlowDiagram(name: "New Process")
        
        // Инициализируем симулятор с примером
        let water = database.substance(for: "H2O")!
        let composition = Composition(substances: [(water, 1.0)])
        let stream = Stream(
            temperature: 300,
            pressure: 101325,
            massFlow: 1.0,
            composition: composition
        )
        self.simulator = ProcessSimulator(inputStream: stream)
    }
    
    // MARK: - Canvas Operations
    
    func addEquipment(type: EquipmentType, at location: CGPoint) {
        let equipment = EquipmentFactory.create(
            type,
            at: CanvasPosition(x: location.x, y: location.y)
        )
        pfd.addEquipment(equipment)
    }
    
    func removeEquipment(withId id: UUID) {
        pfd.removeEquipment(id)
        if selectedEquipmentId == id {
            selectedEquipmentId = nil
        }
    }
    
    func connectEquipment(from sourceId: UUID, to targetId: UUID) {
        guard let source = pfd.equipment(withId: sourceId),
              let target = pfd.equipment(withId: targetId) else {
            return
        }
        
        guard !source.outputStreams.isEmpty && !target.inputStreams.isEmpty else {
            return
        }
        
        pfd.connect(
            from: sourceId,
            sourcePort: source.outputStreams[0],
            to: targetId,
            targetPort: target.inputStreams[0]
        )
    }
    
    // MARK: - Project Operations
    
    func newProject() {
        pfd = ProcessFlowDiagram(name: "New Process")
        selectedEquipmentId = nil
        simulationResults = ""
    }
    
    // MARK: - View Operations
    
    func zoomIn() {
        // Реализуем при добавлении масштабирования в CanvasView
    }
    
    func zoomOut() {
        // Реализуем при добавлении масштабирования в CanvasView
    }
    
    func zoomFit() {
        // Реализуем при добавлении масштабирования в CanvasView
    }
    
    // MARK: - Simulation
    
    func runSimulation() {
        isSimulating = true
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            // Симулируем расчёт
            Thread.sleep(forTimeInterval: 1.0)
            
            DispatchQueue.main.async {
                self?.simulationResults = "Simulation completed successfully"
                self?.isSimulating = false
            }
        }
    }
}
