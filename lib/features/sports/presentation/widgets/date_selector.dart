import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class DateSelector extends StatefulWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;

  const DateSelector({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  State<DateSelector> createState() => _DateSelectorState();
}

class _DateSelectorState extends State<DateSelector> {
  late ScrollController _scrollController;
  final double itemWidth = 52.0;
  final double separatorWidth = 10.0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    
    // Initial centering of "Today" (index 7 in our 15-day range)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final screenWidth = MediaQuery.of(context).size.width;
        // Today is at index 7.
        // offset = (index * total_item_width) + left_padding - (screen/2) + (item/2)
        // items are separated by separatorWidth, and there is 16px padding on the left
        const double leftPadding = 16.0;
        final double offset = (7 * (itemWidth + separatorWidth)) + leftPadding - (screenWidth / 2) + (itemWidth / 2);
        _scrollController.jumpTo(offset);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    // Generate 15 dates (7 past, today, 7 future)
    final List<DateTime> dates = List.generate(
      15,
      (index) => today.subtract(const Duration(days: 7)).add(Duration(days: index)),
    );

    return Container(
      height: 75, // Reduced container height for 52px cards
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.separated(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: dates.length,
        separatorBuilder: (_, __) => SizedBox(width: separatorWidth),
        itemBuilder: (context, index) {
          final date = dates[index];
          final isSelected = date.day == widget.selectedDate.day && date.month == widget.selectedDate.month;
          final isToday = date.day == today.day && date.month == today.month && date.year == today.year;
          
          return GestureDetector(
            onTap: () => widget.onDateSelected(date),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: itemWidth,   // Square width 52px
                  height: itemWidth,  // Square height 52px
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primaryBlue : AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected ? AppColors.primaryBlue : AppColors.border,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        date.day.toString(),
                        style: AppTypography.h3.copyWith(
                          fontSize: 16, // Adjusted for 52px
                          color: isSelected ? Colors.white : AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        DateFormat('MMM').format(date),
                        style: AppTypography.labelSmall.copyWith(
                          fontSize: 9, // Slightly smaller for 52px
                          color: isSelected ? Colors.white.withOpacity(0.8) : AppColors.textLight,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isToday)
                  Positioned(
                    top: -2,
                    right: -2,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.scaffoldBackground, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
