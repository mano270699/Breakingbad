import 'package:bloc/bloc.dart';
import '../../data/models/char_qoute.dart';
import '../../data/models/character_model.dart';
import '../../data/repository/characters_repository.dart';
import 'package:meta/meta.dart';

part 'characters_state.dart';

class CharactersCubit extends Cubit<CharactersState> {
  CharactersCubit(this.characterRepository) : super(CharactersInitial());
  List<Character> characters = [];
  List<Qoute> qoute = [];
  final CharacterRepository characterRepository;
  List<Character> getAllCharacters() {
    characterRepository.getAllCharacters().then((characters) {
      emit(CharactersLoaded(characters));
      this.characters = characters;
    });
    return characters;
  }

  List<Qoute> getCharactersQoute(String charName) {
    characterRepository.getCharactersQoute(charName).then((qoute) {
      emit(CharacterQoutLoaded(qoute));
      this.qoute = qoute;
    });
    return qoute;
  }
}
