// ignore_for_file: avoid_print, prefer_const_constructors, non_constant_identifier_names, unused_local_variable, unnecessary_null_comparison, prefer_if_null_operators, avoid_function_literals_in_foreach_calls, unnecessary_string_interpolations, curly_braces_in_flow_control_structures, unnecessary_brace_in_string_interps

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:socialapp/model/LikesModel.dart';

import '../../../Widgets.dart';
import '../../../constants/variables.dart';
import '../../../helper/DioHelper.dart';
import '../../../helper/endPoints.dart';
import '../../../layout/BottomNaviBar.dart';
import '../../../main.dart';
import '../../../model/CommentsModel.dart';
import '../../../model/CreatePost.dart';
import '../../../model/LikesAndCommentsNotifications.dart';
import '../../../model/MessagesModel.dart';
import '../../../model/UserModel.dart';
import '../../../view/BottomNaviScreens/ChatsScreen.dart';
import '../../../view/BottomNaviScreens/FeedsScreen.dart';
import '../../../view/BottomNaviScreens/NewPostScreen.dart';
import '../../../view/BottomNaviScreens/SettingsScreen.dart';
import '../../../view/BottomNaviScreens/UsersScreen.dart';

part 'social_state.dart';

class SocialCubit extends Cubit<SocialState> {
  SocialCubit() : super(SocialInitial());
  static SocialCubit get(context) => BlocProvider.of(context);

  MessageModel? replayMessage; // Updated to handle replayMessage
  final advancedDrawerController = AdvancedDrawerController();
  void handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    advancedDrawerController.showDrawer();
  }

  void closeDrawer() {
    advancedDrawerController.hideDrawer();
  }

  void changeReplayStatus({required MessageModel message}) {
    replayMessage = message;
    emit(SocialRessetReplayStatusSuccessState());
  }

  void cancelReplay() {
    replayMessage = null;
    emit(SocialCancelReplayStatusSuccessState());
  }

  bool scrollToBottom = false;
  void ResetScrollController() {
    scrollToBottom = true;
    emit(SocialResetScrollController());
  }

  bool isProfilePhotoExpanded = false;
  void toggleProfilePhoto() {
    isProfilePhotoExpanded = !isProfilePhotoExpanded;
    emit(SocialToggleProfilePhotostate());
  }

  void returnPhotoDefault() {
    isProfilePhotoExpanded = false;
    emit(SocialToggleProfilePhotostate());
  }

  UserModel? model;
  dynamic getUserData() async {
    emit(SocialGetUserLoadingState());
    try {
      final userData =
          await FirebaseFirestore.instance.collection("users").doc(uid).get();
      if (userData.exists) {
        final data = userData.data() as Map<String, dynamic>;
        model = UserModel.fromMap(data);
        emit(SocialGetUserSuccessState());
      } else {
        emit(SocialGetUserErrorState(error: "User not found"));
      }
    } catch (error) {
      print(error);
      emit(SocialGetUserErrorState(error: error.toString()));
    }
  }

  List<CreatePostModel> posts = [];
  List<String> postId = [];
  List<int> Likes = [];
  List<int> Comments = [];

  void getPosts() {
    FirebaseFirestore.instance
        .collection("posts")
        .orderBy("datetime", descending: true)
        .snapshots()
        .listen((value) {
      final newPosts = <CreatePostModel>[];
      final newComments = <int>[];
      final newLikes = <int>[];
      final newPostIds = <String>[];

      value.docs.forEach((element) {
        final postId = element.id;
        final postRef = element.reference;

        // Listen for changes in the likes collection
        final likesRef = postRef.collection('likes');
        likesRef.snapshots().listen((likesValue) {
          bool isLiked = likesValue.docs.any((doc) => doc.id == model?.uid);

          // Listen for changes in the comments collection
          final commentsRef = postRef.collection('comments');
          commentsRef.orderBy('dateTime').snapshots().listen((commentsValue) {
            int commentsCount = commentsValue.docs.length;
            int likesCount = likesValue.docs.length;
            bool isPostLiked = likesValue.docs.any(
              (like) => like.id == model?.uid && like.data()['like'] == true,
            );

            int index = newPostIds.indexOf(postId);
            if (index != -1) {
              // Update the existing post in the list
              newComments[index] = commentsCount;
              newLikes[index] = likesCount;
              newPosts[index] = CreatePostModel.fromMap(element.data())
                ..isLiked = isPostLiked;
            } else {
              // Add the new post to the lists
              newComments.add(commentsCount);
              newLikes.add(likesCount);
              newPostIds.add(postId);
              newPosts.add(CreatePostModel.fromMap(element.data())
                ..isLiked = isPostLiked);
            }

            emit(SocialGetpostsSuccessState());
          });
        });
      });

      // Update the lists with the new data
      Comments = newComments;
      Likes = newLikes;
      postId = newPostIds;
      posts = newPosts;
    });
  }

  Future<void> refreshPosts() async {
    getPosts();
    emit(SocialRefreshingState());
  }
  // bool isLike = false;

  // void changeLikeStatus() {
  //   isLike = !isLike;
  //   emit(SocialChangeLikeStatusstate());
  // }
  List<UserModel> getallUsers = [];
  void getAllUsers() {
    // Fetch the list of users
    FirebaseFirestore.instance
        .collection("users")
        .orderBy("dateTime", descending: true)
        .get()
        .then((querySnapshot) {
      getallUsers = [];

      querySnapshot.docs.forEach((document) {
        print(document.data());
        if (document.data()["uid"] != model?.uid) {
          getallUsers.add(UserModel.fromMap(document.data()));
        }
      });
      emit(SocialGetAllUsersSuccessState());
    }).catchError((error) {
      emit(SocialGetAllUsersErrorState(error: error));
    });
  }

  void addLikes({
    required String postId,
    required CreatePostModel postModel,
  }) {
    FirebaseFirestore.instance
        .collection("posts")
        .doc(postId)
        .collection("likes")
        .doc(model?.uid)
        .set({'like': true}).then((value) {
      // Update the local post model to reflect that the user has liked it
      postModel.isLiked = true;
      emit(SocialLikePostSuccesState());
    }).catchError((error) {
      print(error.toString());
      emit(SocialLikePostErrorState(error: error.toString()));
    });
  }

  void removeLike({
    required String postId,
    required CreatePostModel postModel,
  }) {
    FirebaseFirestore.instance
        .collection("posts")
        .doc(postId)
        .collection("likes")
        .doc(model?.uid)
        .delete()
        .then((value) {
      // Update the local post model to reflect that the user has unliked it
      postModel.isLiked = false;
      emit(SocialRemoveLikeSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(SocialRemoveLikeErrorState(error: error.toString()));
    });
  }

  void removeLikesss({
    required String postId,
    required CreatePostModel postModel,
  }) {
    FirebaseFirestore.instance
        .collection("posts")
        .doc(postId)
        .collection("likes")
        .doc(model?.uid)
        .delete()
        .then((value) {
      // Update the local post model to reflect that the user has unliked it
      postModel.isLiked = false;
      emit(SocialRemoveLikeSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(SocialRemoveLikeErrorState(error: error.toString()));
    });
  }

  List<LikesAndCommentsNotifications>? likesAndCommentsNotifications = [];
  Stream<List<LikesAndCommentsNotifications>> getlikesAndCommentsNotifications(
      {required String UID}) {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(UID)
        .collection("notifications")
        .orderBy("dateTime", descending: true)
        .snapshots()
        .map((querySnapshot) {
      likesAndCommentsNotifications = [];
      querySnapshot.docs.forEach((document) {
        likesAndCommentsNotifications
            ?.add(LikesAndCommentsNotifications.fromMap(document.data()));
      });
      return likesAndCommentsNotifications
          as List<LikesAndCommentsNotifications>;
    });
  }

  void addLikesss({
    required String postId,
    required String timestamp,
    required CreatePostModel postModel,
  }) {
    String LikesAndcommentsNotificationsId =
        FirebaseFirestore.instance.collection("notifications").doc().id;
    LikesModel Likesmodel = LikesModel(
      postId: postId,
      uid: model!.uid,
      name: model!.name,
      like: true,
      image: model!.image,
      cover: model!.cover,
      bio: model!.bio,
      email: model!.email,
      password: model!.password,
      phone: model!.phone,
      tokenDevice: model!.tokenDevice,
      dateTime: timestamp,
    );
    LikesAndCommentsNotifications likesAndCommentsNotifications =
        LikesAndCommentsNotifications(
            postId: postId,
            uid: model!.uid,
            notificatoinId: LikesAndcommentsNotificationsId,
            recevUserId: postModel.uid,
            name: model!.name,
            like: true,
            image: model!.image,
            cover: model!.cover,
            bio: model!.bio,
            email: model!.email,
            password: model!.password,
            phone: model!.phone,
            dateTime: timestamp,
            type: "like",
            commetText: "",
            text: postModel.text ?? "",
            postImage: postModel.postImage ?? "");
    FirebaseFirestore.instance
        .collection("posts")
        .doc(postId)
        .collection("likes")
        .doc(model?.uid)
        .set(Likesmodel.toMap())
        .then((value) {
      postModel.isLiked = true;
      FirebaseFirestore.instance
          .collection("users")
          .doc(postModel.uid)
          .collection("notifications")
          .doc(LikesAndcommentsNotificationsId)
          .set(likesAndCommentsNotifications.toMap());
      if (likesAndCommentsNotifications.recevUserId != model?.uid) {
        FirebaseFirestore.instance
            .collection("users")
            .doc(likesAndCommentsNotifications.recevUserId)
            .update({
          'unreadNotification.${likesAndCommentsNotifications.recevUserId}':
              FieldValue.increment(1)
        });
      }
      emit(SocialLikePostSuccesState());
    }).catchError((error) {
      print(error.toString());

      emit(SocialLikePostErrorState(error: error.toString()));
    });
  }

  List<LikesModel>? Likesmodel = [];
  Stream<List<LikesModel>> getLikes(String postId) {
    print("Fetching Likes for postId: $postId"); // Debug log
    return FirebaseFirestore.instance
        .collection("posts")
        .doc(postId)
        .collection("likes")
        .orderBy("dateTime", descending: true)
        .snapshots()
        .map((querySnapshot) {
      Likesmodel = [];
      querySnapshot.docs.forEach((document) {
        Likesmodel?.add(LikesModel.fromMap(document.data()));
      });
      return Likesmodel as List<LikesModel>;
    });
  }

  void addComments(
      {required String postId,
      required String commentText,
      required String timestamp,
      required CreatePostModel postModel}) {
    String LikesAndcommentsNotificationsId =
        FirebaseFirestore.instance.collection("notifications").doc().id;
    String commentsId = FirebaseFirestore.instance.collection("posts").doc().id;
    CommentsModel comment = CommentsModel(
        postId: postId,
        uid: model!.uid,
        CommentsId: commentsId,
        image: model!.image,
        name: model!.name,
        text: commentText,
        dateTime: timestamp,
        bio: model!.bio,
        cover: model!.cover,
        email: model!.email,
        password: model!.password,
        tokenDevice: model!.tokenDevice,
        phone: model!.phone);

    LikesAndCommentsNotifications likesAndCommentsNotifications =
        LikesAndCommentsNotifications(
            postId: postId,
            uid: model!.uid,
            notificatoinId: LikesAndcommentsNotificationsId,
            recevUserId: postModel.uid,
            name: model!.name,
            like: true,
            image: model!.image,
            cover: model!.cover,
            bio: model!.bio,
            email: model!.email,
            password: model!.password,
            phone: model!.phone,
            dateTime: timestamp,
            type: "comment",
            commetText: commentText,
            text: postModel.text ?? "",
            postImage: postModel.postImage ?? "");
    FirebaseFirestore.instance
        .collection("posts")
        .doc(postId)
        .collection("comments")
        .doc(commentsId)
        .set(comment.toMap())
        .then((value) {
      FirebaseFirestore.instance
          .collection("users")
          .doc(postModel.uid)
          .collection("notifications")
          .doc(LikesAndcommentsNotificationsId)
          .set(likesAndCommentsNotifications.toMap());
      if (likesAndCommentsNotifications.recevUserId != model?.uid) {
        FirebaseFirestore.instance
            .collection("users")
            .doc(likesAndCommentsNotifications.recevUserId)
            .update({
          'unreadNotification.${likesAndCommentsNotifications.recevUserId}':
              FieldValue.increment(1)
        });
        print("add comment: postId=$postId, CommentsId=${commentsId}");

        emit(SocialCommentPostSuccesState());
      }
    }).catchError((error) {
      print(error.toString());
      emit(SocialCommentPostErrorState(error: error.toString()));
    });
  }

  void deleteNotification({required notificationId}) {
    emit(DeleteNotificationLoadingStete());
    FirebaseFirestore.instance
        .collection("users")
        .doc(model?.uid)
        .collection("notifications")
        .doc(notificationId)
        .delete()
        .then((value) {
      if (likesAndCommentsNotifications != null) {
        likesAndCommentsNotifications!.removeWhere(
            (notification) => notification.notificatoinId == notificationId);
        emit(SocialDeleteCommentSuccessState());
      }
      emit(DeleteNotificationSuccessStete());
    }).catchError((error) {
      print("the error when delete notification is $error");
      emit(DeleteNotificationErrorStete());
    });
  }

  void deleteAllNotifications() {
    emit(DeleteNotificationLoadingStete());

    // Delete all notifications for the current user
    FirebaseFirestore.instance
        .collection("users")
        .doc(model?.uid)
        .collection("notifications")
        .get()
        .then((querySnapshot) {
      for (final doc in querySnapshot.docs) {
        doc.reference.delete();
      }

      if (likesAndCommentsNotifications != null) {
        likesAndCommentsNotifications!.clear();
      }

      emit(DeleteNotificationSuccessStete());
    }).catchError((error) {
      print("Error when deleting notifications: $error");
      emit(DeleteNotificationErrorStete());
    });
  }

  void deleteComment({
    required String postId,
    required String CommentsId, // Identify comments by their unique ID
  }) {
    print("Deleting comment: postId=$postId, CommentsId=$CommentsId");

    FirebaseFirestore.instance
        .collection("posts")
        .doc(postId)
        .collection("comments")
        .doc(CommentsId) // Use the unique CommentsId to identify the comment
        .delete()
        .then((value) {
      print("Before comment removal: commentss=${commentss!.length}");

      if (commentss != null) {
        commentss!.removeWhere((comment) => comment.CommentsId == CommentsId);
        // Notify the UI of the updated commentss list
        emit(SocialDeleteCommentSuccessState());
      }

      print("After comment removal: commentss=$commentss");

      getComments(postId);
      snackbar(
        type: "Success",
        snackPosition: SnackPosition.TOP,
        color: HexColor("#1B5E20"),
        message: "The comment has been removed successfully ",
      );
      emit(SocialDeleteCommentSuccessState());
    }).catchError((error) {
      snackbar(
        type: "Error",
        snackPosition: SnackPosition.BOTTOM,
        color: HexColor("#990000"),
        message: "Error deleting comment $error",
      );
      print("Error deleting comment: $error");
      emit(SocialDeleteCommentErrorState(error: error.toString()));
    });
  }

  List<CommentsModel>? commentss = [];
  Stream<List<CommentsModel>> getComments(String postId) {
    print("Fetching comments for postId: $postId"); // Debug log

    return FirebaseFirestore.instance
        .collection("posts")
        .doc(postId)
        .collection("comments")
        .orderBy("dateTime", descending: true)
        .snapshots()
        .map((querySnapshot) {
      commentss = [];

      querySnapshot.docs.forEach((document) {
        commentss?.add(CommentsModel.fromMap(document.data()));
      });

      return commentss as List<CommentsModel>;
    });
  }

  int selectedindex = 0;

  List<Widget> pages = [
    FeedsScreen(),
    ChatsScreen(),
    NewPostScreen(),
    NotificationsScreen(),
    SettingsScreen()
  ];
  List<String> titles = ["Home", "Chats", "Posts", "Notification", "Settings"];
  bool changeicon = false;
  void changeIcon() {
    changeicon = !changeicon;
    emit(changeIconState());
  }

  void ChangeIndex(index) {
    if (index == 1) {
      getAllUsers();
    }
    if (index == 2) {
      emit(SocialNewPostState());
    }
    if (index == 3) {
      FirebaseFirestore.instance
          .collection("users")
          .doc(model?.uid)
          .update({'unreadNotification.${model?.uid}': 0});
      selectedindex = index;
      emit(SocialChangeButtomNavState());
    } else {
      selectedindex = index;
      emit(SocialChangeButtomNavState());
    }
  }

  var picker = ImagePicker();
  File? profileimage;
  Future getProfileImage({required String name, required String bio}) async {
    // emit(SocialProfilePicedImageLoadingState());
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileimage = File(pickedFile.path);
      uploadProfileImage(name: name, bio: bio);
      emit(SocialProfilePicedImageSuccesState());
    } else {
      print("No image selected");
      emit(SocialProfilePicedImageErrorState());
    }
  }

  File? Postimage;

  void removeImage() {
    Postimage = null;
    emit(SocialRemoveImageSuccesState());
  }

  File? Chatimage;
  Future getchatImage() async {
    emit(SocialChatPicedImageLoadingState());
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        Chatimage = File(pickedFile.path);
        emit(SocialChatPicedImageSuccesState());
      } else {
        print("No image selected");
        emit(SocialChatPicedImageErrorState());
      }
    } catch (e) {
      print("Error picking image: $e");
      emit(SocialChatPicedImageErrorState());
    }
  }

  void uploadChatImage({
    required String text,
    required String datetime,
    required String receiverId,
  }) {
    emit(SocialUploadImageChatLoadingState());

    firebase_storage.FirebaseStorage.instance
        .ref()
        .child("chats/${Uri.file(Chatimage!.path).pathSegments.last}")
        .putFile(Chatimage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        sendMessage(
            receiverId: receiverId,
            dateTime: datetime,
            text: text,
            image: value);
        // updateUserData(name: name, bio: bio, cover: value);

        print(value);
      }).catchError((error) {
        emit(SocialUploadImageChatErrorState());
      });
    }).catchError((error) {
      emit(SocialUploadImageChatErrorState());
    });
  }

  Future getPostImage() async {
    emit(SocialPostPicedImageLoadingState());
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      Postimage = File(pickedFile.path);
      emit(SocialPostPicedImageSuccesState());
    } else {
      print("No image selected");
      emit(SocialPostPicedImageErrorState());
    }
  }

  File? coverImage;
  Future getcoverImage({required String name, required String bio}) async {
    emit(SocialProfilePicedImageLoadingState());
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      coverImage = File(pickedFile.path);
      uploadCoverImage(name: name, bio: bio);
      emit(SocialCoverPicedImageSuccesState());
    } else {
      print("No image selected");
      emit(SocialCoverPicedImageErrorState());
    }
  }

  //String profileImageUrl = "";
  void uploadProfileImage({
    required String name,
    required String bio,
  }) {
    emit(SocialUpdateUserDetailsLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child("users/${Uri.file(profileimage!.path).pathSegments.last}")
        .putFile(profileimage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        // emit(SocialProfileUploadImageSuccesState());
        // profileImageUrl = value;
        updateUserData(name: name, bio: bio, image: value);
        print(value);
      }).catchError((error) {
        emit(SocialProfileUploadImageErrorState());
      });
    }).catchError((error) {
      emit(SocialProfileUploadImageErrorState());
    });
  }

  //String coverImageUrl = "";
  void uploadCoverImage({
    required String name,
    required String bio,
  }) {
    emit(SocialUpdateUserDetailsLoadingState());

    firebase_storage.FirebaseStorage.instance
        .ref()
        .child("users/${Uri.file(coverImage!.path).pathSegments.last}")
        .putFile(coverImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        // emit(SocialCoverUploadImageSuccesState());
        // coverImageUrl = value;
        updateUserData(name: name, bio: bio, cover: value);
        print(value);
      }).catchError((error) {
        emit(SocialCoverUploadImageErrorState());
      });
    }).catchError((error) {
      emit(SocialCoverUploadImageErrorState());
    });
  }

  void uploadPostImage({
    required String text,
    required String datetime,
  }) {
    emit(SocialCreatePostLoadingState());

    firebase_storage.FirebaseStorage.instance
        .ref()
        .child("posts/${Uri.file(Postimage!.path).pathSegments.last}")
        .putFile(Postimage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        createPost(text: text, postimage: value, datetime: datetime);
        // updateUserData(name: name, bio: bio, cover: value);

        print(value);
      }).catchError((error) {
        emit(SocialCreatePostErrorState());
      });
    }).catchError((error) {
      emit(SocialCreatePostErrorState());
    });
  }

  // void updateUserImages({
  //   required String name,
  //   required String bio,
  // }) {
  // emit(SocialUpdateUserDetailsLoadingState());
  //   if (profileimage != null) {
  //     uploadProfileImage();
  //   } else if (coverImage != null) {
  //     uploadCoverImage();
  //   } else if (profileimage != null && coverImage != null) {
  //     uploadProfileImage();
  //     uploadCoverImage();
  //   } else {
  //     updateUserData(name: name, bio: bio);
  //   }
  // }

  void changePassword({required String newPassword}) {
    emit(SocialUpdatePasswordLoadingState());
    print("Updating password ${newPassword}");
    UserModel modell = UserModel(
      name: model!.name,
      email: model!.email,
      password: newPassword,
      phone: model!.phone,
      image: model!.image,
      bio: model!.bio,
      cover: model!.cover,
      uid: model!.uid,
      tokenDevice: model!.tokenDevice,
      isEmailVarified: false, // Correct the property name
    );
    FirebaseFirestore.instance
        .collection("users")
        .doc(model?.uid) // Use model?.uId as the document ID
        .update(modell.toMap())
        .then((value) async {
      getUserData();
    }).catchError((error) {
      print("Error updating password data: ${error.toString()}");
      emit(SocialUpdatePasswordErrorState());
    });
  }

  void updateUserData(
      {required String name,
      required String bio,
      String? image,
      String? cover}) {
    print("Updating user data: name=$name, bio=$bio, uid=${model?.uid}");
    UserModel modell = UserModel(
      name: name,
      email: model!.email,
      password: model!.password,
      phone: model!.phone,
      image: image ?? model!.image,
      bio: bio,
      cover: cover ?? model!.cover,
      uid: model!.uid,
      tokenDevice: model!.tokenDevice,
      isEmailVarified: false, // Correct the property name
    );

    FirebaseFirestore.instance
        .collection("users")
        .doc(model?.uid) // Use model?.uId as the document ID
        .update(modell.toMap())
        .then((value) {
      updateProfileImageInComments(
          image: image ?? model!.image, name: modell.name);
      updateProfileImageInPosts(
          model!.uid, modell.image, modell.name, modell.cover, modell.bio);
      getUserData();
    }).catchError((error) {
      print("Error updating user data: ${error.toString()}");
      emit(SocialUpdateUserDetailsErrorState());
    });
  }

  // Function to update profile image in user's posts
  void updateProfileImageInPosts(String userId, String newProfileImage,
      String newName, String cover, String bio) {
    FirebaseFirestore.instance
        .collection("posts")
        .where("uid", isEqualTo: userId)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        doc.reference.update({"image": newProfileImage});
        doc.reference.update({"name": newName});
        doc.reference.update({"cover": cover});
        doc.reference.update({"bio": bio});
      });
    }).catchError((error) {
      print("Error updating profile image in posts: ${error.toString()}");
    });
  }

  void updateProfileImageInComments(
      {required String image, required String name}) {
    // Update the profile image in comments of user's posts
    FirebaseFirestore.instance
        .collection("posts")
        .where("uid", isEqualTo: model?.uid)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        FirebaseFirestore.instance
            .collection("posts")
            .doc(doc.id)
            .collection("comments")
            .get()
            .then((commentQuerySnapshot) {
          commentQuerySnapshot.docs.forEach((commentDoc) {
            // Update the profile image field in each comment
            commentDoc.reference.update({"image": image});
            commentDoc.reference.update({"name": name});
          });
        });
      });
    });
  }

  void createPost({
    required String text,
    required String datetime,
    String? postimage,
  }) {
    emit(SocialCreatePostLoadingState());
    print(
        "Updating user data: name=${model?.uid}, bio=${model?.bio}, uid=${model?.uid}");
    CreatePostModel modell = CreatePostModel(
        name: model!.name,
        email: model!.email,
        password: model!.password,
        phone: model!.phone,
        image: model!.image,
        cover: model!.cover,
        bio: model!.bio,
        uid: model!.uid,
        text: text,
        datetime: datetime,
        isLiked: false,
        tokenDevice: model!.tokenDevice,
        postImage: postimage ?? "");

    FirebaseFirestore.instance
        .collection("posts")
        .add(modell.toMap())
        .then((value) {
      PostNotification(
          to: "fiMkSCmAR82mAn0RI7Etn-:APA91bHnpL8ZWRdwEhceNu_Y30jVcumYk_zFN381y25XUnvmD7eFi2IUmSriE794hvAmGwK3ZflKqK8Udz4o2SCZJvh0SicQUJwaqTdzctRh8dCgIgVnkALyCL-OUbuFBIVwNoVLmOP-",
          title: "${model!.name}",
          body: "sent a Post");
      emit(SocialCreatePostSuccessState());
    }).catchError((error) {
      print("Error When post : ${error.toString()}");
      emit(SocialCreatePostErrorState());
    });
  }

  void deletePost(String postId) {
    emit(SocialDeletePostLoadingState());

    FirebaseFirestore.instance
        .collection("posts")
        .doc(postId) // Provide the document ID of the post to delete
        .delete()
        .then((_) {
      emit(SocialDeletePostSuccessState());
    }).catchError((error) {
      print("Error when deleting post: ${error.toString()}");
      emit(SocialDeletePostErrorState());
    });
  }

  void sendMessage(
      {required receiverId,
      required dateTime,
      required text,
      String? image,
      MessageModel? replaymessage}) {
    String messageId = FirebaseFirestore.instance.collection("chats").doc().id;
// Debugging statement
    MessageModel modell = MessageModel(
      senderId: model!.uid,
      receiverId: receiverId,
      messageId: messageId,
      dateTime: dateTime,
      text: text,
      receiverTkoenDevice: model!.tokenDevice,
      image: image ?? "",
      replayMessage: replaymessage, // Pass the replayMessage here
      isRead: false,
      isSeen: false,
    );
//Send by me
    FirebaseFirestore.instance
        .collection("users")
        .doc(model?.uid)
        .collection("chats")
        .doc(receiverId)
        .collection("messages")
        .doc(messageId)
        .set(modell.toMap())
        .then((value) {
      FirebaseFirestore.instance
          .collection("users")
          .doc(model?.uid)
          .update({'unreadMessages.${receiverId}': FieldValue.increment(1)});
      emit(SocialSendMessageSuccessState());
    }).catchError((error) {
      print("Error sending message: $error");

      emit(SocialSendMessageErrorState());
    });
//Send by him
    FirebaseFirestore.instance
        .collection("users")
        .doc(receiverId)
        .collection("chats")
        .doc(model?.uid)
        .collection("messages")
        .doc(messageId)
        .set(modell.toMap())
        .then((value) {
      emit(SocialSendMessageSuccessState());
    }).catchError((error) {
      print("Error sending message: $error");
      emit(SocialSendMessageErrorState());
    });
    FirebaseFirestore.instance
        .collection("users")
        .doc(model?.uid)
        .update({'dateTime': dateTime, 'lastMessage': text}).then((value) {
      // Update the dateTime field for the receiver
      FirebaseFirestore.instance
          .collection("users")
          .doc(receiverId)
          .update({'dateTime': dateTime, 'lastMessage': text}).then((value) {
        emit(SocialUpdateDateAndMessageSuccessState());
      }).catchError((error) {
        print("Error updating receiver's dateTime and Message: $error");
        emit(SocialUpdateDateAndMessageErrorState());
      });
    }).catchError((error) {
      print("Error updating sender's dateTime and Message: $error");
      emit(SocialUpdateDateAndMessageErrorState());
    });
  }

  void deleteMessageForAll({
    required String receiverId,
    required String messageId,
  }) {
    // Delete the message from the sender's chat
    FirebaseFirestore.instance
        .collection("users")
        .doc(model?.uid)
        .collection("chats")
        .doc(receiverId)
        .collection("messages")
        .doc(messageId)
        .delete()
        .then((value) {
      emit(SocialDeleteMessageForAllSuccessState());
    }).catchError((error) {
      print("Error deleting message: $error");
      emit(SocialDeleteMessageForAllErrorState());
    });

    // Delete the message from the receiver's chat
    FirebaseFirestore.instance
        .collection("users")
        .doc(receiverId)
        .collection("chats")
        .doc(model?.uid)
        .collection("messages")
        .doc(messageId)
        .delete()
        .then((value) {
      emit(SocialDeleteMessageForAllSuccessState());
    }).catchError((error) {
      print("Error deleting message: $error");
      emit(SocialDeleteMessageForAllErrorState());
    });
  }

  void deleteMessageForYou({
    required String receiverId,
    required String messageId,
  }) {
    // Delete the message from the sender's chat
    FirebaseFirestore.instance
        .collection("users")
        .doc(model?.uid)
        .collection("chats")
        .doc(receiverId)
        .collection("messages")
        .doc(messageId)
        .delete()
        .then((value) {
      emit(SocialDeleteMessageSuccessState());
    }).catchError((error) {
      print("Error deleting message: $error");
      emit(SocialDeleteMessageErrorState());
    });
  }

  List<MessageModel> messagesmodel = [];

  void getMessages({
    required receiverId,
  }) {
    FirebaseFirestore.instance
        .collection("users")
        .doc(model?.uid)
        .collection("chats")
        .doc(receiverId)
        .collection("messages")
        .orderBy("dateTime")
        .snapshots()
        .listen((element) {
      messagesmodel = [];

      element.docs.forEach((element) {
        var message = MessageModel.fromMap(element.data());

        if (message.senderId != model?.uid) {
          // Mark received messages as read when they are retrieved
          if (!message.isRead) {
            // Update the message's read status in Firestore
            element.reference.update({'isRead': true});
            // FirebaseFirestore.instance
            //     .collection("users")
            //     .doc(receiverId)
            //     .update({'unreadMessages.${model?.uid}': 0});
          }
        }

        messagesmodel.add(message);
      });

      emit(SocialGetMessageSuccessState());
    });
  }

  void confirmMessageRead(
      String messageId, String receiverId, String senderId) {
    // Update the message's read status to mark it as "read"
    FirebaseFirestore.instance
        .collection("users")
        .doc(receiverId) // Replace with the recipient's user ID
        .collection("chats")
        .doc(senderId) // Replace with the sender's user ID
        .collection("messages")
        .doc(messageId)
        .update({'isRead': true}).then((value) {
      // Handle the update success, e.g., show a confirmation message
      print("Message marked as read.");
    }).catchError((error) {
      // Handle any errors that occur during the update
      print("Error marking message as read: $error");
    });
  }

  Future<MessageModel?> getLastMessageForUser(String userId) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("chats")
        .doc(model
            ?.uid) // Assuming you're storing messages under the current user's ID
        .collection("messages")
        .orderBy('dateTime', descending: true)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final lastMessageData = querySnapshot.docs.first.data();
      return MessageModel.fromMap(lastMessageData);
    } else {
      return null;
    }
  }

  void PostNotification(
      {required String to,
      required String title,
      required String body,
      String type = "message"}) {
    DioHelper().postData(url: SEND, data: {
      "to": to,
      "notification": {
        "title": title,
        "body": body,
        "sound": "default",
        "priority": "high",
      },
      "android": {
        "priority": "HIGH",
        "notification": {
          "notification_priority": "PRIORITY_MAX",
          "sound": "default",
          "default_sound": "true",
          "default_vibrate_timings": "true",
          "default_light_settings": "true"
        }
      },
      "data": {"type": type, "click_action": "FLUTTER_NOTIFICATION_CLICK"}
    }).then((value) {
      emit(SocialPostNotificationSuccessState());
    }).catchError((error) {
      print(error);
      emit(SocialPostNotificationErrorState());
    });
  }

  final _firebaseMessaging = FirebaseMessaging.instance;
  Future<void> initNotification() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    RemoteMessage? initialmessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialmessage != null) {
      _handeleMessage((initialmessage));
    }
    FirebaseMessaging.onMessageOpenedApp.listen(_handeleMessage);
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }
}

void _handeleMessage(RemoteMessage event) {
  String notificationType = event.data['type'];

  if (notificationType == 'like') {
    // Handle message notification
    // Add your code here for handling message notifications
    BottomNaviBar.navigateToNotificationsTab(
        navigatorKey.currentState!.context);
    print("On Message Opened App");
  } else if (notificationType == 'comment') {
    BottomNaviBar.navigateToNotificationsTab(
        navigatorKey.currentState!.context);
    print("On Message Opened App");
  } else {
    BottomNaviBar.navigateToChatsTab(navigatorKey.currentState!.context);
    print("On Message Opened App");
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage? message) async {
  print("On BackgroungMessage");

  print(message?.data.toString());
}
            // </intent-filter>
            //     <action android:name="FLUTTER_NOTIFICATION_CLICK" />
            //     <category android:name="android.intent.category.DEFAULT" />
            // </intent-filter>
            