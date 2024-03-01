library snippetcoder_utils;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

enum ImagePickSource {
  /// Opens up the device camera, letting the user to take a new picture.
  camera,

  /// Opens the user's photo gallery.
  gallery,

  // Show Both Options
  both,
}

enum ImageType {
  grid,

  list,

  single,
}

class ImageUploadModel {
  bool isUploaded;
  bool uploading;
  String imageFile;
  String? imageUrl;

  ImageUploadModel({
    required this.isUploaded,
    required this.uploading,
    required this.imageFile,
    this.imageUrl,
  });
}

class MultiImagePicker extends StatefulWidget {
  const MultiImagePicker({
    required this.totalImages,
    required this.onImageChanged,
    this.initialValue,
    this.imageSource = ImagePickSource.gallery,
    this.imageType = ImageType.grid,
    this.addImageWidget,
    this.gridCrossAxisCount = 2,
    this.gridChildAspectRatio = 0.7,
    this.onImageRemoved,
    this.imgWidth = 100,
    this.imgHeight = 100,
  });

  final int totalImages;
  final ValueChanged<dynamic> onImageChanged;
  final List<String>? initialValue;
  final ImagePickSource imageSource;
  final ImageType imageType;
  final Widget? addImageWidget;
  final int gridCrossAxisCount;
  final double gridChildAspectRatio;
  final ValueChanged<dynamic>? onImageRemoved;
  final double imgWidth;
  final double imgHeight;

  @override
  _MultiImagePickerState createState() => _MultiImagePickerState();
}

class _MultiImagePickerState extends State<MultiImagePicker> {
  List<Object> images = List<Object>.empty(growable: true);
  late Future<XFile?> _imageFile;

  @override
  void initState() {
    super.initState();

    for (var i = 0; i < this.widget.totalImages; i++) {
      images.add("Add Image");
    }

    if (this.widget.initialValue!.length > 0) {
      for (var i = 0; i < this.widget.initialValue!.length; i++) {
        ImageUploadModel imageUpload = new ImageUploadModel(
          isUploaded: false,
          uploading: false,
          imageFile: '',
          imageUrl: this.widget.initialValue![i],
        );

        images.replaceRange(i, i + 1, [imageUpload]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (this.widget.imageType == ImageType.grid) {
      return buildGridView();
    } else if (this.widget.imageType == ImageType.list) {
      return buildListView();
    } else {
      return buildSingle();
    }
  }

  Widget buildGridView() {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: this.widget.gridCrossAxisCount,
      childAspectRatio: this.widget.gridChildAspectRatio,
      physics: const NeverScrollableScrollPhysics(),
      children: List.generate(images.length, (index) {
        if (images[index] is ImageUploadModel) {
          ImageUploadModel uploadModel = images[index] as ImageUploadModel;
          return uploadModel.imageFile == "" && uploadModel.imageUrl == ""
              ? GestureDetector(
                  child: widget.addImageWidget == null
                      ? IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            this.widget.imageSource == ImagePickSource.both
                                ? _onAddImagePicker(index)
                                : _onAddImageClick(index);
                          },
                        )
                      : widget.addImageWidget,
                  onTap: () {
                    this.widget.imageSource == ImagePickSource.both
                        ? _onAddImagePicker(index)
                        : _onAddImageClick(index);
                  },
                )
              : SizedBox(
                  height: 120,
                  child: Stack(
                    children: <Widget>[
                      uploadModel.imageUrl == null
                          ? Image.file(
                              File(uploadModel.imageFile),
                              width: widget.imgWidth,
                              height: widget.imgHeight,
                            )
                          : Image.network(
                              uploadModel.imageUrl ?? "",
                              width: widget.imgWidth,
                              height: widget.imgHeight,
                            ),
                      Positioned(
                        right: 5,
                        top: 5,
                        child: InkWell(
                          child: Icon(
                            Icons.remove_circle,
                            size: 20,
                            color: Colors.red,
                          ),
                          onTap: () {
                            setState(() {
                              images.replaceRange(
                                  index, index + 1, ['Add Image']);
                              _handleChanged();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                );
        } else {
          return GestureDetector(
            child: widget.addImageWidget == null
                ? IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      this.widget.imageSource == ImagePickSource.both
                          ? _onAddImagePicker(index)
                          : _onAddImageClick(index);
                    },
                  )
                : widget.addImageWidget,
            onTap: () {
              this.widget.imageSource == ImagePickSource.both
                  ? _onAddImagePicker(index)
                  : _onAddImageClick(index);
            },
          );
          // return Card(
          //   child: IconButton(
          //     icon: Icon(Icons.add),
          //     onPressed: () {
          //       this.widget.imageSource == ImagePickSource.both
          //           ? _onAddImagePicker(index)
          //           : _onAddImageClick(index);
          //     },
          //   ),
          // );
        }
      }),
    );
  }

  Widget buildSingle() {
    if (images[0] is ImageUploadModel) {
      ImageUploadModel uploadModel = images[0] as ImageUploadModel;
      return uploadModel.imageFile == "" && uploadModel.imageUrl == ""
          ? GestureDetector(
              child: widget.addImageWidget,
              onTap: () {
                this.widget.imageSource == ImagePickSource.both
                    ? _onAddImagePicker(0)
                    : _onAddImageClick(0);
              },
            )
          : Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.15),
                        blurRadius: 5,
                        spreadRadius: 5,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: uploadModel.imageUrl == null
                        ? Image.file(
                            File(uploadModel.imageFile),
                            width: widget.imgWidth,
                            height: widget.imgHeight,
                            fit: BoxFit.fitWidth,
                          )
                        : Image.network(
                            uploadModel.imageUrl ?? "",
                            width: widget.imgWidth,
                            height: widget.imgHeight,
                            fit: BoxFit.fitWidth,
                          ),
                  ),
                ),
                Positioned(
                  right: 5,
                  top: 5,
                  child: InkWell(
                    child: Icon(
                      Icons.remove_circle,
                      size: 20,
                      color: Colors.red,
                    ),
                    onTap: () {
                      setState(() {
                        images.replaceRange(0, 1, ['Add Image']);
                        _handleChanged();
                      });
                    },
                  ),
                ),
              ],
            );
    } else {
      return GestureDetector(
        child: widget.addImageWidget,
        onTap: () {
          this.widget.imageSource == ImagePickSource.both
              ? _onAddImagePicker(0)
              : _onAddImageClick(0);
        },
      );
      // return Card(
      //   child: IconButton(
      //     icon: Icon(Icons.add),
      //     onPressed: () {
      //       this.widget.imageSource == ImagePickSource.both
      //           ? _onAddImagePicker(index)
      //           : _onAddImageClick(index);
      //     },
      //   ),
      // );
    }
  }

  Widget buildListView() {
    return ListView.builder(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        itemBuilder: (context, index) {
          if (images[index] is ImageUploadModel) {
            ImageUploadModel uploadModel = images[index] as ImageUploadModel;
            return uploadModel.imageFile == "" && uploadModel.imageUrl == ""
                ? GestureDetector(
                    child: widget.addImageWidget,
                    onTap: () {
                      this.widget.imageSource == ImagePickSource.both
                          ? _onAddImagePicker(index)
                          : _onAddImageClick(index);
                    },
                  )
                : Card(
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      children: <Widget>[
                        uploadModel.imageUrl == null
                            ? Image.file(
                                File(uploadModel.imageFile),
                                width: widget.imgWidth,
                                height: widget.imgHeight,
                              )
                            : Image.network(
                                uploadModel.imageUrl ?? "",
                                width: widget.imgWidth,
                                height: widget.imgHeight,
                              ),
                        Positioned(
                          right: 5,
                          top: 5,
                          child: InkWell(
                            child: Icon(
                              Icons.remove_circle,
                              size: 20,
                              color: Colors.red,
                            ),
                            onTap: () {
                              setState(() {
                                images.replaceRange(
                                    index, index + 1, ['Add Image']);
                                _handleChanged();
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  );
          } else {
            return GestureDetector(
              child: widget.addImageWidget,
              onTap: () {
                this.widget.imageSource == ImagePickSource.both
                    ? _onAddImagePicker(index)
                    : _onAddImageClick(index);
              },
            );
            // return Card(
            //   child: IconButton(
            //     icon: Icon(Icons.add),
            //     onPressed: () {
            //       this.widget.imageSource == ImagePickSource.both
            //           ? _onAddImagePicker(index)
            //           : _onAddImageClick(index);
            //     },
            //   ),
            // );
          }
        });
  }

  Future _onAddImageClick(int index) async {
    ImagePicker _picker = new ImagePicker();
    setState(() {
      _imageFile = _picker.pickImage(
        source: this.widget.imageSource == ImagePickSource.gallery
            ? ImageSource.gallery
            : ImageSource.camera,
      );
      getFileImage(index);
    });
  }

  _onAddImagePicker(int index) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: new Icon(Icons.photo),
              title: new Text('Gallery'),
              onTap: () {
                Navigator.pop(context);
                ImagePicker _picker = new ImagePicker();
                setState(() {
                  _imageFile = _picker.pickImage(
                    source: ImageSource.gallery,
                  );
                  getFileImage(index);
                });
              },
            ),
            ListTile(
              leading: new Icon(Icons.music_note),
              title: new Text('Camera'),
              onTap: () {
                Navigator.pop(context);
                ImagePicker _picker = new ImagePicker();
                setState(() {
                  _imageFile = _picker.pickImage(
                    source: ImageSource.camera,
                  );
                  getFileImage(index);
                });
              },
            ),
          ],
        );
      },
    );
  }

  void getFileImage(int index) async {
    _imageFile.then((file) async {
      if (file != null) {
        setState(() {
          ImageUploadModel imageUpload = new ImageUploadModel(
            isUploaded: false,
            uploading: false,
            imageFile: file.path,
            imageUrl: null,
          );

          images.replaceRange(index, index + 1, [imageUpload]);

          _handleChanged();
        });
      }
    });
  }

  void _handleChanged() {
    widget.onImageChanged(images);
  }
}
