import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:vooms/activity/repository/tutor_entity.dart';

class TutorDetailPage extends StatelessWidget {
  const TutorDetailPage({super.key, required this.entity});
  final TutorEntity entity;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
             _TutorDetail(
              imageUrl: entity.photoUrl, 
              location: 'Somewhere in the city', 
              name: entity.fullname, 
              rating: entity.tutorDetails.popularity.rating.toString(),),
              const Divider(height: 1,),
          ],),
        ),
      ));
  }
}


class _TutorDetail extends StatelessWidget {
  const _TutorDetail({super.key,
   required this.imageUrl,
   required this.name, 
   required this.rating,
   required this.location
   });
  final String imageUrl;
  final String name;
  final String rating;
  final String location;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
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

     Column(children: [
       Row(children: [
        Text(name),
        const Icon(Icons.start_rounded),
        Text(rating),
       ],),
       Text(location)
     ],)       
    ],);
  }
}

class TutorOverview extends StatelessWidget {
  const TutorOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}