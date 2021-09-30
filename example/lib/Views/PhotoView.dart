import 'package:example/Models/PhotoModel.dart';
import 'package:flutter/material.dart';
import 'package:mc/mc.dart';

class PhotoExample extends StatelessWidget {
  PhotoExample({this.title});
  final String title;
  final Photo photo = McController().add<Photo>('photos', Photo());
  final McRequest request = McController().get<McRequest>('rq');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: McView(
            model: photo,

            // get 5000 items
            call: getData,
            builder: () {
              return ListView.builder(
                  itemCount: photo.multi.length,
                  itemBuilder: (BuildContext context, int index) {
                    Photo currentphoto = photo.multi[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(currentphoto.title),
                            leading: Image.network(currentphoto.thumbnailUrl),
                          ),
                          Image.network(
                            currentphoto.url,
                            frameBuilder: (_, child, __, ___) {
                              return Container(
                                decoration: BoxDecoration(boxShadow: [
                                  BoxShadow(
                                      blurRadius: 10.0,
                                      color: Colors.black.withAlpha(100),
                                      offset: Offset.zero)
                                ]),
                                child: child,
                              );
                            },
                          )
                        ],
                      ),
                    );
                  });
            },
          )),
    );
  }

  Future getData() => request.getObjData("photos", photo, multi: true);
}
