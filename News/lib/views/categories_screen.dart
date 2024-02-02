import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news/models/category_news_model.dart';

import '../view_model/view_news_model.dart';
import 'home_screen.dart';

class CategoriesScreen extends StatefulWidget {
   CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();

}

class _CategoriesScreenState extends State<CategoriesScreen> {
  NewsViewModel newsViewModel = NewsViewModel();

  final format=DateFormat('MMMM dd.yyyy');
  String categoryName='General';
  List<String>categoriesList=['General','Entertainment','Health','Support','Busimess','Tecnology',];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 1;
    final height = MediaQuery.of(context).size.height * 1;
    return Scaffold(
      appBar: AppBar(


      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 50,
              child: ListView.builder(

                scrollDirection: Axis.horizontal,
                itemCount: categoriesList.length,
                  itemBuilder: (context,index){
                  return InkWell(
                    onTap: (){
                      categoryName=categoriesList[index];
                      setState(() { });


                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Container(
                        decoration: BoxDecoration(color: categoryName==categoriesList[index]?Colors.blue:Colors.grey,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Center(child: Text(categoriesList[index].toString(),style: GoogleFonts.poppins(fontSize: 13,color: Colors.white),)),
                        ),
                      ),
                    ),
                  );



                  }),
            ),
            SizedBox(height: 15,),
            Expanded(
              child: FutureBuilder<CategoryNewsModel>(
                future: newsViewModel.fetchCategoriesNewsApi(),
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
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        DateTime dateTime=DateTime.parse(snapshot.data!.articles![index].publishedAt.toString());
                        return  Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: Row(
                                                 children: [
                           ClipRRect(
                             borderRadius: BorderRadius.circular(15),
                             child: CachedNetworkImage(
                               imageUrl: snapshot.data!.articles![index].urlToImage .toString(),
                               fit: BoxFit.cover,
                               height:height *.18,
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
                                                         height: height*.14,
                                                         padding:EdgeInsets.only(left:13),
                                                         child: Column(
                                                           children: [
                                                             Text(snapshot.data!.articles![index].title .toString(),

                                                               style: GoogleFonts.poppins(fontSize: 8,color: Colors.black54,
                                                                 fontWeight: FontWeight.w500,
                                                               ),
                                                             ),
                                                             Spacer(),
                                                             Row(
                                                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                               children: [
                                                                 Text(snapshot.data!.articles![index].source!.name .toString(),

                                                                   style: GoogleFonts.poppins(fontSize: 15,color: Colors.black54,
                                                                     fontWeight: FontWeight.w500,
                                                                   ),
                                                                 ),
                                                                 Text(format.format(dateTime),

                                                                   style: GoogleFonts.poppins(fontSize: 8,
                                                                     fontWeight: FontWeight.w400,
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
      ),
    );
  }
}
