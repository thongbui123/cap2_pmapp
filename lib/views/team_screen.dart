import 'package:capstone2_project_management_app/models/team_model.dart';
import 'package:capstone2_project_management_app/views/subs/add_team_screen.dart';
import 'package:capstone2_project_management_app/views/profile_screen.dart';
import 'package:capstone2_project_management_app/views/update_team_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';

class TeamScreen extends StatefulWidget {
  const TeamScreen({super.key});

  @override
  State<TeamScreen> createState() => _TeamScreenState();
}

class _TeamScreenState extends State<TeamScreen> {
  User? user;
  DatabaseReference? userRef;
  DatabaseReference? teamRef;
  DatabaseReference? memRef;
  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      userRef = FirebaseDatabase.instance.ref().child('userId');
      teamRef = FirebaseDatabase.instance.ref().child('teams');
      memRef = FirebaseDatabase.instance
          .ref()
          .child('teams')
          .child('${teamRef!.key}');
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Team List"),
        automaticallyImplyLeading: true,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return const profile_screen();
                }));
              },
              icon: const Icon(Icons.person)),
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (ctx) {
                      return AlertDialog(
                        title: const Text('Confirmation !!!'),
                        content: const Text('Are you sure to Log Out ? '),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(ctx).pop();
                            },
                            child: const Text('No'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(ctx).pop();

                              FirebaseAuth.instance.signOut();

                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(builder: (context) {
                                return const LoginScreen();
                              }));
                            },
                            child: const Text('Yes'),
                          ),
                        ],
                      );
                    });
              },
              icon: const Icon(Icons.logout)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return const AddTeamScreen();
          }));
        },
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder(
        stream: teamRef != null ? teamRef!.onValue : null,
        builder: (context, snapshot) {
          // return const Center(
          //   child: CircularProgressIndicator(),
          // );
          if (snapshot.hasData && !snapshot.hasError) {
            var event = snapshot.data as DatabaseEvent;
            var snapshot2 = event.snapshot.value as dynamic;
            if (snapshot2 == null) {
              return const Center(
                child: Text('No Team Added Yet'),
              );
            }
            Map<String, dynamic> map = Map<String, dynamic>.from(snapshot2);
            var teams = <TeamModel>[];

            for (var teamMap in map.values) {
              TeamModel teamModel =
                  TeamModel.fromMap(Map<String, dynamic>.from(teamMap));
              teams.add(teamModel);
            }

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: teams.length,
                  itemBuilder: (context, index) {
                    TeamModel team = teams[index];
                    final List<String> members = teams[index].teamMembers;
                    return Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                          border: Border.all(
                        color: Colors.black,
                        width: 2,
                      )),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('ID: ${team.teamId}'),
                            Text('Name: ${team.teamName}'),
                            Text('Leader:  ${team.teamLeader}'),
                            const Text('Members: '),
                            ListView.builder(
                                shrinkWrap: true,
                                primary: false,
                                itemBuilder: (_, index) {
                                  return Center(
                                      child: Text(team.teamMembers[index]));
                                },
                                itemCount: team.teamMembers.length),
                            //Text(team.teamMembers[0]),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (ctx) {
                                          return AlertDialog(
                                            title:
                                                const Text('Confirmation !!!'),
                                            content: const Text(
                                                'Are you sure to delete ?'),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.of(ctx).pop();
                                                  },
                                                  child: const Text('No')),
                                              TextButton(
                                                  onPressed: () async {
                                                    if (teamRef != null) {
                                                      await teamRef!
                                                          .child(team.teamId)
                                                          .remove();
                                                    }
                                                    Navigator.of(ctx).pop();
                                                  },
                                                  child: const Text('Yes'))
                                            ],
                                          );
                                        });
                                  },
                                  icon: const Icon(Icons.delete),
                                ),
                                IconButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) {
                                      return UpdateTeamScreen(teamModel: team);
                                    }));
                                  },
                                  icon: const Icon(Icons.edit),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
