import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:email_validator/email_validator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jr_case_boilerplate/features/auth/views/register_view.dart';
import 'package:jr_case_boilerplate/features/auth/widgets/auth_rich_text.dart';
import 'package:jr_case_boilerplate/features/home/view/home_view.dart';
import 'package:jr_case_boilerplate/l10n/app_localizations.dart';
import 'package:lottie/lottie.dart';
import '../services/auth_service.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _scrollController = ScrollController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  late AnimationController _lottieController;

  @override
  void initState() {
    super.initState();
    _lottieController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _lottieController.repeat();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _scrollController.dispose();
    _lottieController.dispose();
    super.dispose();
  }

  // Responsive breakpoints
  bool _isMobile(double width) => width < 600;
  bool _isTablet(double width) => width >= 600 && width < 1024;

  // Responsive sizing methods
  double _getResponsivePadding(double screenWidth) {
    if (_isMobile(screenWidth)) return 16.0;
    if (_isTablet(screenWidth)) return 32.0;
    return 48.0;
  }

  double _getResponsiveFontSize(double screenWidth, double baseFontSize) {
    double scaleFactor = 1.0;
    if (_isMobile(screenWidth)) {
      scaleFactor = screenWidth < 360 ? 0.85 : 1.0;
    } else if (_isTablet(screenWidth)) {
      scaleFactor = 1.1;
    } else {
      scaleFactor = 1.2;
    }
    return baseFontSize * scaleFactor;
  }

  double _getResponsiveIconSize(double screenWidth, double baseIconSize) {
    if (_isMobile(screenWidth)) return baseIconSize;
    if (_isTablet(screenWidth)) return baseIconSize * 1.2;
    return baseIconSize * 1.4;
  }

  double _getMaxContentWidth(double screenWidth) {
    if (_isMobile(screenWidth)) return screenWidth;
    if (_isTablet(screenWidth)) return 500;
    return 400;
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _login() async {
    final currentScrollOffset = _scrollController.hasClients ? _scrollController.offset : 0.0;
    
    if (!_formKey.currentState!.validate()) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            currentScrollOffset,
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeOut,
          );
        }
      });
      return;
    }

    setState(() => _isLoading = true);

    try {
      final result = await AuthService.login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (result['success']) {
        _lottieController.forward();
        await Future.delayed(const Duration(milliseconds: 800));
        
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeView(),
          ),
        );
      } else {
        _showSnackBar(result['message'], isError: true);
      }
    } catch (e) {
      _showSnackBar('${AppLocalizations.of(context)!.unexpectedError}: $e', isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            tileMode: TileMode.clamp,
            center: Alignment.topCenter,
            radius: 2,
            colors: [
              Color.fromARGB(255, 216, 5, 16),
              Color.fromARGB(255, 158, 12, 22),
              Color.fromARGB(255, 53, 5, 5),
              Color(0xFF090909),
            ],
            stops: [0.0, 0.1, 0.2, 0.9],
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = constraints.maxWidth;
            final screenHeight = MediaQuery.of(context).size.height;
            final responsivePadding = _getResponsivePadding(screenWidth);
            final maxContentWidth = _getMaxContentWidth(screenWidth);

            return SafeArea(
              child: Center(
                child: Container(
                  width: maxContentWidth,
                  height: screenHeight,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(
                      responsivePadding, 
                      0,
                      responsivePadding, 
                      responsivePadding + MediaQuery.of(context).viewInsets.bottom + 20
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Responsive spacing
                          // SizedBox(height: _isMobile(screenWidth) ? 10 : 20),
                          
                          // Lottie Animation - responsive
                          Container(
                            alignment: Alignment.topCenter,
                            height: _isMobile(screenWidth) ? 180 : 230,
                            width: double.infinity,
                            child: Lottie.asset(
                              'assets/Artboard_1.json',
                              controller: _lottieController,
                              height: _isMobile(screenWidth) ? 180 : 230,
                              width: double.infinity,
                              fit: BoxFit.contain,
                              repeat: true,
                              animate: true,
                              frameRate: FrameRate.max,
                              options: LottieOptions(
                                enableMergePaths: true,
                              ),
                              onLoaded: (composition) {
                                _lottieController.duration = composition.duration;
                                _lottieController.repeat();
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: _isMobile(screenWidth) ? 150 : 180,
                                  width: double.infinity,
                                  color: Colors.transparent,
                                  child: Center(
                                    child: Icon(
                                      Icons.movie_creation_outlined,
                                      color: Colors.white,
                                      size: _getResponsiveIconSize(screenWidth, 50),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          
                          SizedBox(height: _isMobile(screenWidth) ? 8 : 10),
                          
                          // Logo - responsive
                          Image.asset(
                            'assets/Icon.png',
                            width: _getResponsiveIconSize(screenWidth, 120),
                            height: _getResponsiveIconSize(screenWidth, 120),
                          ),
                          
                          SizedBox(height: _isMobile(screenWidth) ? 12 : 14),
                          
                          // Title - responsive
                          Text(
                            AppLocalizations.of(context)!.loginTitle,
                            style: GoogleFonts.instrumentSans(
                              fontSize: _getResponsiveFontSize(screenWidth, 28),
                              fontWeight: FontWeight.bold,
                              color: Colors.white70,
                            ),
                          ),
                          
                          SizedBox(height: _isMobile(screenWidth) ? 6 : 8),
                          
                          // Subtitle - responsive
                          Text(
                            AppLocalizations.of(context)!.loginSubtitle,
                            style: GoogleFonts.instrumentSans(
                              fontSize: _getResponsiveFontSize(screenWidth, 16),
                              color: Colors.white70,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          
                          SizedBox(height: _isMobile(screenWidth) ? 24 : 28),
                          
                          // Form - responsive
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                // Email field
                                AuthRichText(
                                  hintText: AppLocalizations.of(context)!.email,
                                  prefixAsset: 'assets/Mail.png',
                                  keyboardType: TextInputType.emailAddress,
                                  controller: _emailController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return AppLocalizations.of(context)!.emailRequired;
                                    }
                                    if (!EmailValidator.validate(value)) {
                                      return AppLocalizations.of(context)!.validEmailRequired;
                                    }
                                    return null;
                                  },
                                ),
                                
                                SizedBox(height: _isMobile(screenWidth) ? 12 : 16),
                                
                                // Password field
                                AuthRichText(
                                  hintText: AppLocalizations.of(context)!.password,
                                  prefixAsset: 'assets/Lock.png',
                                  obscureText: _obscurePassword,
                                  controller: _passwordController,
                                  suffixAssetVisible: 'assets/See.png',
                                  suffixAssetHidden: 'assets/Hide.png',
                                  onSuffixTap: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return AppLocalizations.of(context)!.passwordRequired;
                                    }
                                    if (value.length < 6) {
                                      return AppLocalizations.of(context)!.passwordMinLength;
                                    }
                                    return null;
                                  },
                                ),
                                
                                SizedBox(height: _isMobile(screenWidth) ? 6 : 8),
                                
                                // Forgot Password - responsive
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      AppLocalizations.of(context)!.forgotPassword,
                                      style: GoogleFonts.instrumentSans(
                                        color: Colors.white,
                                        fontSize: _getResponsiveFontSize(screenWidth, 14),
                                      ),
                                    ),
                                  ),
                                ),
                                
                                SizedBox(height: _isMobile(screenWidth) ? 12 : 14),
                                
                                // Login Button - responsive
                                SizedBox(
                                  width: double.infinity,
                                  height: _isMobile(screenWidth) ? 48 : 52,
                                  child: ElevatedButton(
                                    onPressed: _isLoading ? null : _login,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFCC0000),
                                      foregroundColor: const Color(0xFFFFFFFF),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      elevation: 2,
                                    ),
                                    child: _isLoading
                                        ? SpinKitThreeBounce(
                                            color: Colors.white,
                                            size: _isMobile(screenWidth) ? 18 : 20,
                                          )
                                        : Text(
                                            AppLocalizations.of(context)!.login,
                                            style: GoogleFonts.instrumentSans(
                                              fontSize: _getResponsiveFontSize(screenWidth, 16),
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          SizedBox(height: _isMobile(screenWidth) ? 20 : 22),
                          
                          // Social Buttons - responsive
                          _buildSocialButtons(screenWidth),
                          
                          SizedBox(height: _isMobile(screenWidth) ? 20 : 22),
                          
                          // Register Link - responsive
                          _buildRegisterLink(screenWidth),
                        ],
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

  Widget _buildSocialButtons(double screenWidth) {
    return Column(
      children: [
        Text(
          AppLocalizations.of(context)!.or,
          style: GoogleFonts.instrumentSans(
            color: Colors.white.withOpacity(0.7),
            fontSize: _getResponsiveFontSize(screenWidth, 14),
          ),
        ),
        SizedBox(height: _isMobile(screenWidth) ? 16 : 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSocialButton(
              asset: 'assets/Google.png',
              onTap: () {},
              screenWidth: screenWidth,
            ),
            SizedBox(width: _isMobile(screenWidth) ? 12 : 16),
            _buildSocialButton(
              asset: 'assets/Apple.png',
              onTap: () {},
              screenWidth: screenWidth,
            ),
            SizedBox(width: _isMobile(screenWidth) ? 12 : 16),
            _buildSocialButton(
              asset: 'assets/Facebook.png',
              onTap: () {},
              screenWidth: screenWidth,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required String asset,
    required VoidCallback onTap,
    required double screenWidth,
  }) {
    final buttonSize = _isMobile(screenWidth) ? 52.0 : 56.0;
    final iconSize = _isMobile(screenWidth) ? 20.0 : 24.0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: buttonSize,
        height: buttonSize,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.07),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Center(
          child: Image.asset(
            asset,
            width: iconSize,
            height: iconSize,
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterLink(double screenWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppLocalizations.of(context)!.dontHaveAccount,
          style: GoogleFonts.instrumentSans(
            color: Colors.white70,
            fontSize: _getResponsiveFontSize(screenWidth, 14),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const RegisterView(),
              ),
            );
          },
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            AppLocalizations.of(context)!.register,
            style: GoogleFonts.instrumentSans(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: _getResponsiveFontSize(screenWidth, 14),
            ),
          ),
        ),
      ],
    );
  }
}