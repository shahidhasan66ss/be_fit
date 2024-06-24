import 'dart:io';

import 'package:be_fit/dummy.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/const/color_constants.dart';
import '../../../core/const/data_constants.dart';
import '../../../core/const/path_constants.dart';
import '../../../core/const/text_constants.dart';
import '../../edit_account/edit_account_screen.dart';
import '../../workout_details_screen/page/workout_details_page.dart';
import '../bloc/home_bloc.dart';
import 'heart_rate_widget.dart';
import 'home_exercises_card.dart';
import 'home_statistics.dart';
import '../../sign_in/page/sign_in_page.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeBloc()..add(LoadProfileImageEvent()),
      child: Container(
        color: ColorConstants.homeBackgroundColor,
        height: double.infinity,
        width: double.infinity,
        child: _createHomeBody(context),
      ),
    );
  }

  Widget _createHomeBody(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        children: [
          _createProfileData(context),
          const SizedBox(height: 35),
          HeartRateCard(),
          const SizedBox(height: 35),
          HomeStatistics(),
          const SizedBox(height: 30),
          _createExercisesList(context),
          const SizedBox(height: 25),
          _createProgress(),
        ],
      ),
    );
  }

  Widget _createExercisesList(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            TextConstants.discoverWorkouts,
            style: TextStyle(
              color: ColorConstants.textBlack,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 15),
        Container(
          height: 160,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              const SizedBox(width: 20),
              WorkoutCard(
                color: ColorConstants.cardioColor,
                workout: DataConstants.workouts[0],
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => WorkoutDetailsPage(
                      workout: DataConstants.workouts[0],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              WorkoutCard(
                color: ColorConstants.armsColor,
                workout: DataConstants.homeWorkouts[1],
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => WorkoutDetailsPage(
                      workout: DataConstants.workouts[2],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
            ],
          ),
        ),
      ],
    );
  }

  Widget _createProfileData(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    final displayName = user?.displayName ?? "No Username";

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  BlocBuilder<HomeBloc, HomeState>(
                    buildWhen: (_, currState) => currState is ProfileImageLoadedState,
                    builder: (context, state) {
                      String? imagePath;
                      if (state is ProfileImageLoadedState) {
                        imagePath = state.imagePath;
                      }
                      return GestureDetector(
                        child: imagePath == null || imagePath.isEmpty
                            ? CircleAvatar(
                          backgroundImage: AssetImage(PathConstants.profile),
                          radius: 25,
                        )
                            : CircleAvatar(
                          backgroundImage: FileImage(File(imagePath)),
                          radius: 25,
                        ),
                        onTap: () async {
                          await Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => EditAccountScreen()),
                          );
                          BlocProvider.of<HomeBloc>(context).add(ReloadImageEvent());
                        },
                      );
                    },
                  ),
                  SizedBox(width: 6),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hi, $displayName',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                      Text(
                        TextConstants.checkActivity,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
          Container(
            height: 35,
            decoration: BoxDecoration(
              color: Color(0xFF1A73E8), // Background color #1A73E8
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: TextButton(
              onPressed: () {
                _signOut(context);
              },
              child: Text(
                "Sign Out",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => SignInPage()),
      );
    } catch (e) {
      // Handle sign-out errors
      print("Error signing out: $e");
    }
  }

  Widget _createProgress() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: ColorConstants.white,
        boxShadow: [
          BoxShadow(
            color: ColorConstants.textBlack.withOpacity(0.12),
            blurRadius: 5.0,
            spreadRadius: 1.1,
          ),
        ],
      ),
      child: Row(
        children: [
          Image(
            image: AssetImage(
              PathConstants.progress,
            ),
          ),
          SizedBox(width: 20),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  TextConstants.keepProgress,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  TextConstants.profileSuccessful,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
