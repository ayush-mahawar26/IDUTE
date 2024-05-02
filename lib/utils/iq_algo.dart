import "dart:math";

import "package:idute_app/model/iq_model.dart";

class UserIQCalculator {
  static const double maxIQ = 150.0;
  // Assign points for different user actions
  static const double postPoints = 5.0;
  static const double validationPoints = 2.0;
  static const double commentPoints = 1.0;
  static const double replyPoints = 1.0;
  static const double likeOnCommentPoints = 0.5;
  static const double likeOnReplyPoints = 0.3;
  static const double connectionPoints = 3.0;
  static const double higherIQMultiplier = 0.1;
  // Minimum and maximum points for each action
  static const double minPostPoints = 1.0;
  static const double maxPostPoints = 10.0;
  static const double minValidationPoints = 1.0;
  static const double maxValidationPoints = 5.0;
  static const double minCommentPoints = 0.5;
  static const double maxCommentPoints = 2.0;
  static const double minReplyPoints = 0.5;
  static const double maxReplyPoints = 2.0;
  static const double minLikeOnCommentPoints = 0.1;
  static const double maxLikeOnCommentPoints = 0.5;
  static const double minLikeOnReplyPoints = 0.1;
  static const double maxLikeOnReplyPoints = 0.3;
  static const double minConnectionPoints = 1.0;
  static const double maxConnectionPoints = 5.0;
  // Calculate IQ based on user actions
  static double calculateIQ({
    required IqModel iq,
  }) {
    double totalPoints = 0;
    // Assign points for each action
    totalPoints += _calculatePostPoints(iq.postCount.toDouble());
    totalPoints += _calculateValidationPoints(iq.validationCount.toDouble());
    totalPoints += _calculateCommentPoints(iq.commentCount.toDouble());
    totalPoints += _calculateReplyPoints(iq.replyCount.toDouble());
    totalPoints +=
        _calculateLikeOnCommentPoints(iq.likeOnCommentCount.toDouble());
    totalPoints += _calculateLikeOnReplyPoints(iq.likeOnReplyCount.toDouble());
    totalPoints += _calculateConnectionPoints(iq.connectionCount.toDouble());
    totalPoints += _calculateConnectionWithHigherIQPoints(
        iq.connectionWithHigherIq.toDouble(), totalPoints);
    // Normalize points to be within the valid range
    totalPoints = max(0, min(totalPoints, _calculateMaxPossiblePoints()));
    // Calculate IQ as a percentage of the max IQ
    double iqPercentage = totalPoints / _calculateMaxPossiblePoints();
    double userIQ = iqPercentage * maxIQ;
    return userIQ;
  }

  // Calculate points for making a post
  static double _calculatePostPoints(double postCount) {
    return min(maxPostPoints, max(minPostPoints, postCount * postPoints));
  }

  // Calculate points for validations on user's post
  static double _calculateValidationPoints(double validationCount) {
    return min(maxValidationPoints,
        max(minValidationPoints, validationCount * validationPoints));
  }

  // Calculate points for comments on user's post
  static double _calculateCommentPoints(double commentCount) {
    return min(
        maxCommentPoints, max(minCommentPoints, commentCount * commentPoints));
  }

  // Calculate points for replies to comments
  static double _calculateReplyPoints(double replyCount) {
    return min(maxReplyPoints, max(minReplyPoints, replyCount * replyPoints));
  }

  // Calculate points for likes on comments
  static double _calculateLikeOnCommentPoints(double likeOnCommentCount) {
    return min(maxLikeOnCommentPoints,
        max(minLikeOnCommentPoints, likeOnCommentCount * likeOnCommentPoints));
  }

  // Calculate points for likes on replies
  static double _calculateLikeOnReplyPoints(double likeOnReplyCount) {
    return min(maxLikeOnReplyPoints,
        max(minLikeOnReplyPoints, likeOnReplyCount * likeOnReplyPoints));
  }

  // Calculate points for the number of connections
  static double _calculateConnectionPoints(double connectionCount) {
    return min(maxConnectionPoints,
        max(minConnectionPoints, connectionCount * connectionPoints));
  }

  // Calculate additional points for connections with higher IQ
  static double _calculateConnectionWithHigherIQPoints(
      double connectionsWithHigherIQ, double totalPoints) {
    // Give bonus points for connections with higher IQ
    return connectionsWithHigherIQ * (totalPoints * higherIQMultiplier);
  }

  // Calculate the maximum possible points
  static double _calculateMaxPossiblePoints() {
    return (maxPostPoints +
        maxValidationPoints +
        maxCommentPoints +
        maxReplyPoints +
        maxLikeOnCommentPoints +
        maxLikeOnReplyPoints +
        maxConnectionPoints);
  }
}

// void main() {
//   // Example usage:
//   double userIQ = UserIQCalculator.calculateIQ(
//     postCount: 10,
//     validationCount: 5,
//     commentCount: 20,
//     replyCount: 8,
//     likeOnCommentCount: 15,
//     likeOnReplyCount: 10,
//     connectionCount: 15,
//     connectionsWithHigherIQ: 8,
//   );
//   print('User IQ: $userIQ');
// }
