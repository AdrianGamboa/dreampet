import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final Function onPressed;
  final Color color;

  CustomButton({
    this.label = 'Continue',
    this.onPressed,
    this.color,
  });

  bool isSmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < 800;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.0,
      width: MediaQuery.of(context).size.width,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
            backgroundColor: color ?? Theme.of(context).primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            )),
        child: Text(
          "$label",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18.0,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
