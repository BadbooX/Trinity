import 'package:get_it/get_it.dart';


/// A debugger for GetIt that stores registered types and instances for debugging purposes
/// 
/// use this instance of GetIt instead of the default one for registering services 
/// > no needed for getting services
/// 
/// Example:
/// 
/// ```dart
/// final getIt = GetIt.instance;
/// DebugGetIt.registerSingleton<JwtService>(JwtService());
/// DebugGetIt.registerSingleton<HttpClientApi>(HttpClientApi(allowSelfSigned: kDebugMode));
/// DebugGetIt.registerSingleton<AuthService>(AuthService());
/// ```
/// 
/// ```dart
/// final getIt = GetIt.instance;
/// class xxx() {
///   final JwtService _jwtService = getIt<JwtService>();
/// }
/// ```
/// 
/// # add to a debug widget to see all registered instances
/// Example:
/// ```dart
/// class MyApp extends StatelessWidget {
///  const MyApp({super.key});
///
///  @override
///  Widget build(BuildContext context) {
///    return MaterialApp.router(
///      routerConfig: router,
///      title: 'Flutter Demo',
///      builder: (context, child) {
///        if (kDebugMode) {
///          return Stack(
///            children: [
///              child!,
///              GetItDebugWidget( // Add GetItDebugWidget to the widget tree to display registered instances with DebugGetIt
///                registeredTypeNames: DebugGetIt.registeredTypes
///                    .map((type) => type.toString())
///                    .toList(),
///              ),
///            ],
///          );
///        } else {
///          return child!;
///        }
///      },
///    );
///  }
///}
/// ```
/// 
class DebugGetIt {
  static final GetIt _getIt = GetIt.instance;
  static final List<Type> registeredTypes = [];
  static final Map<String, Object> registeredInstances = {};

  static void registerSingleton<T extends Object>(T instance) {
    _getIt.registerSingleton<T>(instance);
    registeredTypes.add(T);
    registeredInstances[T.toString()] = instance; // Store the instance
  }

  static void registerFactory<T extends Object>(T Function() factoryFunc) {
    _getIt.registerFactory<T>(factoryFunc);
    registeredTypes.add(T);
    // Note: Factories don't store instances immediately since they create new ones on demand
  }

  static T get<T extends Object>() {
    return _getIt<T>();
  }
}