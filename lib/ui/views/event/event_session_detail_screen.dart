import 'dart:math';
import 'package:flutter/material.dart';
import 'package:event_any_where_app/core/constants/app_routers.dart';
import 'package:event_any_where_app/models/session_model.dart';
import 'package:event_any_where_app/core/theme/my_theme.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';
import 'package:event_any_where_app/repositories/test livestream/keys.dart';
import 'package:intl/intl.dart';

class SessionDetailScreen extends StatefulWidget {
  final Session session;

  SessionDetailScreen({required this.session});

  @override
  State<SessionDetailScreen> createState() => _SessionDetailScreenState();
}

class _SessionDetailScreenState extends State<SessionDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();

  bool isHostButton = false;
  String username = "";

  List<String> comments = [];

  String formatEventTime(String date) {
    DateTime dateTime = DateTime.parse(date);
    String formattedTime = DateFormat('hh:mm a').format(dateTime);

    return formattedTime;
  }

  @override
  void initState() {
    super.initState();
    ZegoUIKit().getInRoomMessageStream().listen((ZegoInRoomMessage message) {
      final comment = '${message.message}';
      comments.add(comment);
      print(comment);
    });
    _loadPreference();
  }

  Future<void> _loadPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isHostButton = prefs.getBool('activeSpeaker') ?? false;
      username = prefs.getString('name') ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      backgroundColor: MyTheme.backgroundcolor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            context.pop();
          },
        ),
        title: Text(
          'Session Detail',
          style: AppTextStyles.appbarText,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.session.title, style: AppTextStyles.heading),
              SizedBox(height: 16),
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    color: MyTheme.primaryColor,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    '${formatEventTime(widget.session.startTime)} - ${formatEventTime(widget.session.endTime)}',
                    style: TextStyle(color: MyTheme.grey),
                  ),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    color: MyTheme.primaryColor,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    '${widget.session.location}',
                    style: TextStyle(color: MyTheme.grey),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                widget.session.description,
                style: AppTextStyles.description,
              ),
              SizedBox(height: 16),
              Text('Speakers:', style: TextStyle(fontWeight: FontWeight.bold)),
              Column(
                children: widget.session.sessionSpeakers.map((speaker) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(speaker.profileImageUrl),
                    ),
                    title: Text(
                      speaker.name,
                      style: AppTextStyles.subheading,
                    ),
                    subtitle: Text(
                      speaker.position,
                      style: AppTextStyles.body,
                    ),
                  );
                }).toList(),
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Offstage(
                        offstage: true,
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: 'LiveStreamID',
                            hintStyle: TextStyle(
                              color: Colors.grey.withOpacity(0.5),
                            ),
                          ),
                          controller: _idController..text = widget.session.id,
                          style: AppTextStyles.description,
                          enabled: false,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            'Speaker: ',
                            style: AppTextStyles.subheading,
                          ),
                          Switch(
                            activeColor: MyTheme.white,
                            activeTrackColor: MyTheme.primaryColor,
                            value: isHostButton,
                            onChanged: null,
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: MyTheme.primaryColor,
        shape: CircleBorder(),
        child: Text(
          'Join',
          style: AppTextStyles.subheading,
        ),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => LivePage(
                    uuserName: username,
                    liveID: _idController.text.toString(),
                    isHost: isHostButton,
                  )));
        },
      ),
    );
  }
}

class LivePage extends StatelessWidget {
  final String liveID;
  final String uuserName;
  final bool isHost;

  const LivePage(
      {Key? key,
      required this.liveID,
      this.isHost = false,
      required this.uuserName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ZegoUIKitPrebuiltLiveStreaming(
        appID: appId,
        appSign: appSign,
        userID: 'user_id' + Random().nextInt(100).toString(),
        userName: uuserName,
        liveID: liveID,
        config: isHost
            ? ZegoUIKitPrebuiltLiveStreamingConfig.host()
            : ZegoUIKitPrebuiltLiveStreamingConfig.audience(),
      ),
    );
  }
}
