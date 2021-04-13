
class INavigate{
  Future<void> push(context, String ui, {bool popCurrentPage = false, bool popAllPage = false}) async {}
  register(String name, page){}
}