import 'package:local_basket/components/custom_snackbar.dart';
import 'package:local_basket/components/custom_topbar.dart';
import 'package:local_basket/core/constants/colors.dart';
import 'package:local_basket/core/utils/address_formatter.dart';
import 'package:local_basket/data/model/address/state/state_model.dart';
import 'package:local_basket/presentation/cubit/address/city/getCities_cubit.dart';
import 'package:local_basket/presentation/cubit/address/city/getCities_state.dart';
import 'package:local_basket/presentation/cubit/address/getAddress/getAddress_cubit.dart';
import 'package:local_basket/presentation/cubit/address/saveAddress/saveAddress_cubit.dart';
import 'package:local_basket/presentation/cubit/address/saveAddress/saveAddress_state.dart';
import 'package:local_basket/presentation/cubit/address/state/getStates_cubit.dart';
import 'package:local_basket/presentation/cubit/address/state/getStates_state.dart';
import 'package:local_basket/presentation/cubit/authentication/currentcustomer/get/current_customer_cubit.dart';
import 'package:local_basket/presentation/cubit/authentication/currentcustomer/get/current_customer_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final houseController = TextEditingController();
  final streetController = TextEditingController();
  final landmarkController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final pincodeController = TextEditingController();

  List<StateModel> _states = [];
  List<CityModel> _allCities = [];

  @override
  void initState() {
    super.initState();
    _fetchStates();
    _fetchAllCities();
    _fetchCurrentCustomer();
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    houseController.dispose();
    streetController.dispose();
    landmarkController.dispose();
    cityController.dispose();
    stateController.dispose();
    pincodeController.dispose();
    super.dispose();
  }

  void _fetchStates() => context.read<GetStatesCubit>().getStates(context);

  void _fetchAllCities() => context.read<GetCitiesCubit>().getCities(context);

  void _fetchCurrentCustomer() =>
      context.read<CurrentCustomerCubit>().GetCurrentCustomer(context);

  String _normalizePhoneNumber(String? raw) {
    final digits = (raw ?? '').replaceAll(RegExp(r'\D'), '');
    if (digits.length <= 10) return digits;
    return digits.substring(digits.length - 10);
  }

  StateModel? _matchState(String stateText) {
    final key = looseMatchKey(stateText);
    if (key.isEmpty) return null;
    for (final state in _states) {
      if (looseMatchKey(state.name) == key) return state;
    }
    return null;
  }

  CityModel? _matchCity(String cityText, StateModel state) {
    final key = looseMatchKey(cityText);
    if (key.isEmpty) return null;
    final stateCode = state.code?.toLowerCase();
    for (final city in _allCities) {
      if (looseMatchKey(city.name) == key &&
          city.stateCode?.toLowerCase() == stateCode) {
        return city;
      }
    }
    return null;
  }

  void _applyDefaultLocation() {
    if (_states.isEmpty) return;

    StateModel? defaultState;
    if (stateController.text.trim().isEmpty) {
      defaultState = _states.first;
      setState(() {
        stateController.text = defaultState!.name;
      });
    } else {
      defaultState = _matchState(stateController.text.trim());
    }

    if (defaultState == null || _allCities.isEmpty) return;
    if (cityController.text.trim().isEmpty) {
      final stateCode = defaultState.code?.toLowerCase();
      final candidates =
          _allCities.where((c) => c.stateCode?.toLowerCase() == stateCode);
      final defaultCity =
          candidates.isNotEmpty ? candidates.first : _allCities.first;
      setState(() {
        cityController.text = defaultCity.name;
      });
    }
  }

  void _applyDefaultPhone() {
    if (phoneController.text.trim().isNotEmpty) return;
    final customerState = context.read<CurrentCustomerCubit>().state;
    if (customerState is CurrentCustomerLoaded) {
      final mobile = _normalizePhoneNumber(
        customerState.currentCustomerModel.mobile,
      );
      if (mobile.isNotEmpty) {
        setState(() {
          phoneController.text = mobile;
        });
      }
    }
  }

  void _saveAddress() {
    if (!_formKey.currentState!.validate()) return;

    final stateText = stateController.text.trim();
    final cityText = cityController.text.trim();

    final matchedState = _matchState(stateText);
    if (matchedState == null) {
      CustomSnackbars.showInfoSnack(
        context: context,
        title: "Out of Service Area",
        message:
            "We currently don't deliver to $stateText. Please check the State and try again.",
      );
      return;
    }

    final matchedCity = _matchCity(cityText, matchedState);
    if (matchedCity == null) return;

    final addressLine1 = joinAddressParts([
      houseController.text,
      landmarkController.text,
      streetController.text,
    ]);

    final payload = {
      "addressLine1": addressLine1,
      "cityId": matchedCity.id,
      "stateId": matchedState.id,
      "country": "IN",
      "postalCode": pincodeController.text.trim(),
    };
    context.read<SaveAddressCubit>().saveAddress(payload, context);
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    int maxLines = 1,
    bool required = true,
    bool enabled = true,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
              if (required)
                const Text('*', style: TextStyle(color: Colors.red)),
            ],
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            enabled: enabled,
            maxLines: maxLines,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            validator: validator,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: InputDecoration(
              filled: !enabled,
              fillColor: Colors.grey.shade100,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: AppColor.PrimaryColor,
                  width: 1.5,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.red),
              ),
              hintText: 'Enter $label',
              hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
            ),
            style: TextStyle(
              fontSize: 14,
              color: enabled ? null : Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: CustomAppBar(
          title: "Add New Address",
          showBackButton: true,
        ),
      ),
      backgroundColor: AppColor.White,
      body: MultiBlocListener(
        listeners: [
          BlocListener<SaveAddressCubit, SaveAddressState>(
            listener: (context, state) {
              if (state is SaveAddressSuccess) {
                CustomSnackbars.showSuccessSnack(
                  context: context,
                  title: "Success",
                  message: "Address Saved Successfully",
                );
                context.read<GetAddressCubit>().fetchAddress(context);
                Navigator.pop(context);
              } else if (state is SaveAddressFailure) {
                CustomSnackbars.showErrorSnack(
                  context: context,
                  title: "Failed",
                  message:
                      state.message.isEmpty
                          ? "Failed to Save Address"
                          : state.message,
                );
              }
            },
          ),
          BlocListener<GetStatesCubit, GetStatesState>(
            listener: (context, state) {
              if (state is GetStatesSuccess) {
                setState(() {
                  _states = state.states;
                });
                _applyDefaultLocation();
              } else if (state is GetStatesFailure) {
                CustomSnackbars.showErrorSnack(
                  context: context,
                  title: "Failed",
                  message:
                      state.error.isEmpty
                          ? "Failed to load states"
                          : state.error,
                );
              }
            },
          ),
          BlocListener<GetCitiesCubit, GetCitiesState>(
            listener: (context, state) {
              if (state is GetCitiesSuccess && state.stateId == null) {
                setState(() {
                  _allCities = state.cities;
                });
                _applyDefaultLocation();
              } else if (state is GetCitiesFailure) {
                CustomSnackbars.showErrorSnack(
                  context: context,
                  title: "Failed",
                  message:
                      state.error.isEmpty
                          ? "Failed to load cities"
                          : state.error,
                );
              }
            },
          ),
          BlocListener<CurrentCustomerCubit, CurrentCustomerState>(
            listener: (context, state) {
              if (state is CurrentCustomerLoaded) {
                _applyDefaultPhone();
              }
            },
          ),
        ],
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                _buildTextField(
                  label: "Full Name",
                  controller: nameController,
                  validator:
                      (v) =>
                          (v == null || v.trim().isEmpty)
                              ? 'Please enter your name'
                              : null,
                ),
                _buildTextField(
                  label: "Phone Number",
                  controller: phoneController,
                  enabled: false,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Please enter phone number';
                    }
                    if (v.trim().length != 10) {
                      return 'Please enter a valid 10-digit phone number';
                    }
                    return null;
                  },
                ),
                _buildTextField(
                  label: "House No. / Building",
                  controller: houseController,
                  validator:
                      (v) =>
                          (v == null || v.trim().isEmpty)
                              ? 'Please enter house/building details'
                              : null,
                ),
                _buildTextField(
                  label: "Street / Locality",
                  controller: streetController,
                  validator:
                      (v) =>
                          (v == null || v.trim().isEmpty)
                              ? 'Please enter street/locality'
                              : null,
                ),
                _buildTextField(
                  label: "Landmark (optional)",
                  controller: landmarkController,
                  required: false,
                ),
                _buildTextField(
                  label: "State",
                  controller: stateController,
                  enabled: false,
                  validator:
                      (v) =>
                          (v == null || v.trim().isEmpty)
                              ? 'Please enter your state'
                              : null,
                ),
                _buildTextField(
                  label: "City",
                  controller: cityController,
                  enabled: false,
                  validator:
                      (v) =>
                          (v == null || v.trim().isEmpty)
                              ? 'Please enter your city'
                              : null,
                ),
                _buildTextField(
                  label: "Pincode",
                  controller: pincodeController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Please enter pincode';
                    }
                    if (v.trim().length != 6) {
                      return 'Please enter a valid 6-digit pincode';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                BlocBuilder<SaveAddressCubit, SaveAddressState>(
                  builder:
                      (context, state) => SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed:
                              state is SaveAddressLoading
                                  ? null
                                  : _saveAddress,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.PrimaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child:
                              state is SaveAddressLoading
                                  ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CupertinoActivityIndicator(
                                      color: Colors.white,
                                    ),
                                  )
                                  : const Text(
                                    "Save Address",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                        ),
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
