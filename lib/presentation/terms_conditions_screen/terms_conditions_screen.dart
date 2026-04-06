import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle("1. Agreement to Terms"),
                  _buildSectionContent(
                    "By accessing or using our App, you agree to be bound by these Terms and Conditions and our Privacy Policy. If you do not agree with any part of these terms, you should not use the App.",
                  ),
                  const SizedBox(height: 24),
                  _buildSectionTitle("2. Use of the App"),
                  _buildSectionContent(
                    "You may use the App for personal, non-commercial purposes only. You agree not to use the App for any illegal or unauthorized purpose.",
                  ),
                  const SizedBox(height: 24),
                  _buildSectionTitle("3. User Accounts"),
                  _buildSectionContent(
                    "To use certain features, you may be required to create an account. You are responsible for maintaining the confidentiality of your account credentials.",
                  ),
                  const SizedBox(height: 24),
                  _buildSectionTitle("4. Intellectual Property"),
                  _buildSectionContent(
                    "All content in the App, including text, graphics, logos, and images, is the property of WayToFresh and is protected by intellectual property laws.",
                  ),
                  const SizedBox(height: 24),
                  _buildSectionTitle("5. Limitation of Liability"),
                  _buildSectionContent(
                    "WayToFresh shall not be liable for any indirect, incidental, or consequential damages arising from your use of the App.",
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 10,
        bottom: 20,
        left: 20,
        right: 20,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(CupertinoIcons.back, color: Colors.white, size: 20),
            ),
          ),
          const SizedBox(width: 20),
          const Text(
            "Terms & Conditions",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          fontFamily: 'Poppins',
        ),
      ),
    );
  }

  Widget _buildSectionContent(String content) {
    return Text(
      content,
      style: TextStyle(
        fontSize: 14,
        color: Colors.grey.shade700,
        height: 1.6,
        fontFamily: 'Poppins',
      ),
    );
  }
}
