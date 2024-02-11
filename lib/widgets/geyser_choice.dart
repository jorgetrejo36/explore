import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class GeyserChoiceStateful extends StatefulWidget {
  const GeyserChoiceStateful({
    Key? key,
    required this.handleState,
    required this.choice,
    required this.answer,
    required this.correctAnswer,
    required this.answeredQuestion,
    required this.item,
    required this.top,
  }) : super(key: key);

  final Function(int) handleState;
  final int choice;
  final int answer;
  final int correctAnswer;
  final bool answeredQuestion;
  final String item;
  final String top;
  @override
  State<GeyserChoiceStateful> createState() => _GeyserChoiceState();
}

class _GeyserChoiceState extends State<GeyserChoiceStateful>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  Animation<double>? _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 250).animate(
      CurvedAnimation(
          parent: _animationController!, curve: Curves.fastOutSlowIn),
    );
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  Widget _buildChoiceButton() {
    return Center(
      child: TextButton(
        onPressed: () {
          widget.handleState(widget.choice);
        },
        style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            textStyle: const TextStyle(fontFamily: 'Fredoka', fontSize: 40)),
        child: Text('${widget.choice}'),
      ),
    );
  }

  Widget _buildAlienSvg() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: SvgPicture.asset(
        'assets/images/alien.svg',
        width: double.infinity,
        height: 150,
        fit: BoxFit.fill,
      ),
    );
  }

  Widget _buildSmokeSvg() {
    final scaleAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _animationController!, curve: Curves.fastOutSlowIn),
    );

    return ScaleTransition(
      scale: scaleAnimation,
      alignment: Alignment.bottomCenter, // Grow from the bottom
      child: SvgPicture.asset(
        widget.top,
        width: double.infinity,
        height: 250, // Fixed height
        fit: BoxFit.fill,
      ),
    );
  }

  Widget _buildItemSvg() {
    return Align(
      alignment: Alignment.center,
      child: SvgPicture.asset(
        widget.item,
        width: double.infinity,
        height: 75,
        fit: BoxFit.fill,
      ),
    );
  }

  List<Widget> correctWidget() {
    if (!widget.answeredQuestion) {
      return widget.choice == widget.answer
          ? [_buildChoiceButton(), _buildAlienSvg()]
          : [_buildChoiceButton()];
    }

    if (widget.correctAnswer != widget.answer) {
      _animationController?.reset(); // Reset the animation controller
      _animationController?.forward(); // Start the smoke animation

      if (widget.choice != widget.correctAnswer) {
        return widget.choice == widget.answer
            ? [
                SizedBox(
                  width: double.infinity,
                  height: 250,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Stack(
                      children: [_buildSmokeSvg(), _buildAlienSvg()],
                    ),
                  ),
                ),
              ]
            : [_buildSmokeSvg()];
      } else {
        return [_buildItemSvg()];
      }
    } else {
      _animationController?.reset(); // Reset the animation controller
      _animationController?.forward(); // Start the smoke animation
    }

    return widget.choice == widget.answer
        ? [_buildItemSvg(), _buildAlienSvg()]
        : [_buildSmokeSvg()];
  }

  @override
  Widget build(BuildContext context) {
    print("build");
    return SafeArea(
      child: Column(children: correctWidget()),
    );
  }
}
