import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pleco_to_anki/widgets/floating_action_button.dart';

import 'home_controller.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (controller) => Scaffold(
        appBar: AppBar(
          title: const Text(
            'Choose a deck',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: ListView.builder(
          itemCount: controller.decks.length,
          itemBuilder: (context, i) {
            return ListTile(
              title: Obx(() => Text(controller.decks[i].name.value)),
              // trailing: Obx(() => Text(controller.decks[i].numPhrases.string)),
              onTap: () => controller.viewDeck(i),
            );
          },
        ),
        floatingActionButton: MyFloatingActionButton(
          icon: Icons.add,
          onPressed: controller.newDeck,
        ),
      ),
    );
  }
}
