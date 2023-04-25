import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vooms/activity/pages/tutor_cubit/tutor_cubit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:vooms/activity/pages/tutor_detail_page.dart';
import 'package:vooms/activity/repository/tutor_entity.dart';
import 'package:vooms/shareds/components/color_rundom.dart';
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
    return SafeArea(child: Scaffold(
      body: BlocBuilder<TutorCubit, TutorState>(builder: (context, state) {
        switch (state.tutorStateStatus) {
          case TutorStateStatus.initial:
            return const SizedBox();
          case TutorStateStatus.loaded:
            return _TutorListView(
              entities: state.entities,
            );
          case TutorStateStatus.failure:
            return  Center(
              child: TextButton(onPressed: () async {
                await context.read<TutorCubit>().getTutors();
              }, child: Container()),
            );
          case TutorStateStatus.loading:
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
        }
      }),
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

  final BoxDecoration _setupDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.shade100,
          blurRadius: 3,
          spreadRadius: 2,
          offset: Offset(1, 2),
          blurStyle: BlurStyle.solid,
        )
      ],
      color: Colors.white);

  Widget _setDetailTutor() {
    return Expanded(
      flex: 1,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: CachedNetworkImage(
              imageUrl: entity.photoUrl,
              imageBuilder: (context, imageProvider) => Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              placeholder: (context, url) => const Icon(Icons.image),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
          Text(
              "${entity.tutorDetails.wages.amount}/${entity.tutorDetails.wages.frequency}",
              style: GoogleFonts.dmMono(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _setDetailInformation() {
    return Expanded(
      flex: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(entity.fullname,
                  style: GoogleFonts.dmMono(fontWeight: FontWeight.w500)),
              const Icon(
                Icons.star_rounded,
                color: UIColorConstant.softOrange,
              ),
              Text(
                "${entity.tutorDetails.popularity.rating}",
                style: GoogleFonts.dmMono(
                    fontWeight: FontWeight.w300,
                    color: UIColorConstant.nativeGrey),
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                "(${entity.tutorDetails.popularity.rating})",
                style: GoogleFonts.dmMono(
                    fontWeight: FontWeight.w300,
                    color: UIColorConstant.nativeGrey),
              ),
            ],
          ),
          Text(entity.email,
              style: GoogleFonts.dmMono(
                  fontWeight: FontWeight.w100,
                  color: UIColorConstant.nativeGrey,
                  fontSize: 12)),
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: UIColorConstant.accentGrey3),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                    entity.tutorDetails.courseList.length,
                    (index) => Container(
                          decoration: BoxDecoration(
                            color: ColorExtension.random(),
                          ),
                          child: Text(
                            entity.tutorDetails.courseList[index],
                            style: GoogleFonts.dmMono(
                                fontSize: 12, color: Colors.white),
                          ),
                        ))),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(25, 15, 25, 15),
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      decoration: _setupDecoration,
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
