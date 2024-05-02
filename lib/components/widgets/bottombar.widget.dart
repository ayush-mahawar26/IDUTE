import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idute_app/components/constants/colors.dart';
import 'package:idute_app/components/constants/urls.dart';
import 'package:idute_app/controller/BuisnessLogic/cubits/bottombar_cubit.dart';
import 'package:idute_app/controller/BuisnessLogic/state/bottombar_states.dart';

class BottomBarWidget extends StatelessWidget {
  const BottomBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LandingPageCubit, LandingPageState>(
        builder: (context, state) {
      LandingPageCubit switchTab = BlocProvider.of<LandingPageCubit>(context);
      return Theme(
        data: ThemeData(
            splashColor: AppColors.sBackgroundColor,
            highlightColor: AppColors.sBackgroundColor),
        child: SizedBox(
          height: 66,
          child: BottomNavigationBar(
              showSelectedLabels: false,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Colors.white,
              showUnselectedLabels: false,
              currentIndex: state.tabIndex,
              onTap: (value) => switchTab.toggle(value),
              unselectedItemColor: AppColors.kFillColor,
              backgroundColor: AppColors.sBackgroundColor,
              items: UrlConstants.bottomNavBarItems),
        ),
      );
    });
  }
}
