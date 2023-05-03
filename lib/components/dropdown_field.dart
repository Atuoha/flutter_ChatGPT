import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chatgpt/business_logic/api_work/api_work_cubit.dart';

import '../constants/colors.dart';
import '../repositories/api_repository.dart';

class ModelDropDownButton extends StatefulWidget {
  const ModelDropDownButton({Key? key}) : super(key: key);

  @override
  State<ModelDropDownButton> createState() => _ModelDropDownButtonState();
}

class _ModelDropDownButtonState extends State<ModelDropDownButton> {

  // persisting model
  void changeModel(String model) {
    context.read<ApiWorkCubit>().selectModel(model);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: APIRepository.getModels(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          const Center(
            child: Text(
              'Error Loading models',
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(
            color: btnBg,
          );
        }

        if (snapshot.data!.isEmpty || snapshot.data == null) {
          const Center(
            child: Text(
              'Models are empty',
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        return DropdownButtonFormField(
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(10),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          value: context.watch<ApiWorkCubit>().state.selectedModel,
          style: const TextStyle(color: Colors.white),
          dropdownColor: msgBg,
          iconEnabledColor: btnBg,
          items: List<DropdownMenuItem>.generate(
            snapshot.data!.length,
            (index) => DropdownMenuItem(
              value: snapshot.data![index].id,
              child: Text(snapshot.data![index].id),
            ),
          ).toList(),
          onChanged: (model) {
            changeModel(model);
          },
        );
      },
    );
  }
}

//
