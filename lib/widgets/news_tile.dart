import 'package:flutter/material.dart';
import 'package:hacker_news/models/story.dart';
import 'package:hacker_news/screens/story_detailed.dart';
import 'package:hacker_news/utils/providers/story_provider.dart';
import 'package:provider/provider.dart';


class NewsTile extends StatelessWidget {
  final Story story;
  final bool isFav;
  final int position;
  const NewsTile({super.key, required this.story, required this.isFav, required this.position, });

  @override
  Widget build(BuildContext context) {

    return Card(
        child: ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return StoryDetailed(story: story);
                }),
              );
            },
            leading: CircleAvatar(
              child: Text(story.author.characters.first),
            ),
            title: Text(story.title),
            subtitle: Text(story.time),
            trailing: IconButton(
              onPressed: () {
                final itemProvider =
                    Provider.of<StoryProvider>(context, listen: false);
                itemProvider.updateFavorites(position);
              },
              icon: story.isFavorite? const Icon(Icons.star): const Icon(Icons.star_border),
            ),
          ),);
      }

  }
