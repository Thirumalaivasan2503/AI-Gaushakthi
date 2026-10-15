/// Target User Roles in the Indigenous Livestock AgriTech System
enum UserRole {
  ruralFarmer('Rural Farmer', 'Smallholder and traditional cattle & goat farmers'),
  urbanFarmer('Urban Farmer', 'Peri-urban, dairy entrepreneurs & modern livestock growers'),
  veterinaryExpert('Veterinary Expert', 'Registered vets, animal health officers & breeding specialists'),
  administrator('Administrator', 'AgriTech system managers & government livestock officers');

  final String title;
  final String description;

  const UserRole(this.title, this.description);
}
