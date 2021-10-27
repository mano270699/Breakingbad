import '../../business_logic/cubit/characters_cubit.dart';
import '../../constants/my_colors.dart';
import '../../data/models/character_model.dart';
import '../widgets/character_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';

class CharactersScreen extends StatefulWidget {
  const CharactersScreen({Key? key}) : super(key: key);

  @override
  _CharactersScreenState createState() => _CharactersScreenState();
}

class _CharactersScreenState extends State<CharactersScreen> {
  late List<Character> allCharacters;
  late List<Character> _searchedCharacter;
  bool _isSearching = false;
  final _searchController = TextEditingController();

  Widget _buildSearchingField() {
    return TextField(
      controller: _searchController,
      cursorColor: MyColors.myGrey,
      decoration: InputDecoration(
        hintText: 'Find a character..',
        border: InputBorder.none,
        hintStyle: TextStyle(
          fontSize: 18,
          color: MyColors.myGrey,
        ),
      ),
      style: TextStyle(color: MyColors.myGrey, fontSize: 18),
      onChanged: (searchChar) {
        searchedForCharacterFunction(searchChar);
      },
    );
  }

  void searchedForCharacterFunction(String searchedChar) {
    _searchedCharacter = allCharacters
        .where((character) =>
            character.name.toLowerCase().startsWith(searchedChar))
        .toList();
    setState(() {});
  }

  List<Widget> _buildAppBarActions() {
    if (_isSearching) {
      return [
        IconButton(
          onPressed: () {
            _clearSearching();
            Navigator.pop(context);
          },
          icon: Icon(Icons.clear),
          color: MyColors.myGrey,
        )
      ];
    } else {
      return [
        IconButton(
          onPressed: _startSearch,
          icon: Icon(Icons.search),
          color: MyColors.myGrey,
        )
      ];
    }
  }

  void _startSearch() {
    ModalRoute.of(context)!.addLocalHistoryEntry(LocalHistoryEntry(
      onRemove: _stopSearching,
    ));
    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearching() {
    _clearSearching();
    setState(() {
      _isSearching = false;
    });
  }

  void _clearSearching() {
    setState(() {
      _searchController.clear();
    });
  }

  @override
  void initState() {
    super.initState();

    BlocProvider.of<CharactersCubit>(context).getAllCharacters();
  }

  Widget buildBlocWidget() {
    return BlocBuilder<CharactersCubit, CharactersState>(
      builder: (context, state) {
        if (state is CharactersLoaded) {
          allCharacters = (state).characters;
          return buildCharacterItem();
        } else {
          return showLoadingIndecator();
        }
      },
    );
  }

  Widget buildCharacterItem() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Container(
        color: MyColors.myGrey,
        child: Column(
          children: [
            buildCharacterList(),
          ],
        ),
      ),
    );
  }

  Widget buildCharacterList() {
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 1,
          childAspectRatio: 2 / 3,
          mainAxisSpacing: 2,
        ),
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: _searchController.text.isEmpty
            ? allCharacters.length
            : _searchedCharacter.length,
        itemBuilder: (context, index) {
          return CharacterItem(
            character: _searchController.text.isEmpty
                ? allCharacters[index]
                : _searchedCharacter[index],
          );
        });
  }

  Widget showLoadingIndecator() {
    return Center(
      child: CircularProgressIndicator(
        color: MyColors.myYellow,
      ),
    );
  }

  Widget _buildAppBarTitel() {
    return Text(
      'Character',
      style: TextStyle(
        color: MyColors.myGrey,
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.myYellow,
        title: _isSearching ? _buildSearchingField() : _buildAppBarTitel(),
        actions: _buildAppBarActions(),
        leading: _isSearching
            ? BackButton(
                color: MyColors.myGrey,
              )
            : Container(),
      ),
      body: OfflineBuilder(
        connectivityBuilder: (
          BuildContext context,
          ConnectivityResult connectivity,
          Widget child,
        ) {
          final bool connected = connectivity != ConnectivityResult.none;
          if (connected) {
            return buildBlocWidget();
          } else {
            return buildNoInternetWidget();
          }
        },
        child: showLoadingIndecator(),
      ),
    );
  }
}
