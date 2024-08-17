import '../features/authentication/presentation/pages/auth_pages.dart';
import '../features/authentication/presentation/pages/login_screen.dart';
import '../features/authentication/presentation/pages/register_pages.dart';
import '../features/dashboard/presentation/pages/dashboard_page.dart';

dynamic routes = {
  SplashScreen.routeName: (context) => const SplashScreen(),
  LoginScreen.routeName: (context) => const LoginScreen(),
  RegisterScreen.routeName: (context) => const RegisterScreen(),
  DashboardPage.routeName: (context) => const DashboardPage(),
};
