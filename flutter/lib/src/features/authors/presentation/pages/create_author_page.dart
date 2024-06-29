import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:habib_app/src/features/authors/domain/usecases/author_create_author_usecase.dart';
import 'package:habib_app/core/common/models/error_details.dart';
import 'package:habib_app/core/common/widgets/hb_dialog.dart';
import 'package:habib_app/core/common/widgets/hb_gap.dart';
import 'package:habib_app/core/common/widgets/hb_text_field.dart';
import 'package:habib_app/core/extensions/object_extension.dart';
import 'package:habib_app/core/res/hb_icons.dart';
import 'package:habib_app/core/services/routes.dart';
import 'package:habib_app/core/utils/core_utils.dart';
import 'package:habib_app/core/utils/enums/toast_type.dart';
import 'package:habib_app/core/utils/result.dart';
import 'package:habib_app/core/utils/typedefs.dart';
import 'package:habib_app/core/utils/validator.dart';

class CreateAuthorPage extends StatefulHookConsumerWidget {
  
  const CreateAuthorPage({ super.key });

  @override
  ConsumerState<CreateAuthorPage> createState() => _CreateAuthorPageState();
}

class _CreateAuthorPageState extends ConsumerState<CreateAuthorPage> {

  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _titleController;

  Future<void> _handleCreate() async {
    final String title = _titleController.text.trim();
    final String firstName = _firstNameController.text.trim();
    final String lastName = _lastNameController.text.trim();

    try {
      Validator.validateAuthorCreate(
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

    Json authorJson = <String, dynamic>{
      if (title.isNotEmpty) 'title' : "'$title'",
      'first_name' : "'$firstName'",
      'last_name' : "'$lastName'"
    };

    final AuthorCreateAuthorUsecase authorCreateAuthorUsecase = ref.read(authorCreateAuthorUsecaseProvider);
    final AuthorCreateAuthorUsecaseParams authorCreateAuthorUsecaseParams = AuthorCreateAuthorUsecaseParams(authorJson: authorJson);
    final Result<int> authorCreateAuthorUsecaseResult = await authorCreateAuthorUsecase.call(authorCreateAuthorUsecaseParams);

    authorCreateAuthorUsecaseResult.fold<void>(
      onSuccess: (int authorId) async {
        CoreUtils.showToast(
          context, 
          type: ToastType.success, 
          title: 'Erfolgreich angelegt.',
          description: 'Der Autor wurde erfolgreich angelegt.'
        );

        if (!mounted) return;

        context.pop();

        await AuthorDetailsRoute(authorId: authorId).push(context);
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
  
  @override
  Widget build(BuildContext context) {

    _firstNameController = useTextEditingController();
    _lastNameController = useTextEditingController();
    _titleController = useTextEditingController();

    return HBDialog<int>(
      title: 'Neuer Autor',
      actionButton: HBDialogActionButton(
        onPressed: _handleCreate,
        title: 'Erstellen'
      ),
      children: [
        const HBDialogSection(
          title: 'Personendetails',
          isFirstSection: true
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: HBTextField(
                controller: _titleController,
                icon: HBIcons.academicCap,
                title: 'Titel'
              )
            ),
            const HBGap.lg(),
            Expanded(
              child: HBTextField(
                controller: _firstNameController,
                icon: HBIcons.user,
                title: 'Vorname'
              )
            )
          ]
        ),
        const HBGap.lg(),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: HBTextField(
                controller: _lastNameController,
                icon: HBIcons.user,
                title: 'Nachname'
              )
            ),
            const HBGap.lg(),
            const Spacer()
          ]
        )
      ]
    );
  }
}