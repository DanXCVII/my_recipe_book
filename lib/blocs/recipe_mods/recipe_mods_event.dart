part of 'recipe_mods_bloc.dart';

abstract class RecipeModsEvent extends Equatable {
  const RecipeModsEvent();

  @override
  List<Object> get props => [];
}

class BlockMods extends RecipeModsEvent {
  const BlockMods();

  @override
  List<Object> get props => [];
}

class UnblockMods extends RecipeModsEvent {
  const UnblockMods();

  @override
  List<Object> get props => [];
}
