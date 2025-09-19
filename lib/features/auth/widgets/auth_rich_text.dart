import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthRichText extends StatefulWidget {
  final String hintText;
  final String? labelText;
  final String? prefixAsset;
  final IconData? prefixIcon;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final String? suffixAssetVisible;
  final String? suffixAssetHidden;
  final VoidCallback? onSuffixTap;
  final bool enabled;
  final int maxLines;

  const AuthRichText({
    Key? key,
    required this.hintText,
    this.labelText,
    this.prefixAsset,
    this.prefixIcon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    required this.controller,
    this.validator,
    this.suffixIcon,
    this.suffixAssetVisible,
    this.suffixAssetHidden,
    this.onSuffixTap,
    this.enabled = true,
    this.maxLines = 1,
  }) : super(key: key);

  @override
  State<AuthRichText> createState() => _AuthRichTextState();
}

class _AuthRichTextState extends State<AuthRichText> {
  String? _currentError;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 76, // Sabit toplam yükseklik: 56 (field) + 20 (error space)
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.labelText != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                widget.labelText!,
                style: GoogleFonts.instrumentSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          Container(
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _currentError != null 
                    ? const Color.fromARGB(255, 244, 113, 113)
                    : Colors.white24,
                width: 1,
              ),
            ),
            child: TextFormField(
              controller: widget.controller,
              obscureText: widget.obscureText,
              keyboardType: widget.keyboardType,
              enabled: widget.enabled,
              maxLines: widget.maxLines,
              style: GoogleFonts.instrumentSans(color: Colors.white),
              validator: (value) {
                if (widget.validator == null) return null;
                final error = widget.validator!(value);
                
                // Error state'i güncelle ama setState kullanma
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted && _currentError != error) {
                    setState(() {
                      _currentError = error;
                    });
                  }
                });
                
                return error;
              },
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: const TextStyle(color: Colors.white54),
                prefixIcon: _buildPrefixIcon(),
                suffixIcon: _buildSuffixIcon(),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                errorStyle: const TextStyle(fontSize: 0, height: 0),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
            ),
          ),
          // Error mesajı için sabit alan
          SizedBox(
            height: 20,
            child: _currentError != null
                ? Padding(
                    padding: const EdgeInsets.only(top: 4, left: 16),
                    child: Text(
                      _currentError!,
                      style: GoogleFonts.instrumentSans(
                        color: Color.fromARGB(255, 244, 113, 113),
                        fontSize: 12,
                      ),
                    ),
                  )
                : null,
          ),
        ],
      ),
    );
  }

  Widget? _buildPrefixIcon() {
    if (widget.prefixAsset != null) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Image.asset(
          widget.prefixAsset!,
          width: 20,
          height: 20,
          color: Colors.white54,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(
              Icons.error_outline,
              color: Colors.white54,
              size: 20,
            );
          },
        ),
      );
    } else if (widget.prefixIcon != null) {
      return Icon(
        widget.prefixIcon,
        color: Colors.white54,
      );
    }
    return null;
  }

  Widget? _buildSuffixIcon() {
    if (widget.suffixAssetVisible != null && widget.suffixAssetHidden != null) {
      return GestureDetector(
        onTap: widget.onSuffixTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Image.asset(
            widget.obscureText ? widget.suffixAssetHidden! : widget.suffixAssetVisible!,
            width: 20,
            height: 20,
            color: Colors.white54,
            errorBuilder: (context, error, stackTrace) {
              return Icon(
                widget.obscureText ? Icons.visibility_off : Icons.visibility,
                color: Colors.white54,
                size: 20,
              );
            },
          ),
        ),
      );
    }
    
    return widget.suffixIcon;
  }
}