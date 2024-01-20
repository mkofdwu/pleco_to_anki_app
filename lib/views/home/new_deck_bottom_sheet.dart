import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pleco_to_anki/constants/palette.dart';
import 'package:pleco_to_anki/widgets/primary_icon_button.dart';

import 'new_deck_controller.dart';

class NewDeckBottomSheet extends StatelessWidget {
  const NewDeckBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NewDeckController>(
      init: NewDeckController(),
      builder: (controller) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: const BoxDecoration(
          color: Palette.black1,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
        ),
        child: Row(
          children: [
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                autofocus: true,
                controller: controller.textController,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                  border: InputBorder.none,
                  hintText: 'Give your deck a name',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                ),
              ),
            ),
            PrimaryIconButton(
              icon: Icons.check,
              onPressed: controller.submit,
            ),
          ],
        ),
      ),
    );
  }
}
