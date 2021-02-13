import 'package:example/Models/PhotoModel.dart';
import 'package:example/Request/Request.dart';
import 'package:flutter/material.dart';

class PhotoExample extends StatelessWidget {
  PhotoExample({this.title});
  final String title;
  final Photo photo = Photo();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: FutureBuilder(
            //get 5000 items
            future: request.getObjData("photos", photo, multi: true),
            builder: (BuildContext context, snp) {
              return photo.loading
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: snp.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        Photo currentphoto = snp.data[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              ListTile(
                                title: Text(currentphoto.title),
                                leading:
                                    Image.network(currentphoto.thumbnailUrl),
                              ),
                              Image.network(currentphoto.url)
                            ],
                          ),
                        );
                      });
            },
          )),
    );
  }
}
