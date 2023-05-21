import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_auth/constants/constant.dart';
import 'package:http/http.dart' as http;

import 'model.dart';

class ChatRoomPage extends StatefulWidget {
  const ChatRoomPage({Key? key}) : super(key: key);

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  late bool isLoading;
  final TextEditingController _textController = TextEditingController();
  final _scrollController = ScrollController();
  final List<ChatMessage> _message = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoading = false;
  }

  Future<String> generateResponse(String prompt) async {
    final api_key = apiSecretKey;
    var url = Uri.https("api.openai.com", "/v1/completions");
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $api_key'
      },
      body: json.encode({
        "model": "text-davinci-003",
        "prompt": prompt,
        'temperature': 0,
        'max_tokens': 2000,
        'top_p': 1,
        'frequency_penalty': 0.0,
        'presence_penalty': 0.0,
      }),
    );
    //decode the reponse
    Map<String, dynamic> newresponse = jsonDecode(response.body);
    return newresponse['choices'][0]['text'];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 10,
          shadowColor: Colors.amber,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
          toolbarHeight: 80,
          title: const Padding(
            padding: EdgeInsets.all(25.0),
            child: Text(
              " Interactive Bot...!!",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.5),
              maxLines: 2,
              textAlign: TextAlign.center,
            ),
          ),
          backgroundColor: Colors.green.shade600,
        ),
        backgroundColor: Colors.white,
        body: Column(
          children: [
            //chat body
            Expanded(
              child: _buildList(),
            ),
            Visibility(
              visible: !isLoading,
              child: Padding(
                padding: EdgeInsets.all(5.0),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 13.0),
              margin: EdgeInsets.only(left: 12, right: 12, top: 0, bottom: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(13),
                ),
                color: Colors.green.shade700,
              ),
              // color: Colors.green.shade600,
              child: Row(
                children: [
                  _buildInput(),
                  _buildSubmit(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Expanded _buildInput() {
    return Expanded(
      child: TextField(
        textCapitalization: TextCapitalization.sentences,
        controller: _textController,
        decoration: InputDecoration(
          fillColor: Colors.green.shade200,
          filled: true,
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildSubmit() {
    return Visibility(
      visible: !isLoading,
      child: Container(
        child: IconButton(
          icon: Icon(
            Icons.send_rounded,
            color: Colors.green.shade900,
            size: 30,
          ),
          onPressed: () {
            //display user input
            setState(() {
              _message.add(ChatMessage(
                  text: _textController.text,
                  chatMessageType: ChatMessageType.user));
              isLoading = true;
            });
            var input = _textController.text;
            _textController.clear();
            Future.delayed(Duration(microseconds: 50))
                .then((value) => _scrollDown());
            //call chatbot api
            generateResponse(input).then((value) {
              setState(() {
                isLoading = false;
                //display chatbot response
                _message.add(ChatMessage(
                    text: value, chatMessageType: ChatMessageType.bot));
              });
            });
            _textController.clear();
            Future.delayed(Duration(milliseconds: 50))
                .then((value) => _scrollDown());
          },
        ),
      ),
    );
  }

  void _scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(microseconds: 300),
      curve: Curves.easeOut,
    );
  }

  ListView _buildList() {
    return ListView.builder(
      itemCount: _message.length,
      controller: _scrollController,
      itemBuilder: ((context, index) {
        var message = _message[index];
        return ChatMessageWidget(
          text: message.text,
          chatMessageType: message.chatMessageType,
        );
      }),
    );
  }
}

class ChatMessageWidget extends StatelessWidget {
  final String text;
  final ChatMessageType chatMessageType;
  const ChatMessageWidget(
      {Key? key, required this.text, required this.chatMessageType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          chatMessageType == ChatMessageType.bot
              ? Container(
                  margin: EdgeInsets.only(right: 5.0),
                  child: CircleAvatar(
                    backgroundColor: const Color.fromRGBO(67, 160, 71, 1),
                    child: Icon(
                      Icons.ac_unit,
                      size: 35,
                    ),
                  ),
                )
              : Container(
                  margin: EdgeInsets.only(right: 8.0, bottom: 2),
                  child: const CircleAvatar(
                    backgroundColor: const Color.fromRGBO(67, 160, 71, 1),
                    child: Icon(
                      Icons.person,
                      size: 35,
                      color: Colors.white,
                    ),
                  ),
                ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 20.0, top: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                  child: Text(
                    text,
                    // style: TextStyle(fontSize: 20, color: Colors.white,  ),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.black,
                          fontSize: 19,
                          fontWeight: FontWeight.w400,
                        ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
