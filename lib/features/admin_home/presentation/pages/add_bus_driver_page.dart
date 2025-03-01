import 'package:bus_tracker_app/core/common/widgets/basic_button.dart';
import 'package:bus_tracker_app/core/common/widgets/basic_field.dart';
import 'package:bus_tracker_app/core/models/driver_user_model.dart';
import 'package:bus_tracker_app/core/utils/loader.dart';
import 'package:bus_tracker_app/core/utils/show_snackbar.dart';
import 'package:bus_tracker_app/features/admin_home/presentation/bloc/admin_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddBusDriverPage extends StatefulWidget {
  const AddBusDriverPage({super.key});

  @override
  State<AddBusDriverPage> createState() => _AddBusDriverPageState();
}

class _AddBusDriverPageState extends State<AddBusDriverPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController busNumberController = TextEditingController();
  bool visible = false;

  @override
  void initState() {
    emailController.text = "jprbus@gmail.com";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Bus Driver'),
      ),
      body: BlocConsumer<AdminBloc, AdminState>(
        listener: (context, state) {
          if (state is AdminAddDriverSuccess) {
            Navigator.pop(context);
            showSnackBar(context: context, text: 'Driver added successfully');
          }
          if (state is AdminFailure) {
            showSnackBar(context: context, text: state.message);
          }
        },
        builder: (context, state) {
          if (state is AdminLoading) {
            return Loader();
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                spacing: 10,
                children: [
                  BasicField(
                    controller: nameController,
                    icon: Icons.person_rounded,
                    hintText: 'Name',
                  ),
                  BasicField(
                    isNum: true,
                    controller: phoneController,
                    icon: Icons.phone_rounded,
                    hintText: 'Phone',
                  ),
                  BasicField(
                    isNum: true,
                    controller: busNumberController,
                    onChange: (value) {
                      emailController.text = "jprbus$value@gmail.com";
                    },
                    icon: Icons.directions_bus_rounded,
                    hintText: 'Bus Number',
                  ),
                  BasicField(
                    readOnly: true,
                    controller: emailController,
                    icon: Icons.email_rounded,
                    hintText: 'New Email',
                  ),
                  BasicField(
                    isobscureText: !visible,
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            visible = !visible;
                          });
                        },
                        icon: Icon(!visible
                            ? Icons.visibility_off_rounded
                            : Icons.visibility_rounded)),
                    controller: passwordController,
                    icon: Icons.lock_rounded,
                    hintText: 'New Password',
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.35,
                  ),
                  BasicButton(
                    onPressed: () {
                      context.read<AdminBloc>().add(
                            AdminAddDriver(
                              driverUserModel: DriverUserModel(
                                uid: '',
                                name: nameController.text.trim(),
                                email: emailController.text.trim(),
                                busNo:
                                    int.parse(busNumberController.text.trim()),
                                phoneNo: phoneController.text.trim(),
                                password: passwordController.text.trim(),
                              ),
                            ),
                          );
                    },
                    text: 'Add Driver',
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
