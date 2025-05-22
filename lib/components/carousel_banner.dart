import 'package:flutter/material.dart';
import 'dart:async';

class EnhancedCarouselBanner extends StatefulWidget {
  final List<CarouselItem> items;
  final double height;
  final Duration autoScrollDuration;
  final bool enableAutoScroll;
  final bool showIndicators;
  final bool enableParallax;
  final EdgeInsets margin;
  final BorderRadius borderRadius;
  final CarouselIndicatorStyle indicatorStyle;

  const EnhancedCarouselBanner({
    Key? key,
    required this.items,
    this.height = 200.0,
    this.autoScrollDuration = const Duration(seconds: 4),
    this.enableAutoScroll = true,
    this.showIndicators = true,
    this.enableParallax = true,
    this.margin = const EdgeInsets.all(16.0),
    this.borderRadius = const BorderRadius.all(Radius.circular(16.0)),
    this.indicatorStyle = CarouselIndicatorStyle.dots,
  }) : super(key: key);

  @override
  _EnhancedCarouselBannerState createState() => _EnhancedCarouselBannerState();
}

class _EnhancedCarouselBannerState extends State<EnhancedCarouselBanner>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController(viewportFraction: 0.9);
  Timer? _autoScrollTimer;
  int _currentPage = 0;
  late AnimationController _indicatorController;
  late AnimationController _scaleController;
  bool _isUserInteracting = false;

  @override
  void initState() {
    super.initState();
    _indicatorController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    if (widget.enableAutoScroll) {
      _startAutoScroll();
    }
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _pageController.dispose();
    _indicatorController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = Timer.periodic(widget.autoScrollDuration, (timer) {
      if (_isUserInteracting) return;
      
      if (_currentPage < widget.items.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  void _pauseAutoScroll() {
    setState(() {
      _isUserInteracting = true;
    });
    
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isUserInteracting = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      margin: widget.margin,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: widget.borderRadius,
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.items.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
                _indicatorController.forward().then((_) {
                  _indicatorController.reverse();
                });
              },
              itemBuilder: (context, index) {
                return AnimatedBuilder(
                  animation: _pageController,
                  builder: (context, child) {
                    double value = 1.0;
                    if (_pageController.position.haveDimensions) {
                      value = _pageController.page! - index;
                      value = (1 - (value.abs() * 0.3)).clamp(0.0, 1.0);
                    }
                    return _buildCarouselItem(widget.items[index], value);
                  },
                );
              },
            ),
          ),
          
          Positioned.fill(
            child: ClipRRect(
              borderRadius: widget.borderRadius,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.1),
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          Positioned.fill(
            child: GestureDetector(
              onTapDown: (_) {
                _scaleController.forward();
                _pauseAutoScroll();
              },
              onTapUp: (_) {
                _scaleController.reverse();
              },
              onTapCancel: () {
                _scaleController.reverse();
              },
              child: Container(color: Colors.transparent),
            ),
          ),
          
          if (widget.showIndicators)
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: _buildIndicators(),
            ),
        ],
      ),
    );
  }

  Widget _buildCarouselItem(CarouselItem item, double parallaxValue) {
    return GestureDetector(
      onPanStart: (_) => _pauseAutoScroll(),
      child: AnimatedBuilder(
        animation: _scaleController,
        builder: (context, child) {
          return Transform.scale(
            scale: 1.0 - (_scaleController.value * 0.02),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              decoration: BoxDecoration(
                borderRadius: widget.borderRadius,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: widget.borderRadius,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Transform.scale(
                      scale: widget.enableParallax ? 1.0 + (parallaxValue * 0.1) : 1.0,
                      child: Image.network(
                        item.imageUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: Colors.grey.shade200,
                            child: Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey.shade200,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.image_not_supported_outlined,
                                  color: Colors.grey.shade400,
                                  size: 48,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Image not available',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    
                    if (item.title != null || item.subtitle != null)
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black.withOpacity(0.8),
                                Colors.transparent,
                              ],
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (item.title != null)
                                Text(
                                  item.title!,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              if (item.subtitle != null) ...[
                                const SizedBox(height: 4),
                                Text(
                                  item.subtitle!,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildIndicators() {
    switch (widget.indicatorStyle) {
      case CarouselIndicatorStyle.bars:
        return _buildBarIndicators();
      case CarouselIndicatorStyle.numbers:
        return _buildNumberIndicator();
      case CarouselIndicatorStyle.dots:
      default:
        return _buildDotIndicators();
    }
  }

  Widget _buildDotIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        widget.items.length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          height: 8.0,
          width: _currentPage == index ? 24.0 : 8.0,
          decoration: BoxDecoration(
            color: _currentPage == index 
                ? Colors.white
                : Colors.white.withOpacity(0.4),
            borderRadius: BorderRadius.circular(4.0),
            boxShadow: [
              if (_currentPage == index)
                BoxShadow(
                  color: Colors.white.withOpacity(0.5),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBarIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        widget.items.length,
        (index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 2.0),
          height: 4.0,
          width: MediaQuery.of(context).size.width / widget.items.length - 20,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.3),
            borderRadius: BorderRadius.circular(2.0),
          ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: _currentPage == index 
                ? MediaQuery.of(context).size.width / widget.items.length - 20
                : 0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(2.0),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNumberIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        '${_currentPage + 1} / ${widget.items.length}',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class CarouselItem {
  final String imageUrl;
  final String? title;
  final String? subtitle;
  final VoidCallback? onTap;

  const CarouselItem({
    required this.imageUrl,
    this.title,
    this.subtitle,
    this.onTap,
  });
}

enum CarouselIndicatorStyle {
  dots,
  bars,
  numbers,
}

