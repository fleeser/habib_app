import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:habib_app/core/common/models/error_details.dart';
import 'package:habib_app/core/common/widgets/hb_dialog.dart';
import 'package:habib_app/core/common/widgets/hb_gap.dart';
import 'package:habib_app/core/common/widgets/hb_text_field.dart';
import 'package:habib_app/core/extensions/object_extension.dart';
import 'package:habib_app/core/res/hb_icons.dart';
import 'package:habib_app/core/utils/core_utils.dart';
import 'package:habib_app/core/utils/enums/toast_type.dart';
import 'package:habib_app/core/utils/result.dart';
import 'package:habib_app/core/utils/typedefs.dart';
import 'package:habib_app/core/utils/validator.dart';
import 'package:habib_app/src/features/categories/domain/usecases/category_create_category_usecase.dart';

class CreateCategoryPage extends StatefulHookConsumerWidget {
  
  const CreateCategoryPage({ super.key });

  @override
  ConsumerState<CreateCategoryPage> createState() => _CreateCategoryPageState();
}

class _CreateCategoryPageState extends ConsumerState<CreateCategoryPage> {

  late TextEditingController _nameController;

  Future<void> _handleCreate() async {
    final String name = _nameController.text.trim();

    try {
      Validator.validateCategoryCreate(name: name);
    } catch (e) {
      CoreUtils.showToast(
        context, 
        type: ToastType.error, 
        title: e.errorTitle, 
        description: e.errorDescription, 
      );
      return;
    }

    Json categoryJson = <String, dynamic>{
      'name' : "'$name'"
    };

    final CategoryCreateCategoryUsecase categoryCreateCategoryUsecase = ref.read(categoryCreateCategoryUsecaseProvider);
    final CategoryCreateCategoryUsecaseParams categoryCreateCategoryUsecaseParams = CategoryCreateCategoryUsecaseParams(categoryJson: categoryJson);
    final Result<int> categoryCreateCategoryUsecaseResult = await categoryCreateCategoryUsecase.call(categoryCreateCategoryUsecaseParams);

    categoryCreateCategoryUsecaseResult.fold<void>(
      onSuccess: (int categoryId) async {
        CoreUtils.showToast(
          context, 
          type: ToastType.success, 
          title: 'Erfolgreich angelegt.',
          description: 'Die Kategorie wurde erfolgreich angelegt.' 
        );

        if (!mounted) return;

        context.pop(categoryId);
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

    _nameController = useTextEditingController();

    return HBDialog<int>(
      title: 'Neue Kategorie',
      actionButton: HBDialogActionButton(
        onPressed: _handleCreate,
        title: 'Erstellen'
      ),
      children: [
        const HBDialogSection(
          title: 'Allgemeine Details',
          isFirstSection: true
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: HBTextField(
                controller: _nameController,
                icon: HBIcons.academicCap,
                title: 'Name'
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