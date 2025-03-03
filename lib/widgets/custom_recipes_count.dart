import 'package:flutter/material.dart';
import 'package:idc_etus_bechar/utils/app_colors.dart';

class CustomRecipeCountControl extends StatefulWidget {
  final List<String> recipeNames;
  final int busTripCount;
  final int selectedRecipeIndex;
  final Function(int) onCircleTap;
  final Function(int) onSelectedIndexChange;

  CustomRecipeCountControl({
    required this.recipeNames,
    required this.busTripCount,
    required this.selectedRecipeIndex,
    required this.onCircleTap,
    required this.onSelectedIndexChange,
  });

  @override
  _CustomRecipeCountControlState createState() =>
      _CustomRecipeCountControlState();
}

class _CustomRecipeCountControlState extends State<CustomRecipeCountControl> {
  ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0.0;

  void _scrollLeft() {
    _scrollOffset -= 100.0;
    _scrollController.animateTo(
      _scrollOffset,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _scrollRight() {
    _scrollOffset += 100.0;
    _scrollController.animateTo(
      _scrollOffset,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        children: [
          if (widget.recipeNames.length > 3)
            GestureDetector(
              onTap: _scrollLeft,
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withOpacity(0.5),
                ),
                child: Icon(
                  Icons.arrow_left,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          SizedBox(width: 10),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              controller: _scrollController,
              child: Row(
                children: List.generate(widget.recipeNames.length, (index) {
                  return GestureDetector(
                    onTap: () {
                      widget.onCircleTap(index);
                      widget.onSelectedIndexChange(index);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: CircleAvatar(
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(color: Colors.white), // Text color
                        ),
                        backgroundColor: widget.selectedRecipeIndex == index
                            ? AppColors.primary
                            :  Colors.grey.shade200,
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
          SizedBox(width: 10),
          if (widget.recipeNames.length > 3)
            GestureDetector(
              onTap: _scrollRight,
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withOpacity(0.5),
                ),
                child: Icon(
                  Icons.arrow_right,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
