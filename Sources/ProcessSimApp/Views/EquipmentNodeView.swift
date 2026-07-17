import SwiftUI
import ProcessSim

struct EquipmentNodeView: View {
    @ObservedObject var viewModel: ProcessSimViewModel
    let equipment: Equipment
    
    var isSelected: Bool {
        viewModel.selectedEquipmentId == equipment.id
    }
    
    var body: some View {
        VStack(spacing: 4) {
            // Иконка оборудования
            Image(systemName: equipmentIcon)
                .font(.system(size: 28))
                .foregroundColor(.white)
            
            // Название
            Text(equipment.name)
                .font(.caption2)
                .foregroundColor(.white)
                .lineLimit(1)
        }
        .frame(width: 60, height: 60)
        .background(equipmentColor)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(isSelected ? Color.orange : Color.clear, lineWidth: 2)
        )
        .shadow(radius: 2)
    }
    
    private var equipmentIcon: String {
        switch equipment.type {
        case .inlet:
            return "arrow.right.circle.fill"
        case .outlet:
            return "arrow.left.circle.fill"
        case .mixer:
            return "plus.circle.fill"
        case .splitter:
            return "minus.circle.fill"
        case .heater:
            return "flame.circle.fill"
        case .cooler:
            return "snowflake.circle.fill"
        case .flashSeparator:
            return "bolt.circle.fill"
        case .cstr:
            return "cube.circle.fill"
        case .pfr:
            return "cylinder.circle.fill"
        }
    }
    
    private var equipmentColor: Color {
        switch equipment.type {
        case .inlet, .outlet:
            return .blue
        case .mixer, .splitter:
            return .purple
        case .heater, .cooler:
            return .red
        case .flashSeparator:
            return .orange
        case .cstr, .pfr:
            return .green
        }
    }
}

#Preview {
    EquipmentNodeView(
        viewModel: ProcessSimViewModel(),
        equipment: EquipmentFactory.create(.mixer, at: CanvasPosition(x: 100, y: 100))
    )
}
