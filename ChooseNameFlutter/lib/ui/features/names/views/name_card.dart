import 'package:flutter/material.dart';

import '../../../../domain/models/name_decision.dart';
import '../../../../domain/models/name_record.dart';
import '../../../core/app_colors.dart';

class NameCard extends StatelessWidget {
  const NameCard({
    required this.name,
    required this.onDetails,
    required this.detailsLabel,
    required this.likedStatusLabel,
    required this.dislikedStatusLabel,
    this.fullName,
    this.compact = false,
    super.key,
  });

  final NameRecord name;
  final VoidCallback onDetails;
  final String detailsLabel;
  final String likedStatusLabel;
  final String dislikedStatusLabel;
  final String? fullName;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final hasSupportingInfo =
        (fullName?.isNotEmpty ?? false) ||
        name.decision != NameDecision.neutral;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onDetails,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: compact
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _NameText(name: name.name),
                      if (hasSupportingInfo) ...[
                        const SizedBox(height: 18),
                        SizedBox(
                          width: double.infinity,
                          child: _FullNameAndStatus(
                            fullName: fullName,
                            decision: name.decision,
                            likedStatusLabel: likedStatusLabel,
                            dislikedStatusLabel: dislikedStatusLabel,
                          ),
                        ),
                      ],
                      SizedBox(height: hasSupportingInfo ? 24 : 52),
                      if (name.description?.isNotEmpty ?? false)
                        _DetailsButton(
                          label: detailsLabel,
                          onPressed: onDetails,
                        )
                      else
                        const SizedBox(height: 36),
                    ],
                  ),
                )
              : Column(
                  children: [
                    const Spacer(flex: 88),
                    _NameText(name: name.name),
                    const Spacer(flex: 44),
                    SizedBox(
                      width: double.infinity,
                      child: _FullNameAndStatus(
                        fullName: fullName,
                        decision: name.decision,
                        likedStatusLabel: likedStatusLabel,
                        dislikedStatusLabel: dislikedStatusLabel,
                      ),
                    ),
                    const Spacer(flex: 84),
                    if (name.description?.isNotEmpty ?? false)
                      _DetailsButton(label: detailsLabel, onPressed: onDetails)
                    else
                      const SizedBox(height: 36),
                    const SizedBox(height: 60),
                  ],
                ),
        ),
      ),
    );
  }
}

class _NameText extends StatelessWidget {
  const _NameText({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Text(
      name,
      textAlign: TextAlign.center,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context).textTheme.displaySmall?.copyWith(
        color: AppColors.mainText,
        fontSize: 37,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class _FullNameAndStatus extends StatelessWidget {
  const _FullNameAndStatus({
    required this.fullName,
    required this.decision,
    required this.likedStatusLabel,
    required this.dislikedStatusLabel,
  });

  final String? fullName;
  final NameDecision decision;
  final String likedStatusLabel;
  final String dislikedStatusLabel;

  @override
  Widget build(BuildContext context) {
    final hasFullName = fullName?.isNotEmpty ?? false;
    final hasDecision = decision != NameDecision.neutral;

    if (!hasFullName && !hasDecision) {
      return const SizedBox(height: 30);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (hasFullName)
          Text(
            fullName!,
            key: const ValueKey('card_full_name'),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.secondaryText,
              fontSize: 17,
              fontWeight: FontWeight.w500,
              height: 1.18,
            ),
          ),
        if (hasDecision) ...[
          if (hasFullName) const SizedBox(height: 18),
          _DecisionStatus(
            decision: decision,
            likedStatusLabel: likedStatusLabel,
            dislikedStatusLabel: dislikedStatusLabel,
          ),
        ],
      ],
    );
  }
}

class _DetailsButton extends StatelessWidget {
  const _DetailsButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      height: 36,
      child: OutlinedButton(
        key: const ValueKey('details_button'),
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.secondaryText,
          side: const BorderSide(color: AppColors.secondaryText),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14),
          textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.keyboard_arrow_down, size: 23),
          ],
        ),
      ),
    );
  }
}

class _DecisionStatus extends StatelessWidget {
  const _DecisionStatus({
    required this.decision,
    required this.likedStatusLabel,
    required this.dislikedStatusLabel,
  });

  final NameDecision decision;
  final String likedStatusLabel;
  final String dislikedStatusLabel;

  @override
  Widget build(BuildContext context) {
    final liked = decision == NameDecision.liked;
    return Row(
      key: const ValueKey('card_decision_status'),
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          liked ? Icons.check_circle : Icons.cancel,
          color: AppColors.secondaryText,
          size: 30,
        ),
        const SizedBox(width: 5),
        Flexible(
          child: Text(
            liked ? likedStatusLabel : dislikedStatusLabel,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.secondaryText,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
