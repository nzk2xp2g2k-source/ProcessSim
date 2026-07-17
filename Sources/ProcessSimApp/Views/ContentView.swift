import SwiftUI
import ProcessSim

struct ContentView: View {
    @StateObject private var viewModel = ProcessSimViewModel()
    
    var body: some View {
        ZStack {
            // Основной layout
            HStack(spacing: 0) {
                // Левая панель: Палитра оборудования
                EquipmentPaletteView(viewModel: viewModel)
                    .frame(width: 280)
                    .background(Color(.controlBackgroundColor))
                    .border(.gray, width: 1)
                
                // Центр: Canvas
                CanvasView(viewModel: viewModel)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                // Правая панель: Свойства
                PropertiesPanelView(viewModel: viewModel)
                    .frame(width: 320)
                    .background(Color(.controlBackgroundColor))
                    .border(.gray, width: 1)
            }
            
            // Top Toolbar
            VStack(spacing: 0) {
                ToolbarView(viewModel: viewModel)
                    .frame(height: 50)
                    .background(Color(.controlBackgroundColor))
                    .border(.gray.opacity(0.3), width: 1)
                
                Spacer()
            }
        }
    }
}

#Preview {
    ContentView()
}
