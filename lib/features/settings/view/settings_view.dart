import 'package:daily_expense_tracker_app/core/router/app_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../core/shared/shared.dart';
import '../../../core/utils/alerts/alerts.dart';
import '../../blocs/auth_bloc/auth_cubit.dart';
import 'widgets/widgets.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<AuthCubit>().initAuth();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Cài đặt'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            return state.maybeWhen(
              authChanged: (authStatus, user) {
                return _buildBody(
                  context,
                  authStatus: authStatus,
                );
              },
              orElse: () {
                return _buildBody(
                  context,
                  authStatus: AuthStatus.unauthenticated,
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context, {
    required AuthStatus authStatus,
  }) {
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const AuthProfile(),
            const SizedBox(height: 10),
            const DarkModeSwitch(),
            const SizedBox(height: 10),
            if (authStatus == AuthStatus.authenticated) ...[
              ItemSettings(
                title: 'Danh mục chi tiêu',
                iconData: FontAwesomeIcons.tags,
                backgroundIcon: Colors.blueAccent,
                trailing: const FaIcon(FontAwesomeIcons.chevronRight, size: 16),
                onTap: () =>
                    Navigator.pushNamed(context, RoutesName.categories),
              ),
              ItemSettings(
                title: 'Quản lý thẻ',
                iconData: FontAwesomeIcons.creditCard,
                backgroundIcon: Colors.blueAccent,
                trailing: const FaIcon(FontAwesomeIcons.chevronRight, size: 16),
                onTap: () => Navigator.pushNamed(context, RoutesName.cards),
              ),
            ],
            ItemSettings(
              title: 'Phiên bản',
              iconData: FontAwesomeIcons.circleInfo,
              backgroundIcon: Colors.blueAccent,
              trailing: const FaIcon(FontAwesomeIcons.chevronRight, size: 16),
              onTap: () => Alerts.showSheet(
                context: context,
                child: const VersionSheet(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
