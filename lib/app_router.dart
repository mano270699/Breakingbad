import 'business_logic/cubit/characters_cubit.dart';
import 'constants/strings.dart';
import 'data/api/characters_api.dart';
import 'data/repository/characters_repository.dart';
import 'presentation/screens/character_details.dart';
import 'presentation/screens/character_screen.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:splash_screen_view/SplashScreenView.dart';

import 'constants/my_colors.dart';
import 'data/models/character_model.dart';

class AppRouter {
  late CharacterRepository characterRepository;
  late CharactersCubit charactersCubit;
  AppRouter() {
    characterRepository = CharacterRepository(CharactersApi());
    charactersCubit = CharactersCubit(characterRepository);
  }

  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case CHARACTERS:
        return MaterialPageRoute(
          builder: (_) => SplashScreenView(
            navigateRoute: BlocProvider(
              create: (BuildContext context) => charactersCubit,
              child: CharactersScreen(),
            ),
            duration: 4000,
            imageSize: 130,
            imageSrc: "assets/images/logo.png",
            text: "Breaking Bad",
            textType: TextType.ColorizeAnimationText,
            textStyle: TextStyle(
              fontSize: 40.0,
            ),
            colors: [
              Colors.purple,
              Colors.blue,
              Colors.yellow,
              Colors.red,
            ],
            backgroundColor: MyColors.myGrey,
          ),
        );

      case charactersDetailsScreen:
        final character = settings.arguments as Character;
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (BuildContext context) =>
                      CharactersCubit(characterRepository),
                  child: CharacterDetails(
                    character: character,
                  ),
                ));
    }
  }
}
