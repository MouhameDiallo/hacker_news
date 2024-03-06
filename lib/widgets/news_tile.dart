import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:hacker_news/models/story.dart';
import 'package:hacker_news/screens/story_detailed.dart';
import 'package:provider/provider.dart';

import '../database/database_helper.dart';
import '../providers/story_provider.dart';


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
              onPressed: () async {
                final itemProvider =
                    Provider.of<StoryProvider>(context, listen: false);
                itemProvider.updateFavorites(position);

                DatabaseHelper db = DatabaseHelper();
                db.init().then((value) {
                  if(story.isFavorite){
                    //Si la story n'est pas sauvegardee, faut sauvegarder dans la base
                    db.isInDatabase(story.id).then((value) => value?-1:db.insertStories(story));
                  }
                  db.update(story);
                  final snackBar = SnackBar(
                    elevation: 0,
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.transparent,
                    content: AwesomeSnackbarContent(
                      title: 'Cool!',
                      message:
                      'Favorite list updated!',
                      contentType: ContentType.help,
                    ),
                  );

                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(snackBar);
                } );


              },
              icon: story.isFavorite? const Icon(Icons.star): const Icon(Icons.star_border),
            ),
          ),);
      }

  }
