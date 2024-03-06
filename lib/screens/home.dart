import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hacker_news/screens/news_list.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hacker News'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          const SizedBox(
            height: 20.0,
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              width: double.infinity,
              height: 300.0,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  image: DecorationImage(
                    image: NetworkImage(
                        'https://i.pinimg.com/474x/d2/3d/8c/d23d8cd0331ad0050a713124a45f2b5a.jpg'),
                    fit: BoxFit.cover,
                    colorFilter:
                        ColorFilter.mode(Colors.grey, BlendMode.darken),
                  )),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Welcome into Hacker News...',
                      style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontSize: 32.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 25.0,
          ),
          const Center(
            child: Text(
              'Stories',
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.blueAccent,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>const NewsList()));
                },
                child: Container(
                  width: 120,
                  height: 170,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.blueAccent,
                    image: const DecorationImage(
                        image: NetworkImage('https://i.pinimg.com/474x/24/75/3f/24753ffd5bf3d465bbab45c803174f20.jpg'),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(Colors.grey, BlendMode.darken)
                    ),
                  ),
                  child: const Center(
                    child: Text('All',style: TextStyle(fontSize: 27, color: Colors.white,fontStyle: FontStyle.italic),),
                  ),
                ),
              ),
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>const NewsList(onlyFavorite: true,)));
                },
                child: Container(
                  width: 120,
                  height: 170,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.blueAccent,
                    image: const DecorationImage(
                        image: NetworkImage('https://i.pinimg.com/474x/80/fd/0c/80fd0c70c1522e2894f979188509ce1f.jpg'),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(Colors.grey, BlendMode.darken)
                    ),
                  ),
                  child: const Center(
                    child: Text('Favorites',style: TextStyle(fontSize: 25, color: Colors.white,fontStyle: FontStyle.italic),),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 20,),
        ],
      ),
    );
  }
}
