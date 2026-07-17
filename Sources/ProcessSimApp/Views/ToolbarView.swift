import SwiftUI
import ProcessSim

struct ToolbarView: View {
    @ObservedObject var viewModel: ProcessSimViewModel
    @State private var showSavePanel = false
    @State private var showOpenPanel = false
    
    var body: some View {
        HStack(spacing: 16) {
            // Project name
            TextField("Project Name", text: Binding(
                get: { viewModel.pfd.name },
                set: { viewModel.pfd.name = $0 }
            ))
            .textFieldStyle(.roundedBorder)
            .frame(width: 200)
            
            Divider()
                .frame(height: 24)
            
            // File operations
            Button(action: { viewModel.newProject() }) {
                Label("New", systemImage: "doc.badge.plus")
            }
            
            Button(action: { showOpenPanel = true }) {
                Label("Open", systemImage: "folder.badge.questionmark")
            }
            
            Button(action: { showSavePanel = true }) {
                Label("Save", systemImage: "doc.badge.ellipsis")
            }
            
            Divider()
                .frame(height: 24)
            
            // Zoom controls
            Button(action: { viewModel.zoomIn() }) {
                Image(systemName: "plus.magnifyingglass")
            }
            
            Button(action: { viewModel.zoomOut() }) {
                Image(systemName: "minus.magnifyingglass")
            }
            
            Button(action: { viewModel.zoomFit() }) {
                Image(systemName: "square.resize")
            }
            
            Divider()
                .frame(height: 24)
            
            // Simulation
            Button(action: { viewModel.runSimulation() }) {
                Label("Run", systemImage: "play.circle.fill")
            }
            .foregroundColor(.green)
            
            Spacer()
            
            // Status
            if viewModel.isSimulating {
                HStack(spacing: 6) {
                    ProgressView()
                        .scaleEffect(0.8, anchor: .center)
                    
                    Text("Simulating...")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.horizontal, 16)
        .frame(maxHeight: .infinity)
    }
}

#Preview {
    ToolbarView(viewModel: ProcessSimViewModel())
        .frame(height: 50)
}
