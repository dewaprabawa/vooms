import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vooms/activity/pages/tutor_cubit/tutor_cubit.dart';
import 'package:vooms/activity/pages/tutor_detail_page.dart';
import 'package:vooms/activity/repository/tutor_entity.dart';
import 'package:vooms/profile/pages/cubit/profile_cubit.dart';
import 'package:vooms/profile/pages/profile_page.dart';
import 'package:vooms/shareds/components/color_rundom.dart';
import 'package:vooms/shareds/components/m_cached_image.dart';
import 'package:vooms/shareds/components/m_text_field.dart';
import 'package:vooms/shareds/general_helper/text_extension.dart';
import 'package:vooms/shareds/general_helper/ui_color_constants.dart';

class TutorListPage extends StatefulWidget {
  const TutorListPage({super.key});

  @override
  State<TutorListPage> createState() => _TutorListPageState();
}

class _TutorListPageState extends State<TutorListPage> {
  @override
  void initState() {
    context.read<TutorCubit>().getTutors();
    context.read<ProfileCubit>().getProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(
        children: [
          BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              return _BuildAppBar(state: state);
            },
          ),
          const _BuildSearchBar(),
          Flexible(
            child:
                BlocBuilder<TutorCubit, TutorState>(builder: (context, state) {
              switch (state.tutorStateStatus) {
                case TutorStateStatus.initial:
                  return const SizedBox();
                case TutorStateStatus.loaded:
                  return RefreshIndicator(
                    onRefresh: () async {
                      await context.read<TutorCubit>().getTutors();
                    },
                    child: ListView.builder(
                        padding: const EdgeInsets.only(bottom: 20),
                        itemCount: state.entities.length,
                        itemBuilder: (context, index) {
                          final itemTile = _TutorCardTile(
                            entity: state.entities[index],
                          );
                          return GestureDetector(
                              onTap: () {
                                var route = CupertinoPageRoute(
                                    builder: ((context) => TutorDetailPage(
                                          entity: state.entities[index],
                                        )));
                                Navigator.push(context, route);
                              },
                              child: itemTile);
                        }),
                  );
                case TutorStateStatus.failure:
                  return Center(
                    child: TextButton(
                        onPressed: () async {
                          await context.read<TutorCubit>().getTutors();
                        },
                        child: const Text(
                          "Refresh",
                        ).toNormalText()),
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
            const SizedBox(
              height: 10,
            ),
            Text(
              "${entity.tutorDetails.wages.amount}/${entity.tutorDetails.wages.frequency}",
            ).toNormalText(),
          ],
        ),
      ),
    );
  }

  Widget _setDetailInformation(BuildContext context) {
    return Flexible(
      flex: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                entity.fullname,
              ).toNormalText(fontSize: 18),
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
              ).toBoldText(
                color: Theme.of(context).hintColor, 
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
                child: Text(entity.address).toNormalText(
                    color: Theme.of(context).hintColor, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text(
              "Subjects: ",
            ).toBoldText(fontSize: 14),
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
                        ).toBoldText(color: UIColorConstant.nativeWhite),
                      )
                    ],
                  );
                }))
          ]),
        ],
      ),
    );
  }

  BoxDecoration _setDecoration (BuildContext context) => BoxDecoration(
      border: Border.all(color: UIColorConstant.accentGrey1),
      borderRadius: BorderRadius.circular(10),
      color: Theme.of(context).backgroundColor);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(25, 15, 25, 5),
      padding: const EdgeInsets.only(top: 10, bottom: 10, right: 5),
      decoration: _setDecoration(context),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _setDetailTutor(),
          _setDetailInformation(context),
        ],
      ),
    );
  }
}

class _BuildAppBar extends StatelessWidget {
  final ProfileState state;
  const _BuildAppBar({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final profileCubit = context.read<ProfileCubit>();
    Widget userAvatar = const Icon(Icons.person);
    Widget userName = const SizedBox();
    Widget userEmail = const SizedBox();
    var entity = state.entity;
    if (entity != null) {
      userAvatar = McachedImage(
          border: Border.all(color: Theme.of(context).dividerColor),
          url: entity.photoUrl);
      userName = Text(entity.fullname).toNormalText(fontSize: 18);
      userEmail =
          Text(entity.email).toThinText(color: Theme.of(context).hintColor);
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: GestureDetector(
        onTap: () {
          var route = CupertinoPageRoute(
              builder: ((context) =>  ProfilePage(profileCubit: profileCubit,)));
          Navigator.push(context, route);
        },
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
                border: Border.all(color: Theme.of(context).dividerColor),
                borderRadius: BorderRadius.circular(50),
                color: Theme.of(context).backgroundColor),
            child: IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.notifications_active,
                  color: Theme.of(context).iconTheme.color,
                )),
          )
        ]),
      ),
    );
  }
}

class _BuildSearchBar extends StatelessWidget {
  const _BuildSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
      child: Row(
        children: [
          Flexible(
            child: MtextField(
                borderRadius: 8,
                color: Theme.of(context).backgroundColor,
                borderColor: Theme.of(context).dividerColor,
                borderWidth: 1,
                enabled: false,
                labelText: "Find the course or tutor here.",
                hintText: "ex: swift, flutter, Node.",
                leadingChild: const Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Icon(
                    Icons.search,
                  ),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 3)),
          ),
        ],
      ),
    );
  }
}
