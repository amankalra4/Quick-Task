import 'package:flutter/material.dart';

class FormInput extends StatelessWidget {
  final String? iLabel;
  final TextEditingController? iController;
  final List<String>? iOptions;

  const FormInput({
    Key? key,
    this.iLabel = "",
    this.iController,
    required this.iOptions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15),
      child: TextFormField(
        controller: iController,
        readOnly: iOptions!.isNotEmpty ? true : false,
        onTap: () {
          if (iOptions!.isNotEmpty) {
            showModalBottomSheet(
              context: context,
              builder: (context) {
                return showDropDown(context);
              },
            );
          }
        },
        decoration: InputDecoration(
          labelText: iLabel,
          labelStyle: TextStyle(fontSize: 16),
        ),
        style: const TextStyle(
          fontSize: 18,
        ),
      ),
    );
  }

  Widget showDropDown(BuildContext context) {
    return Container(
      height: 250,
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      color: Colors.white,
      child: ListView(
        children: iOptions!
            .map(
              (listItem) => ListTile(
                onTap: () {
                  iController!.text = listItem;
                  Navigator.pop(context);
                },
                title: Column(
                  children: [
                    Text(
                      listItem,
                      textAlign: TextAlign.start,
                      style: const TextStyle(color: Colors.black),
                    ),
                    const SizedBox(height: 4),
                    const Divider(height: 1)
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
