// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card_deck.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************


class DeckAdapter extends TypeAdapter<Deck> {
  @override
  final int typeId = 0;

  @override
  Deck read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Deck(
      fields[1] as String,
    ).._cards = (fields[0] as List).cast<IndexCard>();
  }

  @override
  void write(BinaryWriter writer, Deck obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj._cards)
      ..writeByte(1)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeckAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class IndexCardAdapter extends TypeAdapter<IndexCard> {
  @override
  final int typeId = 1;

  @override
  IndexCard read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return IndexCard(
      fields[0] as String,
      fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, IndexCard obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj._q)
      ..writeByte(1)
      ..write(obj._a);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IndexCardAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
