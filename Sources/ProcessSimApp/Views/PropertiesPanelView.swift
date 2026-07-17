import SwiftUI
import ProcessSim

struct PropertiesPanelView: View {
    @ObservedObject var viewModel: ProcessSimViewModel
    
    var selectedEquipment: Equipment? {
        guard let id = viewModel.selectedEquipmentId else { return nil }
        return viewModel.pfd.equipment(withId: id)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Заголовок
            VStack(alignment: .leading, spacing: 8) {
                Text("Properties")
                    .font(.headline)
                    .padding(.horizontal)
                
                Divider()
            }
            .padding(.vertical, 12)
            .background(Color(.controlBackgroundColor))
            
            if let equipment = selectedEquipment {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        // Основная информация
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Equipment Info")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(.secondary)
                            
                            VStack(alignment: .leading, spacing: 6) {
                                PropertyRow(label: "Type", value: equipment.type.rawValue)
                                PropertyRow(label: "ID", value: equipment.id.uuidString.prefix(8).uppercased())
                            }
                        }
                        .padding(.horizontal)
                        
                        Divider()
                        
                        // Параметры оборудования
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Parameters")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(.secondary)
                            
                            VStack(spacing: 10) {
                                // Изменяемое название
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Name")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    
                                    TextField("Equipment Name", text: Binding(
                                        get: { equipment.name },
                                        set: { equipment.name = $0 }
                                    ))
                                    .textFieldStyle(.roundedBorder)
                                }
                                
                                // Положение
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Position")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    
                                    HStack {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text("X")
                                                .font(.caption2)
                                            TextField("X", value: Binding(
                                                get: { equipment.position.x },
                                                set: { equipment.position.x = $0 }
                                            ), format: .number)
                                            .textFieldStyle(.roundedBorder)
                                        }
                                        
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text("Y")
                                                .font(.caption2)
                                            TextField("Y", value: Binding(
                                                get: { equipment.position.y },
                                                set: { equipment.position.y = $0 }
                                            ), format: .number)
                                            .textFieldStyle(.roundedBorder)
                                        }
                                    }
                                }
                                
                                // Специфичные параметры
                                ForEach(equipment.parameters.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(key.capitalized)
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                        
                                        TextField(
                                            key,
                                            value: Binding(
                                                get: { value },
                                                set: { equipment.parameters[key] = $0 }
                                            ),
                                            format: .number
                                        )
                                        .textFieldStyle(.roundedBorder)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                        Divider()
                        
                        // Порты
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Ports")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(.secondary)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Input Ports: \(equipment.inputStreams.count)")
                                    .font(.caption)
                                
                                Text("Output Ports: \(equipment.outputStreams.count)")
                                    .font(.caption)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical, 12)
                }
            } else {
                VStack(spacing: 12) {
                    Image(systemName: "rectangle.dashed")
                        .font(.system(size: 32))
                        .foregroundColor(.secondary)
                    
                    Text("Select an equipment")
                        .font(.body)
                        .foregroundColor(.secondary)
                    
                    Text("Click on any equipment on the canvas to view and edit its properties")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(3)
                }
                .frame(maxHeight: .infinity)
                .padding()
            }
        }
    }
}

struct PropertyRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    PropertiesPanelView(viewModel: ProcessSimViewModel())
        .frame(width: 320)
}
