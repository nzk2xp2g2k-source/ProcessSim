import SwiftUI
import ProcessSim

struct EquipmentPaletteView: View {
    @ObservedObject var viewModel: ProcessSimViewModel
    @State private var draggedEquipmentType: EquipmentType?
    
    let equipmentLibrary = EquipmentFactory.defaultEquipmentLibrary()
    
    var body: some View {
        VStack(spacing: 0) {
            // Заголовок
            VStack(alignment: .leading, spacing: 8) {
                Text("Equipment Library")
                    .font(.headline)
                    .padding(.horizontal)
                
                Divider()
            }
            .padding(.vertical, 12)
            .background(Color(.controlBackgroundColor))
            
            // Список оборудования по категориям
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    ForEach(groupedEquipment.keys.sorted(), id: \.self) { category in
                        VStack(alignment: .leading, spacing: 8) {
                            // Заголовок категории
                            Text(category)
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(.secondary)
                                .padding(.horizontal)
                                .padding(.top, 4)
                            
                            // Элементы категории
                            VStack(spacing: 6) {
                                ForEach(groupedEquipment[category] ?? [], id: \.id) { item in
                                    EquipmentPaletteItemView(item: item)
                                        .draggable(item.type) {
                                            Label(item.displayName, systemImage: item.icon)
                                                .padding(8)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .background(Color.blue)
                                                .foregroundColor(.white)
                                                .cornerRadius(6)
                                        }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.vertical, 12)
            }
        }
        .dropDestination(for: EquipmentType.self) { items, location in
            if let item = items.first {
                viewModel.addEquipment(type: item, at: location)
            }
            return true
        }
    }
    
    private var groupedEquipment: [String: [EquipmentLibraryItem]] {
        Dictionary(grouping: equipmentLibrary) { $0.category }
    }
}

// MARK: - Equipment Palette Item

struct EquipmentPaletteItemView: View {
    let item: EquipmentLibraryItem
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: item.icon)
                .font(.system(size: 16))
                .foregroundColor(.blue)
                .frame(width: 24)
            
            Text(item.displayName)
                .font(.body)
                .foregroundColor(.primary)
            
            Spacer()
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 10)
        .background(Color(.controlBackgroundColor))
        .cornerRadius(6)
        .contentShape(Rectangle())
    }
}

#Preview {
    EquipmentPaletteView(viewModel: ProcessSimViewModel())
        .frame(width: 280)
}
