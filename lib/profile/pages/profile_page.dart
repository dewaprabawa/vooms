import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vooms/authentication/pages/blocs/app_state_cubit/app_state_cubit.dart';
import 'package:vooms/authentication/repository/user_entity.dart';
import 'package:vooms/profile/pages/cubit/profile_cubit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vooms/shareds/components/app_dialog.dart';
import 'package:vooms/shareds/general_helper/ui_color_constants.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shimmer/shimmer.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    Future.microtask(
        () async => await context.read<ProfileCubit>().getProfile());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AppStateCubit, AppStateState>(
          listener: (context, state) {
            if (state.appStateStatus == AppStateStatus.failure) {
              AppDialog.snackBarModal(context, message: "Terjadi kesalahan.");
            }
          },
        ),
        BlocListener<ProfileCubit, ProfileState>(
          listener: (context, state) {
             if(state.userStateStatus == UserStateStatus.imageUploaded){
                AppDialog.snackBarModal(context, message: "Profile berhasil diupload.");
             }else if(state.userStateStatus == UserStateStatus.imageUploaded){
                AppDialog.snackBarModal(context, message: "Terjadi kesalahan.");
             } 
          },
        ),
      ],
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              BlocBuilder<ProfileCubit, ProfileState>(
                  builder: (context, state) {
                switch (state.userStateStatus) {
                  case UserStateStatus.initial:
                    return const _LoadingShimmer();
                  case UserStateStatus.loaded:
                    return _BuildDetailHeader(
                      entity: state.entity!,
                    );
                  case UserStateStatus.failure:
                    return _ErrorTextMessage(text: state.mesaage);
                  case UserStateStatus.loading:
                    return const _LoadingShimmer();
                  default:
                    return const _LoadingShimmer();
                }
              }),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Tentang saya',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean euismod bibendum laoreet. Proin gravida dolor sit amet lacus accumsan et viverra justo commodo.',
                        style: GoogleFonts.dmMono(
                          fontSize: 16,
                          color: Colors.grey.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              TextButton(
                  onPressed: () async {
                    await context.read<AppStateCubit>().signOut();
                  },
                  child: Text("SignOut", style: GoogleFonts.dmMono()))
            ],
          ),
        ),
      ),
    );
  }
}

class _ErrorTextMessage extends StatelessWidget {
  const _ErrorTextMessage({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(text),
    );
  }
}

class _LoadingShimmer extends StatelessWidget {
  const _LoadingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: double.infinity,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomRight,
              colors: [
                Colors.black.withOpacity(0.9),
                Colors.black.withOpacity(0.3),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const SizedBox(
                height: 10,
              ),
              CircleAvatar(
                radius: 50,
                child: Container(),
              ),
              const SizedBox(height: 10),
              Text(
                '',
                style: GoogleFonts.dmMono(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                '',
                style: GoogleFonts.dmMono(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                '',
                style: GoogleFonts.dmMono(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
    ;
  }
}

class _BuildDetailHeader extends StatelessWidget {
  const _BuildDetailHeader({super.key, required this.entity});
  final UserEntity entity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(entity.photoUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomRight,
            colors: [
              Colors.black.withOpacity(0.9),
              Colors.black.withOpacity(0.3),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const SizedBox(
              height: 10,
            ),
            ImagePickerButton(
              onImageSelected: (File file) async {
                await context
                    .read<ProfileCubit>()
                    .updateImage(file)
                    .whenComplete(() {});
              },
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(entity.photoUrl),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              entity.fullname,
              style: GoogleFonts.dmMono(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              entity.email,
              style: GoogleFonts.dmMono(
                color: Colors.white.withOpacity(0.7),
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              entity.phone,
              style: GoogleFonts.dmMono(
                color: Colors.white.withOpacity(0.7),
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class ImagePickerButton extends StatefulWidget {
  final Function(File) onImageSelected;
  final Widget child;

  const ImagePickerButton({
    super.key,
    required this.child,
    required this.onImageSelected,
  });

  @override
  _ImagePickerButtonState createState() => _ImagePickerButtonState();
}

class _ImagePickerButtonState extends State<ImagePickerButton> {
  // Selected image after picking
  File? _image;
  // Define a function to pick an image from either the camera or gallery
  Future<void> _pickImage(ImageSource source) async {
    try {
      // Use the ImagePicker plugin to pick an image from the specified source
      final pickedImage =
          await ImagePicker().pickImage(source: source, imageQuality: 70);
      // If an image was picked, update the state with the new image
      //and call the onImageSelected callback
      if (pickedImage != null) {
        setState(() {
          _image = File(pickedImage.path);
        });
        widget.onImageSelected(_image!);
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
      }
    } catch (e) {
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
      AppDialog.snackBarModal(context, message: "Terjadi kesalahan membuka galery atau kamera.");
    }
  }

  Future<bool> requestCameraAndGalleryPermissions() async {
    bool cameraGranted = false;
    bool galleryGranted = false;

    // Request camera permission
    PermissionStatus cameraStatus = await Permission.camera.request();
    if (cameraStatus == PermissionStatus.granted) {
      cameraGranted = true;
    }

    // Request gallery permission
    PermissionStatus galleryStatus = await Permission.storage.request();
    if (galleryStatus == PermissionStatus.granted) {
      galleryGranted = true;
    }

    // Return true if both permissions are granted
    return (cameraGranted && galleryGranted);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: widget.child,
      onTap: () {
        _showBottomSheet(context);
      },
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.2,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ListTile(
                onTap: () async {
                  if (Platform.isAndroid) {
                    bool permissionsGranted =
                        await requestCameraAndGalleryPermissions();
                    if (permissionsGranted) {
                      // Permissions granted, do something
                      await _pickImage(ImageSource.camera);
                    } else {
                      // Navigator.pop(context);
                      // Permissions not granted, handle the error
                    }
                  } else {
                    await _pickImage(ImageSource.camera);
                  }
                },
                leading: const Icon(
                  Icons.camera_alt_outlined,
                  size: 40,
                ),
                subtitle: Text(
                  "Ambil photo langsung dari kamera.",
                  style: GoogleFonts.dmMono(
                    fontWeight: FontWeight.w300,
                    color: UIColorConstant.nativeGrey,
                  ),
                ),
                title: Text(
                  "Kamera",
                  style: GoogleFonts.dmMono(fontWeight: FontWeight.w800),
                ),
              ),
              ListTile(
                onTap: () async {
                  if (Platform.isIOS) {
                    await _pickImage(ImageSource.gallery);
                  } else {
                    bool permissionsGranted =
                        await requestCameraAndGalleryPermissions();
                    if (permissionsGranted) {
                      // Permissions granted, do something
                      await _pickImage(ImageSource.gallery);
                    } else {
                      // Navigator.pop(context);
                      // Permissions not granted, handle the error
                    }
                  }
                },
                leading: const Icon(
                  Icons.image,
                  size: 40,
                ),
                subtitle: Text(
                  "Pilih photo dari galeri.",
                  style: GoogleFonts.dmMono(
                    fontWeight: FontWeight.w300,
                    color: UIColorConstant.nativeGrey,
                  ),
                ),
                title: Text(
                  "Galeri",
                  style: GoogleFonts.dmMono(fontWeight: FontWeight.w800),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
