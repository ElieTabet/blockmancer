/// A phone's mail app: records each draft it is asked to open, and opens it
/// unless [installed] is false.
final class FakeMailApp {
  FakeMailApp({this.installed = true});

  final drafts = <Uri>[];
  final bool installed;

  Future<bool> compose(Uri mailto) async {
    drafts.add(mailto);

    return installed;
  }
}
