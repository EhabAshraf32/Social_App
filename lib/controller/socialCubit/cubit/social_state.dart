// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'social_cubit.dart';

abstract class SocialState {}

class SocialInitial extends SocialState {}

class SocialGetUserLoadingState extends SocialState {}

class SocialGetUserSuccessState extends SocialState {}

class SocialGetUserErrorState extends SocialState {
  String error;
  SocialGetUserErrorState({
    required this.error,
  });
}

class SocialGetAllUsersLoadingState extends SocialState {}

class SocialGetAllUsersSuccessState extends SocialState {}

class SocialGetAllUsersErrorState extends SocialState {
  String error;
  SocialGetAllUsersErrorState({
    required this.error,
  });
}

class SocialGetPostsLoadingState extends SocialState {}

class SocialGetpostsSuccessState extends SocialState {}

class SocialGetPostsErrorState extends SocialState {
  String error;
  SocialGetPostsErrorState({
    required this.error,
  });
}

class SocialChangeButtomNavState extends SocialState {}

class SocialNewPostState extends SocialState {}

class SocialLikePostSuccesState extends SocialState {}

class SocialLikePostErrorState extends SocialState {
  late String error;
  SocialLikePostErrorState({
    required this.error,
  });
}

class SocialCommentPostSuccesState extends SocialState {}

class SocialCommentPostErrorState extends SocialState {
  late String error;
  SocialCommentPostErrorState({
    required this.error,
  });
}

class SocialChangeLikeStatusstate extends SocialState {}

class SocialToggleProfilePhotostate extends SocialState {}

class SocialProfilePicedImageSuccesState extends SocialState {}

class SocialProfilePicedImageErrorState extends SocialState {}

class SocialProfilePicedImageLoadingState extends SocialState {}

class SocialCoverPicedImageSuccesState extends SocialState {}

class SocialCoverPicedImageErrorState extends SocialState {}

class SocialProfileUploadImageSuccesState extends SocialState {}

class SocialProfileUploadImageErrorState extends SocialState {}

class SocialCoverUploadImageSuccesState extends SocialState {}

class SocialCoverUploadImageErrorState extends SocialState {}

class SocialUpdateUserDetailsErrorState extends SocialState {}

class SocialUpdateUserDetailsLoadingState extends SocialState {}
//[posts state]

class SocialPostPicedImageSuccesState extends SocialState {}

class SocialChatPicedImageLoadingState extends SocialState {}

class SocialChatPicedImageSuccesState extends SocialState {}

class SocialChatPicedImageErrorState extends SocialState {}

class SocialPostPicedImageErrorState extends SocialState {}

class SocialPostPicedImageLoadingState extends SocialState {}

class SocialCreatePostLoadingState extends SocialState {}

class SocialCreatePostSuccessState extends SocialState {}

class SocialCreatePostErrorState extends SocialState {}

class SocialDeletePostLoadingState extends SocialState {}

class SocialDeletePostSuccessState extends SocialState {}

class SocialDeletePostErrorState extends SocialState {}

class SocialRemoveImageSuccesState extends SocialState {}

class SocialRefreshingState extends SocialState {}

class SocialUpdateLikesState extends SocialState {}

class SocialUpdateCommentsState extends SocialState {}

//chat
class SocialSendMessageSuccessState extends SocialState {}

class SocialSendMessageErrorState extends SocialState {}

class SocialGetMessageSuccessState extends SocialState {}

class SocialGetMessageLoadingState extends SocialState {}

class SocialUploadImageChatLoadingState extends SocialState {}

class SocialUploadImageChatErrorState extends SocialState {}

class SocialDeleteMessageSuccessState extends SocialState {}

class SocialDeleteMessageErrorState extends SocialState {}

class SocialDeleteMessageForAllSuccessState extends SocialState {}

class SocialDeleteMessageForAllErrorState extends SocialState {}

class SocialUpdateDateAndMessageSuccessState extends SocialState {}

class SocialUpdateDateAndMessageErrorState extends SocialState {}

class SocialMarkMessageAsReadSuccessState extends SocialState {}

class SocialMarkMessageAsReadErrorState extends SocialState {}

class SocialRessetMessageAsReadSuccessState extends SocialState {}

class SocialRessetMessageAsReadErrorState extends SocialState {}

class SocialRessetUnReedSuccessState extends SocialState {}

class SocialRessetReplayStatusSuccessState extends SocialState {}

class SocialCancelReplayStatusSuccessState extends SocialState {}

//Likes
class SocialRemoveLikeSuccessState extends SocialState {}

class SocialToggleLikeStatusState extends SocialState {}

class SocialRemoveLikeErrorState extends SocialState {
  final String error;

  SocialRemoveLikeErrorState({required this.error});
}

//comments
class SocialGetCommentsSuccessState extends SocialState {}

class SocialGetCommentsLoadingState extends SocialState {}

class SocialDeleteCommentSuccessState extends SocialState {}

class SocialCommentNotFoundState extends SocialState {}

class SocialDeleteCommentErrorState extends SocialState {
  final String error;
  SocialDeleteCommentErrorState({
    required this.error,
  });
}

class SocialFetchCommentErrorState extends SocialState {
  final String error;
  SocialFetchCommentErrorState({
    required this.error,
  });
}

//Notification
class SocialPostNotificationSuccessState extends SocialState {}

class SocialPostNotificationErrorState extends SocialState {}

class SocialResetScrollController extends SocialState {}
