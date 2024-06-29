import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:habib_app/src/features/publishers/domain/usecases/publisher_create_publisher_usecase.dart';
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

class CreatePublisherPage extends StatefulHookConsumerWidget {
  
  const CreatePublisherPage({ super.key });

  @override
  ConsumerState<CreatePublisherPage> createState() => _CreatePublisherPageState();
}

class _CreatePublisherPageState extends ConsumerState<CreatePublisherPage> {

  late TextEditingController _nameController;
  late TextEditingController _cityController;

  Future<void> _handleCreate() async {
    final String name = _nameController.text.trim();
    final String city = _cityController.text.trim();

    try {
      Validator.validatePublisherCreate(
        name: name,
        city: city
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

    Json publisherJson = <String, dynamic>{
      'name' : "'$name'",
      if (city.isNotEmpty) 'city' : "'$city'"
    };

    final PublisherCreatePublisherUsecase publisherCreatePublisherUsecase = ref.read(publisherCreatePublisherUsecaseProvider);
    final PublisherCreatePublisherUsecaseParams publisherCreatePublisherUsecaseParams = PublisherCreatePublisherUsecaseParams(publisherJson: publisherJson);
    final Result<int> publisherCreatePublisherUsecaseResult = await publisherCreatePublisherUsecase.call(publisherCreatePublisherUsecaseParams);

    publisherCreatePublisherUsecaseResult.fold<void>(
      onSuccess: (int publisherId) async {
        CoreUtils.showToast(
          context, 
          type: ToastType.success, 
          title: 'Erfolgreich angelegt.',
          description: 'Der Verlag wurde erfolgreich angelegt.'
        );

        if (!mounted) return;

        context.pop();

        await PublisherDetailsRoute(publisherId: publisherId).push(context);
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
    _cityController = useTextEditingController();

    return HBDialog<int>(
      title: 'Neuer Verlag',
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
            Expanded(
              child: HBTextField(
                controller: _cityController,
                icon: HBIcons.user,
                title: 'Stadt'
              )
            )
          ]
        )
      ]
    );
  }
}