class Validators {
  static String? required(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? "Este campo"} es obligatorio';
    }
    return null;
  }
  
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'El correo es obligatorio';
    }
    
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Ingresa un correo válido';
    }
    return null;
  }
  
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'La contraseña es obligatoria';
    }
    
    if (value.length < 8) {
      return 'La contraseña debe tener al menos 8 caracteres';
    }
    return null;
  }
  
  static String? number(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? "Este campo"} es obligatorio';
    }
    
    if (double.tryParse(value) == null) {
      return 'Ingresa un número válido';
    }
    return null;
  }
  
  static String? positiveNumber(String? value, {String? fieldName}) {
    final numberError = number(value, fieldName: fieldName);
    if (numberError != null) return numberError;
    
    if (double.parse(value!) <= 0) {
      return '${fieldName ?? "Este campo"} debe ser mayor a 0';
    }
    return null;
  }
}
