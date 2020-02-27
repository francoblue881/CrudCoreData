//
//  ImagenesLugaresViewController.swift
//  CrudCoreData
//
//  Created by Francisco Córdova on 2/17/20.
//  Copyright © 2020 Home. All rights reserved.
//

import UIKit
import CoreData

class ImagenesLugaresViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  var imagenLugar : Lugares!
  var id : Int16!
  var imagen : UIImage!
  
  func conexion()->NSManagedObjectContext{
    let delegate = UIApplication.shared.delegate as! AppDelegate
    return delegate.persistentContainer.viewContext
    
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = imagenLugar.nombre
    id =  imagenLugar.id
    
    
    let rightButton = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(accionCamara))
    
    self.navigationItem.rightBarButtonItem = rightButton
  }
  
  @objc func accionCamara(){
    
    let alerta = UIAlertController(title: "Tomar foto", message: "camara-galeria", preferredStyle: .actionSheet)
    
    let accionCamara =  UIAlertAction(title: "Tomar fotografia", style: .default) { (action) in self.tomarFotografia()
      
    }
    
    let accionGaleria =  UIAlertAction(title: "Entrar a galeria ", style: .default) { (action) in self.entrarGaleria()
    }
    
    let accionCancelar = UIAlertAction(title: "cancelar", style: .destructive, handler: nil)
    
    alerta.addAction(accionCamara)
    alerta.addAction(accionGaleria)
    alerta.addAction(accionCancelar)
    
    present(alerta,animated: true,completion: nil)
    
  }
  
  func tomarFotografia(){
    let imagePicker = UIImagePickerController()
    imagePicker.delegate = self
    imagePicker.sourceType = .camera
    imagePicker.allowsEditing =  true
    present(imagePicker, animated: true, completion: nil)
  }
  
  func entrarGaleria(){
    let imagePicker = UIImagePickerController()
    imagePicker.delegate = self
    imagePicker.sourceType = .photoLibrary
    imagePicker.allowsEditing =  true
    present(imagePicker, animated: true, completion: nil)
  }
  
  private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
     let imagenTomada = info[UIImagePickerController.InfoKey.originalImage.rawValue] as? UIImage
    imagen = imagenTomada
    let contexto =  conexion()
    let entityImagenes =  NSEntityDescription.insertNewObject(forEntityName: "Imagenes", into: contexto) as! Imagenes
   
    let uuid = UUID()
    
    print(uuid)
    entityImagenes.id = uuid
    entityImagenes.id_lugares = id
    let imagenFinal = imagen.pngData() as Data?
    entityImagenes.imagenes = imagenFinal
    
    //poner el nombre de la relacion :imagenes
    
    imagenLugar.mutableSetValue(forKey: "imagenes").add(entityImagenes)
    do {
      try contexto.save()
      dismiss(animated: true, completion: nil)
      print("guardo!")
    } catch let error as NSError {
      print("No se guardo!",error)
    }
    
    
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true, completion: nil)
  }
  
}
