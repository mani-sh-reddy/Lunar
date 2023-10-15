//
//  PhotoPicker.swift
//  Lunar
//
//  Created by Mani on 15/10/2023.
//

import PhotosUI
import SwiftUI

struct PhotoPicker: UIViewControllerRepresentable {
  @Binding var pickerResult: [UIImage]
  @Binding var isPresented: Bool

  func makeUIViewController(context: Context) -> some UIViewController {
    var configuration = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
    configuration.filter = .images // filter only to images
    configuration.selectionLimit = 1

    let photoPickerViewController = PHPickerViewController(configuration: configuration)
    photoPickerViewController.delegate = context.coordinator
    return photoPickerViewController
  }

  func updateUIViewController(_: UIViewControllerType, context _: Context) {}

  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }

  class Coordinator: PHPickerViewControllerDelegate {
    private let parent: PhotoPicker

    init(_ parent: PhotoPicker) {
      self.parent = parent
    }

    func picker(_: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
      parent.pickerResult.removeAll()

      for image in results {
        if image.itemProvider.canLoadObject(ofClass: UIImage.self) {
          image.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] newImage, error in
            if let error {
              print("Can't load image \(error.localizedDescription)")
            } else if let image = newImage as? UIImage {
              self?.parent.pickerResult.append(image)
            }
          }
        } else {
          print("Can't load asset")
        }
      }

      parent.isPresented = false
    }
  }
}

// struct ImageView: View {
//  var uiImage: UIImage
//
//  var body: some View {
//    Image(uiImage: uiImage)
//      .resizable()
//      .frame(height: 250, alignment: .center)
//      .aspectRatio(contentMode: .fit)
//      .cornerRadius(10)
//      .padding(10)
//  }
// }

// struct PhotoPickerView: View {
//  @State private var photoPickerIsPresented = false
//  @State var pickerResult: [UIImage] = []
//
//  var body: some View {
//    NavigationView {
//      ScrollView {
//        ForEach(pickerResult, id: \.self) { uiImage in
//          ImageView(uiImage: uiImage)
//        }
//        .padding()
//      }
//      .edgesIgnoringSafeArea(.bottom)
//      .navigationBarTitle("Select Photo", displayMode: .inline)
//      .navigationBarItems(trailing: selectPhotoButton)
//      .sheet(isPresented: $photoPickerIsPresented) {
//        PhotoPicker(pickerResult: $pickerResult,
//                    isPresented: $photoPickerIsPresented)
//      }
//    }
//  }
//
//  @ViewBuilder
//  private var selectPhotoButton: some View {
//    Button(action: {
//      photoPickerIsPresented = true
//    }, label: {
//      Label("Select", systemImage: "photo")
//    })
//  }
// }
//
// struct PhotoPickerView_Previews: PreviewProvider {
//  static var previews: some View {
//    PhotoPickerView()
//  }
// }
