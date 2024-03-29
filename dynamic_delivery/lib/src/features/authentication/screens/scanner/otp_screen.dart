import 'package:dynamic_delivery/src/utils/theme/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/status_controller.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key, required this.value});
  final String value;
  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final List<TextEditingController> _controllers =
  List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());
  late FocusNode _currentFocusNode;
  bool _showGif = false;

  @override
  void initState() {
    super.initState();
    _currentFocusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    Get.put(StatusController());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: tThemeMain,
        foregroundColor: Colors.white,
        title: const Text('OTP Screen'),
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('Please Enter a OTP which Sends \n To Your Registered Mobile'),
              const SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  4,
                      (index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child: TextFormField(
                        controller: _controllers[index],
                        focusNode: _focusNodes[index],
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        maxLength: 1,
                        onChanged: (String value) {
                          if (value.isNotEmpty && index < 3) {
                            _focusNodes[index + 1].requestFocus();
                          }
                        },
                        decoration: InputDecoration(
                          counterText: "",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: tThemeMain,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    // Handle submit button pressed
                    String otp = _controllers.map((controller) => controller.text).join();
                    // Check if OTP is "0000"
                    if (otp == "0000") {
                      StatusController.instance.updateStatus(widget.value,"Delivered");
                      setState(() {
                        _showGif = true; // Set flag to true to display GIF
                      });
                    }
                    // Here you can validate OTP and perform further actions
                    print('Entered OTP: $otp');
                  },
                  child: const Text('Submit'),
                ),
              ),
              const SizedBox(height: 30),
              if (_showGif)
                Image.asset(
                  'assets/images/delivered.gif',
                  width: 200,
                  height: 300,
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _currentFocusNode.dispose();
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
