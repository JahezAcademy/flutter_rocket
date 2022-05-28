import 'package:example/models/user_model.dart';
import 'package:example/models/user_submodel/address_submodel.dart';
import 'package:example/models/user_submodel/company_submodel.dart';
import 'package:example/models/user_submodel/geo_submodel.dart';
import 'package:example/requests/user_request.dart';
import 'package:flutter/material.dart';
import 'package:mvc_rocket/mvc_rocket.dart';

class UserExample extends StatelessWidget {
  final User users = RocketController().add<User>(usersEndpoint, User());
  UserExample({Key? key, required this.title}) : super(key: key);
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
                children: const [Icon(Icons.get_app), Text("Get Data")],
              ),
              onPressed: () => GetUsers.getUsers(users),
            ),
            TextButton(
                child: const Text(
                    "Click here to Change First User\nCompany & User name & image"),
                onPressed: () {
                  Company newCompany = Company(
                    bs: "change data...bs",
                    catchPhrase: "change data...catch",
                  );
                  // [1]-change data with constractor:

                  // User editUser = User(
                  //     name: "Mohammed CHAHBOUN 💙",
                  //     company: newCompany,
                  //     image:
                  //         "https://avatars.githubusercontent.com/u/69054810?s=400&u=89be3dbf1c40d543e1fe2f648068bd8e388325ff&v=4");

                  // users.multi[0].fromJson(editUser.toJson());
                  // users.rebuild();

                  // [2]-change data with fromJson method directly:

                  users.multi![0].fromJson({
                    users.nameVar: "Mohammed CHAHBOUN 💙",
                    users.companyVar: newCompany.toJson(),
                    users.imageVar:
                        "https://avatars.githubusercontent.com/u/69054810?s=400&u=89be3dbf1c40d543e1fe2f648068bd8e388325ff&v=4"
                  });
                  // Call rebuild method required if data multi
                  users.rebuildWidget();
                }),
          ],
        ),
      ),
      body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: RocketView(
            // call api by RocketRequest saved in McController and make model on ready
            call: () => GetUsers.getUsers(users),
            // call api every 1 sec
            callType: CallType.callAsStream,
            // update data from server after 2 sec
            secondsOfStream: 2,
            // your model
            model: users,
            // your widget for show data from model
            builder: (context) {
              return ListView.builder(
                itemCount: users.multi!.length,
                itemBuilder: (BuildContext context, int index) {
                  User user = users.multi![index];
                  Company company = user.company!;
                  Address address = user.address!;
                  Geo geo = address.geo!;
                  return ExpansionTile(
                      leading: InkWell(
                        onLongPress: () => users.delItem(index),
                        onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(builder: (BuildContext context) {
                          return OneUser(index);
                        })),
                        child: CircleAvatar(
                          backgroundColor: Theme.of(context).primaryColor,
                          backgroundImage: user.image == null
                              ? null
                              : NetworkImage(user.image!),
                          child: user.image == null
                              ? const Icon(Icons.person)
                              : null,
                        ),
                      ),
                      title: Text("User :${user.name!}"),
                      children: [
                        const SizedBox(height: 5.0),
                        Text(user.id.toString()),
                        Text(user.username!),
                        Text(user.email!),
                        Text(user.phone!),
                        Text(user.website!),
                        const SizedBox(height: 5),
                        ExpansionTile(
                            tilePadding:
                                const EdgeInsets.symmetric(horizontal: 40.0),
                            leading: CircleAvatar(
                              backgroundColor: Theme.of(context).primaryColor,
                              child: const Icon(Icons.home),
                            ),
                            title: Text("Company :${company.name!}"),
                            children: [
                              const SizedBox(height: 5.0),
                              Text(company.bs!),
                              Text(company.catchPhrase!),
                            ]),
                        const SizedBox(height: 5),
                        ExpansionTile(
                            tilePadding:
                                const EdgeInsets.symmetric(horizontal: 40.0),
                            leading: CircleAvatar(
                              backgroundColor: Theme.of(context).primaryColor,
                              child: const Icon(Icons.place),
                            ),
                            title: Text("Address :${address.city!}"),
                            children: [
                              const SizedBox(height: 5.0),
                              Text(address.street!),
                              Text(address.suite!),
                              Text(address.zipcode!),
                              Text(address.city!),
                              const SizedBox(height: 5.0),
                              ExpansionTile(
                                  tilePadding: const EdgeInsets.symmetric(
                                      horizontal: 80.0),
                                  leading: CircleAvatar(
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    child: const Icon(Icons.map),
                                  ),
                                  title: const Text("geo adrdress"),
                                  children: [
                                    const SizedBox(height: 5.0),
                                    Text(geo.lat!),
                                    Text(geo.lng!),
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

// ignore: must_be_immutable
class OneUser extends StatelessWidget {
  final int index;
  late User user;
  late Company company;
  late Address address;
  late Geo geo;
  OneUser(this.index, {Key? key}) : super(key: key) {
    user = rocket.get<User>(usersEndpoint).multi![index];
    company = user.company!;
    address = user.address!;
    geo = address.geo!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ExpansionTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              backgroundImage:
                  user.image == null ? null : NetworkImage(user.image!),
              child: user.image == null ? const Icon(Icons.person) : null,
            ),
            title: Text("User :${user.name!}"),
            children: [
              const SizedBox(height: 5.0),
              Text(user.id.toString()),
              Text(user.username!),
              Text(user.email!),
              Text(user.phone!),
              Text(user.website!),
              const SizedBox(height: 5),
              ExpansionTile(
                  tilePadding: const EdgeInsets.symmetric(horizontal: 40.0),
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor,
                    child: const Icon(Icons.home),
                  ),
                  title: Text("Company :${company.name!}"),
                  children: [
                    const SizedBox(height: 5.0),
                    Text(company.bs!),
                    Text(company.catchPhrase!),
                  ]),
              const SizedBox(height: 5),
              ExpansionTile(
                  tilePadding: const EdgeInsets.symmetric(horizontal: 40.0),
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor,
                    child: const Icon(Icons.place),
                  ),
                  title: Text("Address :${address.city!}"),
                  children: [
                    const SizedBox(height: 5.0),
                    Text(address.street!),
                    Text(address.suite!),
                    Text(address.zipcode!),
                    Text(address.city!),
                    const SizedBox(height: 5.0),
                    ExpansionTile(
                        tilePadding:
                            const EdgeInsets.symmetric(horizontal: 80.0),
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(context).primaryColor,
                          child: const Icon(Icons.map),
                        ),
                        title: const Text("geo adrdress"),
                        children: [
                          const SizedBox(height: 5.0),
                          Text(geo.lat!),
                          Text(geo.lng!),
                        ]),
                  ]),
            ]),
      ),
    );
  }
}
