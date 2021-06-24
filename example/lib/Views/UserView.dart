import 'package:example/Models/UserModel.dart';
import 'package:flutter/material.dart';
import 'package:mc/mc.dart';

class UserExample extends StatelessWidget {
  final User users = McController().add<User>("users", User());
  UserExample({this.title});
  final String title;
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
            TextButton(
              child: Wrap(
                children: [Icon(Icons.get_app), Text("Get Data")],
              ),
              onPressed: () => mc
                  .get<McRequest>('rq')
                  .getObjData<User>("users", users, multi: true),
            ),
            TextButton(
                child: Text(
                    "Click here to Change First User\nCompany & User name & img"),
                onPressed: () {
                  Company newCompany = Company(
                    bs: "change data...bs",
                    catchPhrase: "change data...catch",
                  );

                  users.multi[0].fromJson({
                    "name": "Mohammed CHAHBOUN 💙",
                    "company": newCompany.toJson(),
                    'image':
                        "https://avatars.githubusercontent.com/u/69054810?s=400&u=89be3dbf1c40d543e1fe2f648068bd8e388325ff&v=4"
                  });
                  //rebuild method required if data multi
                  users.rebuild();
                }),
          ],
        ),
      ),
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: McView(
            call: () =>
                mc.get<McRequest>('rq').getObjData("users", users, multi: true),
            callType: CallType.callAsStream,
            secondsOfStream: 1,
            model: users,
            builder: (BuildContext __, _) {
              return ListView.builder(
                itemCount: users.multi.length,
                itemBuilder: (BuildContext context, int index) {
                  User user = users.multi[index];
                  Company company = user.company;
                  Address address = user.address;
                  Geo geo = address.geo;
                  return ExpansionTile(
                      leading: InkWell(
                        onLongPress: () => users.delItem(index),
                        onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(builder: (BuildContext context) {
                          return OneUser(index);
                        })),
                        child: CircleAvatar(
                          backgroundColor: Theme.of(context).primaryColor,
                          backgroundImage:
                              user.img == null ? null : NetworkImage(user.img),
                          child: user.img == null ? Icon(Icons.person) : null,
                        ),
                      ),
                      title: Text("User :" + user.name),
                      children: [
                        SizedBox(height: 5.0),
                        Text(user.id.toString()),
                        Text(user.username),
                        Text(user.email),
                        Text(user.phone),
                        Text(user.website),
                        SizedBox(height: 5),
                        ExpansionTile(
                            tilePadding: EdgeInsets.symmetric(horizontal: 40.0),
                            leading: CircleAvatar(
                              backgroundColor: Theme.of(context).primaryColor,
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
                            tilePadding: EdgeInsets.symmetric(horizontal: 40.0),
                            leading: CircleAvatar(
                              backgroundColor: Theme.of(context).primaryColor,
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
                                  tilePadding:
                                      EdgeInsets.symmetric(horizontal: 80.0),
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

class OneUser extends StatelessWidget {
  final int index;
  User user;
  Company company;
  Address address;
  Geo geo;
  OneUser(this.index) {
    user = mc.get<User>('users').multi[index];
    company = user.company;
    address = user.address;
    geo = address.geo;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ExpansionTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              backgroundImage: user.img == null ? null : NetworkImage(user.img),
              child: user.img == null ? Icon(Icons.person) : null,
            ),
            title: Text("User :" + user.name),
            children: [
              SizedBox(height: 5.0),
              Text(user.id.toString()),
              Text(user.username),
              Text(user.email),
              Text(user.phone),
              Text(user.website),
              SizedBox(height: 5),
              ExpansionTile(
                  tilePadding: EdgeInsets.symmetric(horizontal: 40.0),
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor,
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
                  tilePadding: EdgeInsets.symmetric(horizontal: 40.0),
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor,
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
                        tilePadding: EdgeInsets.symmetric(horizontal: 80.0),
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(context).primaryColor,
                          child: Icon(Icons.map),
                        ),
                        title: Text("geo adrdress"),
                        children: [
                          SizedBox(height: 5.0),
                          Text(geo.lat),
                          Text(geo.lng),
                        ]),
                  ]),
            ]),
      ),
    );
  }
}
