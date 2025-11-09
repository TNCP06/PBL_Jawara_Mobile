import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawara_pintar_kel_5/constants/constant_colors.dart';
import 'package:jawara_pintar_kel_5/screens/auth/auth.dart';
import 'package:jawara_pintar_kel_5/widget/drop_down_trailing_arrow.dart';
import 'package:jawara_pintar_kel_5/widget/login_button.dart';
import 'package:jawara_pintar_kel_5/widget/text_input_login.dart';
import 'package:moon_design/moon_design.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String? errorMessage;
  bool isLogin = true;

  final TextEditingController _controllerEmail = TextEditingController(
    text: '',
  );
  final TextEditingController _controllerPassword = TextEditingController(
    text: '',
  );

  Future<void> createUserWithEmailAndPassword() async {
    try {
      await Auth().createUserWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );

      // Navigasi ke halaman dashboard setelah berhasil login
      context.go('/login');
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  late final TextEditingController _namaController,
      _nikController,
      _emailController,
      _phoneController,
      _passwordController,
      _confirmPasswordController,
      _alamatController;

  @override
  void initState() {
    _namaController = TextEditingController();
    _nikController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _alamatController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _namaController.dispose();
    _nikController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _alamatController.dispose();
    super.dispose();
  }

  final Map<int, String> _jenisKelamin = {1: 'Laki-laki', 0: 'Perempuan'};
  bool? _isLakilaki;
  bool _showDdKelamin = false;

  bool _showDdPilihRumah = false;

  bool _showDdPilihKelurahan = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: Row(
          spacing: 12,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MoonButton.icon(
              onTap: () => context.go('/login'),
              icon: Icon(MoonIcons.controls_chevron_left_32_regular),
            ),
            Text(
              "Daftar",
              style: MoonTokens.light.typography.heading.text40.copyWith(
                color: MoonTokens.light.colors.piccolo,
                fontWeight: FontWeight.w700,
              ),
              textScaler: TextScaler.linear(0.7),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(right: 24, left: 24),
            child: Column(
              spacing: 8,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Daftar untuk mengakses sistem Jawara Pintar.',
                  style: MoonTokens.light.typography.body.text14,
                ),
                const SizedBox(height: 8),
                inputGroup(
                  title: 'Identitas',
                  children: [
                    TextInputLogin(
                      controller: _namaController,
                      hint: 'Nama Lengkap',
                      keyboardType: TextInputType.name,
                    ),
                    TextInputLogin(
                      controller: _nikController,
                      hint: 'NIK',
                      keyboardType: TextInputType.number,
                    ),
                    MoonDropdown(
                      show: _showDdKelamin,
                      constrainWidthToChild: true,
                      onTapOutside: () =>
                          setState(() => _showDdKelamin = false),
                      content: Column(
                        children: [
                          MoonMenuItem(
                            absorbGestures: true,
                            onTap: () => setState(() {
                              _showDdKelamin = false;
                              _isLakilaki = true;
                            }),
                            label: Text(_jenisKelamin[1]!),
                          ),
                          MoonMenuItem(
                            absorbGestures: true,
                            onTap: () => setState(() {
                              _showDdKelamin = false;
                              _isLakilaki = false;
                            }),
                            label: Text(_jenisKelamin[0]!),
                          ),
                        ],
                      ),
                      child: dropDownChild(
                        hintText: _isLakilaki == null
                            ? 'Jenis Kelamin'
                            : _isLakilaki!
                            ? 'Laki-Laki'
                            : 'Perempuan',
                        isShow: _showDdKelamin,
                        setState: () =>
                            setState(() => _showDdKelamin = !_showDdKelamin),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 100,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: MoonTokens.light.colors.goku,
                        border: Border.all(
                          color: MoonTokens.light.colors.beerus,
                        ),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {},
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(MoonIcons.generic_picture_32_light),
                              Text(
                                'Upload foto KK/KTP (.jpg/.png)',
                                style:
                                    MoonTokens.light.typography.heading.text14,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                inputGroup(
                  title: 'Akun',
                  children: [
                    TextInputLogin(
                      controller: _controllerEmail,
                      hint: 'Email',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    TextInputLogin(
                      controller: _phoneController,
                      hint: 'No Telepone',
                      keyboardType: TextInputType.phone,
                    ),
                    TextInputLogin(
                      controller: _controllerPassword,
                      hint: 'Password',
                      isPassword: true,
                      trailing: Center(
                        child: Text(
                          'Show',
                          style: MoonTokens.light.typography.body.text14
                              .copyWith(decoration: TextDecoration.underline),
                        ),
                      ),
                    ),
                    TextInputLogin(
                      controller: _confirmPasswordController,
                      hint: 'Konfirmasi Password',
                      isPassword: true,
                      trailing: Center(
                        child: Text(
                          'Show',
                          style: MoonTokens.light.typography.body.text14
                              .copyWith(decoration: TextDecoration.underline),
                        ),
                      ),
                    ),
                  ],
                ),
                inputGroup(
                  title: 'Alamat',
                  children: [
                    MoonDropdown(
                      show: _showDdPilihRumah,
                      constrainWidthToChild: true,
                      onTapOutside: () =>
                          setState(() => _showDdPilihRumah = false),
                      content: Column(
                        children: [
                          MoonMenuItem(
                            label: Text('data'),
                            onTap: () => setState(
                              () => _showDdPilihRumah = !_showDdPilihRumah,
                            ),
                          ),
                        ],
                      ),
                      child: dropDownChild(
                        hintText: 'Pilih Rumah',
                        isShow: _showDdPilihRumah,
                        setState: () => setState(
                          () => _showDdPilihRumah = !_showDdPilihRumah,
                        ),
                      ),
                    ),
                    TextInputLogin(
                      controller: _alamatController,
                      hint: 'Alamat (Jika tidak ada di list)',
                      keyboardType: TextInputType.streetAddress,
                    ),
                    MoonDropdown(
                      show: _showDdPilihKelurahan,
                      constrainWidthToChild: true,
                      onTapOutside: () =>
                          setState(() => _showDdPilihKelurahan = false),
                      content: Column(
                        children: [
                          MoonMenuItem(
                            label: Text('data'),
                            onTap: () => setState(
                              () => _showDdPilihKelurahan =
                                  !_showDdPilihKelurahan,
                            ),
                          ),
                        ],
                      ),
                      child: dropDownChild(
                        hintText: 'Status kepemilikan rumah',
                        isShow: _showDdPilihKelurahan,
                        setState: () => setState(
                          () => _showDdPilihKelurahan = !_showDdPilihKelurahan,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                LoginButton(
                  text: 'Daftar',
                  onTap: () {
                    createUserWithEmailAndPassword();
                  },
                  withColor: true,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        height: 1,
                        margin: const EdgeInsets.only(right: 8.0),
                        color: ConstantColors.separatorColor,
                      ),
                    ),
                    Text(
                      'Sudah punya akun?',
                      style: MoonTokens.light.typography.body.text12.copyWith(
                        color: ConstantColors.separatorColor,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 1,
                        margin: const EdgeInsets.only(left: 8.0),
                        color: ConstantColors.separatorColor,
                      ),
                    ),
                  ],
                ),
                LoginButton(
                  text: 'Login',
                  onTap: () => context.go('/login'),
                  withColor: false,
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  MoonTextInput dropDownChild({
    required String hintText,
    required bool isShow,
    required VoidCallback setState,
  }) {
    return MoonTextInput(
      textInputSize: MoonTextInputSize.xl,
      readOnly: true,
      hintText: hintText,
      onTap: setState,
      trailing: DropDownTrailingArrow(isShow: isShow),
    );
  }

  Column inputGroup({required String title, required List<Widget> children}) {
    return Column(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: MoonTokens.light.typography.heading.text16),
        ...children,
      ],
    );
  }
}
