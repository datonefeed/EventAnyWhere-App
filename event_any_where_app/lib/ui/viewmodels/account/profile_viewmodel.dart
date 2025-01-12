import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:event_any_where_app/services/auth_service.dart';
import '../event/event_viewmodel.dart';

class ProfileViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final EventViewModel _eventViewModel = EventViewModel();
  bool isLoading = false;
  String errorMessage = '';
  File? profileImage;

  // Thông tin người dùng
  String? name;
  String? email;
  String? phone;
  String? description;
  String? address;
  String? hobbies;
  String? profileImageUrl;
  String? role;

  // Phương thức để tải thông tin người dùng từ backend
  Future<void> loadUserProfile() async {
    isLoading = true;
    notifyListeners();

    final user = await _authService.getUserProfile();
    if (user != null) {
      name = user['name'];
      email = user['email'];
      phone = user['phone'];
      description = user['description'];
      address = user['address'];
      profileImageUrl = user['image'];
      role = user['role'];
      var hobbiesData = user['hobbies'];
      if (hobbiesData is List) {
        hobbies = hobbiesData.join(', ');
      } else {
        hobbies = hobbiesData as String?;
      }
    } else {
      errorMessage = 'Failed to load profile information';
    }

    isLoading = false;
    notifyListeners();
  }

  // Hàm chọn ảnh từ thư viện
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      notifyListeners();
    }
  }

  // Phương thức để cập nhật thông tin người dùng
  Future<void> updateUserProfile() async {
    isLoading = true;
    errorMessage = '';
    notifyListeners();

    final profileData = {
      'name': name,
      'phone': phone,
      'description': description,
      'address': address,
      'hobbies': hobbies,
    };

    bool success;

    // Kiểm tra nếu có ảnh thì gọi phương thức cập nhật có ảnh, ngược lại gọi phương thức không có ảnh
    if (profileImage != null) {
      success =
          await _authService.updateProfileWithImage(profileData, profileImage);
    } else {
      success = await _authService.updateProfileWithoutImage(profileData);
    }

    if (!success) {
      errorMessage = 'Failed to update profile';
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> logout() async {
    await _authService.clearTokens();
    _eventViewModel.clearEventsList();
    notifyListeners();
  }

  //phương thức trở thành organizer
  Future<bool> becomeOrganizer() async {
    isLoading = true;
    errorMessage = '';
    notifyListeners();

    final success = await _authService.becomeOrganizer();

    if (!success) {
      errorMessage = "Failed to update role to organizer.";
    }

    isLoading = false;
    notifyListeners();
    return success;
  }

  //phương thức kiểm tra role
  bool isOrganizer() {
    return role == 'organizer';
  }
}
