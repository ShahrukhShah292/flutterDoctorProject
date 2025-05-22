import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EnhancedTabSwitcher extends StatefulWidget {
  final List<TabItem> tabs;
  final int selectedIndex;
  final Function(int) onTabSelected;
  final TabSwitcherStyle style;
  final double height;
  final EdgeInsets margin;
  final Duration animationDuration;
  final bool enableHaptics;
  final bool enableIcons;

  const EnhancedTabSwitcher({
    Key? key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTabSelected,
    this.style = TabSwitcherStyle.modern,
    this.height = 56,
    this.margin = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.animationDuration = const Duration(milliseconds: 300),
    this.enableHaptics = true,
    this.enableIcons = false,
  }) : super(key: key);

  @override
  _EnhancedTabSwitcherState createState() => _EnhancedTabSwitcherState();
}

class _EnhancedTabSwitcherState extends State<EnhancedTabSwitcher>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _scaleController;
  late Animation<double> _slideAnimation;
  late Animation<double> _scaleAnimation;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.selectedIndex;
    
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    
    _slideAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutCubic,
    ));
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void didUpdateWidget(EnhancedTabSwitcher oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedIndex != widget.selectedIndex) {
      _updateSelectedIndex(widget.selectedIndex);
    }
  }

  void _updateSelectedIndex(int newIndex) {
    if (_currentIndex != newIndex) {
      setState(() {
        _currentIndex = newIndex;
      });
      _animationController.forward().then((_) {
        _animationController.reverse();
      });
    }
  }

  void _onTabTap(int index) {
    if (widget.enableHaptics) {
      HapticFeedback.lightImpact();
    }
    
    _scaleController.forward().then((_) {
      _scaleController.reverse();
    });
    
    widget.onTabSelected(index);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.style) {
      case TabSwitcherStyle.glassmorphism:
        return _buildGlassmorphismTabs();
      case TabSwitcherStyle.neumorphism:
        return _buildNeumorphismTabs();
      case TabSwitcherStyle.gradient:
        return _buildGradientTabs();
      case TabSwitcherStyle.modern:
      default:
        return _buildModernTabs();
    }
  }

  Widget _buildModernTabs() {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            height: widget.height,
            margin: widget.margin,
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey.shade800
                  : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(widget.height / 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              children: [
                AnimatedPositioned(
                  duration: widget.animationDuration,
                  curve: Curves.easeInOutCubic,
                  left: (MediaQuery.of(context).size.width - widget.margin.horizontal) / 
                        widget.tabs.length * widget.selectedIndex,
                  top: 4,
                  bottom: 4,
                  width: (MediaQuery.of(context).size.width - widget.margin.horizontal) / 
                         widget.tabs.length - 8,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).primaryColor,
                          Theme.of(context).primaryColor.withOpacity(0.8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular((widget.height - 8) / 2),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).primaryColor.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: List.generate(
                    widget.tabs.length,
                    (index) => _buildTabItem(index),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildGlassmorphismTabs() {
    return Container(
      height: widget.height,
      margin: widget.margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.height / 2),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.height / 2),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(widget.height / 2),
          ),
          child: Stack(
            children: [
              AnimatedPositioned(
                duration: widget.animationDuration,
                curve: Curves.easeInOutCubic,
                left: (MediaQuery.of(context).size.width - widget.margin.horizontal) / 
                      widget.tabs.length * widget.selectedIndex,
                top: 0,
                bottom: 0,
                width: (MediaQuery.of(context).size.width - widget.margin.horizontal) / 
                       widget.tabs.length,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(widget.height / 2),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                ),
              ),
              Row(
                children: List.generate(
                  widget.tabs.length,
                  (index) => _buildTabItem(index, isGlass: true),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNeumorphismTabs() {
    return Container(
      height: widget.height,
      margin: widget.margin,
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey.shade800
            : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(widget.height / 2),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.black.withOpacity(0.3)
                : Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(5, 5),
          ),
          BoxShadow(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white.withOpacity(0.1)
                : Colors.white,
            blurRadius: 15,
            offset: const Offset(-5, -5),
          ),
        ],
      ),
      child: Stack(
        children: [
          AnimatedPositioned(
            duration: widget.animationDuration,
            curve: Curves.easeInOutCubic,
            left: (MediaQuery.of(context).size.width - widget.margin.horizontal) / 
                  widget.tabs.length * widget.selectedIndex + 4,
            top: 4,
            bottom: 4,
            width: (MediaQuery.of(context).size.width - widget.margin.horizontal) / 
                   widget.tabs.length - 8,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey.shade700
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular((widget.height - 8) / 2),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white.withOpacity(0.1)
                        : Colors.white,
                    blurRadius: 8,
                    offset: const Offset(-2, -2),
                  ),
                  BoxShadow(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.black.withOpacity(0.3)
                        : Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
            ),
          ),
          Row(
            children: List.generate(
              widget.tabs.length,
              (index) => _buildTabItem(index),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradientTabs() {
    return Container(
      height: widget.height,
      margin: widget.margin,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.purple.shade400,
            Colors.blue.shade400,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(widget.height / 2),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          AnimatedPositioned(
            duration: widget.animationDuration,
            curve: Curves.easeInOutCubic,
            left: (MediaQuery.of(context).size.width - widget.margin.horizontal) / 
                  widget.tabs.length * widget.selectedIndex + 4,
            top: 4,
            bottom: 4,
            width: (MediaQuery.of(context).size.width - widget.margin.horizontal) / 
                   widget.tabs.length - 8,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular((widget.height - 8) / 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),
          Row(
            children: List.generate(
              widget.tabs.length,
              (index) => _buildTabItem(index, isGradient: true),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem(int index, {bool isGlass = false, bool isGradient = false}) {
    final isSelected = widget.selectedIndex == index;
    final tab = widget.tabs[index];
    
    Color textColor;
    if (isGradient) {
      textColor = isSelected ? Colors.purple.shade600 : Colors.white;
    } else if (isGlass) {
      textColor = Colors.white;
    } else {
      textColor = isSelected 
          ? Colors.white 
          : (Theme.of(context).brightness == Brightness.dark 
              ? Colors.white70 
              : Colors.black87);
    }

    return Expanded(
      child: GestureDetector(
        onTap: () => _onTabTap(index),
        child: AnimatedBuilder(
          animation: _slideAnimation,
          builder: (context, child) {
            return Container(
              alignment: Alignment.center,
              child: AnimatedDefaultTextStyle(
                duration: widget.animationDuration,
                style: TextStyle(
                  color: textColor,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  fontSize: isSelected ? 16 : 14,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.enableIcons && tab.icon != null) ...[
                      AnimatedContainer(
                        duration: widget.animationDuration,
                        child: Icon(
                          tab.icon,
                          color: textColor,
                          size: isSelected ? 20 : 18,
                        ),
                      ),
                      const SizedBox(width: 6),
                    ],
                    Flexible(
                      child: Text(
                        tab.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class TabItem {
  final String title;
  final IconData? icon;

  const TabItem({
    required this.title,
    this.icon,
  });
}

enum TabSwitcherStyle {
  modern,
  glassmorphism,
  neumorphism,
  gradient,
}

List<TabItem> stringListToTabItems(List<String> strings) {
  return strings.map((string) => TabItem(title: string)).toList();
}

