class AppUser {
  String? id;
  String? email;
  String? name;
  String? flatNumber;
  String? mobileNumber;
  bool? isVerified;
  bool? isRejected;
  bool? isAdmin;

  AppUser({
    this.id,
    this.name,
    this.mobileNumber,
    this.flatNumber,
    this.email,
    this.isVerified,
    this.isRejected,
    this.isAdmin,
  });

  AppUser copyWith({
    String? id,
    String? email,
    String? name,
    String? flatNumber,
    String? mobileNumber,
    bool? isVerified,
    bool? isRejected,
    bool? isAdmin,
  }) =>
      AppUser(
          id: id ?? this.id,
          email: email ?? this.email,
          name: name ?? this.name,
          flatNumber: flatNumber ?? this.flatNumber,
          mobileNumber: mobileNumber ?? this.mobileNumber,
          isVerified: isVerified ?? this.isVerified,
          isRejected: isRejected ?? this.isVerified,
          isAdmin: isAdmin ?? this.isAdmin);

  @override
  String toString() {
    return 'User{id: $id, email: $email, name: $name, flatNumber: $flatNumber, mobileNumber: $mobileNumber, isVerified: $isVerified, isRejected: $isRejected, isAdmin: $isAdmin}';
  }

  factory AppUser.fromMap(Map<String, dynamic> json) => AppUser(
        id: json['id'] == null ? null : json['id'],
        name: json['name'] == null ? null : json['name'],
        mobileNumber:
            json['mobileNumber'] == null ? null : json['mobileNumber'],
        flatNumber: json['flatNumber'] == null ? null : json['flatNumber'],
        email: json['email'] == null ? null : json['email'],
        isVerified: json['isVerified'] == null ? false : json['isVerified'],
        isRejected: json['isRejected'] == null ? false : json['isRejected'],
        isAdmin: json['isAdmin'] == null ? false : json['isAdmin'],
      );

  Map<String, dynamic> toMap() => {
        'id': id == null ? null : id,
        'name': name == null ? null : name,
        'mobileNumber': mobileNumber == null ? null : mobileNumber,
        'flatNumber': flatNumber == null ? null : flatNumber,
        'email': email == null ? null : email,
        'isVerified': isVerified == null ? false : isVerified,
        'isRejected': isRejected == null ? false : isRejected,
        'isAdmin': isAdmin == null ? false : isAdmin,
      };
}
