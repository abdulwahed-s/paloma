import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paloma/controllers/auth_controller.dart';
import 'package:paloma/presentation/widgets/auth/login/email_form_field.dart';
import 'package:paloma/presentation/widgets/auth/login/or_divider.dart';
import 'package:paloma/presentation/widgets/auth/sign_up/confirm_password_form_field.dart';
import 'package:paloma/presentation/widgets/auth/sign_up/password_form_field.dart';
import 'package:paloma/presentation/widgets/auth/sign_up/sign_in_prompt.dart';
import 'package:paloma/presentation/widgets/auth/sign_up/sign_up_button.dart';
import 'package:paloma/presentation/widgets/auth/sign_up/sign_up_header.dart';
import 'package:paloma/presentation/widgets/auth/sign_up/terms_checkbox.dart';
import 'package:paloma/presentation/widgets/auth/sign_up/username_form_field.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final usernameC = TextEditingController();
  final emailC = TextEditingController();
  final passC = TextEditingController();
  final confirmPassC = TextEditingController();
  final usernameFocus = FocusNode();
  final emailFocus = FocusNode();
  final passFocus = FocusNode();
  final confirmPassFocus = FocusNode();

  bool isObscured = true;
  bool isConfirmObscured = true;
  bool agreeToTerms = false;

  final AuthController _authController = Get.find<AuthController>();

  @override
  void dispose() {
    usernameC.dispose();
    emailC.dispose();
    passC.dispose();
    confirmPassC.dispose();
    usernameFocus.dispose();
    emailFocus.dispose();
    passFocus.dispose();
    confirmPassFocus.dispose();
    super.dispose();
  }

  void changeObscure(bool value) {
    setState(() => isObscured = value);
  }

  void changeConfirmObscure(bool value) {
    setState(() => isConfirmObscured = value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Back button
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: _authController.isLoading
                          ? null
                          : () => Get.back(),
                      icon: const Icon(Icons.arrow_back),
                      style: IconButton.styleFrom(
                        backgroundColor: theme.colorScheme.surface,
                        foregroundColor: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  const SignUpHeader(),

                  const SizedBox(height: 40),

                  // Form
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Username field
                        UsernameFormField(
                          controller: usernameC,
                          focusNode: usernameFocus,
                          nextFocus: emailFocus,
                        ),

                        const SizedBox(height: 16),

                        // Email field
                        EmailFormField(
                          controller: emailC,
                          focusNode: emailFocus,
                          nextFocus: passFocus,
                        ),

                        const SizedBox(height: 16),

                        // Password field
                        SignUpPasswordFormField(
                          controller: passC,
                          focusNode: passFocus,
                          nextFocus: confirmPassFocus,
                          isObscured: isObscured,
                          onObscureChanged: changeObscure,
                        ),

                        const SizedBox(height: 16),

                        // Confirm password field
                        ConfirmPasswordFormField(
                          controller: confirmPassC,
                          passwordController: passC,
                          focusNode: confirmPassFocus,
                          isObscured: isConfirmObscured,
                          onObscureChanged: changeConfirmObscure,
                          onSubmitted: _handleSignUp,
                        ),

                        const SizedBox(height: 20),

                        // Terms and conditions checkbox
                        TermsCheckbox(
                          value: agreeToTerms,
                          onChanged: (value) {
                            setState(() => agreeToTerms = value ?? false);
                          },
                          onTermsTap: () => _showTermsDialog(context),
                          onPrivacyTap: () => _showPrivacyDialog(context),
                        ),

                        const SizedBox(height: 32),

                        // Sign up button
                        SignUpButton(
                          agreeToTerms: agreeToTerms,
                          onPressed: _handleSignUp,
                        ),

                        const SizedBox(height: 32),

                        // Divider
                        const OrDivider(),

                        const SizedBox(height: 24),

                        // Login link
                        const SignInPrompt(),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleSignUp() {
    if (!agreeToTerms) {
      Get.snackbar(
        'Attention',
        'Please agree to the Terms of Service and Privacy Policy',
        icon: const Icon(Icons.warning, color: Colors.white),
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return;
    }

    if (_formKey.currentState?.validate() ?? false) {
      final email = emailC.text.trim();
      final username = usernameC.text.trim();
      final pass = passC.text;

      _authController.signUp(email: email, password: pass, username: username);
    }
  }

  void _showTermsDialog(BuildContext context) {
    final theme = Theme.of(context);

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.description_outlined, color: theme.colorScheme.primary),
            const SizedBox(width: 8),
            const Text('Terms of Service'),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Last updated: ${DateTime.now().toLocal().toString().split(' ')[0]}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 16),

                _buildSectionTitle('1. Acceptance of Terms', theme),
                _buildSectionContent(
                  'By creating an account and using our service, you acknowledge that you have read, understood, and agree to be bound by these Terms of Service. If you do not agree to these terms, please do not use our service.',
                  theme,
                ),

                _buildSectionTitle('2. Account Responsibilities', theme),
                _buildSectionContent(
                  'You are responsible for maintaining the security of your account and password. You must not share your account credentials with others and must notify us immediately of any unauthorized use of your account.',
                  theme,
                ),

                _buildSectionTitle('3. Acceptable Use', theme),
                _buildSectionContent(
                  'You agree not to use our service for any unlawful purpose or in any way that could damage, disable, or impair our service. You must not attempt to gain unauthorized access to any part of our service.',
                  theme,
                ),

                _buildSectionTitle('4. Service Availability', theme),
                _buildSectionContent(
                  'We strive to maintain high availability of our service, but we cannot guarantee uninterrupted access. We reserve the right to modify or discontinue our service at any time with reasonable notice.',
                  theme,
                ),

                _buildSectionTitle('5. Limitation of Liability', theme),
                _buildSectionContent(
                  'Our liability to you is limited to the fullest extent permitted by law. We are not liable for any indirect, incidental, special, or consequential damages arising from your use of our service.',
                  theme,
                ),

                _buildSectionTitle('6. Changes to Terms', theme),
                _buildSectionContent(
                  'We reserve the right to modify these terms at any time. We will notify users of any material changes via email or through our service. Continued use of our service after changes constitutes acceptance of the new terms.',
                  theme,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Close')),
        ],
      ),
    );
  }

  void _showPrivacyDialog(BuildContext context) {
    final theme = Theme.of(context);

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.privacy_tip_outlined, color: theme.colorScheme.primary),
            const SizedBox(width: 8),
            const Text('Privacy Policy'),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Last updated: ${DateTime.now().toLocal().toString().split(' ')[0]}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 16),

                _buildSectionTitle('1. Information We Collect', theme),
                _buildSectionContent(
                  'We collect information you provide directly to us, such as when you create an account, use our services, or contact us for support. This includes your username, email address, and any other information you choose to provide.',
                  theme,
                ),

                _buildSectionTitle('2. How We Use Your Information', theme),
                _buildSectionContent(
                  'We use the information we collect to provide, maintain, and improve our services, communicate with you, and ensure the security of your account. We may also use your information to send you updates about our service.',
                  theme,
                ),

                _buildSectionTitle('3. Information Sharing', theme),
                _buildSectionContent(
                  'We do not sell, trade, or otherwise transfer your personal information to third parties without your consent, except as described in this policy. We may share information with service providers who assist us in operating our service.',
                  theme,
                ),

                _buildSectionTitle('4. Data Security', theme),
                _buildSectionContent(
                  'We implement appropriate security measures to protect your personal information against unauthorized access, alteration, disclosure, or destruction. However, no method of transmission over the internet is 100% secure.',
                  theme,
                ),

                _buildSectionTitle('5. Data Retention', theme),
                _buildSectionContent(
                  'We retain your personal information for as long as necessary to provide our services and fulfill the purposes outlined in this policy, unless a longer retention period is required by law.',
                  theme,
                ),

                _buildSectionTitle('6. Your Rights', theme),
                _buildSectionContent(
                  'You have the right to access, update, or delete your personal information. You may also opt out of certain communications from us. To exercise these rights, please contact us through our support channels.',
                  theme,
                ),

                _buildSectionTitle('7. Contact Us', theme),
                _buildSectionContent(
                  'If you have any questions about this Privacy Policy or our privacy practices, please contact us at privacy@example.com or through our support system.',
                  theme,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Close')),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Text(
        title,
        style: theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: theme.colorScheme.onSurface,
        ),
      ),
    );
  }

  Widget _buildSectionContent(String content, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        content,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurface.withOpacity(0.8),
          height: 1.5,
        ),
      ),
    );
  }
}
