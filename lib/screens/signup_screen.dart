import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

import '../resources/auth_methods.dart';
import '../utils/colors.dart';
import '../utils/utils.dart';
import '../widgets/text_field_input.dart';


class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  Uint8List?  _image ;
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
  }


  void signupUser() async {
    setState(() {
      isLoading = true;
    });
    String res = await AuthMethods().signupUser(
      email: _emailController.text,
      password: _passController.text,
      username: _usernameController.text,
      bio: _bioController.text,
      file: _image!
    );


    if (res != 'success') {
      showSnackbar(res, context);
      setState(() {
        isLoading = false;
      });
    } else {
      showSnackbar("Signup Successfull!", context);
      setState(() {
        isLoading = false;
      });
    }

  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Container(),
                flex: 1,
              ),
              //LOGO SVG
              SvgPicture.asset(
                "assets/ic_instagram.svg",
                color: primaryColor,
                height: 64,
              ),
              SizedBox(
                height: 64,
              ),

              // Circular Widget To Accept and show selected image
              Stack(
                children: [
                  _image != null
                      ? CircleAvatar(
                          radius: 64,
                          backgroundImage: MemoryImage(_image!),
                        )
                      : CircleAvatar(
                          radius: 64,
                          backgroundImage: NetworkImage(
                              "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1887&q=80"),
                        ),
                  Positioned(
                      bottom: -10,
                      left: 80,
                      child: IconButton(
                          onPressed: selectImage,
                          icon: Icon(Icons.add_a_photo)))
                ],
              ),

              SizedBox(
                height: 64,
              ),
              // USERNAME TEXTFIELD INPUT
              TextFieldInput(
                  textEditingController: _usernameController,
                  textInputType: TextInputType.name,
                  hintText: "Enter Your Username"),
              SizedBox(
                height: 24,
              ),

              // EMAIL TEXTFIELD INPUT
              TextFieldInput(
                  textEditingController: _emailController,
                  textInputType: TextInputType.emailAddress,
                  hintText: "Enter Your Email"),
              SizedBox(
                height: 24,
              ),

              // PASSWORD TEXTFIELD INPUT
              TextFieldInput(
                  textEditingController: _passController,
                  textInputType: TextInputType.visiblePassword,
                  isPass: true,
                  hintText: "Enter Your Password"),
              SizedBox(
                height: 24,
              ),

              // BIO TEXTFIELD INPUT
              TextFieldInput(
                  textEditingController: _bioController,
                  textInputType: TextInputType.text,
                  hintText: "Enter Your Bio..."),
              SizedBox(
                height: 24,
              ),

              // SIGNUP BUTTON
              InkWell(
                onTap: signupUser,
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      color: blueColor),
                  child: Center(
                    child: isLoading?  CircularProgressIndicator(color: primaryColor,):Text('SIGN UP'),
                  ),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Flexible(
                child: Container(),
                flex: 2,
              ),

              // TRANSITIONING TO SINGING IN
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Center(
                      child: Text("Already Have An Account? "),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Center(
                        child: Text(
                          "Sign In",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
