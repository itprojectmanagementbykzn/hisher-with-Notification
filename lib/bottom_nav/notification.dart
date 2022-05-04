import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:kzn/providers/blog_provider.dart';
import 'package:provider/provider.dart';
import 'bankslip.dart';
import 'newclass_enrollbutton.dart';
import 'post.dart';

String url ='https://hisandhermyanmar-95b62f.ingress-erytho.easywp.com';

Future fetchWpPosts() async {
  final response = await http.get(Uri.parse(
    "https://hisandhermyanmar-95b62f.ingress-erytho.easywp.com/index.php/wp-json/wp/v2/posts?per_page=100&categories=289&orderby=date&status=publish",
    // headers: {"Accept: application/json"}
  ));

  var covetedDatatoJson = jsonDecode(response.body);
  return covetedDatatoJson;
}


Future fetchWpPostImageUrl(String href ) async {

  final response = await http.get(Uri.parse(href), headers: {"Accept": "application/json"});
  var covetedDatatoJson = jsonDecode(response.body);
  print(covetedDatatoJson);
  return covetedDatatoJson;
}

class Noti extends StatefulWidget {
  // const Blog({Key? key}) : super(key: key);
  @override
  _NotiState createState() => _NotiState();
}
class _NotiState extends State<Noti> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.indigo),
        backgroundColor: Colors.white,
        title: Center(
          child: Text("His's and Her's Update", style: TextStyle(fontWeight: FontWeight.w700,
              fontSize: 16.0,
              color: Colors.black
          )),
        ),
          actions: [
            Container(
              margin: EdgeInsets.only(
                top: 7,
                bottom: 10,
                right: 15,
              ),
              width: 90,
              child: ElevatedButton(
                style: ButtonStyle(
                  alignment: Alignment.center,
                  padding: MaterialStateProperty.all(EdgeInsets.all(0)),
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  )),
                  overlayColor: MaterialStateProperty.all(Colors.black12),
                ),
                onPressed: () async {
                  {Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BankSlip()),
                  );
                  }
                },
                child: Text("Contact Us", style: TextStyle(fontWeight: FontWeight.w700,
                    fontSize: 14.0,
                    color: Colors.black
                )),
              ),
            ),

          ]
      ),

      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: FutureBuilder(
          future: Provider.of<BlogProvider>(context, listen: true).notiBlogPosts,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if(snapshot.hasData){
              return GridView.builder(
                padding: const EdgeInsets.only(top: 0, bottom: 20, left: 5, right: 5),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount (crossAxisCount: 2),
                physics: BouncingScrollPhysics(),
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  Map wppost = snapshot.data[index];

                  // you write wp:featuredmedia:
                  // I fixed wp:featuredmedia

                  return PostTile(
                      href: wppost["_links"]["wp:featuredmedia"][0]["href"],
                      title: wppost["title"]["rendered"].replaceAll("#038;", ""),
                      desc: wppost["excerpt"]["rendered"],
                      imageUrl: wppost["_embedded"]["wp:featuredmedia"].first["source_url"],
                      content: wppost["content"]["rendered"]);
                },);
            }
            return Center(child: const CircularProgressIndicator());
          },
        ),
      ),


    );
  }
}


class PostTile extends StatefulWidget {
  const PostTile({Key key, this.href, this.title, this.desc, this.content, this.imageUrl}) : super(key: key);

  final String href, title, desc, content, imageUrl;

  @override
  State<PostTile> createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {
  //var imageUrl = "";
  Widget shortDescritionView (){
    return Html(
      data: widget.desc,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => NewClassEnroll(
          desc: widget.content,
          imageUrl: widget.imageUrl,
          title: widget.title,
        )));
      },
      child: Card(
        margin: EdgeInsets.all(6),
        shape:  OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.white, width: 1)
        ),
        elevation: 0,
        // margin: EdgeInsets.only(top: 10),
        child: Container(
          height: 200,
          child: Stack(
          alignment: Alignment.center,
          children: [
              Hero(
                tag: widget.imageUrl,
                child: Image.network(widget.imageUrl,
                    // width: 190,
                    // height: 190,
                    fit: BoxFit.cover
                ),
              ),
                ],
              ),
            // SizedBox(width: 20),

            // Expanded(child:
            // Column(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [Text(widget.title,
            //       style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)
            //   ),
            //     shortDescritionView(),
            //   ],)),
            // SizedBox(width: 5),
        ),
      ),
    );
  }
}