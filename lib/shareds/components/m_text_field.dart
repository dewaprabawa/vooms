import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vooms/shareds/components/shake_widget.dart';
import 'package:vooms/shareds/general_helper/ui_color_constants.dart';



class MtextField extends StatefulWidget {
  const MtextField({
    Key? key,
    this.controller,
    this.margin = const EdgeInsets.symmetric(horizontal: 20),
    this.onChanged,
    this.hintText,
    this.hintStyle,
    this.borderWidth = 0.0,
    this.errorText,
    this.errorStyle,
    this.labelText,
    this.labelStyle,
    this.borderColor,
    this.borderRadius = 0.0,
    this.textInputAction,
    this.textInputType,
    this.isLabelRequired = false,
    this.isShakeErrorAnimationActive = false,
    this.isSecurity = false,
    this.enabled = true,
    this.expands = false,
    this.trailingChild = const SizedBox.shrink(),
    this.leadingChild = const SizedBox.shrink(),
    this.color = UIColorConstant.nativeWhite,
  }) : super(key: key);
  final bool isShakeErrorAnimationActive;
  final bool isSecurity;
  final EdgeInsets margin; 
  final TextEditingController? controller;
  final TextInputAction? textInputAction;
  final TextInputType? textInputType;
  final Color? borderColor;
  final double borderRadius;
  final double borderWidth;
  final String? hintText;
  final TextStyle? hintStyle;
  final String? labelText;
  final bool isLabelRequired;
  final TextStyle? labelStyle;
  final String? errorText;
  final TextStyle? errorStyle;
  final bool? enabled;
  final Widget trailingChild;
  final Widget leadingChild;
  final bool expands;
  final void Function(String)? onChanged;
  final Color color;

  @override
  State<MtextField> createState() => _MtextFieldState();
}

class _MtextFieldState extends State<MtextField>
    with SingleTickerProviderStateMixin {
  bool isFocused = false;
  bool isShowPassowrd = false;
  final shakeKey = GlobalKey<ShakeWidgetState>();
  TextEditingController? _textEditingController;

  @override
  void initState() {
    if(widget.controller == null){
      _textEditingController = TextEditingController();
    }else{
      _textEditingController = widget.controller;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    //text_field
    Widget textField = TextFormField(
      expands: widget.expands,
      enabled: widget.enabled,
      controller: _textEditingController,
      onChanged: widget.onChanged,
      style: GoogleFonts.dmMono(),
      textInputAction: widget.textInputAction,
      keyboardType: widget.textInputType,
      obscureText: widget.isSecurity,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          hintText: widget.hintText,
          labelStyle: widget.labelStyle,
          errorStyle: widget.labelStyle,
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          errorBorder: InputBorder.none),
    );

    //focus_node
    Widget focusNode = Focus(
      onFocusChange: _onFocusChanged,
      child: Container(
        decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: _setBorderColor(), 
                width: widget.borderWidth)),
        child: Row(children: [
        widget.leadingChild,  Expanded(child: textField), widget.trailingChild,
        ],),
      ),
    );

    //label_text
    Widget labelText = const SizedBox.shrink();
    if (widget.labelText != null) {
      labelText = Padding(
        padding: const EdgeInsets.only(left: 3),
        child: Row(
          children: [
            Text(
              widget.labelText ?? "",
              style: GoogleFonts.dmMono().copyWith(fontWeight: FontWeight.w400, color: Colors.grey),
            ),
            widget.isLabelRequired
                ? const Text(
                    "*",
                    style: TextStyle(
                        color: UIColorConstant.primaryRed, fontSize: 25),
                  )
                : const SizedBox.shrink()
          ],
        ),
      );
    }

    //error_text
    Widget errorText = const SizedBox.shrink();
    if (widget.errorText != null) {
      errorText = Text(
        widget.errorText ?? "",
        overflow: TextOverflow.ellipsis,
        style: widget.errorStyle ??
            GoogleFonts.dmMono(color: UIColorConstant.primaryRed)
                .copyWith(fontWeight: FontWeight.w700),
      );
    }

    //shake_widget
    Widget shakeWidget = ShakeWidget(
      key: shakeKey,
      shakeCount: 2,
      shakeOffset: 3,
      shakeDuration: const Duration(milliseconds: 500),
      child: focusNode,
    );


    return Padding(
      padding: widget.margin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          labelText,
          const SizedBox(
            height: 4,
          ),
          shakeWidget,
          const SizedBox(
            height: 5,
          ),
          errorText,
        ],
      ),
    );
  }

  Color _setBorderColor() {
    if (widget.errorText != null) {
      if (isFocused && widget.isShakeErrorAnimationActive) {
        shakeKey.currentState?.shake();
      }
      return UIColorConstant.primaryRed;
    } else if (isFocused) {
      return widget.borderColor ?? UIColorConstant.primaryGreen;
    } else {
      return widget.borderColor ?? UIColorConstant.primaryGreen;
    }
  }

  void _onFocusChanged(value) {
    if (value) {
      setState(() {
        isFocused = true;
      });
    } else {
      setState(() {
        isFocused = false;
      });
    }
  }
}
