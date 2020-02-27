//
//  AgregarViewController.swift
//  CrudCoreData
//
//  Created by Francisco Córdova on 1/29/20.
//  Copyright © 2020 Home. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

class AgregarViewController: UIViewController ,CLLocationManagerDelegate{

  @IBOutlet weak var txtNombre: UITextField!
  @IBOutlet weak var txtDescripcion: UITextField!
  @IBOutlet weak var verCoordenadas: UIButton!
  
  let manager = CLLocationManager()
  var latitud = CLLocationDegrees()
  var longitud = CLLocationDegrees()
  
  
  @IBAction func btnObtenerCoordenadas(_ sender: UIButton) {
    verCoordenadas.setTitle("LAT: \(latitud) - LONG: \(longitud)", for: .normal)
  }
  
  @IBAction func btnGuardar(_ sender: UIButton) {
    let contexto = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let entityLugares = NSEntityDescription.insertNewObject(forEntityName: "Lugares", into: contexto) as! Lugares
    
    entityLugares.nombre = txtNombre.text
    entityLugares.descripcion = txtDescripcion.text
    entityLugares.latitud = latitud
    entityLugares.longitud = longitud
    
    //crear ID incrementable
    //En Mysql seria
    //SELECT FROM LUGARES ORDER BY ID DESC IMIT 1
    let fetchResult : NSFetchRequest<Lugares> = Lugares.fetchRequest()
    //order by id  , true=asc
    let orderById = NSSortDescriptor(key: "id", ascending: false )
    // si se desear agregar mas paramertos de ordenar en [agregar los camps por ordernar como ]
    fetchResult.sortDescriptors = [orderById]
    
    //ultimo
    fetchResult.fetchLimit = 1
    
    do {
      let idResult = try contexto.fetch(fetchResult)
      let id = idResult[0].id + 1
        
      entityLugares.id = id
    } catch let error as NSError {
      print("Sucedio un error ", error)
    }
    
    do {
      try contexto.save()
      print("Se guardó")
    } catch let error as NSError {
      print("Error, no se guardó ",error)
    }
    
    
  }
  override func viewDidLoad() {
        super.viewDidLoad()
    
    manager.delegate = self
    manager.requestWhenInUseAuthorization()
    manager.desiredAccuracy = kCLLocationAccuracyBest
    manager.startUpdatingLocation()

    }
    
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
    if let location = locations.first
    {
      self.latitud = location.coordinate.latitude
      self.longitud = location.coordinate.longitude
    }
    
  }

}
