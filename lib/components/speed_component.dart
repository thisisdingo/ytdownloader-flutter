import 'package:flutter/material.dart';
import 'package:popover/popover.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class SpeedComponent extends StatefulWidget {
  final Function(double speed) didSpeedChanged;
  const SpeedComponent({super.key, required this.didSpeedChanged});

  @override
  State<SpeedComponent> createState() => _SpeedComponentState();
}

class _SpeedComponentState extends State<SpeedComponent> {

  // Скорости
  List speeds = [1.0, 0.9, 0.8, 0.7, 0.6];

  // Текущая скорость
  double currentSpeed = 1.0;

  @override
  Widget build(BuildContext context) {
    return ZoomTapAnimation(
        onTap: () {
          showPopover(
            context: context,
            bodyBuilder: (context) => Container(
                color: const Color(0xFF222222),
                child: Row(
                  children: speeds
                      .asMap()
                      .entries
                      .map((e) => Expanded(
                          child: ZoomTapAnimation(
                              onTap: () {
                                Navigator.of(context).pop();
                                widget.didSpeedChanged(e.value);
                                setState(() {
                                  currentSpeed = e.value;
                                });
                              },
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Center(
                                    child: Text(
                                      "${e.value}x",
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  )),
                                  if (e.key != speeds.length - 1)
                                    Container(
                                      width: 1,
                                      color: Colors.grey,
                                    )
                                ],
                              ))))
                      .toList(),
                )),
            height: 44,
            width: MediaQuery.of(context).size.width * 0.8,
            direction: PopoverDirection.top,
            arrowHeight: 0,
            arrowWidth: 0,
          );
        },
        child: Container(
          width: 50,
          height: 35,
          decoration: BoxDecoration(
              color: const Color(0xFF2C2C2E),
              borderRadius: BorderRadius.circular(10)),
          child: Center(
            child: Text(
              "${currentSpeed.toStringAsFixed(1)}x",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ));
  }
}
