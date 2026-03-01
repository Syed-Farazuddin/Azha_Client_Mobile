import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/common/widgets/custom_button.dart';
import 'package:mobile/common/widgets/custom_text_field.dart';
import 'package:mobile/core/colors/app_colors.dart';
import 'package:mobile/core/constants/text_styles.dart';
import 'package:mobile/features/orders/domain/providers/order_provider.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  String _paymentMethod = 'UPI';

  void _onConfirmOrder() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final data = _formKey.currentState!.value;

      final address = {
        'street': data['street'],
        'city': data['city'],
        'pincode': data['pincode'],
      };

      final order = await ref
          .read(orderNotifierProvider.notifier)
          .confirmOrder(
            productId:
                'sample_product_id', // Would come from cart typically or args
            price: 1500, // Would come from cart
            deliveryAddress: address,
            quantity: 1, // Would come from cart
            paymentMethod: _paymentMethod,
            paymentId: 'pay_${DateTime.now().millisecondsSinceEpoch}', // Mocked
            mobile: data['phone'],
          );

      if (order != null && mounted) {
        context.go('/order-confirmation/${order.id}');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to confirm order')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final orderState = ref.watch(orderNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text(
          'Checkout',
          style: customTextStyles['sb20']?.copyWith(color: AppColors.black),
        ),
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.black,
            size: 20,
          ),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: FormBuilder(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Delivery Address',
                style: customTextStyles['sb18']?.copyWith(
                  color: AppColors.black,
                ),
              ),
              SizedBox(height: 16.h),
              CustomTextField(
                name: 'street',
                label: 'Street Address',
                hintText: 'Enter your street address',
                validator: FormBuilderValidators.required(),
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      name: 'city',
                      label: 'City',
                      hintText: 'City',
                      validator: FormBuilderValidators.required(),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: CustomTextField(
                      name: 'pincode',
                      label: 'Pincode',
                      hintText: 'Pincode',
                      keyboardType: TextInputType.number,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        FormBuilderValidators.numeric(),
                      ]),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              CustomTextField(
                name: 'phone',
                label: 'Phone Number',
                hintText: 'Enter delivery phone number',
                keyboardType: TextInputType.phone,
                validator: FormBuilderValidators.required(),
              ),
              SizedBox(height: 32.h),
              Text(
                'Payment Method',
                style: customTextStyles['sb18']?.copyWith(
                  color: AppColors.black,
                ),
              ),
              SizedBox(height: 16.h),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.subTitles.withOpacity(0.3),
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  children: [
                    RadioListTile<String>(
                      title: Text(
                        'UPI',
                        style: customTextStyles['sb14']?.copyWith(
                          color: AppColors.black,
                        ),
                      ),
                      value: 'UPI',
                      groupValue: _paymentMethod,
                      activeColor: AppColors.blue500,
                      onChanged: (value) {
                        setState(() {
                          _paymentMethod = value!;
                        });
                      },
                    ),
                    Divider(
                      height: 1,
                      color: AppColors.subTitles.withOpacity(0.3),
                    ),
                    RadioListTile<String>(
                      title: Text(
                        'Credit/Debit Card',
                        style: customTextStyles['sb14']?.copyWith(
                          color: AppColors.black,
                        ),
                      ),
                      value: 'Card',
                      groupValue: _paymentMethod,
                      activeColor: AppColors.blue500,
                      onChanged: (value) {
                        setState(() {
                          _paymentMethod = value!;
                        });
                      },
                    ),
                    Divider(
                      height: 1,
                      color: AppColors.subTitles.withOpacity(0.3),
                    ),
                    RadioListTile<String>(
                      title: Text(
                        'Cash on Delivery',
                        style: customTextStyles['sb14']?.copyWith(
                          color: AppColors.black,
                        ),
                      ),
                      value: 'COD',
                      groupValue: _paymentMethod,
                      activeColor: AppColors.blue500,
                      onChanged: (value) {
                        setState(() {
                          _paymentMethod = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40.h),
              CustomButton(
                title: 'Confirm Order',
                isLoading: orderState.isLoading,
                onPressed: _onConfirmOrder,
              ),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }
}
