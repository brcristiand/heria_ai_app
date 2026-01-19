import 'package:flutter/material.dart';

class TypoH1 extends StatelessWidget {
  final String text;
  final TextAlign? textAlign;
  final Color? color;
  final int? maxLines;
  final TextOverflow? overflow;
  final double? height;

  const TypoH1(
    this.text, {
    super.key,
    this.textAlign,
    this.color,
    this.maxLines,
    this.overflow,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: Theme.of(
        context,
      ).textTheme.displayLarge?.copyWith(color: color, height: height),
    );
  }
}

class TypoH2 extends StatelessWidget {
  final String text;
  final TextAlign? textAlign;
  final Color? color;
  final int? maxLines;
  final TextOverflow? overflow;
  final double? height;

  const TypoH2(
    this.text, {
    super.key,
    this.textAlign,
    this.color,
    this.maxLines,
    this.overflow,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: Theme.of(
        context,
      ).textTheme.displayMedium?.copyWith(color: color, height: height),
    );
  }
}

class TypoH3 extends StatelessWidget {
  final String text;
  final TextAlign? textAlign;
  final Color? color;
  final int? maxLines;
  final TextOverflow? overflow;
  final double? height;

  const TypoH3(
    this.text, {
    super.key,
    this.textAlign,
    this.color,
    this.maxLines,
    this.overflow,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: Theme.of(
        context,
      ).textTheme.displaySmall?.copyWith(color: color, height: height),
    );
  }
}

class TypoH4 extends StatelessWidget {
  final String text;
  final TextAlign? textAlign;
  final Color? color;
  final int? maxLines;
  final TextOverflow? overflow;
  final double? height;

  const TypoH4(
    this.text, {
    super.key,
    this.textAlign,
    this.color,
    this.maxLines,
    this.overflow,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: Theme.of(
        context,
      ).textTheme.headlineLarge?.copyWith(color: color, height: height),
    );
  }
}

class TypoH5 extends StatelessWidget {
  final String text;
  final TextAlign? textAlign;
  final Color? color;
  final int? maxLines;
  final TextOverflow? overflow;
  final double? height;

  const TypoH5(
    this.text, {
    super.key,
    this.textAlign,
    this.color,
    this.maxLines,
    this.overflow,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: Theme.of(
        context,
      ).textTheme.headlineMedium?.copyWith(color: color, height: height),
    );
  }
}

class TypoH6 extends StatelessWidget {
  final String text;
  final TextAlign? textAlign;
  final Color? color;
  final int? maxLines;
  final TextOverflow? overflow;
  final double? height;

  const TypoH6(
    this.text, {
    super.key,
    this.textAlign,
    this.color,
    this.maxLines,
    this.overflow,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: Theme.of(
        context,
      ).textTheme.headlineSmall?.copyWith(color: color, height: height),
    );
  }
}
