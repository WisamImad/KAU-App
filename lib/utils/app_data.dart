class Data {
  static Map? user;
  static List<dynamic>? messageList;
  static List<dynamic>? blogList;
  static List<dynamic>? dailyTasksList;
  static List<dynamic>? familyMemberList;
  static List<dynamic>? rewardList;
  static List<dynamic>? videosList;
  static List<dynamic>? notificationList;

  static clearData() {
    user = null;
    messageList = null;
    blogList = null;
    dailyTasksList = null;
    familyMemberList = null;
    rewardList = null;
    videosList = null;
    notificationList = null;
  }
}
