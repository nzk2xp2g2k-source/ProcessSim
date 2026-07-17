import SwiftUI
import ProcessSim

struct CanvasView: View {
    @ObservedObject var viewModel: ProcessSimViewModel
    @State private var scale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var isDraggingCanvas = false
    @State private var lastDragLocation: CGPoint = .zero
    
    var body: some View {
        ZStack {
            // Фон с сеткой
            Canvas { context in
                // Рисуем сетку
                let gridSize: CGFloat = 20
                var x: CGFloat = 0
                while x < context.size.width {
                    var points: [CGPoint] = []
                    var y: CGFloat = 0
                    while y < context.size.height {
                        points.append(CGPoint(x: x, y: y))
                        y += gridSize
                    }
                    var path = Path()
                    if !points.isEmpty {
                        path.move(to: points[0])
                        points.dropFirst().forEach { path.addLine(to: $0) }
                    }
                    context.stroke(path, with: .color(.gray.opacity(0.1)), lineWidth: 0.5)
                    x += gridSize
                }
            }
            .background(Color(.windowBackgroundColor))
            
            // Оборудование на canvas
            ZStack {
                // Соединения (потоки)
                ForEach(viewModel.pfd.connections, id: \.id) { connection in
                    ConnectionLineView(
                        viewModel: viewModel,
                        connection: connection
                    )
                }
                
                // Оборудование
                ForEach(viewModel.pfd.equipment, id: \.id) { equipment in
                    EquipmentNodeView(
                        viewModel: viewModel,
                        equipment: equipment
                    )
                    .position(
                        x: equipment.position.x * scale + offset.width,
                        y: equipment.position.y * scale + offset.height
                    )
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                let newX = (value.location.x - offset.width) / scale
                                let newY = (value.location.y - offset.height) / scale
                                equipment.position = CanvasPosition(x: newX, y: newY)
                                viewModel.objectWillChange.send()
                            }
                    )
                    .onTapGesture {
                        viewModel.selectedEquipmentId = equipment.id
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .contentShape(Rectangle())
            .gesture(
                DragGesture()
                    .onChanged { value in
                        if !isDraggingCanvas {
                            isDraggingCanvas = true
                            lastDragLocation = value.location
                        }
                        let delta = CGSize(
                            width: value.location.x - lastDragLocation.x,
                            height: value.location.y - lastDragLocation.y
                        )
                        offset = CGSize(
                            width: offset.width + delta.width,
                            height: offset.height + delta.height
                        )
                        lastDragLocation = value.location
                    }
                    .onEnded { _ in
                        isDraggingCanvas = false
                    }
                    .simultaneously(with:
                        MagnificationGesture()
                            .onChanged { value in
                                scale = value
                            }
                    )
            )
        }
    }
}

// MARK: - Connection Line View

struct ConnectionLineView: View {
    @ObservedObject var viewModel: ProcessSimViewModel
    let connection: StreamConnection
    
    var body: some View {
        Canvas { context in
            guard let fromEquip = viewModel.pfd.equipment(withId: connection.fromEquipmentId),
                  let toEquip = viewModel.pfd.equipment(withId: connection.toEquipmentId) else {
                return
            }
            
            let fromPoint = CGPoint(
                x: fromEquip.position.x,
                y: fromEquip.position.y
            )
            let toPoint = CGPoint(
                x: toEquip.position.x,
                y: toEquip.position.y
            )
            
            var path = Path()
            path.move(to: fromPoint)
            
            // Рисуем линию через контрольные точки (Bezier)
            let midX = (fromPoint.x + toPoint.x) / 2
            path.addCurve(
                to: toPoint,
                control1: CGPoint(x: midX, y: fromPoint.y),
                control2: CGPoint(x: midX, y: toPoint.y)
            )
            
            context.stroke(path, with: .color(.blue), lineWidth: 2)
        }
    }
}

#Preview {
    CanvasView(viewModel: ProcessSimViewModel())
}
