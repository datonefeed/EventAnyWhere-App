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

  String? name;
  String? email;
  String? phone;
  String? description;
  String? address;
  String? hobbies;
  String? profileImageUrl;
  String? role;

  Future<void> loadUserProfile() async {
    isLoading = true;
    notifyListeners();

    try {
      final user = await _authService.getUserProfile();
      if (user is Map<String, dynamic>) {
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
        } else if (hobbiesData is String) {
          hobbies = hobbiesData;
        } else {
          hobbies = null;
        }
      } else {
        errorMessage = 'Invalid user data format';
      }
    } catch (e) {
      errorMessage = 'An error occurred: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        profileImage = File(pickedFile.path);
      } else {
        errorMessage = 'No image selected';
      }
    } catch (e) {
      errorMessage = 'An error occurred while picking image: $e';
    } finally {
      notifyListeners();
    }
  }

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

    try {
      if (profileImage != null) {
        success = await _authService.updateProfileWithImage(
            profileData, profileImage);
      } else {
        success = await _authService.updateProfileWithoutImage(profileData);
      }

      if (!success) {
        errorMessage = 'Failed to update profile';
      }
    } catch (e) {
      errorMessage = 'An error occurred: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    try {
      await _authService.clearTokens();
      _eventViewModel.clearEventsList();
    } catch (e) {
      errorMessage = 'Failed to logout: $e';
    } finally {
      notifyListeners();
    }
  }

  Future<bool> becomeOrganizer() async {
    isLoading = true;
    errorMessage = '';
    notifyListeners();

    bool success = false;
    try {
      success = await _authService.becomeOrganizer();

      if (!success) {
        errorMessage = "Failed to update role to organizer.";
      }
    } catch (e) {
      errorMessage = 'An error occurred: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
    return success;
  }

  bool isOrganizer() {
    return role == 'organizer';
  }
}
