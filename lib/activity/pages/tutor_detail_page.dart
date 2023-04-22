import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vooms/activity/repository/tutor_entity.dart';
import 'package:vooms/app.dart';
import 'package:vooms/chat/pages/chat_room_page.dart';
import 'package:vooms/shareds/components/color_rundom.dart';
import 'package:vooms/shareds/general_helper/ui_color_constants.dart';

class TutorDetailPage extends StatelessWidget {
  const TutorDetailPage({super.key, required this.entity});
  final TutorEntity entity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: UIColorConstant.accentGrey2,
        elevation: 0.0,
      ),
      bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: UIColorConstant.accentGrey3,
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
                        builder: (context) =>
                            ChatRoomPage(entity: entity,));
                    Navigator.push(context, route);
                  },
                  icon: const Icon(
                    Icons.chat_bubble,
                    color: UIColorConstant.softOrange,
                  ))
            ],
          )),
      body: SafeArea(
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          children: [
            _TutorDetail(
              imageUrl: entity.photoUrl,
              location: 'Somewhere in the city',
              name: entity.fullname,
              rating: entity.tutorDetails.popularity.rating.toString(),
              courseList: entity.tutorDetails.courseList,
            ),
            const Divider(
              height: 1,
            ),
            _TutorOverview(overview: entity.tutorDetails.teacherOverview),
            const Divider(
              height: 1,
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
    required this.imageUrl,
    required this.name,
    required this.rating,
    required this.location,
    required this.courseList,
  });
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
          CachedNetworkImage(
            imageUrl: imageUrl,
            imageBuilder: (context, imageProvider) => Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            placeholder: (context, url) => const Icon(Icons.image),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.dmMono(
                          fontWeight: FontWeight.w500,
                          color: UIColorConstant.nativeGrey),
                    ),
                    const Icon(
                      Icons.star_rounded,
                      color: UIColorConstant.softOrange,
                    ),
                    Text(
                      rating,
                      style: GoogleFonts.dmMono(),
                    ),
                  ],
                ),
                Text(location),
                Wrap(
                  children: List.generate(
                      courseList.length,
                      (index) => Container(
                            height: 30,
                            margin: const EdgeInsets.only(left: 2, bottom: 2),
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: ColorExtension.random(),
                                borderRadius: BorderRadius.circular(8)),
                            child: Text(courseList[index],
                                style: GoogleFonts.dmMono(
                                    color: UIColorConstant.nativeWhite)),
                          )),
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
          Text(
            "Overview",
            style: GoogleFonts.dmMono(
                fontWeight: FontWeight.w500, color: UIColorConstant.nativeGrey),
          ),
          Text(overview,
              style: GoogleFonts.dmMono(color: UIColorConstant.nativeBlack)),
        ],
      ),
    );
  }
}

class _CourseDetail extends StatelessWidget {
  const _CourseDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Row(children: []),
    );
  }
}
