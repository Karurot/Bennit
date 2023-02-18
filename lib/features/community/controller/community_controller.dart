import 'package:bennit/features/community/repository/communitory_repositort.dart';
import 'package:bennit/models/community_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommunityController {
  final CommunityRepository _communityRepository;
  final _ref;
  CommunityController(
      {required CommunityRepository communityRepository, required Ref ref})
      : _communityRepository = communityRepository,
        _ref = ref;


  void createCommunity(String name, BuildContext context) async{
    Community community = Community(id: id, name: name, banner: banner, avatar: avatar, members: members, mods: mods)
  },
}
