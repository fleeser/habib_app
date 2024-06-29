import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

import 'package:habib_app/src/features/categories/domain/usecases/category_delete_category_usecase.dart';
import 'package:habib_app/src/features/categories/domain/entities/category_details_entity.dart';
import 'package:habib_app/src/features/categories/presentation/app/category_details_page_notifier.dart';
import 'package:habib_app/src/features/categories/presentation/app/category_update_category_usecase.dart';
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

class CategoryDetailsPageParams {

  final int categoryId;

  const CategoryDetailsPageParams({
    required this.categoryId
  });
}

class CategoryDetailsPage extends StatefulHookConsumerWidget {

  final CategoryDetailsPageParams params;
  
  const CategoryDetailsPage({ 
    super.key,
    required this.params
  });

  @override
  ConsumerState<CategoryDetailsPage> createState() => _CategoryDetailsPageState();
}

class _CategoryDetailsPageState extends ConsumerState<CategoryDetailsPage> {

  late TextEditingController _nameController;

  void _onDetailsStateUpdate(CategoryDetailsPageState? _, CategoryDetailsPageState next) {
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
    ref.read(categoryDetailsPageNotifierProvider(widget.params.categoryId).notifier).fetch();
  }

  Future<void> _onSave() async {
    final CategoryDetailsPageState pageState = ref.watch(categoryDetailsPageNotifierProvider(widget.params.categoryId));
    final CategoryDetailsEntity category = pageState.category!;

    final String name = _nameController.text.trim();

    try {
      Validator.validateCategoryUpdate(name: name);
    } catch (e) {
      CoreUtils.showToast(
        context, 
        type: ToastType.error, 
        title: e.errorTitle, 
        description: e.errorDescription, 
      );
      return;
    }

    final bool replaceName = name != category.name;

    Json categoryJson = <String, dynamic>{
      if (replaceName) 'name' : "'$name'"
    };

    if (categoryJson.isEmpty) return;

    final CategoryUpdateCategoryUsecase categoryUpdateCategoryUsecase = ref.read(categoryUpdateCategoryUsecaseProvider);
    final CategoryUpdateCategoryUsecaseParams categoryUpdateCategoryUsecaseParams = CategoryUpdateCategoryUsecaseParams(
      categoryId: category.id,
      categoryJson: categoryJson
    );
    final Result<void> categoryUpdateCategoryUsecaseResult = await categoryUpdateCategoryUsecase.call(categoryUpdateCategoryUsecaseParams);

    categoryUpdateCategoryUsecaseResult.fold<void>(
      onSuccess: (void _) {
        ref.read(categoryDetailsPageNotifierProvider(widget.params.categoryId).notifier).replace(
          CategoryDetailsEntity(
            id: category.id, 
            name: replaceName ? name : category.name
          )
        );

        CoreUtils.showToast(
          context, 
          type: ToastType.success, 
          title: 'Erfolgreich aktualisiert.',
          description: 'Die Kategorie wurde erfolgreich aktualisiert.' 
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
      'Diese Kategorie wirklich löschen?', 
      'Wenn Sie diese Kategorie löschen, werden alle damit verbundenen Daten ebenfalls gelöscht. Dieser Vorgang kann nicht rückgängig gemacht werden.',
      'Löschen',
      onPressed: () async {
        final CategoryDeleteCategoryUsecase categoryDeleteCategoryUsecase = ref.read(categoryDeleteCategoryUsecaseProvider);
        final CategoryDeleteCategoryUsecaseParams categoryDeleteCategoryUsecaseParams = CategoryDeleteCategoryUsecaseParams(categoryId: widget.params.categoryId);
        final Result<void> categoryDeleteCategoryUsecaseResult = await categoryDeleteCategoryUsecase.call(categoryDeleteCategoryUsecaseParams);

        return categoryDeleteCategoryUsecaseResult.fold<bool>(
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
      ref.read(categoryDetailsPageNotifierProvider(widget.params.categoryId).notifier).fetch();
    });
  }

  @override
  Widget build(BuildContext context) {

    final CategoryDetailsPageState pageState = ref.watch(categoryDetailsPageNotifierProvider(widget.params.categoryId));

    if (pageState.hasCategory) {
      _nameController = useTextEditingController(text: pageState.category!.name);
    }

    ref.listen<CategoryDetailsPageState>(
      categoryDetailsPageNotifierProvider(widget.params.categoryId), 
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
            isEnabled: pageState.hasCategory,
          ),
          HBAppBarButton(
            onPressed: _onDelete,
            icon: HBIcons.trash,
            isEnabled: pageState.hasCategory
          )
        ]
      ),
      body: pageState.hasCategory
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
                  const Spacer(),
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