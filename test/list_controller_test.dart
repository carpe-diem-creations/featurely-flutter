import 'package:featurely/src/api/api_exception.dart';
import 'package:featurely/src/api/models.dart';
import 'package:featurely/src/ui/controllers/list_controller.dart';
import 'package:flutter_test/flutter_test.dart';

import 'widgets/harness.dart';

void main() {
  test('infinite scroll appends pages using the cursor until null', () async {
    final api = FakeApi();
    final cursors = <String?>[];
    var call = 0;
    api.onList = (sort, status, cursor, limit) async {
      cursors.add(cursor);
      call++;
      if (call == 1) {
        return Page(
          items: [makeItem(id: 'a'), makeItem(id: 'b')],
          nextCursor: 'cur-1',
        );
      }
      return Page(items: [makeItem(id: 'c')], nextCursor: null);
    };
    final controller = FeedbackListController(api: api);
    await controller.loadFirst();
    expect(controller.canLoadMore, isTrue);
    await controller.loadMore();
    expect(cursors, [null, 'cur-1']);
    expect(controller.items.map((i) => i.id), ['a', 'b', 'c']);
    // nextCursor null is the end — no further requests.
    expect(controller.canLoadMore, isFalse);
    await controller.loadMore();
    expect(call, 2);
  });

  test('appended pages are de-duplicated by id (votes-sort movement)',
      () async {
    final api = FakeApi();
    var call = 0;
    api.onList = (sort, status, cursor, limit) async {
      call++;
      if (call == 1) {
        return Page(
          items: [makeItem(id: 'a'), makeItem(id: 'b')],
          nextCursor: 'cur-1',
        );
      }
      return Page(
        items: [makeItem(id: 'b'), makeItem(id: 'c')],
        nextCursor: null,
      );
    };
    final controller = FeedbackListController(api: api);
    await controller.loadFirst();
    await controller.loadMore();
    expect(controller.items.map((i) => i.id), ['a', 'b', 'c']);
  });

  test('invalid_cursor restarts the list from no cursor', () async {
    final api = FakeApi();
    final cursors = <String?>[];
    var call = 0;
    api.onList = (sort, status, cursor, limit) async {
      cursors.add(cursor);
      call++;
      if (call == 1) {
        return Page(items: [makeItem(id: 'a')], nextCursor: 'stale');
      }
      if (call == 2) {
        throw FeaturelyApiException(FeaturelyErrorCode.invalidCursor, 400);
      }
      return Page(items: [makeItem(id: 'fresh')], nextCursor: null);
    };
    final controller = FeedbackListController(api: api);
    await controller.loadFirst();
    await controller.loadMore();
    expect(cursors, [null, 'stale', null]);
    expect(controller.items.map((i) => i.id), ['fresh']);
  });

  test('sort and filter are held constant across pages and restart on change',
      () async {
    final api = FakeApi();
    final calls = <(FeedbackSort, FeedbackStatus?, String?)>[];
    api.onList = (sort, status, cursor, limit) async {
      calls.add((sort, status, cursor));
      return Page(items: [makeItem(id: '${calls.length}')], nextCursor: 'c');
    };
    final controller = FeedbackListController(api: api);
    await controller.loadFirst();
    await controller.loadMore();
    expect(calls[0], (FeedbackSort.votes, null, null));
    expect(calls[1], (FeedbackSort.votes, null, 'c'));

    await controller.applyFilter(FeedbackSort.newest, FeedbackStatus.open);
    expect(calls[2], (FeedbackSort.newest, FeedbackStatus.open, null));
  });

  test('applyFilter with a preloaded page issues no request', () async {
    final api = FakeApi();
    var calls = 0;
    api.onList = (sort, status, cursor, limit) async {
      calls++;
      return const Page(items: [], nextCursor: null);
    };
    final controller = FeedbackListController(api: api);
    await controller.loadFirst();
    expect(calls, 1);
    await controller.applyFilter(
      FeedbackSort.oldest,
      null,
      preload: Page(items: [makeItem(id: 'pre')], nextCursor: null),
    );
    expect(calls, 1);
    expect(controller.items.single.id, 'pre');
    expect(controller.sort, FeedbackSort.oldest);
  });
}
