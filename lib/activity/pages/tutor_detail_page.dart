import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vooms/activity/repository/tutor_entity.dart';
import 'package:vooms/chat/pages/chat_room_page.dart';
import 'package:vooms/shareds/components/color_rundom.dart';
import 'package:vooms/shareds/components/m_cached_image.dart';
import 'package:vooms/shareds/general_helper/text_extension.dart';
import 'package:vooms/shareds/general_helper/ui_color_constants.dart';

class TutorDetailPage extends StatelessWidget {
  const TutorDetailPage({super.key, required this.entity});
  final TutorEntity entity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Theme.of(context).backgroundColor,
        elevation: 0.0,
        title: Text(
          entity.fullname,
        ).toNormalText(),
      ),
      bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
            boxShadow: [
              BoxShadow(
                  color: Theme.of(context).dividerColor,
                  spreadRadius: 1,
                  blurRadius: 1)
            ],
          ),
          height: 100,
          child: Row(
            children: [
              IconButton(
                  onPressed: () {
                    var route = CupertinoPageRoute(
                        builder: (context) => ChatRoomPage(
                              recepientEntity: entity,
                            ));
                    Navigator.push(context, route);
                  },
                  icon: Icon(
                    Icons.chat_bubble,
                    color: Theme.of(context).iconTheme.color,
                  )),
            ],
          )),
      body: SafeArea(
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          children: [
            _TutorDetail(
              fee: entity.tutorDetails.wages.amount.toString(),
              imageUrl: entity.photoUrl,
              location: entity.address,
              name: entity.fullname,
              rating: entity.tutorDetails.popularity.rating.toString(),
              courseList: entity.tutorDetails.courseList,
            ),
            const Divider(
              height: 1,
            ),
            _TutorSkill(
              courseList: entity.tutorDetails.courseList,
            ),
            const Divider(
              height: 1,
            ),
            _TutorOverview(overview: entity.tutorDetails.teacherOverview),
            const Divider(
              height: 1,
            ),
            _CourseDetail(
              tutorDetails: entity.tutorDetails,
            ),
          ],
        ),
      ),
    );
  }
}

class _TutorDetail extends StatelessWidget {
  const _TutorDetail({
    super.key,
    required this.fee,
    required this.imageUrl,
    required this.name,
    required this.rating,
    required this.location,
    required this.courseList,
  });
  final String fee;
  final String imageUrl;
  final String name;
  final String rating;
  final String location;
  final List<String> courseList;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          McachedImage(
            url: imageUrl,
            height: 80,
            width: 80,
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      color: UIColorConstant.softOrange,
                    ),
                    Text(
                      rating,
                    ).toNormalText(),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                 Row(children: [
                  const Icon(
                Icons.location_on,
                size: 18,
              ),
                Flexible(
                  child: Text(
                    location,
                  ).toNormalText(color: Theme.of(context).hintColor),
                ),
                 ],),
                 const SizedBox(
                  height: 5,
                ),
               Text(fee).toNormalText(),  
                const SizedBox(
                  height: 5,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _TutorOverview extends StatelessWidget {
  const _TutorOverview({super.key, required this.overview});
  final String overview;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Overview",
          ).toBoldText(),
          const SizedBox(
            height: 5,
          ),
          Text(overview).toNormalText(color: Theme.of(context).hintColor),
        ],
      ),
    );
  }
}

class _TutorSkill extends StatelessWidget {
  final List<String> courseList;
  const _TutorSkill({super.key, required this.courseList});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Skill",
          ).toBoldText(),
          const SizedBox(
            height: 5,
          ),
          Row(
            children: List.generate(courseList.length, (index) {
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
                      courseList[index],
                      style: GoogleFonts.dmMono(
                          fontSize: 13,
                          color: Colors.white,
                          fontWeight: FontWeight.w500),
                    ),
                  )
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _CourseDetail extends StatelessWidget {
  final TutorDetails tutorDetails;
  const _CourseDetail({super.key, required this.tutorDetails});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        const Text(
              "Courses",
            ).toBoldText(),
            const SizedBox(
              height: 5,
            ),
        SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
            children:
                List.generate(tutorDetails.courseDetailList.length, (index) {
          return Card(
            child: Column(children: [
              McachedImage(url: tutorDetails.courseDetailList[index].imageUrl,
              radius: 0,
              height: 100,
              width: 200,
              ),
              Text(tutorDetails.courseDetailList[index].subjectName,).toNormalText(),
            ],),
          );
        })),
      )
      ],),
    );
  }
}


class _ReviewsDetail extends StatelessWidget {
  const _ReviewsDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}