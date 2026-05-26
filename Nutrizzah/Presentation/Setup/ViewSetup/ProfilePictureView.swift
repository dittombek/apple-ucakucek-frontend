//
//  ProfilePictureView.swift
//  Nutrizzah
//
//  Created by Muhammad Maulana Husein on 22/05/26.
//

import SwiftUI
import UIKit // Diperlukan untuk UIImagePickerController

struct ProfilePictureView: View {
    // MARK: - States untuk Image Picker
    @State private var selectedImage: UIImage? = nil
    @State private var showActionSheet: Bool = false
    @State private var showImagePicker: Bool = false
    @State private var imageSourceType: UIImagePickerController.SourceType = .photoLibrary
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Profile picture")
                .font(.title)
                .fontDesign(.serif)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.top, 30)
            
            Text("Optional, you can change it later")
                .font(.footnote)
                .foregroundColor(.gray)
            
            // MARK: - Avatar & Camera Button
            ZStack(alignment: .bottomTrailing) {
                // 1. Logika untuk menampilkan foto yang dipilih atau placeholder tomat
                if let image = selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 140, height: 140)
                        .clipShape(Circle())
                } else {
                    Circle()
                        .fill(Color.red.opacity(0.1))
                        .frame(width: 140, height: 140)
                        .overlay(Text("🍅").font(.system(size: 70)))
                }
                
                // 2. Tombol Kamera
                Button(action: {
                    showActionSheet = true // Memunculkan menu pilihan
                }) {
                    Image(systemName: "camera.fill")
                        .padding(10)
                        // Catatan: Saya menggunakan warna statis agar bisa di-preview,
                        // silakan ganti kembali ke Color.machaMecha400 milikmu
                        .background(Color(red: 0.60, green: 0.68, blue: 0.48))
                        .foregroundColor(.white)
                        .clipShape(Circle())
                }
            }
            .padding(.top, 30)
            
            // MARK: - Confirmation Dialog (Apple HIG)
            .confirmationDialog("Choose Profile Picture", isPresented: $showActionSheet, titleVisibility: .visible) {
                Button("Camera") {
                    imageSourceType = .camera
                    showImagePicker = true
                }
                
                Button("Photo Library") {
                    imageSourceType = .photoLibrary
                    showImagePicker = true
                }
                
                Button("Cancel", role: .cancel) {}
            }
            // MARK: - Menampilkan Image Picker
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(image: $selectedImage, sourceType: imageSourceType)
            }
            
            Spacer()
        }
    }
}

// MARK: - Komponen Image Picker (Menjembatani UIKit ke SwiftUI)
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    var sourceType: UIImagePickerController.SourceType
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        // Membatasi pengguna agar hanya bisa memilih foto, bukan video (jika perlu)
        picker.mediaTypes = ["public.image"]
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            picker.dismiss(animated: true)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}

// MARK: - Preview
#Preview {
    ZStack {
        LinearGradient(
            // Silakan ganti kembali ke Color.potOfCream400 milikmu
            colors: [Color.white, Color(red: 0.95, green: 0.94, blue: 0.90)],
            startPoint: .top,
            endPoint: .bottom
        ).ignoresSafeArea()
        
        ProfilePictureView()
    }
}
