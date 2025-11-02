import 'package:flutter/material.dart';

class CustomPage extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;

  /// Optional: short bullet points shown under the description.
  final List<String> bullets;

  /// Optional: put image on the right on wide screens (for alternating layouts).
  final bool invertLayout;

  /// Optional: cap max content width on large screens.
  final double maxWidth;

  /// Optional: override image height. If null, it adapts to screen size.
  final double? imageHeight;

  const CustomPage({
    super.key,
    required this.title,
    required this.description,
    required this.imagePath,
    this.bullets = const [],
    this.invertLayout = false,
    this.maxWidth = 900,
    this.imageHeight,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 640;
        final imgH = imageHeight ?? (isWide ? 300.0 : 220.0);

        final image = _BrandedImage(imagePath: imagePath, height: imgH);

        final text = _TextBlock(
          title: title,
          description: description,
          bullets: bullets,
        );

        Widget content;
        if (isWide) {
          final children = <Widget>[
            Expanded(child: image),
            const SizedBox(width: 24),
            Expanded(child: text),
          ];
          content = Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: invertLayout ? children.reversed.toList() : children,
          );
        } else {
          content = Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              image,
              const SizedBox(height: 24),
              text,
            ],
          );
        }

        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: content,
            ),
          ),
        );
      },
    );
  }
}

class _BrandedImage extends StatelessWidget {
  final String imagePath;
  final double height;
  const _BrandedImage({required this.imagePath, required this.height});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            cs.primary.withOpacity(0.06),
            cs.secondary.withOpacity(0.06),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          imagePath,
          height: height,
          fit: BoxFit.contain,
          semanticLabel: 'Illustration for $imagePath',
        ),
      ),
    );
  }
}

class _TextBlock extends StatelessWidget {
  final String title;
  final String description;
  final List<String> bullets;
  const _TextBlock({
    required this.title,
    required this.description,
    required this.bullets,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isWide = MediaQuery.sizeOf(context).width >= 640;

    return Column(
      crossAxisAlignment: isWide ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Text(
          title,
          textAlign: isWide ? TextAlign.start : TextAlign.center,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
            color: cs.primary,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          description,
          textAlign: isWide ? TextAlign.start : TextAlign.center,
          style: theme.textTheme.bodyLarge,
        ),
        if (bullets.isNotEmpty) ...[
          const SizedBox(height: 12),
          Column(
            crossAxisAlignment: isWide ? CrossAxisAlignment.start : CrossAxisAlignment.center,
            children: bullets.map((b) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.check_circle_rounded,
                        size: 18, color: cs.secondary),
                    const SizedBox(width: 8),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 520),
                      child: Text(
                        b,
                        style: theme.textTheme.bodyMedium,
                        textAlign: isWide ? TextAlign.start : TextAlign.center,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}
