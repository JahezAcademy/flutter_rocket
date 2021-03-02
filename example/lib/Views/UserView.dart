import 'package:example/Models/UserModel.dart';
import 'package:example/Request/Request.dart';
import 'package:flutter/material.dart';
import 'package:mc/mc.dart';

class UserExample extends StatelessWidget {
  UserExample({this.title});
  final String title;
  final User user = User();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      floatingActionButton: Container(
        color: Theme.of(context).primaryColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FlatButton(
              child: Wrap(
                children: [Icon(Icons.get_app), Text("Get Data")],
              ),
              onPressed: () => request.getObjData("users", user, multi: true),
            ),
            FlatButton(
                child: Text(
                    "Click here to Change First User\nCompany & User name & omg"),
                onPressed: () {
                  Company newCompany = Company(
                    bs: "change data...bs",
                    catchPhrase: "change data...catch",
                  );

                  user.multi[5].fromJson({
                    "name": "Mohammed CHAHBOUN 💙",
                    "company": newCompany.toJson(),
                    'image':
                        "https://avatars.githubusercontent.com/u/69054810?s=400&u=89be3dbf1c40d543e1fe2f648068bd8e388325ff&v=4"
                  });
                  //rebuild method required if data multi
                  user.rebuild();
                }),
          ],
        ),
      ),
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: McView(
            model: user,
            builder: (BuildContext __, _) {
              return user.loading
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: user.multi.length,
                      itemBuilder: (BuildContext context, int index) {
                        User currentUser = user.multi[index];
                        Company company = currentUser.company;
                        Address address = currentUser.address;
                        Geo geo = address.geo;
                        return ExpansionTile(
                            leading: CircleAvatar(
                              backgroundColor: Theme.of(context).primaryColor,
                              backgroundImage: currentUser.img == null
                                  ? null
                                  : NetworkImage(currentUser.img),
                              child: currentUser.img == null
                                  ? Icon(Icons.person)
                                  : null,
                            ),
                            title: Text("User :" + currentUser.name),
                            children: [
                              SizedBox(height: 5.0),
                              Text(currentUser.id.toString()),
                              Text(currentUser.username),
                              Text(currentUser.email),
                              Text(currentUser.phone),
                              Text(currentUser.website),
                              SizedBox(height: 5),
                              ExpansionTile(
                                  tilePadding:
                                      EdgeInsets.symmetric(horizontal: 40.0),
                                  leading: CircleAvatar(
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    child: Icon(Icons.home),
                                  ),
                                  title: Text("Company :" + company.name),
                                  children: [
                                    SizedBox(height: 5.0),
                                    Text(company.bs),
                                    Text(company.catchPhrase),
                                  ]),
                              SizedBox(height: 5),
                              ExpansionTile(
                                  tilePadding:
                                      EdgeInsets.symmetric(horizontal: 40.0),
                                  leading: CircleAvatar(
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    child: Icon(Icons.place),
                                  ),
                                  title: Text("Address :" + address.city),
                                  children: [
                                    SizedBox(height: 5.0),
                                    Text(address.street),
                                    Text(address.suite),
                                    Text(address.zipcode),
                                    Text(address.city),
                                    SizedBox(height: 5.0),
                                    ExpansionTile(
                                        tilePadding: EdgeInsets.symmetric(
                                            horizontal: 80.0),
                                        leading: CircleAvatar(
                                          backgroundColor:
                                              Theme.of(context).primaryColor,
                                          child: Icon(Icons.map),
                                        ),
                                        title: Text("geo adrdress"),
                                        children: [
                                          SizedBox(height: 5.0),
                                          Text(geo.lat),
                                          Text(geo.lng),
                                        ]),
                                  ]),
                            ]);
                      },
                    );
            },
          )),
    );
  }
}
