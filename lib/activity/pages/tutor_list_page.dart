import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vooms/activity/pages/tutor_cubit/tutor_cubit.dart';
import 'package:vooms/activity/pages/tutor_detail_page.dart';
import 'package:vooms/activity/repository/tutor_entity.dart';
import 'package:vooms/profile/pages/cubit/profile_cubit.dart';
import 'package:vooms/shareds/components/color_rundom.dart';
import 'package:vooms/shareds/components/m_cached_image.dart';
import 'package:vooms/shareds/components/m_text_field.dart';
import 'package:vooms/shareds/general_helper/ui_color_constants.dart';

class TutorListPage extends StatefulWidget {
  const TutorListPage({super.key});

  @override
  State<TutorListPage> createState() => _TutorListPageState();
}

class _TutorListPageState extends State<TutorListPage> {
  @override
  void initState() {
    Future.microtask(() async => await context.read<TutorCubit>().getTutors());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: UIColorConstant.backgroundColorGrey,
      body: Column(
        children: [
          BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              Widget userAvatar = const Icon(Icons.person);
              Widget userName = const SizedBox();
              Widget userEmail = const SizedBox();
              var userEntity = state.entity;
              if (userEntity != null) {
                userAvatar = McachedImage(
                  border: Border.all(color:UIColorConstant.accentGrey1),
                  url: userEntity.photoUrl);
                userName = Text(userEntity.fullname,
                    style: GoogleFonts.dmMono(
                        fontWeight: FontWeight.w500, fontSize: 18));
                userEmail = Text(userEntity.email,
                    style: GoogleFonts.dmMono(
                        fontWeight: FontWeight.w300,
                        fontSize: 15,
                        color: UIColorConstant.nativeGrey));
              }
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(children: [
                  userAvatar,
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      userName,
                      userEmail,
                    ],
                  ),
                  const Spacer(),
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      border: Border.all(color: UIColorConstant.accentGrey1),
                        borderRadius: BorderRadius.circular(50),
                        color: UIColorConstant.nativeWhite),
                    child: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.notifications)),
                  )
                ]),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
            child: Row(
              children: [
                Flexible(
                  child: MtextField(
                      color: UIColorConstant.nativeWhite,
                      borderColor: UIColorConstant.accentGrey1,
                      borderWidth: 1,
                      enabled: false,
                      labelText: "Search course or tutor here.",
                      hintText: "ex: programming",
                      leadingChild: const Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Icon(
                          Icons.search,
                          color: UIColorConstant.nativeBlack,
                        ),
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      controller: TextEditingController()),
                ),
              ],
            ),
          ),
          Flexible(
            child:
                BlocBuilder<TutorCubit, TutorState>(builder: (context, state) {
              switch (state.tutorStateStatus) {
                case TutorStateStatus.initial:
                  return const SizedBox();
                case TutorStateStatus.loaded:
                  return _TutorListView(
                    entities: state.entities,
                  );
                case TutorStateStatus.failure:
                  return Center(
                    child: TextButton(
                        onPressed: () async {
                          await context.read<TutorCubit>().getTutors();
                        },
                        child: Container()),
                  );
                case TutorStateStatus.loading:
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
              }
            }),
          )
        ],
      ),
    ));
  }
}

class _TutorListView extends StatelessWidget {
  const _TutorListView({super.key, required this.entities});
  final List<TutorEntity> entities;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await context.read<TutorCubit>().getTutors();
      },
      child: ListView.builder(
          padding: const EdgeInsets.only(bottom: 20),
          itemCount: entities.length,
          itemBuilder: (context, index) {
            final itemTile = _TutorCardTile(
              entity: entities[index],
            );
            return GestureDetector(
                onTap: () {
                  var route = CupertinoPageRoute(
                      builder: ((context) => TutorDetailPage(
                            entity: entities[index],
                          )));
                  Navigator.push(context, route);
                },
                child: itemTile);
          }),
    );
  }
}

class _TutorCardTile extends StatelessWidget {
   _TutorCardTile({super.key, required this.entity});
  final TutorEntity entity;

  Widget _setDetailTutor() {
    return Flexible(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            McachedImage(
              url: entity.photoUrl,
              height: 80,
              width: 80,
            ),
            Text(
                "${entity.tutorDetails.wages.amount}/${entity.tutorDetails.wages.frequency}",
                style: GoogleFonts.dmMono(fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _setDetailInformation() {
    return Flexible(
      flex: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(entity.fullname,
                  style: GoogleFonts.dmMono(
                      fontWeight: FontWeight.w500, fontSize: 18)),
              const Spacer(),
              const Icon(
                Icons.star_rounded,
                color: UIColorConstant.softOrange,
              ),
              const SizedBox(
                width: 8,
              ),
              Text(
                "${entity.tutorDetails.popularity.rating}",
                style: GoogleFonts.dmMono(
                    fontWeight: FontWeight.w600,
                    color: UIColorConstant.nativeGrey,
                    fontSize: 14),
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.location_on,
                size: 18,
              ),
              const SizedBox(
                width: 5,
              ),
              Flexible(
                child: Text(entity.address,
                    style: GoogleFonts.dmMono(
                        fontWeight: FontWeight.w100,
                        color: UIColorConstant.nativeGrey,
                        fontSize: 14)),
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("Subjects:",
                style: GoogleFonts.dmMono(
                    fontWeight: FontWeight.bold,
                    color: UIColorConstant.nativeBlack,
                    fontSize: 14)),
            const SizedBox(
              height: 5,
            ),
            Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(entity.tutorDetails.courseList.length,
                    (index) {
                  final color = ColorExtension.random();
                  return Row(
                    children: [
                      Icon(
                        Icons.circle,
                        size: 10,
                        color: color,
                      ),
                      Container(
                        margin: const EdgeInsets.all(2),
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: color,
                        ),
                        child: Text(
                          entity.tutorDetails.courseList[index],
                          style: GoogleFonts.dmMono(
                              fontSize: 13,
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
                        ),
                      )
                    ],
                  );
                }))
          ]),
        ],
      ),
    );
  }

  final _setDecoration = BoxDecoration(
      border: Border.all(color: UIColorConstant.accentGrey1),
      borderRadius: BorderRadius.circular(10),
      color: Colors.white);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(25, 15, 25, 5),
      padding: const EdgeInsets.only(top: 10, bottom: 10, right: 10),
      decoration: _setDecoration,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _setDetailTutor(),
          _setDetailInformation(),
        ],
      ),
    );
  }
}
