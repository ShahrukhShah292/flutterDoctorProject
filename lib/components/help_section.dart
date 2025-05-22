import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HelpSection extends StatefulWidget {
  final VoidCallback? onCallNow;
  final VoidCallback? onChatWithUs;
  final bool initiallyExpanded;
  final Duration animationDuration;

  const HelpSection({
    Key? key,
    this.onCallNow,
    this.onChatWithUs,
    this.initiallyExpanded = false,
    this.animationDuration = const Duration(milliseconds: 400),
  }) : super(key: key);

  @override
  _HelpSectionState createState() => _HelpSectionState();
}

class _HelpSectionState extends State<HelpSection>
    with TickerProviderStateMixin {
  AnimationController? _pulseController;
  AnimationController? _expandController;
  AnimationController? _fabController;
  AnimationController? _callButtonController;
  AnimationController? _chatButtonController;
  
  Animation<double>? _pulseAnimation;
  Animation<double>? _expandAnimation;
  Animation<double>? _fabRotationAnimation;
  Animation<double>? _fabScaleAnimation;
  Animation<double>? _callScaleAnimation;
  Animation<double>? _chatScaleAnimation;
  
  bool _isExpanded = false;
  bool _isCallHovered = false;
  bool _isChatHovered = false;

  @override
  void initState() {
    super.initState();
    
    _isExpanded = widget.initiallyExpanded;
    
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _expandController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    
    _fabController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _callButtonController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    
    _chatButtonController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController!,
      curve: Curves.easeInOut,
    ));
    
    _expandAnimation = CurvedAnimation(
      parent: _expandController!,
      curve: Curves.easeInOutCubic,
    );
    
    _fabRotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.75, 
    ).animate(CurvedAnimation(
      parent: _expandController!,
      curve: Curves.easeInOutCubic,
    ));
    
    _fabScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _fabController!,
      curve: Curves.easeInOut,
    ));
    
    _callScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _callButtonController!,
      curve: Curves.easeInOut,
    ));
    
    _chatScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _chatButtonController!,
      curve: Curves.easeInOut,
    ));
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        if (_isExpanded) {
          _expandController?.value = 1.0;
        }
        _pulseController?.repeat(reverse: true);
      }
    });
  }

  @override
  void dispose() {
    _pulseController?.dispose();
    _expandController?.dispose();
    _fabController?.dispose();
    _callButtonController?.dispose();
    _chatButtonController?.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
    
    if (_isExpanded) {
      _expandController?.forward();
    } else {
      _expandController?.reverse();
    }
    
    HapticFeedback.mediumImpact();
  }

  void _onFabHover(bool hovering) {
    if (hovering) {
      _fabController?.forward();
    } else {
      _fabController?.reverse();
    }
  }

  void _onCallHover(bool hovering) {
    setState(() {
      _isCallHovered = hovering;
    });
    
    if (hovering) {
      _callButtonController?.forward();
    } else {
      _callButtonController?.reverse();
    }
  }

  void _onChatHover(bool hovering) {
    setState(() {
      _isChatHovered = hovering;
    });
    
    if (hovering) {
      _chatButtonController?.forward();
    } else {
      _chatButtonController?.reverse();
    }
  }

  void _onCallPressed() {
    HapticFeedback.mediumImpact();
    widget.onCallNow?.call();
  }

  void _onChatPressed() {
    HapticFeedback.lightImpact();
    widget.onChatWithUs?.call();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).primaryColor;
    
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        AnimatedBuilder(
          animation: _expandAnimation ?? const AlwaysStoppedAnimation(0.0),
          builder: (context, child) {
            final animationValue = _expandAnimation?.value ?? 0.0;
            return Transform.scale(
              scale: animationValue,
              alignment: Alignment.bottomRight,
              child: Opacity(
                opacity: animationValue,
                child: Container(
                  margin: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    bottom: 80, 
                    top: 16,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                        spreadRadius: 2,
                      ),
                      BoxShadow(
                        color: isDark 
                            ? Colors.black.withOpacity(0.3)
                            : Colors.white.withOpacity(0.7),
                        blurRadius: 20,
                        offset: const Offset(0, -2),
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: isDark 
                              ? [
                                  Colors.grey.shade800,
                                  Colors.grey.shade900,
                                ]
                              : [
                                  Colors.white,
                                  Colors.grey.shade50,
                                ],
                        ),
                      ),
                      child: Stack(
                        children: [
                          _buildFloatingOrbs(isDark, primaryColor),
                          
                          Positioned(
                            top: 12,
                            right: 12,
                            child: _buildCloseButton(isDark, primaryColor),
                          ),
                          
                          Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildHeader(isDark, primaryColor),
                                const SizedBox(height: 16),
                                _buildDescription(isDark),
                                const SizedBox(height: 24),
                                _buildActionButtons(isDark, primaryColor),
                                const SizedBox(height: 12),
                                _buildSupportInfo(isDark),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        
        Positioned(
          bottom: 16,
          right: 16,
          child: _buildFloatingActionButton(isDark, primaryColor),
        ),
      ],
    );
  }

  Widget _buildFloatingActionButton(bool isDark, Color primaryColor) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _fabRotationAnimation ?? const AlwaysStoppedAnimation(0.0),
        _fabScaleAnimation ?? const AlwaysStoppedAnimation(1.0)
      ]),
      builder: (context, child) {
        final scaleValue = _fabScaleAnimation?.value ?? 1.0;
        final rotationValue = _fabRotationAnimation?.value ?? 0.0;
        
        return Transform.scale(
          scale: scaleValue,
          child: MouseRegion(
            onEnter: (_) => _onFabHover(true),
            onExit: (_) => _onFabHover(false),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: FloatingActionButton(
                onPressed: _toggleExpanded,
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                elevation: 0,
                child: AnimatedBuilder(
                  animation: _pulseAnimation ?? const AlwaysStoppedAnimation(1.0),
                  builder: (context, child) {
                    final pulseValue = _pulseAnimation?.value ?? 1.0;
                    return Transform.scale(
                      scale: _isExpanded ? 1.0 : pulseValue,
                      child: Transform.rotate(
                        angle: rotationValue * 3.14159 * 2,
                        child: Icon(
                          _isExpanded ? Icons.close : Icons.help_center,
                          size: 28,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCloseButton(bool isDark, Color primaryColor) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isDark 
            ? Colors.grey.shade700
            : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        onPressed: _toggleExpanded,
        icon: Icon(
          Icons.close,
          color: isDark ? Colors.white : Colors.grey.shade600,
          size: 20,
        ),
        padding: const EdgeInsets.all(8),
        constraints: const BoxConstraints(
          minWidth: 36,
          minHeight: 36,
        ),
      ),
    );
  }

  Widget _buildFloatingOrbs(bool isDark, Color primaryColor) {
    return Positioned.fill(
      child: Stack(
        children: [
          Positioned(
            top: -20,
            right: -20,
            child: AnimatedBuilder(
              animation: _pulseAnimation ?? const AlwaysStoppedAnimation(1.0),
              builder: (context, child) {
                final pulseValue = _pulseAnimation?.value ?? 1.0;
                return Transform.scale(
                  scale: pulseValue,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          primaryColor.withOpacity(0.1),
                          primaryColor.withOpacity(0.05),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned(
            bottom: -30,
            left: -30,
            child: AnimatedBuilder(
              animation: _pulseAnimation ?? const AlwaysStoppedAnimation(1.0),
              builder: (context, child) {
                final pulseValue = _pulseAnimation?.value ?? 1.0;
                return Transform.scale(
                  scale: 1.2 - (pulseValue - 1.0),
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          primaryColor.withOpacity(0.08),
                          primaryColor.withOpacity(0.03),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isDark, Color primaryColor) {
    return Row(
      children: [
        AnimatedBuilder(
          animation: _pulseAnimation ?? const AlwaysStoppedAnimation(1.0),
          builder: (context, child) {
            final pulseValue = _pulseAnimation?.value ?? 1.0;
            return Transform.scale(
              scale: pulseValue,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      primaryColor.withOpacity(0.8),
                      primaryColor,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.support_agent,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            );
          },
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Need Help?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                height: 3,
                width: 40,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [primaryColor, primaryColor.withOpacity(0.3)],
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
        
        
      ],
    );
  }

  Widget _buildDescription(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark 
            ? Colors.grey.shade700
            : Colors.blue.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark 
              ? Colors.grey.shade600
              : Colors.blue.shade100,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: isDark ? Colors.blue.shade300 : Colors.blue.shade600,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Our expert support team is available 24/7 to assist you with any healthcare queries, appointment bookings, or technical issues.',
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.grey.shade200 : Colors.grey.shade700,
                height: 1.4,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(bool isDark, Color primaryColor) {
    return Row(
      children: [
        Expanded(
          child: AnimatedBuilder(
            animation: _callScaleAnimation ?? const AlwaysStoppedAnimation(1.0),
            builder: (context, child) {
              final scaleValue = _callScaleAnimation?.value ?? 1.0;
              return Transform.scale(
                scale: scaleValue,
                child: MouseRegion(
                  onEnter: (_) => _onCallHover(true),
                  onExit: (_) => _onCallHover(false),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.green.shade400,
                          Colors.green.shade600,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(_isCallHovered ? 0.4 : 0.2),
                          blurRadius: _isCallHovered ? 16 : 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton.icon(
                      onPressed: _onCallPressed,
                      icon: const Icon(Icons.phone, size: 20),
                      label: const Text(
                        'Call Now',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.white,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        
        const SizedBox(width: 16),
        
        Expanded(
          child: AnimatedBuilder(
            animation: _chatScaleAnimation ?? const AlwaysStoppedAnimation(1.0),
            builder: (context, child) {
              final scaleValue = _chatScaleAnimation?.value ?? 1.0;
              return Transform.scale(
                scale: scaleValue,
                child: MouseRegion(
                  onEnter: (_) => _onChatHover(true),
                  onExit: (_) => _onChatHover(false),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: primaryColor.withOpacity(0.3),
                        width: 2,
                      ),
                      boxShadow: [
                        if (_isChatHovered)
                          BoxShadow(
                            color: primaryColor.withOpacity(0.2),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                      ],
                    ),
                    child: OutlinedButton.icon(
                      onPressed: _onChatPressed,
                      icon: Icon(
                        Icons.chat_bubble_outline,
                        size: 20,
                        color: _isChatHovered ? Colors.white : primaryColor,
                      ),
                      label: Text(
                        'Chat with Us',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: _isChatHovered ? Colors.white : primaryColor,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: _isChatHovered 
                            ? primaryColor 
                            : Colors.transparent,
                        side: BorderSide.none,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSupportInfo(bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.schedule,
          size: 16,
          color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
        ),
        const SizedBox(width: 6),
        Text(
          'Average response time: 2 minutes',
          style: TextStyle(
            fontSize: 12,
            color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 16),
        Icon(
          Icons.verified_user,
          size: 16,
          color: Colors.green.shade600,
        ),
        const SizedBox(width: 6),
        Text(
          'Secure & Private',
          style: TextStyle(
            fontSize: 12,
            color: Colors.green.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}