import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tpi/data/repo/auth_repository.dart';
import 'package:tpi/theme.dart';
import 'package:tpi/ui/auth/bloc/auth_bloc.dart';
import 'package:tpi/ui/home/home.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthScreen extends StatelessWidget {
  AuthScreen({super.key});

  final TextEditingController usernameController =
      TextEditingController(text: 'giliardi');
  final TextEditingController passwordController =
      TextEditingController(text: 'Giliardi*1234');
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<AuthBloc>(
        create: (context) {
          final bloc = AuthBloc(authRepository);
          bloc.stream.forEach((state) {
            if (state is AuthSuccess) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            } else if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.exception.message,
                    textDirection: TextDirection.rtl,
                  ),
                ),
              );
            }
          });
          bloc.add(AuthStarted());
          return bloc;
        },
        child: BlocBuilder<AuthBloc, AuthState>(

          builder: (context, state) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 48, right: 48),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Form(
                    key: _formKey,
                    child: Center(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset('assets/img/company_logo2.png',
                                width: 120),
                            const SizedBox(height: 8),
                            const Text(
                              'خوش آمدید',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'اپلیکیشن بازرسی ایمنی شرکت ملی صنایع مس ایران',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                                'برای ورود نام کاربری و رمز عبور خود را وارد کنید'),
                            const SizedBox(height: 16),
                            _UsernameTextField(
                              usernameController: usernameController,
                              formKey: _formKey,
                            ),
                            const SizedBox(height: 16),
                            _PasswordTextField(
                              passwordController: passwordController,
                              formKey: _formKey,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Checkbox(
                                  value: state.isRememberMe,
                                  onChanged: (value) {
                                    BlocProvider.of<AuthBloc>(context).add(AuthRememberMeIsClicked());
                                  },
                                ),
                                const Text('مرا به خاطر بسپار')
                              ],
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: LightThemeColors.primaryColor,
                                foregroundColor: Colors.white,
                                minimumSize: const Size(double.infinity, 48),
                                padding: const EdgeInsets.all(12.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              onPressed: () {
                                FocusScope.of(context).unfocus();
                                if (_formKey.currentState!.validate()) {
                                  BlocProvider.of<AuthBloc>(context).add(
                                    AuthButtonIsClicked(
                                      usernameController.text,
                                      passwordController.text,
                                    ),
                                  );
                                }
                              },
                              child: state is AuthLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : const Text('ورود'),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'نیاز به راهنمایی دارید؟',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                InkWell(
                                  onTap: () async {
                                    await launchUrl(
                                        Uri.parse('tel://03434305881'));
                                  },
                                  child: const Text(
                                    '5881',
                                    style: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                        decoration: TextDecoration.underline),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const Text('(نوروزی)')
                              ],
                            ),
                            const SizedBox(height: 26),
                            const Row(
                              children: [
                                Expanded(
                                  child: Divider(
                                    color: Colors.grey,
                                    thickness: 1,
                                  ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Text(
                                    'امور هوشمندسازی و فاوا',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Divider(
                                    color: Colors.grey,
                                    thickness: 1,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _UsernameTextField extends StatelessWidget {
  const _UsernameTextField({
    required this.usernameController,
    required GlobalKey<FormState> formKey,
  }) : _formKey = formKey;

  final TextEditingController usernameController;
  final GlobalKey<FormState> _formKey;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: usernameController,
      decoration: const InputDecoration(
        label: Text('نام کاربری'),
        suffixIcon: Icon(Iconsax.user),
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'لطفاً نام کاربری را وارد کنید';
        }
        return null;
      },
      onSaved: (value) {
        // مقدار وارد شده را برای استفاده‌های بعدی ذخیره کنید
        usernameController.text = value ?? '';
      },
      autovalidateMode: AutovalidateMode
          .onUserInteraction, // اعتبارسنجی به صورت خودکار هنگام تعامل کاربر
      onEditingComplete: () {
        // عملیات مورد نظر هنگامی که کاربر ویرایش را تمام کرد
        FocusScope.of(context).nextFocus();
      },
      onFieldSubmitted: (value) {
        // عملیات زمانی که کاربر "ارسال" یا "تایید" را زد
        if (_formKey.currentState!.validate()) {
          // اگر اعتبارسنجی موفق بود، عملیات بعدی را انجام دهید
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('اعتبارسنجی موفق بود'),
            ),
          );
        }
      },
      textInputAction:
          TextInputAction.done, // برای نشان دادن دکمه "تایید" در صفحه‌کلید
    );
  }
}

class _PasswordTextField extends StatefulWidget {
  const _PasswordTextField({
    required this.passwordController,
    required GlobalKey<FormState> formKey,
  }) : _formKey = formKey;

  final TextEditingController passwordController;
  final GlobalKey<FormState> _formKey;

  @override
  State<_PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<_PasswordTextField> {
  bool obsecureText = true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.passwordController,
      decoration: InputDecoration(
        label: const Text('رمز عبور'),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              obsecureText = !obsecureText;
            });
          },
          icon: Icon(
            obsecureText ? Iconsax.eye : Iconsax.eye_slash,
          ),
        ),
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'لطفاً رمز عبور را وارد کنید';
        }
        if (value.length < 6) {
          return 'رمز عبور باید حداقل ۶ کاراکتر باشد';
        }
        return null;
      },
      obscureText: obsecureText, // برای مخفی کردن متن رمز عبور
      autovalidateMode: AutovalidateMode
          .onUserInteraction, // اعتبارسنجی به صورت خودکار هنگام تعامل کاربر
      onEditingComplete: () {
        FocusScope.of(context).nextFocus(); // به فیلد بعدی بروید
      },
      onFieldSubmitted: (value) {
        if (widget._formKey.currentState!.validate()) {
          // اگر اعتبارسنجی موفق بود، عملیات بعدی را انجام دهید
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('اعتبارسنجی موفق بود'),
            ),
          );
        }
      },
      textInputAction:
          TextInputAction.done, // برای نشان دادن دکمه "تایید" در صفحه‌کلید
    );
  }
}
