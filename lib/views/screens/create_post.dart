import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:mongo_dart/mongo_dart.dart' as m;
import '../../models/post.dart';
import '../../services/adoptionPostService.dart';
import '../../services/lostPostService.dart';
import '../../util/alerts.dart';
import '../../util/connection.dart';
import '../../util/const.dart';
import '../../util/view_image_handler.dart';

class CreatePost extends StatefulWidget {
  final int postType;

  const CreatePost({Key key, this.postType}) : super(key: key);

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  /// Variables
  List<File> _postImages = [];
  final _titleField = TextEditingController();
  final _contentField = TextEditingController();
  bool _loadindicador = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => !_loadindicador,
      child: IgnorePointer(
        ignoring: _loadindicador,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(
                color: Theme.of(context).textTheme.headline6.color,
              ),
              backgroundColor: Theme.of(context).primaryColor,
              title: Container(
                  margin: EdgeInsets.only(top: 15, bottom: 10),
                  child: MediaQuery.of(context).platformBrightness ==
                          Brightness.dark
                      ? Image.asset(
                          '${Constants.logoWhite}',
                          height: 120,
                        )
                      : Image.asset(
                          '${Constants.logoBlack}',
                          height: 120,
                        )),
              centerTitle: true,
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.check),
                  onPressed: () {
                    //Publicar post
                    insertPost();
                  },
                )
              ],
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _loadindicador
                        ? LinearProgressIndicator()
                        : Container(height: 4),
                    TextField(
                      controller: _titleField,
                      decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color:
                                  Theme.of(context).textTheme.headline6.color,
                              width: 1.0,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color:
                                  Theme.of(context).textTheme.headline6.color,
                            ),
                          ),
                          border: InputBorder.none,
                          hintText: 'Título',
                          hintStyle: TextStyle(
                              color:
                                  Theme.of(context).textTheme.headline6.color)),
                      style: TextStyle(
                          color: Theme.of(context).textTheme.headline6.color,
                          fontSize: 26,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 150,
                      child: TextField(
                          controller: _contentField,
                          decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                  width: 1.0,
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                ),
                              ),
                              border: InputBorder.none,
                              hintText: 'Contenido',
                              hintStyle: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      .color)),
                          style: TextStyle(
                            color: Theme.of(context).textTheme.headline6.color,
                          ),
                          minLines: null,
                          maxLines: null,
                          keyboardType: TextInputType.multiline),
                    ),
                    Divider(
                      thickness: 1,
                    ),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      primary: false,
                      padding: EdgeInsets.all(5),
                      itemCount: _postImages.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 200 / 200,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: EdgeInsets.all(1.0),
                          child: Stack(fit: StackFit.expand, children: <Widget>[
                            ImageFullScreenWrapperWidget(
                              dark: true,
                              child: Image.file(
                                _postImages[index],
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              right: -6,
                              top: -6,
                              child: CircleAvatar(
                                radius: 18,
                                backgroundColor: Colors.black.withOpacity(0.5),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    size: 18,
                                    color: Theme.of(context)
                                        .textTheme
                                        .headline6
                                        .color,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _postImages.removeAt(index);
                                    });
                                  },
                                ),
                              ),
                            )
                          ]),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Divider(
                    thickness: 1,
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.photo_size_select_actual_outlined,
                          color: Theme.of(context).textTheme.headline6.color,
                        ),
                        onPressed: () {
                          // do something
                          _getFromGallery();
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.camera_alt_outlined,
                          color: Theme.of(context).textTheme.headline6.color,
                        ),
                        onPressed: () {
                          // do something
                          _getFromCamera();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Get from gallery
  _getFromGallery() async {
    XFile pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 25,
    );
    if (pickedFile != null) {
      setState(() {
        _postImages.add(File(pickedFile.path));
      });
    }
  }

  /// Get from Camera
  _getFromCamera() async {
    XFile pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 25,
    );
    if (pickedFile != null) {
      setState(() {
        _postImages.add(File(pickedFile.path));
      });
    }
  }

  Future<List<String>> _uploadToFirebase(String pathName) async {
    if (_postImages.isNotEmpty) {
      try {
        if (await hasNetwork()) {
          List<String> data = [];
          for (var i = 0; i < _postImages.length; i++) {
            // Upload file and metadata to the path 'images/{id}/{index}.jpg'
            final uploadTask =
                FirebaseStorage.instance.ref().child('images/$pathName/$i');
            await uploadTask.putFile(_postImages[i]);
            String url = await uploadTask.getDownloadURL();
            data.add(url);
          }

          return data;
        } else {
          throw ('Internet error');
        }
      } catch (e) {
        return Future.error(e);
      }
    }
    return null;
  }

  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value)));
  }

  insertPost() async {
    if (_titleField.text.isEmpty ||
        _contentField.text.isEmpty ||
        _postImages.isEmpty) {
      showInSnackBar(
          'Es necesario establecer un título, contenido y al menos una imagen para hacer la publicación.');
    } else {
      try {
        _loadindicador = true;
        setState(() {});
        var id = m.ObjectId();

        final post = Post(
            id: id,
            images: await _uploadToFirebase(id.$oid),
            title: _titleField.text,
            description: _contentField.text,
            publishedDate: DateTime.now(),
            userId: FirebaseAuth.instance.currentUser.uid);

        if (widget.postType == 0) {
          await AdoptionPostDB.insert(post);
        } else if (widget.postType == 1) {
          await LostPostDB.insert(post);
        }
        Navigator.of(context).pop();
      } catch (e) {
        _loadindicador = false;
        if (e == ("Internet error")) {
          showAlertDialog(context, 'Problema de conexión',
              'Compruebe si existe conexión a internet e inténtale más tarde.');
        } else {
          showAlertDialog(context, 'Problema con el servidor',
              'Es posible que alguno de los servicios no esté funcionando correctamente. Recomendamos que vuelva a intentarlo más tarde.');
        }
        setState(() {});
      }
    }
  }
}
