import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:world_of_wood/Resources/colors.dart';
import 'package:world_of_wood/Utils/constrainst/Text_Style.dart';
import '../../Utils/constrainst/Button_Style.dart';
import '../../View_Model/UserView_Model.dart';

class UserDetailsForm extends StatefulWidget {
  @override
  _UserDetailsFormState createState() => _UserDetailsFormState();
}

class _UserDetailsFormState extends State<UserDetailsForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _aadhaarController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _aadhaarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context);

    return Scaffold(
      backgroundColor: Appcolors.white,
      appBar: AppBar(
        title: Text(
          'Add Your Details',
          style: AppbarText,
        ),
        backgroundColor: Appcolors.brown,
        foregroundColor: Appcolors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Widget
              Image.asset(
                'images/details.png',
                height: 220,
                width: 320,
              ),
              SizedBox(height: 10),

              // Name TextFormField
              _buildTextFormField(
                controller: _nameController,
                label: 'Name',
                validator: (value) =>
                value!.isEmpty ? 'Please enter your name' : null,
              ),

              // Phone Number TextFormField
              _buildTextFormField(
                controller: _phoneController,
                label: 'Phone Number',
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value!.isEmpty) return 'Please enter your phone number';
                  if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                    return 'Please enter a valid 10-digit phone number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              // Save Details Button
              Center(
                child: userViewModel.isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                  style: LSFbutton_Style,
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await userViewModel.saveUserDetails(
                        name: _nameController.text.trim(),
                        phone: _phoneController.text.trim(),
                        aadhaar: _aadhaarController.text.trim(),
                        context: context,
                      );
                    }
                  },
                  child: Text('Save Details', style: KTextStyle),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper function to build TextFormField
  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    required String? Function(String?) validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        keyboardType: keyboardType,
        validator: validator,
      ),
    );
  }
}
