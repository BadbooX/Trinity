// First, let's update the ProfilePage to use ValueListenableBuilder for reactive updates
import 'package:bite/components/buttons/main_actionn_button.dart';
import 'package:bite/components/buttons/secondary_button.dart';
import 'package:bite/components/inputs/custom_text_input.dart';
import 'package:bite/components/titles/page_title.dart';
import 'package:bite/layouts/auth_pages_layout.dart';
import 'package:bite/models/address.dart';
import 'package:bite/services/my_user_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

final GetIt getIt = GetIt.instance;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final MyUserService userService = getIt.get<MyUserService>();

    return AuthPagesLayout(
      child: ValueListenableBuilder<User?>(
        valueListenable: userService.user,
        builder: (context, user, _) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 16,
              children: [
                PageTitle(text: 'Profile'),
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(
                    'https://www.gravatar.com/avatar/${user!.email.hashCode}?d=identicon',
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 0,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit_outlined),
                      color: Colors.black,
                      splashColor: Colors.red[100],
                      tooltip: 'Edit Profile',
                      onPressed: () {
                        context.go('/profile/edit');
                      },
                    ),
                    IconButton(
                      onPressed: () =>
                          _showDeleteConfirmation(context, userService),
                      tooltip: 'Delete Account',
                      icon: Icon(Icons.delete_forever_outlined,
                          color: Color(0xffde1826)),
                    ),
                    IconButton(
                        onPressed: userService.fetchUserFromApi,
                        icon: Icon(Icons.refresh)),
                  ],
                ),
                RichText(
                    text: TextSpan(
                  text: 'Firstname: ',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: Colors.black,
                            offset: const Offset(0, -3),
                          ),
                        ],
                        color: Colors.transparent,
                        decoration: TextDecoration.underline,
                        decorationColor: const Color(0xffde1826),
                        decorationThickness: 4,
                      ),
                  children: [
                    TextSpan(
                      text: ' ${user.firstName}',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(color: Colors.transparent),
                    ),
                  ],
                )),
                RichText(
                    text: TextSpan(
                  text: 'Lastname: ',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: Colors.black,
                            offset: const Offset(0, -3),
                          ),
                        ],
                        color: Colors.transparent,
                        decoration: TextDecoration.underline,
                        decorationColor: const Color(0xffde1826),
                        decorationThickness: 4,
                      ),
                  children: [
                    TextSpan(
                      text: ' ${user.lastName}',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(color: Colors.transparent),
                    ),
                  ],
                )),
                RichText(
                    text: TextSpan(
                  text: 'Email: ',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: Colors.black,
                            offset: const Offset(0, -3),
                          ),
                        ],
                        color: Colors.transparent,
                        decoration: TextDecoration.underline,
                        decorationColor: const Color(0xffde1826),
                        decorationThickness: 4,
                      ),
                  children: [
                    TextSpan(
                      text: ' ${user.email}',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(color: Colors.transparent),
                    ),
                  ],
                )),
                RichText(
                    text: TextSpan(
                  text: 'Phone: ',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: Colors.black,
                            offset: const Offset(0, -3),
                          ),
                        ],
                        color: Colors.transparent,
                        decoration: TextDecoration.underline,
                        decorationColor: const Color(0xffde1826),
                        decorationThickness: 4,
                      ),
                  children: [
                    TextSpan(
                      text: ' ${user.phone}',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(color: Colors.transparent),
                    ),
                  ],
                )),
                Text(
                  'Addresses:',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: Colors.black,
                            offset: const Offset(0, -3),
                          ),
                        ],
                        color: Colors.transparent,
                        decoration: TextDecoration.underline,
                        decorationColor: const Color(0xffde1826),
                        decorationThickness: 4,
                      ),
                ),
                if (user.addresses!.isEmpty) Text('No address available'),
                Wrap(
                  children: [
                    for (final address in user.addresses!)
                      Container(
                        padding: const EdgeInsets.all(8),
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xffde2816),
                              spreadRadius: 0,
                              blurRadius: 0,
                              offset: const Offset(-4, 0),
                            ),
                            BoxShadow(
                              color: Color.fromARGB(78, 0, 0, 0),
                              spreadRadius: 0,
                              blurRadius: 4,
                              offset: const Offset(0, 0),
                            )
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${address['street']}'),
                            Text('${address['city']}'),
                            Text('${address['country']}'),
                            Text('${address['postalCode']}'),
                          ],
                        ),
                      ),
                  ],
                ),
                MainActionnButton(
                    onPressed: () => context.go('/profile/add-address'),
                    icon: Icons.add_location_outlined,
                    text: 'Add Address'),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showDeleteConfirmation(
      BuildContext context, MyUserService userService) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Delete Account'),
          content: const Text(
            'Are you sure you want to delete your account? This action cannot be undone.',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () async {
                Navigator.of(dialogContext).pop(); // Close the dialog
                try {
                  await userService.deleteUser();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          backgroundColor: Color.fromARGB(255, 209, 255, 243),
                          content: Text('Account deleted successfully',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 0, 161, 113)))),
                    );
                    await Future.delayed(const Duration(milliseconds: 300));
                    if (context.mounted) {
                      context.go('/login'); // Adjust the route as needed
                    }
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          backgroundColor: Color.fromARGB(255, 255, 209, 209),
                          content: Text('Failed to delete account: $e',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 209, 0, 0)))),
                    );
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }
}

// Now let's create a new EditProfilePage
class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  EditProfilePageState createState() => EditProfilePageState();
}

class EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  final _formKey = GlobalKey<FormState>();
  final MyUserService userService = getIt.get<MyUserService>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final user = userService.user.value;
    _firstNameController = TextEditingController(text: user?.firstName ?? '');
    _lastNameController = TextEditingController(text: user?.lastName ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _phoneController = TextEditingController(text: user?.phone ?? '');
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final updatedUser = User(
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      fullName: '${_firstNameController.text} ${_lastNameController.text}',
      email: _emailController.text,
      phone: _phoneController.text,
    );

    try {
      await userService.updateUser(updatedUser);
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
      context.go('/profile');
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating profile: $e')),
      );
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    return AuthPagesLayout(
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            spacing: 16,
            children: [
              const PageTitle(text: 'Edit Profile'),
              CustomTextInput(
                controller: _firstNameController,
                icon: Icons.account_circle_outlined,
                label: 'First Name',
                onChanged: (value) => _firstNameController.text = value,
              ),
              CustomTextInput(
                controller: _lastNameController,
                icon: Icons.account_circle_outlined,
                label: 'Last Name',
                onChanged: (value) => _lastNameController.text = value,
              ),
              CustomTextInput(
                controller: _emailController,
                icon: Icons.email_outlined,
                label: 'Email',
                onChanged: (value) => _emailController.text = value,
              ),
              CustomTextInput(
                controller: _phoneController,
                icon: Icons.phone_outlined,
                label: 'Phone',
                onChanged: (value) => _phoneController.text = value,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  MainActionnButton(
                    onPressed: _isLoading ? null : _saveProfile,
                    text: 'Save',
                    icon: Icons.save_outlined,
                    isLoading: _isLoading,
                  ),
                  SecondaryButton(
                    onPressed: _isLoading ? null : () => context.go('/profile'),
                    text: 'Cancel',
                    icon: Icons.cancel_outlined,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EditUserAddress extends StatefulWidget {
  const EditUserAddress({super.key});

  @override
  EditUserAddressState createState() => EditUserAddressState();
}

class EditUserAddressState extends State<EditUserAddress> {
  late TextEditingController _streetController;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late TextEditingController _zipController;
  final _formKey = GlobalKey<FormState>();
  final MyUserService userService = getIt.get<MyUserService>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final user = userService.user.value;
    _streetController =
        TextEditingController(text: user?.address?.street ?? '');
    _cityController = TextEditingController(text: user?.address?.city ?? '');
    _stateController = TextEditingController(text: user?.address?.state ?? '');
    _zipController = TextEditingController(text: user?.address?.zip ?? '');
  }

  @override
  void dispose() {
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    super.dispose();
  }

  Future<void> _saveAddress() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final updatedUser = User(
      firstName: userService.user.value!.firstName,
      lastName: userService.user.value!.lastName,
      fullName: userService.user.value!.fullName,
      email: userService.user.value!.email,
      phone: userService.user.value!.phone,
      address: Address(
        street: _streetController.text,
        city: _cityController.text,
        state: _stateController.text,
        zip: _zipController.text,
      ),
    );

    try {
      await userService.updateUser(updatedUser);
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Address updated successfully')),
      );
      context.go('/profile');
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating address: $e')),
      );
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    return AuthPagesLayout(
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            spacing: 16,
            children: [
              const PageTitle(text: 'Add Address'),
              CustomTextInput(
                controller: _streetController,
                icon: Icons.location_on_outlined,
                label: 'Address',
                onChanged: (value) => _streetController.text = value,
              ),
              CustomTextInput(
                controller: _cityController,
                icon: Icons.location_city_outlined,
                label: 'City',
                onChanged: (value) => _cityController.text = value,
              ),
              CustomTextInput(
                controller: _stateController,
                icon: Icons.location_city_outlined,
                label: 'State',
                onChanged: (value) => _stateController.text = value,
              ),
              CustomTextInput(
                controller: _zipController,
                icon: Icons.location_city_outlined,
                label: 'Zip',
                onChanged: (value) => _zipController.text = value,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  MainActionnButton(
                    onPressed: _isLoading ? null : _saveAddress,
                    text: 'Save',
                    icon: Icons.save_outlined,
                    isLoading: _isLoading,
                  ),
                  SecondaryButton(
                    onPressed: _isLoading ? null : () => context.go('/profile'),
                    text: 'Cancel',
                    icon: Icons.cancel_outlined,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
