import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:habib_app/src/features/home/domain/entities/new_books_bought_entity.dart';
import 'package:habib_app/src/features/home/domain/entities/number_borrowed_books_entity.dart';
import 'package:habib_app/core/extensions/object_extension.dart';
import 'package:habib_app/core/utils/enums/toast_type.dart';
import 'package:habib_app/core/common/widgets/hb_app_bar.dart';
import 'package:habib_app/core/common/widgets/hb_button.dart';
import 'package:habib_app/core/common/widgets/hb_gap.dart';
import 'package:habib_app/core/common/widgets/hb_scaffold.dart';
import 'package:habib_app/core/extensions/context_extension.dart';
import 'package:habib_app/core/res/hb_icons.dart';
import 'package:habib_app/core/res/theme/spacing/hb_spacing.dart';
import 'package:habib_app/core/utils/core_utils.dart';
import 'package:habib_app/src/features/home/presentation/app/home_page_notifier.dart';
import 'package:habib_app/core/res/theme/colors/hb_colors.dart';
import 'package:habib_app/core/res/theme/typography/hb_typography.dart';

class HomePage extends ConsumerStatefulWidget {

  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {

  Future<void> _onExport() async {
    // TODO
  }

  Future<void> _onRefresh() async {
    ref.read(homePageNotifierProvider.notifier).fetch(2024);
  }

  void _onPageStateUpdate(HomePageState? _, HomePageState next) {
    if (next.hasError) {
      CoreUtils.showToast(
        context, 
        type: ToastType.error, 
        title: next.error!.errorTitle, 
        description: next.error!.errorDescription, 
      );
    }
  }

  @override
  void initState() {
    super.initState();

    CoreUtils.postFrameCall(() {
      ref.read(homePageNotifierProvider.notifier).fetch(2024);
    });
  }

  @override
  Widget build(BuildContext context) {

    final HomePageState pageState = ref.watch(homePageNotifierProvider);

    ref.listen<HomePageState>(
      homePageNotifierProvider, 
      _onPageStateUpdate
    );

    return HBScaffold(
      appBar: HBAppBar(
        context: context,
        title: 'Startseite'
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: HBSpacing.lg,
              right: context.rightPadding + HBSpacing.lg,
              top: HBSpacing.lg,
              bottom: HBSpacing.lg
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                HBButton.shrinkFill(
                  onPressed: _onExport,
                  icon: HBIcons.arrowDownTray,
                  title: 'Export'
                ),
                const HBGap.md(),
                HBButton.shrinkFill(
                  onPressed: _onRefresh,
                  icon: HBIcons.arrowPath
                )
              ]
            )
          ),
          Expanded(
            child: pageState.hasStats
              ? SingleChildScrollView(
                padding: EdgeInsets.only(
                  left: HBSpacing.lg,
                  right: context.rightPadding + HBSpacing.lg,
                  bottom: context.bottomPadding + HBSpacing.lg
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: SfCartesianChart(
                            title: ChartTitle(
                              text: 'Ausgeliehene Bücher',
                              alignment: ChartAlignment.near,
                              textStyle: HBTypography.base.copyWith(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w600,
                                color: HBColors.gray900
                              )
                            ),
                            primaryXAxis: const CategoryAxis(),
                            series: <ColumnSeries<NumberBorrowedBooksEntity, String>>[
                              ColumnSeries<NumberBorrowedBooksEntity, String>(
                                dataSource: pageState.stats!.numberBorrowedBooksList,
                                xValueMapper: (NumberBorrowedBooksEntity numberBorrowedBooks, int _) => CoreUtils.textFromMonth(numberBorrowedBooks.month),
                                yValueMapper: (NumberBorrowedBooksEntity numberBorrowedBooks, int _) => numberBorrowedBooks.booksCount
                              )
                            ]
                          )
                        ),
                        const HBGap.lg(),
                        Expanded(
                          child: SfCartesianChart(
                            title: ChartTitle(
                              text: 'Gekaufte neue Bücher',
                              alignment: ChartAlignment.near,
                              textStyle: HBTypography.base.copyWith(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w600,
                                color: HBColors.gray900
                              )
                            ),
                            primaryXAxis: const CategoryAxis(),
                            margin: EdgeInsets.zero,
                            series: <StackedColumnSeries<NewBooksBoughtEntity, String>>[
                              StackedColumnSeries<NewBooksBoughtEntity, String>(
                                dataSource: pageState.stats!.newBooksBoughtList,
                                xValueMapper: (NewBooksBoughtEntity newBooksBought, int _) => CoreUtils.textFromMonth(newBooksBought.month),
                                yValueMapper: (NewBooksBoughtEntity newBooksBought, int _) => newBooksBought.notBoughtCount
                              ),
                              StackedColumnSeries<NewBooksBoughtEntity, String>(
                                dataSource: pageState.stats!.newBooksBoughtList,
                                xValueMapper: (NewBooksBoughtEntity newBooksBought, int _) => CoreUtils.textFromMonth(newBooksBought.month),
                                yValueMapper: (NewBooksBoughtEntity newBooksBought, int _) => newBooksBought.boughtCount
                              )
                            ]
                          )
                        )
                      ],
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
          )
        ]
      )
    );
  }
}