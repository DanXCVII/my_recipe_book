import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'recipe_mods_event.dart';
part 'recipe_mods_state.dart';

class RecipeModsBloc extends Bloc<RecipeModsEvent, RecipeModsState> {
  RecipeModsBloc() : super(UnblockModsState()) {
    on<BlockMods>((event, emit) async {
      emit(BlockModsState());
    });

    on<UnblockMods>((event, emit) async {
      emit(UnblockModsState());
    });
  }
}
