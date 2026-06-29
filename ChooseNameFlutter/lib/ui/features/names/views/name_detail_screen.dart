import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../data/repositories/name_repository.dart';
import '../../../../data/repositories/user_preferences_repository.dart';
import '../../../../data/services/analytics_service.dart';
import '../../../../domain/models/celebrity.dart';
import '../../../../domain/models/character.dart';
import '../../../../domain/models/child.dart';
import '../../../../domain/models/gender_type.dart';
import '../../../../domain/models/name_decision.dart';
import '../../../../domain/models/name_record.dart';
import '../../../../domain/models/song.dart';
import '../../../../domain/use_cases/build_name_detail_sections.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../core/app_colors.dart';
import '../navigation/name_detail_route_args.dart';

class NameDetailScreen extends StatelessWidget {
  const NameDetailScreen({required this.name, required this.gender, super.key});

  final NameRecord name;
  final GenderType gender;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final preferences = context.read<UserPreferencesRepository>();
    final sections = context.read<BuildNameDetailSections>()(
      name: name,
      gender: gender,
      lastName: preferences.getLastName(gender),
      fatherName: preferences.getFatherName(gender),
    );
    final isMale = gender == GenderType.male;
    final showDecisionBar =
        name.decision == NameDecision.neutral && name.nameId != null;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: DecoratedBox(
          key: const ValueKey('detail_background'),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: isMale
                  ? const [AppColors.boyGradientStart, AppColors.boyGradientEnd]
                  : const [
                      AppColors.girlGradientStart,
                      AppColors.girlGradientEnd,
                    ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: _CloseButton(
                    label: l10n.detailClose,
                    onPressed: () => _close(context),
                  ),
                ),
                Expanded(
                  child: _DetailTable(
                    sections: sections,
                    l10n: l10n,
                    gender: gender,
                    bottomPadding: showDecisionBar ? 10 : 20,
                  ),
                ),
                if (showDecisionBar) _DecisionBar(name: name, gender: gender),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _close(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    }
  }
}

class _CloseButton extends StatelessWidget {
  const _CloseButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: const ValueKey('detail_close_button'),
      width: 150,
      height: 36,
      child: OutlinedButton(
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
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
            const SizedBox(width: 8),
            SizedBox(
              key: const ValueKey('detail_close_arrow'),
              width: 23,
              height: 23,
              child: Center(
                child: Image.asset(
                  'assets/images/arrow_bottom.imageset/arrow_bottom.png',
                  width: 23,
                  height: 22,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailTable extends StatelessWidget {
  const _DetailTable({
    required this.sections,
    required this.l10n,
    required this.gender,
    required this.bottomPadding,
  });

  final List<NameDetailSection> sections;
  final AppLocalizations l10n;
  final GenderType gender;
  final double bottomPadding;

  @override
  Widget build(BuildContext context) {
    final rows = _buildRows(context);
    return ListView.builder(
      key: const ValueKey('detail_table'),
      padding: EdgeInsets.only(top: 10, bottom: bottomPadding),
      itemCount: rows.length,
      itemBuilder: (context, index) => rows[index],
    );
  }

  List<Widget> _buildRows(BuildContext context) {
    final rows = <Widget>[];
    for (final section in sections) {
      final content = section.content;
      switch (section.type) {
        case NameDetailSectionType.name:
          if (content is NameRecord) {
            rows.add(_NameRow(name: content));
          }
        case NameDetailSectionType.fullName:
          rows.add(_FullNameRow(value: content?.toString() ?? ''));
        case NameDetailSectionType.celebrities:
          rows.add(_TitleRow(title: _titleFor(section.type, l10n)));
          if (content is List<Celebrity>) {
            rows.addAll(
              content
                  .where((item) => item.name.isNotEmpty)
                  .map(
                    (item) => _PersonRow(
                      key: ValueKey('detail_person_${item.name}'),
                      name: item.name,
                      photo: item.photo,
                      description: item.description,
                      url: item.url,
                    ),
                  ),
            );
          }
        case NameDetailSectionType.characters:
          rows.add(_TitleRow(title: _titleFor(section.type, l10n)));
          if (content is List<Character>) {
            rows.addAll(
              content
                  .where((item) => item.name.isNotEmpty)
                  .map(
                    (item) => _PersonRow(
                      key: ValueKey('detail_person_${item.name}'),
                      name: item.name,
                      photo: item.photo,
                      description: item.description,
                      url: item.url,
                    ),
                  ),
            );
          }
        case NameDetailSectionType.songs:
          rows.add(_TitleRow(title: _titleFor(section.type, l10n)));
          if (content is List<Song>) {
            rows.addAll(content.map((song) => _SongRow(song: song)));
          }
        case NameDetailSectionType.children:
          rows.add(_TitleRow(title: _titleFor(section.type, l10n)));
          if (content is List<Child>) {
            rows.addAll(content.map((child) => _ChildRow(child: child)));
          }
        case NameDetailSectionType.sameNames:
          rows.add(_TitleRow(title: _titleFor(section.type, l10n)));
          for (final relatedName in _relatedNames(content?.toString() ?? '')) {
            rows.add(_RelatedNameRow(name: relatedName, gender: gender));
          }
        case NameDetailSectionType.langs:
          rows.add(_TitleRow(title: _titleFor(section.type, l10n)));
          rows.add(_LanguagesRow(value: content?.toString() ?? ''));
        case NameDetailSectionType.initials:
        case NameDetailSectionType.description:
        case NameDetailSectionType.versions:
        case NameDetailSectionType.transliteration:
        case NameDetailSectionType.englishVersion:
        case NameDetailSectionType.days:
          rows.add(_TitleRow(title: _titleFor(section.type, l10n)));
          rows.add(_ContentRow(value: content?.toString() ?? ''));
      }
    }
    return rows;
  }

  String _titleFor(NameDetailSectionType type, AppLocalizations l10n) {
    return switch (type) {
      NameDetailSectionType.fullName => l10n.detailFullName,
      NameDetailSectionType.initials => l10n.detailInitials,
      NameDetailSectionType.description => l10n.detailDescription,
      NameDetailSectionType.versions => l10n.detailVersions,
      NameDetailSectionType.transliteration => l10n.detailTransliteration,
      NameDetailSectionType.englishVersion => l10n.detailEnglishVersion,
      NameDetailSectionType.langs => l10n.detailLanguages,
      NameDetailSectionType.days => l10n.detailNameDays,
      NameDetailSectionType.celebrities => l10n.detailFamousPeople,
      NameDetailSectionType.characters => l10n.detailCharacters,
      NameDetailSectionType.songs => l10n.detailMedia,
      NameDetailSectionType.children => l10n.detailChildren,
      NameDetailSectionType.sameNames => l10n.detailRelatedNames,
      NameDetailSectionType.name => '',
    };
  }

  List<String> _relatedNames(String value) {
    return value
        .split(RegExp(r'[,;\n]'))
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList();
  }
}

class _NameRow extends StatelessWidget {
  const _NameRow({required this.name});

  final NameRecord name;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 37, 20, 37),
      child: Text(
        name.name,
        textAlign: TextAlign.center,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.displaySmall?.copyWith(
          color: AppColors.mainText,
          fontSize: 37,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _FullNameRow extends StatelessWidget {
  const _FullNameRow({required this.value});

  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 5, 30, 5),
      child: Text(
        value,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: AppColors.secondaryText,
          fontSize: 17,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _TitleRow extends StatelessWidget {
  const _TitleRow({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 40, 30, 7),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: AppColors.noteText,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _ContentRow extends StatelessWidget {
  const _ContentRow({required this.value});

  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: SelectableText(
        value,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: AppColors.mainText,
          fontSize: 17,
          fontWeight: FontWeight.w400,
          height: 1.35,
        ),
      ),
    );
  }
}

class _LanguagesRow extends StatelessWidget {
  const _LanguagesRow({required this.value});

  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: RichText(
        text: TextSpan(
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppColors.secondaryText,
            fontSize: 17,
            fontWeight: FontWeight.w500,
            height: 1.35,
          ),
          children: _spans(context),
        ),
      ),
    );
  }

  List<InlineSpan> _spans(BuildContext context) {
    final entries = value
        .split(';')
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList();
    final spans = <InlineSpan>[];
    for (var index = 0; index < entries.length; index += 1) {
      final parts = entries[index].split(':');
      if (parts.length > 1) {
        spans
          ..add(
            TextSpan(
              text: '${parts.first.trim()} ',
              style: const TextStyle(
                color: AppColors.noteText,
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            ),
          )
          ..add(TextSpan(text: parts.sublist(1).join(':').trim()));
      } else {
        spans.add(TextSpan(text: entries[index]));
      }
      if (index < entries.length - 1) {
        spans.add(const TextSpan(text: '\n'));
      }
    }
    return spans;
  }
}

class _PersonRow extends StatelessWidget {
  const _PersonRow({
    required this.name,
    this.photo,
    this.description,
    this.url,
    super.key,
  });

  final String name;
  final String? photo;
  final String? description;
  final String? url;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: url == null ? null : () => launchUrl(Uri.parse(url!)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(30, 10, 30, 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (photo?.isNotEmpty ?? false) ...[
              _PersonImage(photo: photo!, name: name),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.mainText,
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (description?.isNotEmpty ?? false) ...[
                    const SizedBox(height: 6),
                    Text(
                      description!,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.noteText,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        height: 1.25,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (url != null) ...[
              const SizedBox(width: 8),
              const Icon(
                Icons.open_in_new,
                color: AppColors.secondaryText,
                size: 22,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _PersonImage extends StatelessWidget {
  const _PersonImage({required this.photo, required this.name});

  final String photo;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.5),
          width: 2,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.network(
        photo,
        key: ValueKey('detail_person_image_$name'),
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => Image.asset(
          'assets/images/photo_defaulte.imageset/photo_defaulte.png',
          fit: BoxFit.cover,
        ),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }
          return Image.asset(
            'assets/images/photo_defaulte.imageset/photo_defaulte.png',
            fit: BoxFit.cover,
          );
        },
      ),
    );
  }
}

class _SongRow extends StatelessWidget {
  const _SongRow({required this.song});

  final Song song;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: song.url == null ? null : () => launchUrl(Uri.parse(song.url!)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(30, 0, 30, 10),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    song.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.mainText,
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (song.singer?.isNotEmpty ?? false) ...[
                    const SizedBox(height: 4),
                    Text(
                      song.singer!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.noteText,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (song.url != null)
              const SizedBox.square(
                dimension: 40,
                child: Icon(Icons.open_in_new, color: AppColors.secondaryText),
              ),
          ],
        ),
      ),
    );
  }
}

class _ChildRow extends StatelessWidget {
  const _ChildRow({required this.child});

  final Child child;

  @override
  Widget build(BuildContext context) {
    final age = _age();
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 0, 30, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(_ageIcon(age), width: 28, height: 28),
              const SizedBox(width: 7),
              Flexible(
                child: Text(
                  child.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.mainText,
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 9),
              Text(
                _ageLabel(context, age),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.noteText,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          if (child.parents?.isNotEmpty ?? false) ...[
            const SizedBox(height: 8),
            Text(
              child.parents!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.noteText,
                fontSize: 14,
                height: 1.25,
              ),
            ),
          ],
        ],
      ),
    );
  }

  int _age() {
    final birthYear = child.birthday;
    if (birthYear == 0) {
      return 0;
    }
    final deathYear = child.yearOfDeath;
    if (deathYear != 0) {
      return deathYear - birthYear;
    }
    return DateTime.now().year - birthYear;
  }

  String _ageIcon(int age) {
    final fileName = switch (age) {
      < 3 => 'icon_child_0-2',
      > 2 && < 7 => 'icon_child_3-6',
      > 6 && < 13 => 'icon_child_7-12',
      > 12 && < 18 => 'icon_child_13-17',
      > 17 && < 23 => 'icon_child_18-22',
      _ => 'icon_child_23',
    };
    return 'assets/images/Children/$fileName.imageset/$fileName.png';
  }

  String _ageLabel(BuildContext context, int age) {
    if (Localizations.localeOf(context).languageCode != 'uk') {
      return '($age ${age == 1 ? 'year' : 'years'})';
    }
    final one = {1, 21, 31, 41, 51, 61, 71, 81, 91, 101};
    final few = {
      2,
      3,
      4,
      22,
      23,
      24,
      32,
      33,
      34,
      42,
      43,
      44,
      52,
      53,
      54,
      62,
      63,
      64,
      72,
      73,
      74,
      82,
      83,
      84,
      92,
      93,
      94,
      102,
      103,
      104,
    };
    final suffix = one.contains(age)
        ? 'рік'
        : few.contains(age)
        ? 'роки'
        : 'років';
    return '($age $suffix)';
  }
}

class _RelatedNameRow extends StatelessWidget {
  const _RelatedNameRow({required this.name, required this.gender});

  final String name;
  final GenderType gender;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final repository = context.read<NameRepository>();
        final match = await repository.findExact(gender, name);
        if (context.mounted && match != null) {
          context.pushNamed(
            'details',
            extra: NameDetailRouteArgs(name: match, gender: gender),
          );
        }
      },
      child: SizedBox(
        key: ValueKey('detail_related_row_$name'),
        height: 66,
        child: Stack(
          children: [
            const Positioned(left: 0, right: 0, top: 0, child: _DividerLine()),
            const Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _DividerLine(),
            ),
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.only(left: 30, right: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        key: ValueKey('detail_related_name_$name'),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: AppColors.mainText,
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ),
                    SizedBox(
                      key: ValueKey('detail_related_arrow_$name'),
                      width: 24,
                      height: 24,
                      child: Center(
                        child: Opacity(
                          opacity: 0.4,
                          child: Image.asset(
                            'assets/images/arrow_right.imageset/arrow_right.png',
                            width: 24,
                            height: 23,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DividerLine extends StatelessWidget {
  const _DividerLine();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white.withValues(alpha: 0.2),
      child: const SizedBox(height: 1),
    );
  }
}

class _DecisionBar extends StatelessWidget {
  const _DecisionBar({required this.name, required this.gender});

  final NameRecord name;
  final GenderType gender;

  @override
  Widget build(BuildContext context) {
    final isMale = gender == GenderType.male;
    return SizedBox(
      height: 70,
      child: Row(
        children: [
          Expanded(
            child: _DecisionButton(
              key: const ValueKey('detail_dislike_button'),
              color: isMale ? AppColors.boyDislike : AppColors.girlDislike,
              asset: 'assets/images/icon_no_middle.imageset/icon_no_middle.png',
              onPressed: () => _setDecision(context, liked: false),
            ),
          ),
          Expanded(
            child: _DecisionButton(
              key: const ValueKey('detail_like_button'),
              color: isMale ? AppColors.boyLike : AppColors.girlLike,
              asset:
                  'assets/images/icon_yes_middle.imageset/icon_yes_middle.png',
              onPressed: () => _setDecision(context, liked: true),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _setDecision(BuildContext context, {required bool liked}) async {
    final nameId = name.nameId;
    if (nameId != null) {
      final repository = context.read<NameRepository>();
      final analytics = context.read<AnalyticsService>();
      if (liked) {
        await repository.likeName(gender, nameId);
        await analytics.logNameLiked(name, gender);
      } else {
        await repository.dislikeName(gender, nameId);
        await analytics.logNameDisliked(name, gender);
      }
    }
    if (context.mounted && context.canPop()) {
      context.pop();
    }
  }
}

class _DecisionButton extends StatelessWidget {
  const _DecisionButton({
    required this.color,
    required this.asset,
    required this.onPressed,
    super.key,
  });

  final Color color;
  final String asset;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      child: InkWell(
        onTap: onPressed,
        child: Center(child: Image.asset(asset, width: 32, height: 32)),
      ),
    );
  }
}
