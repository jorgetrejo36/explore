import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class GeyserChoiceStateful extends StatefulWidget {
  const GeyserChoiceStateful(
      {Key? key,
      required this.handleState,
      required this.choice,
      required this.answer,
      required this.correctAnswer,
      required this.answeredQuestion,
      required this.item,
      required this.top,
      required this.playerAvatar})
      : super(key: key);

  final Function(int) handleState;
  final int choice;
  final int answer;
  final int correctAnswer;
  final bool answeredQuestion;
  final String item;
  final String top;
  final String playerAvatar;
  @override
  State<GeyserChoiceStateful> createState() => _GeyserChoiceState();
}

class _GeyserChoiceState extends State<GeyserChoiceStateful>
    with TickerProviderStateMixin {
  AnimationController? _animationController;
  AnimationController? _animationController2;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _animationController2 = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController?.dispose();
    _animationController2?.dispose(); // Start the smoke animation
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
    final rotationAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _animationController2!, curve: Curves.linearToEaseOut),
    );

    return RotationTransition(
      turns: rotationAnimation,
      alignment: Alignment.center,
      child: SvgPicture.asset(
        widget.playerAvatar,
        width: double.infinity,
        height: MediaQuery.of(context).size.height / 6,
        fit: BoxFit.fill,
      ),
    );
  }

  Widget _buildSmokeSvg() {
    final scaleAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _animationController!, curve: Curves.linearToEaseOut),
    );

    return ScaleTransition(
      scale: scaleAnimation,
      alignment: Alignment.bottomCenter, // Grow from the bottom
      child: SvgPicture.asset(
        widget.top,
        width: double.infinity,
        height: MediaQuery.of(context).size.height / 4, // Fixed height
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
        height: MediaQuery.of(context).size.height / 12,
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
      if (widget.choice != widget.correctAnswer) {
        _animationController?.reset(); // Reset the animation controller
        _animationController?.forward(); // Start the smoke animation
        _animationController2?.reset(); // Reset the animation controller
        _animationController2?.forward(); // Start the smoke animation

        return widget.choice == widget.answer
            ? [
                SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height / 4,
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
      _animationController?.forward();
    }

    return widget.choice == widget.answer
        ? [_buildItemSvg(), _buildAlienSvg()]
        : [_buildSmokeSvg()];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(children: correctWidget()),
    );
  }
}
