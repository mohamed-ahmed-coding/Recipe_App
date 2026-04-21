import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipe_app/cubits/auth/auth_cubit.dart';
import 'package:recipe_app/cubits/recipe/recipe_cubit.dart';
import 'package:recipe_app/cubits/favorites/favorites_cubit.dart';
import 'package:recipe_app/repo/recipe_rebo.dart';
import 'package:recipe_app/repo/favorites_repository.dart';
import 'package:recipe_app/core/api/dio_helper.dart';
import 'package:recipe_app/firebase_options.dart';
import 'package:recipe_app/screens/check_screen.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final dio = DioHelper();
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: dio),
        RepositoryProvider(create: (_) => RecipeRepository(dio)),
        RepositoryProvider(create: (_) => FavoritesRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => AuthCubit()),
          BlocProvider(create: (context) => RecipeCubit(context.read<RecipeRepository>())),
          BlocProvider(
            create: (context) => FavoritesCubit(
              repo: context.read<FavoritesRepository>(),
            ),
          ),
        ],
        child: ScreenUtilInit(
          designSize: const Size(375, 850),
          child: MaterialApp(
            theme: ThemeData(
              textTheme: GoogleFonts.poppinsTextTheme(
                Theme.of(context).textTheme
              )
            ),
            debugShowCheckedModeBanner: false,
            home: const CheckScreen(),
          ),
        ),
      ),
    );
  }
}
