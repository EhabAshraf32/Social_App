import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../controller/socialCubit/cubit/social_cubit.dart';
import '../model/MessagesModel.dart';

String formattedDateTime(dateTime, format) {
  final dateTimeFormat = DateFormat(format);
  final parsedDateTime = DateTime.parse(dateTime);
  return dateTimeFormat.format(parsedDateTime);
}

String formattedDateTimeForChats(dateTime) {
  final parsedDateTime = DateTime.parse(dateTime);
  final now = DateTime.now();
  final difference = now.difference(parsedDateTime);
  if (difference.inDays >= 7) {
    // If a week or more has passed, show the date in the format "dd/MM/yyyy"
    return DateFormat('dd/MM/yyyy').format(parsedDateTime);
  } else if (difference.inDays >= 1) {
    // If a day or more has passed, show the day of the week
    return DateFormat('EEEE').format(parsedDateTime);
  } else {
    return DateFormat('hh:mm a').format(parsedDateTime);
  }
}

String formatDateTimeForPosts(DateTime dateTime) {
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inDays >= 1) {
    return '${difference.inDays} days ago';
  } else if (difference.inHours >= 1) {
    return '${difference.inHours} hours ago';
  } else if (difference.inMinutes >= 1) {
    return '${difference.inMinutes} minutes ago';
  } else {
    return '${difference.inSeconds} seconds ago';
  }
}
