import 'package:flutter/material.dart';

import 'container_layout.dart';
import 'media_query.dart';

/// The active layout mode used by [AdaptiveForm].
enum AdaptiveFormMode {
  stepper,
  sectioned,
}

/// A logical section within an [AdaptiveForm].
class AdaptiveFormSection {
  /// Section title.
  final String title;

  /// Optional supporting copy shown below the title.
  final String? description;

  /// Optional leading widget shown beside the title.
  final Widget? leading;

  /// Form fields or related content within the section.
  final List<Widget> children;

  /// Optional footer shown after the section content.
  final Widget? footer;

  /// Optional explicit state when the section is rendered in a stepper.
  final StepState? stepState;

  /// Creates a form section definition.
  const AdaptiveFormSection({
    required this.title,
    required this.children,
    this.description,
    this.leading,
    this.footer,
    this.stepState,
  });
}

/// An adaptive form surface that switches between grouped cards and a stepper.
///
/// Compact containers render a vertical stepper by default. Medium and expanded
/// containers render section cards laid out in columns.
class AdaptiveForm extends StatefulWidget {
  /// Sections shown by the form.
  final List<AdaptiveFormSection> sections;

  /// Adaptive size at which the form switches to grouped section cards.
  final AdaptiveSize sectionedAt;

  /// Whether the form should resolve layout from its parent constraints.
  final bool useContainerConstraints;

  /// Whether orientation should influence container breakpoint resolution.
  final bool considerOrientation;

  /// Minimum width each section card should try to maintain.
  final double minSectionWidth;

  /// Space between section cards.
  final double sectionSpacing;

  /// Vertical space between fields inside a section.
  final double fieldSpacing;

  /// Padding inside each section card.
  final EdgeInsetsGeometry sectionPadding;

  /// Currently active step for controlled usage.
  final int? currentStep;

  /// Called when the active step changes.
  final ValueChanged<int>? onStepChanged;

  /// Called when the final step continues.
  final VoidCallback? onCompleted;

  /// Whether a step can be activated by tapping its header.
  final bool allowStepTapping;

  /// Label used for non-terminal step advancement.
  final String continueLabel;

  /// Label used on the final step action.
  final String completeLabel;

  /// Label used for the back action.
  final String backLabel;

  /// Whether to animate size changes while switching layout modes.
  final bool animateSize;

  /// Duration used by [AnimatedSize].
  final Duration animationDuration;

  /// Curve used by [AnimatedSize].
  final Curve animationCurve;

  /// Creates an adaptive form.
  const AdaptiveForm({
    super.key,
    required this.sections,
    this.sectionedAt = AdaptiveSize.medium,
    this.useContainerConstraints = true,
    this.considerOrientation = false,
    this.minSectionWidth = 320,
    this.sectionSpacing = 16,
    this.fieldSpacing = 16,
    this.sectionPadding = const EdgeInsets.all(20),
    this.currentStep,
    this.onStepChanged,
    this.onCompleted,
    this.allowStepTapping = true,
    this.continueLabel = 'Continue',
    this.completeLabel = 'Finish',
    this.backLabel = 'Back',
    this.animateSize = true,
    this.animationDuration = const Duration(milliseconds: 250),
    this.animationCurve = Curves.easeInOutCubic,
  });

  @override
  State<AdaptiveForm> createState() => _AdaptiveFormState();
}

class _AdaptiveFormState extends State<AdaptiveForm> {
  int _internalStep = 0;

  bool get _isControlled => widget.currentStep != null;

  int get _maxStepIndex {
    if (widget.sections.isEmpty) {
      return 0;
    }
    return widget.sections.length - 1;
  }

  int get _currentStep {
    final rawStep = widget.currentStep ?? _internalStep;
    if (rawStep < 0) {
      return 0;
    }
    if (rawStep > _maxStepIndex) {
      return _maxStepIndex;
    }
    return rawStep;
  }

  @override
  void didUpdateWidget(covariant AdaptiveForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_isControlled || widget.sections.isEmpty) {
      return;
    }
    if (_internalStep > _maxStepIndex) {
      _internalStep = _maxStepIndex;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.sections.isEmpty) {
      return const SizedBox.shrink();
    }

    final child = widget.useContainerConstraints
        ? ResponsiveContainerBuilder(
            considerOrientation: widget.considerOrientation,
            builder: (context, data) => _buildForData(context, data),
          )
        : Builder(
            builder: (context) =>
                _buildForData(context, context.breakPointData),
          );

    if (!widget.animateSize) {
      return child;
    }

    return AnimatedSize(
      duration: widget.animationDuration,
      curve: widget.animationCurve,
      alignment: Alignment.topCenter,
      child: child,
    );
  }

  Widget _buildForData(BuildContext context, BreakPointData data) {
    final mode = _modeForData(data.adaptiveSize);
    return switch (mode) {
      AdaptiveFormMode.stepper => _AdaptiveFormStepper(
          sections: widget.sections,
          currentStep: _currentStep,
          allowStepTapping: widget.allowStepTapping,
          fieldSpacing: widget.fieldSpacing,
          continueLabel: widget.continueLabel,
          completeLabel: widget.completeLabel,
          backLabel: widget.backLabel,
          onStepChanged: _setStep,
          onCompleted: widget.onCompleted,
          stepStateFor: _stepStateFor,
        ),
      AdaptiveFormMode.sectioned => _AdaptiveFormSections(
          sections: widget.sections,
          minSectionWidth: widget.minSectionWidth,
          sectionSpacing: widget.sectionSpacing,
          fieldSpacing: widget.fieldSpacing,
          sectionPadding: widget.sectionPadding,
        ),
    };
  }

  AdaptiveFormMode _modeForData(AdaptiveSize adaptiveSize) {
    if (widget.sections.length <= 1) {
      return AdaptiveFormMode.sectioned;
    }
    return adaptiveSize.index >= widget.sectionedAt.index
        ? AdaptiveFormMode.sectioned
        : AdaptiveFormMode.stepper;
  }

  StepState _stepStateFor(int index) {
    final section = widget.sections[index];
    if (section.stepState != null) {
      return section.stepState!;
    }
    if (index < _currentStep) {
      return StepState.complete;
    }
    if (index == _currentStep) {
      return StepState.editing;
    }
    return StepState.indexed;
  }

  void _setStep(int index) {
    if (index < 0 || index > _maxStepIndex) {
      return;
    }
    widget.onStepChanged?.call(index);
    if (_isControlled) {
      return;
    }
    setState(() {
      _internalStep = index;
    });
  }
}

class _AdaptiveFormStepper extends StatelessWidget {
  final List<AdaptiveFormSection> sections;
  final int currentStep;
  final bool allowStepTapping;
  final double fieldSpacing;
  final String continueLabel;
  final String completeLabel;
  final String backLabel;
  final ValueChanged<int> onStepChanged;
  final VoidCallback? onCompleted;
  final StepState Function(int index) stepStateFor;

  const _AdaptiveFormStepper({
    required this.sections,
    required this.currentStep,
    required this.allowStepTapping,
    required this.fieldSpacing,
    required this.continueLabel,
    required this.completeLabel,
    required this.backLabel,
    required this.onStepChanged,
    required this.onCompleted,
    required this.stepStateFor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Stepper(
        type: StepperType.vertical,
        currentStep: currentStep,
        onStepTapped: allowStepTapping ? onStepChanged : null,
        onStepContinue: () {
          if (currentStep >= sections.length - 1) {
            onCompleted?.call();
            return;
          }
          onStepChanged(currentStep + 1);
        },
        onStepCancel:
            currentStep == 0 ? null : () => onStepChanged(currentStep - 1),
        controlsBuilder: (context, details) {
          final isLastStep = currentStep >= sections.length - 1;
          return Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                FilledButton(
                  onPressed: details.onStepContinue,
                  child: Text(isLastStep ? completeLabel : continueLabel),
                ),
                if (currentStep > 0)
                  TextButton(
                    onPressed: details.onStepCancel,
                    child: Text(backLabel),
                  ),
              ],
            ),
          );
        },
        steps: [
          for (var index = 0; index < sections.length; index++)
            Step(
              title: _AdaptiveFormSectionTitle(section: sections[index]),
              subtitle: sections[index].description == null
                  ? null
                  : Text(sections[index].description!),
              isActive: index == currentStep,
              state: stepStateFor(index),
              content: _AdaptiveFormSectionBody(
                section: sections[index],
                fieldSpacing: fieldSpacing,
              ),
            ),
        ],
      ),
    );
  }
}

class _AdaptiveFormSections extends StatelessWidget {
  final List<AdaptiveFormSection> sections;
  final double minSectionWidth;
  final double sectionSpacing;
  final double fieldSpacing;
  final EdgeInsetsGeometry sectionPadding;

  const _AdaptiveFormSections({
    required this.sections,
    required this.minSectionWidth,
    required this.sectionSpacing,
    required this.fieldSpacing,
    required this.sectionPadding,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final mediaWidth = MediaQuery.maybeOf(context)?.size.width ?? 0;
        final availableWidth =
            constraints.maxWidth.isFinite ? constraints.maxWidth : mediaWidth;
        final safeWidth = availableWidth > 0 ? availableWidth : minSectionWidth;
        final computedColumns =
            ((safeWidth + sectionSpacing) / (minSectionWidth + sectionSpacing))
                .floor();
        final columnCount = computedColumns < 1
            ? 1
            : computedColumns > sections.length
                ? sections.length
                : computedColumns;
        final itemWidth = columnCount == 1
            ? safeWidth
            : (safeWidth - (sectionSpacing * (columnCount - 1))) / columnCount;

        return Wrap(
          spacing: sectionSpacing,
          runSpacing: sectionSpacing,
          children: [
            for (final section in sections)
              SizedBox(
                width: itemWidth,
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  child: Padding(
                    padding: sectionPadding,
                    child: _AdaptiveFormSectionBody(
                      section: section,
                      fieldSpacing: fieldSpacing,
                      showHeader: true,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _AdaptiveFormSectionTitle extends StatelessWidget {
  final AdaptiveFormSection section;

  const _AdaptiveFormSectionTitle({
    required this.section,
  });

  @override
  Widget build(BuildContext context) {
    final title = Text(
      section.title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
    );

    if (section.leading == null) {
      return title;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        section.leading!,
        const SizedBox(width: 12),
        Flexible(child: title),
      ],
    );
  }
}

class _AdaptiveFormSectionBody extends StatelessWidget {
  final AdaptiveFormSection section;
  final double fieldSpacing;
  final bool showHeader;

  const _AdaptiveFormSectionBody({
    required this.section,
    required this.fieldSpacing,
    this.showHeader = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showHeader) ...[
          _AdaptiveFormSectionTitle(section: section),
          if (section.description != null) ...[
            const SizedBox(height: 8),
            Text(section.description!),
          ],
          const SizedBox(height: 16),
        ],
        for (var index = 0; index < section.children.length; index++) ...[
          if (index > 0) SizedBox(height: fieldSpacing),
          section.children[index],
        ],
        if (section.footer != null) ...[
          const SizedBox(height: 16),
          section.footer!,
        ],
      ],
    );
  }
}
