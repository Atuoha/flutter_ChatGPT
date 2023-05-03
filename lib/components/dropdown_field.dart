import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../repositories/api_repository.dart';

class ModelDropDownButton extends StatefulWidget {
  const ModelDropDownButton({Key? key}) : super(key: key);

  @override
  State<ModelDropDownButton> createState() => _ModelDropDownButtonState();
}

class _ModelDropDownButtonState extends State<ModelDropDownButton> {
  var selectedModel = 'babbage';

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: APIRepository.getModels(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          const Center(
            child: Text(
              'Error Loading models',
              style: TextStyle(color: btnBg),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          const CircularProgressIndicator(
            backgroundColor: btnBg,
          );
        }

        return snapshot.data == null || snapshot.data!.isEmpty
            ? const SizedBox.shrink()
            : DropdownButtonFormField(
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
                value: selectedModel,
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
                onChanged: (value) {
                  setState(() {
                    selectedModel = value!;
                  });
                },
              );
      },
    );
  }
}

//
