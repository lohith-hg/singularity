import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app/widgets/s_tab_bar.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../features/epic/presentation/bloc/epic_bloc.dart';
import '../../../../features/epic/presentation/pages/epic_page.dart';
import '../../../../features/iss_tracker/presentation/bloc/iss_tracker_bloc.dart';
import '../../../../features/iss_tracker/presentation/pages/iss_tracker_page.dart';
import '../../../../injection_container.dart';

class TrackerPage extends StatefulWidget {
  const TrackerPage({super.key});

  @override
  State<TrackerPage> createState() => _TrackerPageState();
}

class _TrackerPageState extends State<TrackerPage> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ink,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.sp24,
                AppSpacing.sp16,
                AppSpacing.sp24,
                0,
              ),
              child: STabBar(
                tabs: const ['ISS', 'Earth'],
                selectedIndex: _tab,
                onTap: (i) => setState(() => _tab = i),
              ),
            ),
            Expanded(
              child: _tab == 0
                  ? BlocProvider(
                      create: (_) => sl<IssTrackerBloc>(),
                      child: const IssTrackerPage(embedded: true),
                    )
                  : BlocProvider(
                      create: (_) => sl<EpicBloc>(),
                      child: const EpicPage(embedded: true),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
