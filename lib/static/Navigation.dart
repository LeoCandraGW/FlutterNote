enum NavigationRoute {
  HomepageRoute("/homepage"),
  DetailTodoPageRoute('/detailtodopage'),
  ListTodoPageRoute('/listtodopage');

  const NavigationRoute(this.name);
  final String name;
}
