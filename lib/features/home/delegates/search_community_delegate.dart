import 'package:bennit/core/common/error_text.dart';
import 'package:bennit/core/common/loader.dart';
import 'package:bennit/features/community/controller/community_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class SearchCommunityDelegate extends SearchDelegate {
  final WidgetRef ref;
  SearchCommunityDelegate({required this.ref});
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    return const SizedBox();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ref.watch(searchCommunityProvider(query)).when(
        data: (communities) => ListView.builder(
              itemCount: communities.length,
              itemBuilder: (BuildContext context, int index) {
                final Community = communities[index];
                return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(Community.avatar),
                    ),
                    title: Text("b/${Community.name}"),
                    onTap: () => navigateToCommunity(context, Community.name));
              },
            ),
        error: (error, stackTrace) => ErrorText(error: error.toString()),
        loading: () => const Loader());
  }

  void navigateToCommunity(BuildContext context, String communityName) {
    Routemaster.of(context).push('/b/$communityName');
  }
}
