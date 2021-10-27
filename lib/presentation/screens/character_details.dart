import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import '../../business_logic/cubit/characters_cubit.dart';
import '../../constants/my_colors.dart';
import '../../data/models/character_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';

class CharacterDetails extends StatelessWidget {
  final Character character;
  const CharacterDetails({Key? key, required this.character}) : super(key: key);
  Widget buildSilverAppBar() {
    return SliverAppBar(
      expandedHeight: 600,
      pinned: true,
      stretch: true,
      backgroundColor: MyColors.myGrey,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          character.nickname,
          style: TextStyle(
            color: MyColors.myWhite,
          ),
        ),
        background: Hero(
          tag: character.charId,
          child: Image.network(
            character.img,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget buildCharacterInfo(String title, String value) {
    return RichText(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(children: [
        TextSpan(
          text: title,
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: MyColors.myWhite),
        ),
        TextSpan(
          text: value,
          style: TextStyle(fontSize: 16, color: MyColors.myWhite),
        ),
      ]),
    );
  }

  Widget buildDivider(double endIndent) {
    return Divider(
      color: MyColors.myYellow,
      height: 30,
      thickness: 2,
      endIndent: endIndent,
    );
  }

  Widget checkQouteAreLoaded(CharactersState state) {
    if (state is CharacterQoutLoaded) {
      return displayRandomQouteOrEmptySpace(state);
    } else {
      return showProgressIndecator();
    }
  }

  Widget displayRandomQouteOrEmptySpace(state) {
    var qoutes = (state).qoute;
    if (qoutes.length != 0) {
      int randomQouteIndex = Random().nextInt(qoutes.length - 1);
      return Center(
        child: DefaultTextStyle(
          textAlign: TextAlign.center,
          child: AnimatedTextKit(
            animatedTexts: [
              FlickerAnimatedText(qoutes[randomQouteIndex].qoute),
            ],
            repeatForever: true,
          ),
          style: TextStyle(fontSize: 20, color: MyColors.myWhite, shadows: [
            Shadow(
                blurRadius: 7, color: MyColors.myYellow, offset: Offset(0, 0))
          ]),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget showProgressIndecator() {
    return Center(
      child: CircularProgressIndicator(
        color: MyColors.myYellow,
      ),
    );
  }

  Widget buildCharacterDetails() {
    return CustomScrollView(
      slivers: [
        buildSilverAppBar(),
        SliverList(
          delegate: SliverChildListDelegate(
            [
              Container(
                margin: EdgeInsets.fromLTRB(14, 14, 14, 0),
                padding: EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildCharacterInfo(
                        'Job : ', character.occupation.join(' / ')),
                    buildDivider(280),
                    buildCharacterInfo('Appeared in : ', character.category),
                    buildDivider(210),
                    buildCharacterInfo(
                        'Seasons : ', character.appearance.join(' / ')),
                    buildDivider(240),
                    buildCharacterInfo('status : ', character.status),
                    buildDivider(260),
                    character.betterCallSaulAppearance.isEmpty
                        ? Container()
                        : buildCharacterInfo('Better Call Saul Season : ',
                            character.betterCallSaulAppearance.join(' / ')),
                    character.betterCallSaulAppearance.isEmpty
                        ? Container()
                        : buildDivider(120),
                    buildCharacterInfo('Actor/Actress : ', character.name),
                    buildDivider(200),
                    SizedBox(
                      height: 20,
                    ),
                    BlocBuilder<CharactersCubit, CharactersState>(
                      builder: (context, state) {
                        return checkQouteAreLoaded(state);
                      },
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 400,
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget showLoadingIndecator() {
    return Center(
      child: CircularProgressIndicator(
        color: MyColors.myYellow,
      ),
    );
  }

  Widget buildNoInternetWidget() {
    return Center(
      child: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 20,
            ),
            Text(
              'Can\'t connect.. Check Internet!',
              style: TextStyle(
                color: MyColors.myGrey,
                fontSize: 22,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Image.asset('assets/images/nointernet.png'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<CharactersCubit>(context)
        .getCharactersQoute(character.name);
    return Scaffold(
      backgroundColor: MyColors.myGrey,
      body: OfflineBuilder(
        connectivityBuilder: (
          BuildContext context,
          ConnectivityResult connectivity,
          Widget child,
        ) {
          final bool connected = connectivity != ConnectivityResult.none;
          if (connected) {
            return buildCharacterDetails();
          } else {
            return buildNoInternetWidget();
          }
        },
        child: showLoadingIndecator(),
      ),
    );
  }
}
