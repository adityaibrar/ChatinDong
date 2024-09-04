import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/theme.dart';
import '../../../../core/utils/image_converter.dart';
import '../../../dashboard/presentation/pages/dashboard_page.dart';
import '../bloc/authentication_bloc.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_texfield.dart';

class SetUpProfileScreen extends StatefulWidget {
  static const String routeName = '/set-up-profile';
  const SetUpProfileScreen({super.key});

  @override
  State<SetUpProfileScreen> createState() => _SetUpProfileScreenState();
}

class _SetUpProfileScreenState extends State<SetUpProfileScreen> {
  final TextEditingController _usernameController = TextEditingController();
  XFile? selectedImage;

  Future<void> selectImage() async {
    final imagePicker = ImagePicker();
    final XFile? image =
        await imagePicker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        selectedImage = image;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    final state = context.read<AuthenticationBloc>().state;
    if (state is ProfileNotSetUp) {
      _usernameController.text = state.user.name;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is SuccessSetUp) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Berhasil memperbarui profile')));
          Navigator.pushNamed(context, DashboardPage.routeName);
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.e)));
        }
      },
      builder: (context, state) {
        // Mendapatkan imageUrl dari state
        final imageUrl = state is ProfileNotSetUp ? state.user.imageUrl : null;

        return Scaffold(
          appBar: AppBar(
            backgroundColor: primaryColor,
            automaticallyImplyLeading: false,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SvgPicture.asset('assets/icons/logo_app_bar.svg'),
            ),
            title: Text(
              'Chatin Dong',
              style: whiteTextStyle.copyWith(
                fontSize: 18,
                fontWeight: semiBold,
              ),
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Center(
                child: Text(
                  'Perbarui Profil Anda',
                  style: blackTextStyle.copyWith(
                    fontWeight: medium,
                    fontSize: 28,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: secondaryColor.withOpacity(0.4),
                      image: selectedImage == null
                          ? (imageUrl != null && imageUrl.isNotEmpty
                              ? DecorationImage(
                                  fit: BoxFit.cover,
                                  image: base64ToImageProvider(imageUrl),
                                )
                              : null)
                          : DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(selectedImage!.path)),
                            ),
                    ),
                    child: selectedImage == null &&
                            (imageUrl == null || imageUrl.isEmpty)
                        ? Icon(
                            Icons.person,
                            size: 180,
                            color: whiteColor,
                          )
                        : null,
                  ),
                  Positioned(
                    top: 0,
                    right: 90,
                    child: GestureDetector(
                      onTap: selectImage,
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: primaryColor,
                        ),
                        child: Icon(
                          Icons.edit,
                          color: whiteColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              InputField(
                controller: _usernameController,
                labelText: 'Username',
                preffixIcon: Icons.person,
              ),
            ],
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(16),
            child: CustomButton(
              title: 'Simpan',
              titleColor: whiteColor,
              backgroundColor: primaryColor,
              onPressed: () {
                // if (selectedImage == null) {
                //   ScaffoldMessenger.of(context).showSnackBar(
                //     const SnackBar(
                //       content: Text('Silakan pilih gambar terlebih dahulu.'),
                //     ),
                //   );
                //   return;
                // }

                try {
                  // Mengecek apakah user sudah memilih gambar atau belum
                  String base64Image = selectedImage != null
                      ? imageToBase64Provider(selectedImage!.path)
                      : imageUrl.toString();

                  context.read<AuthenticationBloc>().add(
                        SetUpProfileEvent(
                          imageUrl: base64Image,
                          userName: _usernameController.text,
                        ),
                      );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Terjadi kesalahan saat memproses gambar.'),
                    ),
                  );
                }
              },
              size: const Size(double.infinity, 50),
            ),
          ),
        );
      },
    );
  }
}
