import 'package:flutter/material.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class SearchComponent extends StatefulWidget {
  final Function(String link) didLinkEntered;

  const SearchComponent({super.key, required this.didLinkEntered});

  @override
  State<SearchComponent> createState() => _SearchComponentState();
}

class _SearchComponentState extends State<SearchComponent> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      decoration: BoxDecoration(
          color: const Color.fromRGBO(118, 118, 128, 0.24),
          borderRadius: BorderRadius.circular(23)),
      child: Row(
        children: [
          const SizedBox(
            width: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Image.asset('assets/search.png'),
          ),
          const SizedBox(
            width: 8,
          ),
          Expanded(
              child: TextField(
            style: const TextStyle(color: Colors.white),
            controller: controller,
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintStyle: TextStyle(color: Colors.grey),
              hintText: 'Youtube link',
            ),
            onSubmitted: widget.didLinkEntered,
          )),
          const SizedBox(
            width: 8,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: ZoomTapAnimation(
              child: Image.asset('assets/close.png'),
              onTap: () {
                controller.clear();
              },
            ),
          ),
          const SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }
}
