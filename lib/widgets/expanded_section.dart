import 'package:flutter/material.dart';

/// Widget used to animate expansion and contraction of a section of the widget tree.
/// This is used as a more aesthetically pleasing alternative to [Visibility].
class ExpandedSection extends StatefulWidget {
  final Widget child;

  /// Flag controling whether the section contained by the widget is expanded or not. Defaults to false.
  final bool expand;

  /// Duration of the expansion and contraction animation. Defaults to 500ms.
  final Duration duration;

  ExpandedSection({
    key,
    this.expand = false,
    this.child,
    this.duration = const Duration(milliseconds: 500),
  }) : super(key: key);

  @override
  _ExpandedSectionState createState() => _ExpandedSectionState();
}

class _ExpandedSectionState extends State<ExpandedSection>
    with SingleTickerProviderStateMixin {
  AnimationController expandController;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    prepareAnimations();
    _runExpandCheck();
  }

  /// Setting up the animation
  void prepareAnimations() {
    Duration duration = widget.duration ?? Duration(milliseconds: 500);
    expandController = AnimationController(
      vsync: this,
      duration: duration,
    );
    animation = CurvedAnimation(
      parent: expandController,
      curve: Curves.fastOutSlowIn,
    );
  }

  void _runExpandCheck() {
    if (widget.expand) {
      expandController.forward();
    } else {
      expandController.reverse();
    }
  }

  @override
  void didUpdateWidget(ExpandedSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    _runExpandCheck();
  }

  @override
  void dispose() {
    expandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
        axisAlignment: 1.0, sizeFactor: animation, child: widget.child);
  }
}