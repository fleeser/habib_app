import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

import 'package:habib_app/src/features/publishers/domain/entities/publisher_details_entity.dart';
import 'package:habib_app/src/features/publishers/presentation/app/publisher_delete_publisher_usecase.dart';
import 'package:habib_app/src/features/publishers/presentation/app/publisher_details_page_notifier.dart';
import 'package:habib_app/src/features/publishers/presentation/app/publisher_update_publisher_usecase.dart';
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

class PublisherDetailsPageParams {

  final int publisherId;

  const PublisherDetailsPageParams({
    required this.publisherId
  });
}

class PublisherDetailsPage extends StatefulHookConsumerWidget {

  final PublisherDetailsPageParams params;
  
  const PublisherDetailsPage({ 
    super.key,
    required this.params
  });

  @override
  ConsumerState<PublisherDetailsPage> createState() => _PublisherDetailsPageState();
}

class _PublisherDetailsPageState extends ConsumerState<PublisherDetailsPage> {

  late TextEditingController _nameController;
  late TextEditingController _cityController;

  void _onDetailsStateUpdate(PublisherDetailsPageState? _, PublisherDetailsPageState next) {
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
    ref.read(publisherDetailsPageNotifierProvider(widget.params.publisherId).notifier).fetch();
  }

  Future<void> _onSave() async {
    final PublisherDetailsPageState pageState = ref.watch(publisherDetailsPageNotifierProvider(widget.params.publisherId));
    final PublisherDetailsEntity publisher = pageState.publisher!;

    final String name = _nameController.text.trim();
    final String city = _cityController.text.trim();

    try {
      Validator.validatePublisherUpdate(
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

    final bool replaceName = name != publisher.name;
    final bool replaceCity = city != (publisher.city ?? '');

    Json publisherJson = <String, dynamic>{
      if (replaceName) 'name' : "'$name'",
      if (replaceCity) 'city' : "'$city'",
    };

    if (publisherJson.isEmpty) return;

    final PublisherUpdatePublisherUsecase publisherUpdatePublisherUsecase = ref.read(publisherUpdatePublisherUsecaseProvider);
    final PublisherUpdatePublisherUsecaseParams publisherUpdatePublisherUsecaseParams = PublisherUpdatePublisherUsecaseParams(
      publisherId: publisher.id,
      publisherJson: publisherJson
    );
    final Result<void> publisherUpdatePublisherUsecaseResult = await publisherUpdatePublisherUsecase.call(publisherUpdatePublisherUsecaseParams);

    publisherUpdatePublisherUsecaseResult.fold<void>(
      onSuccess: (void _) {
        ref.read(publisherDetailsPageNotifierProvider(widget.params.publisherId).notifier).replace(
          PublisherDetailsEntity(
            id: publisher.id,
            name: replaceName ? name : publisher.name,
            city: replaceCity ? city : publisher.city
          )
        );

        CoreUtils.showToast(
          context, 
          type: ToastType.success, 
          title: 'Erfolgreich aktualisiert.',
          description: 'Der Verlag wurde erfolgreich aktualisiert.' 
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
      'Diesen Verlag wirklich löschen?', 
      'Wenn Sie diesen Verlag löschen, werden alle damit verbundenen Daten ebenfalls gelöscht. Dieser Vorgang kann nicht rückgängig gemacht werden.',
      'Löschen',
      onPressed: () async {
        final PublisherDeletePublisherUsecase publisherDeletePublisherUsecase = ref.read(publisherDeletePublisherUsecaseProvider);
        final PublisherDeletePublisherUsecaseParams publisherDeletePublisherUsecaseParams = PublisherDeletePublisherUsecaseParams(publisherId: widget.params.publisherId);
        final Result<void> publisherDeletePublisherUsecaseResult = await publisherDeletePublisherUsecase.call(publisherDeletePublisherUsecaseParams);

        return publisherDeletePublisherUsecaseResult.fold<bool>(
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
      ref.read(publisherDetailsPageNotifierProvider(widget.params.publisherId).notifier).fetch();
    });
  }

  @override
  Widget build(BuildContext context) {

    final PublisherDetailsPageState pageState = ref.watch(publisherDetailsPageNotifierProvider(widget.params.publisherId));

    if (pageState.hasPublisher) {
      _nameController = useTextEditingController(text: pageState.publisher!.name);
      _cityController = useTextEditingController(text: pageState.publisher!.city);
    }

    ref.listen<PublisherDetailsPageState>(
      publisherDetailsPageNotifierProvider(widget.params.publisherId), 
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
            isEnabled: pageState.hasPublisher,
          ),
          HBAppBarButton(
            onPressed: _onDelete,
            icon: HBIcons.trash,
            isEnabled: pageState.hasPublisher
          )
        ]
      ),
      body: pageState.hasPublisher
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
                'Allgemeine Details',
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
                      title: 'Name',
                      controller: _nameController,
                      icon: HBIcons.home
                    )
                  ),
                  const HBGap.xl(),
                  Expanded(
                    child: HBTextField(
                      title: 'Stadt',
                      controller: _cityController,
                      icon: HBIcons.home
                    )
                  ),
                  const HBGap.xl(),
                  const Spacer()
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