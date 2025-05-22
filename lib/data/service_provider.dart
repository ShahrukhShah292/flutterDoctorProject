import 'package:flutter/foundation.dart';
import '../models/service_model.dart';
import 'dummy_data.dart';

class ServiceProvider with ChangeNotifier {
  ServiceType _selectedType = ServiceType.pathology;
  
  ServiceType get selectedType => _selectedType;
  
  List<Service> get displayedServices {
    switch (_selectedType) {
      case ServiceType.pathology:
        return pathologyServices;
      case ServiceType.doctor:
        return doctors;
    }
  }
  
  void setType(ServiceType type) {
    _selectedType = type;
    notifyListeners();
  }
}