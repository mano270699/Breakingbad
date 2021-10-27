import '../api/characters_api.dart';
import '../models/char_qoute.dart';
import '../models/character_model.dart';

class CharacterRepository {
  final CharactersApi charactersApi;

  CharacterRepository(this.charactersApi);
  Future<List<Character>> getAllCharacters() async {
    final charaters = await charactersApi.getAllCharacters();
    return charaters.map((charater) => Character.fromJson(charater)).toList();
  }

  Future<List<Qoute>> getCharactersQoute(String charName) async {
    final qoute = await charactersApi.getCharacterQoute(charName);
    return qoute.map((charQout) => Qoute.fromjson(charQout)).toList();
  }
}
