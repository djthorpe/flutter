// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:reviewapp/models/review.dart';
import 'package:reviewapp/models/reviews.dart';

void main() {
  test('Test MobX state class', () async {
    final Reviews _reviewsStore = Reviews();

    _reviewsStore.initReviews();

    expect(_reviewsStore.totalStars, 0);

    expect(_reviewsStore.averageStars, 0);
    _reviewsStore.addReview(ReviewModel(
      comment: 'This is a test review',
      stars: 3,
    ));

    expect(_reviewsStore.totalStars, 3);
    _reviewsStore.addReview(ReviewModel(
      comment: 'This is a second test review',
      stars: 5,
    ));

    expect(_reviewsStore.averageStars, 4);
  });
}