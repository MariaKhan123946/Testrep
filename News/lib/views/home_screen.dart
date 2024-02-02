import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news/models/category_news_model.dart';
import 'package:news/models/news_channel_headline_model.dart';
import 'package:news/view_model/view_news_model.dart';
import 'package:news/views/news_details_screen.dart';

import 'categories_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
enum FilterList{bbcNews,aryNews,independent,reuters,cnn,aljazeera}

class _HomeScreenState extends State<HomeScreen> {
  NewsViewModel newsViewModel = NewsViewModel();
  FilterList? selectedMenu;
  final format=DateFormat('MMMM dd.yyyy');
  String Name='bbc_news';

  

  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 1;
    final height = MediaQuery.of(context).size.height * 1;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) =>CategoriesScreen () ,));
          },
          icon: Image.asset(
            'images/download (15).png',
            height: 20,
            width: 20,
          ),
        ),

        title: Text(
          'News',
          style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w700,
          ),


        ),
        actions: [
          PopupMenuButton< FilterList>(
            initialValue: selectedMenu,
            icon: Icon(Icons.more_vert,color: Colors.black,),
            onSelected: (FilterList item) {
              if (FilterList.bbcNews.name == item.name) {
                Name == 'bbc News';
              }

              if (FilterList.aryNews.name == item.name) {
                Name =='ary-news';
              }
              if (FilterList.aljazeera.name == item.name) {
                Name== 'al-jazeera-english';
              }
              setState(() {
                selectedMenu=item;

              });

            },
            itemBuilder:(BuildContext)=> <PopupMenuEntry< FilterList>>[
              PopupMenuItem< FilterList>(
                value: FilterList.bbcNews ,
                  child:Text('BBC News') ,),
              PopupMenuItem< FilterList>(
                  value: FilterList.aryNews ,
                  child:Text('Ary News'), ),
              PopupMenuItem< FilterList>(
                value: FilterList.aljazeera ,
                child:Text('Al _Jaseera_News'), ),

            ]
          )

            ]
          ),
      body:ListView(
        children: [
          SizedBox(
            height: height* .55,
            width: width,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: FutureBuilder<NewsChannelsHeadlinesModel>(
                future: newsViewModel.fetchNewsChannelHeadlinesApi(),
                builder: (BuildContext context,  snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: SpinKitCircle(
                        size: 40,
                        color: Colors.blue,
                      ),
                    );

                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.articles!.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        DateTime dateTime=DateTime.parse(snapshot.data!.articles![index].publishedAt.toString());
                        return InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => NewsDetailsScree(
                                newsImage: snapshot.data!.articles![index].urlToImage.toString(),
                                newsTitle: snapshot.data!.articles![index].title.toString(),
                                newsDate: snapshot.data!.articles![index].publishedAt.toString(),
                                author: snapshot.data!.articles![index].author.toString(),
                                description: snapshot.data!.articles![index].description.toString(),
                                source: snapshot.data!.articles![index].source!.name.toString(),
                                content: snapshot.data!.articles![index].content.toString(),
                            ),),
                            );
                          },
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                height: height*0.6,
                                width: width*.9,
                                padding: EdgeInsets.symmetric(horizontal: height*.03),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: CachedNetworkImage(
                                    imageUrl: snapshot.data!.articles![index].urlToImage.toString(),
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Container(child: spinnkit2),
                                    errorWidget: (context, url, error) => Icon(Icons.error_outline, color: Colors.red),
                                  ),
                                ),

                              ),
                              Positioned(
                                bottom: 40,

                                child: Card(
                                  elevation: 5,
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)
                                  ),

                                  child:Container(
                                    alignment: Alignment.bottomCenter,
                                    padding: EdgeInsets.all(5),
                                    height: height*.15,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: width*0.7,
                                          child: Text(snapshot.data!.articles![index].
                                          title.toString(),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.poppins(fontSize: 17,fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                        Spacer(),
                                        Container(
                                          width: width*0.7,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(snapshot.data!.articles![index].
                                              source!.name.toString(),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.poppins(fontSize: 12,fontWeight: FontWeight.w600),
                                              ),
                                              Text(format.format(dateTime),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.poppins(fontSize: 12,fontWeight: FontWeight.w500),
                                              ),
                                            ],
                                          ),

                                        ),

                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: FutureBuilder<CategoryNewsModel>(
              future: newsViewModel.fetchCategoriesNewsApi(),
              builder: (BuildContext context,  snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: SpinKitCircle(
                      size: 50,
                      color: Colors.blue,
                    ),
                  );

                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.articles!.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      DateTime dateTime=DateTime.parse(snapshot.data!.articles![index].publishedAt.toString());
                      return  Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: CachedNetworkImage(
                                imageUrl: snapshot.data!.articles![index].urlToImage .toString(),
                                fit: BoxFit.cover,
                                height:height *.15,
                                width:width *.3,

                                placeholder: (context, url) => Container(child: Center(
                                  child: SpinKitCircle(
                                    size: 50,
                                    color: Colors.blue,
                                  ),
                                ),),
                                errorWidget: (context, url, error) => Icon(Icons.error_outline, color: Colors.red),
                              ),
                            ),
                            Expanded(
                              child:Container(
                                height: height*.15,
                                padding:EdgeInsets.only(left:10),
                                child: Column(
                                  children: [
                                    Text(snapshot.data!.articles![index].title .toString(),
                                      maxLines: 3,
                                      style: GoogleFonts.poppins(fontSize: 10,color: Colors.black54,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Spacer(),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(snapshot.data!.articles![index].source!.name .toString(),

                                          style: GoogleFonts.poppins(fontSize: 8,color: Colors.black54,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(format.format(dateTime),

                                          style: GoogleFonts.poppins(fontSize: 8,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ), ),
                          ],
                        ),

                      );
                    },
                  );
                }
              },
            ),
          ),

        ],
      ),

    );
  }
}

const spinnkit2 = SpinKitFadingCircle(
  color: Colors.amber,
  size: 50,
);
