import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

import 'package:habib_app/src/features/authors/presentation/app/author_details_page_notifier.dart';
import 'package:habib_app/src/features/authors/domain/entities/author_details_entity.dart';
import 'package:habib_app/src/features/authors/presentation/app/author_delete_author_usecase.dart';
import 'package:habib_app/src/features/authors/presentation/app/author_update_author_usecase.dart';
import 'package:habib_app/core/utils/typedefs.dart';
import 'package:habib_app/core/utils/validator.dart';
import 'package:habib_app/core/res/theme/colors/hb_colors.dart';
import 'package:habib_app/core/res/theme/typography/hb_typography.dart';
import 'package:habib_app/core/common/widgets/hb_gap.dart';
import 'package:habib_app/core/common/widgets/hb_text_field.dart';
import 'package:habib_app/core/extensions/context_extension.dart';
import 'package:habib_app/core/res/theme/spacing/hb_spacing.dart';
import 'package:habib_app/core/common/models/error_details.dart';
import 'package:habib_app/core/common/widgets/hb_message_box.dart';
import 'package:habib_app/core/utils/result.dart';
import 'package:habib_app/core/extensions/object_extension.dart';
import 'package:habib_app/core/utils/enums/toast_type.dart';
import 'package:habib_app/core/common/widgets/hb_app_bar.dart';
import 'package:habib_app/core/common/widgets/hb_scaffold.dart';
import 'package:habib_app/core/res/hb_icons.dart';
import 'package:habib_app/core/utils/core_utils.dart';

class AuthorDetailsPageParams {

  final int authorId;

  const AuthorDetailsPageParams({
    required this.authorId
  });
}

class AuthorDetailsPage extends StatefulHookConsumerWidget {

  final AuthorDetailsPageParams params;
  
  const AuthorDetailsPage({ 
    super.key,
    required this.params
  });

  @override
  ConsumerState<AuthorDetailsPage> createState() => _AuthorDetailsPageState();
}

class _AuthorDetailsPageState extends ConsumerState<AuthorDetailsPage> {

  late TextEditingController _titleController;
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;

  void _onDetailsStateUpdate(AuthorDetailsPageState? _, AuthorDetailsPageState next) {
    if (next.hasError) {
      CoreUtils.showToast(
        context, 
        type: ToastType.error, 
        title: next.error!.errorTitle, 
        description: next.error!.errorDescription, 
      );
    }
  }

  Future<void> _onRefresh() async {
    ref.read(authorDetailsPageNotifierProvider(widget.params.authorId).notifier).fetch();
  }

  Future<void> _onSave() async {
    final AuthorDetailsPageState pageState = ref.watch(authorDetailsPageNotifierProvider(widget.params.authorId));
    final AuthorDetailsEntity author = pageState.author!;

    final String title = _titleController.text.trim();
    final String firstName = _firstNameController.text.trim();
    final String lastName = _lastNameController.text.trim();

    try {
      Validator.validateAuthorUpdate(
        title: title,
        firstName: firstName,
        lastName: lastName
      );
    } catch (e) {
      CoreUtils.showToast(
        context, 
        type: ToastType.error, 
        title: e.errorTitle, 
        description: e.errorDescription, 
      );
      return;
    }

    final bool replaceTitle = title != (author.title ?? '');
    final bool replaceFirstName = firstName != author.firstName;
    final bool replaceLastName = lastName != author.lastName;

    Json authorJson = <String, dynamic>{
      if (replaceTitle) 'title' : "'$title'",
      if (replaceFirstName) 'first_name' : "'$firstName'",
      if (replaceLastName) 'last_name' : "'$lastName'"
    };

    if (authorJson.isEmpty) return;

    final AuthorUpdateAuthorUsecase authorUpdateAuthorUsecase = ref.read(authorUpdateAuthorUsecaseProvider);
    final AuthorUpdateAuthorUsecaseParams authorUpdateAuthorUsecaseParams = AuthorUpdateAuthorUsecaseParams(
      authorId: author.id,
      authorJson: authorJson
    );
    final Result<void> authorUpdateAuthorUsecaseResult = await authorUpdateAuthorUsecase.call(authorUpdateAuthorUsecaseParams);

    authorUpdateAuthorUsecaseResult.fold<void>(
      onSuccess: (void _) {
        ref.read(authorDetailsPageNotifierProvider(widget.params.authorId).notifier).replace(
          AuthorDetailsEntity(
            id: author.id, 
            title: replaceTitle ? title : author.title,
            firstName: replaceFirstName ? firstName : author.firstName,
            lastName: replaceLastName ? lastName : author.lastName
          )
        );

        CoreUtils.showToast(
          context, 
          type: ToastType.success, 
          title: 'Erfolgreich aktualisiert.',
          description: 'Der Autor wurde erfolgreich aktualisiert.' 
        );
      },
      onFailure: (Object error, StackTrace stackTrace) {
        final ErrorDetails errorDetails = ErrorDetails(
          error: error, 
          stackTrace: stackTrace
        );
        CoreUtils.showToast(
          context, 
          type: ToastType.error, 
          title: errorDetails.errorTitle, 
          description: errorDetails.errorDescription, 
        );
      }
    );
  }

  Future<void> _onDelete() async {
    final bool? success = await showHBMessageBox(
      context, 
      'Diesen Autor wirklich löschen?', 
      'Wenn Sie diesen Autor löschen, werden alle damit verbundenen Daten ebenfalls gelöscht. Dieser Vorgang kann nicht rückgängig gemacht werden.',
      'Löschen',
      onPressed: () async {
        final AuthorDeleteAuthorUsecase authorDeleteAuthorUsecase = ref.read(authorDeleteAuthorUsecaseProvider);
        final AuthorDeleteAuthorUsecaseParams authorDeleteAuthorUsecaseParams = AuthorDeleteAuthorUsecaseParams(authorId: widget.params.authorId);
        final Result<void> authorDeleteAuthorUsecaseResult = await authorDeleteAuthorUsecase.call(authorDeleteAuthorUsecaseParams);

        return authorDeleteAuthorUsecaseResult.fold<bool>(
          onSuccess: (void _) => true,
          onFailure: (Object error, StackTrace stackTrace) {
            final ErrorDetails errorDetails = ErrorDetails(
              error: error, 
              stackTrace: stackTrace
            );
            CoreUtils.showToast(
              context, 
              type: ToastType.error, 
              title: errorDetails.errorTitle, 
              description: errorDetails.errorDescription, 
            );
            return false;
          }
        );
      }
    );

    if (mounted && context.canPop() && (success ?? false)) context.pop(true);
  }

  @override
  void initState() {
    super.initState();

    CoreUtils.postFrameCall(() {
      ref.read(authorDetailsPageNotifierProvider(widget.params.authorId).notifier).fetch();
    });
  }

  @override
  Widget build(BuildContext context) {

    final AuthorDetailsPageState pageState = ref.watch(authorDetailsPageNotifierProvider(widget.params.authorId));

    if (pageState.hasAuthor) {
      _titleController = useTextEditingController(text: pageState.author!.title);
      _firstNameController = useTextEditingController(text: pageState.author!.firstName);
      _lastNameController = useTextEditingController(text: pageState.author!.lastName);
    }

    ref.listen<AuthorDetailsPageState>(
      authorDetailsPageNotifierProvider(widget.params.authorId), 
      _onDetailsStateUpdate
    );
    
    return HBScaffold(
      appBar: HBAppBar(
        context: context,
        title: 'Details',
        backButton: const HBAppBarBackButton(),
        actionButtons: [
          HBAppBarButton(
            onPressed: _onRefresh,
            icon: HBIcons.arrowPath,
            isEnabled: !pageState.isLoading
          ),
          HBAppBarButton(
            onPressed: _onSave,
            icon: HBIcons.cloudArrowUp,
            isEnabled: pageState.hasAuthor,
          ),
          HBAppBarButton(
            onPressed: _onDelete,
            icon: HBIcons.trash,
            isEnabled: pageState.hasAuthor
          )
        ]
      ),
      body: pageState.hasAuthor
        ? SingleChildScrollView(
          padding: EdgeInsets.only(
            left: HBSpacing.lg,
            right: context.rightPadding + HBSpacing.lg,
            top: HBSpacing.lg
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Personendetails',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: HBTypography.base.copyWith(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                  color: HBColors.gray900
                )
              ),
              const HBGap.xl(),
              Row(
                children: [
                  Expanded(
                    child: HBTextField(
                      title: 'Titel',
                      controller: _titleController,
                      icon: HBIcons.home
                    )
                  ),
                  const HBGap.xl(),
                  Expanded(
                    child: HBTextField(
                      title: 'Vorname',
                      controller: _firstNameController,
                      icon: HBIcons.home
                    )
                  ),
                  const HBGap.xl(),
                  Expanded(
                    child: HBTextField(
                      title: 'Nachname',
                      controller: _lastNameController,
                      icon: HBIcons.home
                    )
                  ),
                ]
              )
            ]
          )
        )
        : pageState.hasError
          ? Center(
            child: Text(
              pageState.error!.errorDescription,
              textAlign: TextAlign.center,
              style: HBTypography.base.copyWith(
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
                color: HBColors.gray900
              ),
            )
          )
          : const SizedBox.shrink()
    );
  }
}