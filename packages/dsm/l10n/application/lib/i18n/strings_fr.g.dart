///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:slang/generated.dart';
import 'strings.g.dart';

// Path: <root>
class TranslationsFr extends Translations with BaseTranslations<AppLocale, Translations> {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsFr({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.fr,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ),
		  super(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver) {
		super.$meta.setFlatMapFunction($meta.getTranslation); // copy base translations to super.$meta
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <fr>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key) ?? super.$meta.getTranslation(key);

	late final TranslationsFr _root = this; // ignore: unused_field

	@override 
	TranslationsFr $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsFr(meta: meta ?? this.$meta);

	// Translations
	@override late final _Translations$game$fr game = _Translations$game$fr._(_root);
	@override late final _Translations$push$fr push = _Translations$push$fr._(_root);
	@override late final _Translations$home$fr home = _Translations$home$fr._(_root);
}

// Path: game
class _Translations$game$fr extends Translations$game$en {
	_Translations$game$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Blockmancer';
	@override String get subtitle => 'Partie du jour · les mêmes pièces pour tous';
	@override String get practiceSubtitle => 'Entraînement · une partie neuve à chaque fois';
	@override String get leave => 'Retour au menu';
	@override String runTotal({required Object total}) => 'Partie ${total}';
	@override late final _Translations$game$round$fr round = _Translations$game$round$fr._(_root);
	@override late final _Translations$game$banner$fr banner = _Translations$game$banner$fr._(_root);
	@override late final _Translations$game$offers$fr offers = _Translations$game$offers$fr._(_root);
	@override late final _Translations$game$lost$fr lost = _Translations$game$lost$fr._(_root);
	@override late final _Translations$game$end$fr end = _Translations$game$end$fr._(_root);
	@override late final _Translations$game$jokers$fr jokers = _Translations$game$jokers$fr._(_root);
}

// Path: push
class _Translations$push$fr extends Translations$push$en {
	_Translations$push$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get channelName => 'Annonces';
	@override String get channelDescription => 'Nouvelles et messages de l\'application.';
}

// Path: home
class _Translations$home$fr extends Translations$home$en {
	_Translations$home$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get tabLabel => 'Jouer';
	@override String get title => 'Blockmancer';
	@override String get tagline => 'Posez des pièces, effacez des lignes, combinez vos jokers.';
	@override late final _Translations$home$daily$fr daily = _Translations$home$daily$fr._(_root);
	@override late final _Translations$home$practice$fr practice = _Translations$home$practice$fr._(_root);
	@override String best({required Object points}) => 'Record : ${points}';
	@override String get noBest => 'Pas encore de partie';
}

// Path: game.round
class _Translations$game$round$fr extends Translations$game$round$en {
	_Translations$game$round$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String regular({required Object index, required Object count}) => 'Manche · ${index} / ${count}';
	@override String get boss => 'Boss · Gravats';
	@override String target({required Object target}) => '/ ${target}';
	@override String piecesLeft({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('fr'))(count,
		one: '${count} pièce restante',
		other: '${count} pièces restantes',
	);
	@override String combo({required Object streak}) => 'Combo ×${streak}';
	@override String storedMult({required Object mult}) => '+${mult} mult en réserve';
}

// Path: game.banner
class _Translations$game$banner$fr extends Translations$game$banner$en {
	_Translations$game$banner$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String clear({required Object chips, required Object mult, required Object total}) => '${chips} jetons × ${mult} mult = ${total}';
	@override String placed({required Object points}) => '+${points}';
	@override String bonus({required Object points}) => '+${points} bonus';
	@override String fired({required Object joker, required Object effect}) => '${joker} ${effect}';
	@override String chipsAdded({required Object amount}) => '+${amount} jetons';
	@override String multAdded({required Object amount}) => '+${amount} mult';
	@override String multMultiplied({required Object factor}) => '×${factor} mult';
	@override String multStored({required Object total}) => 'mult en réserve · ${total} prêts';
	@override String pointsAdded({required Object amount}) => '+${amount}';
	@override String runPointsAdded({required Object amount}) => '+${amount} points de partie';
	@override String get stoneDropped => 'nouvelle pierre';
	@override String piecesAdded({required Object amount}) => '+${amount} pièces';
	@override String stonesAdded({required Object amount}) => '+${amount} pierres';
}

// Path: game.offers
class _Translations$game$offers$fr extends Translations$game$offers$en {
	_Translations$game$offers$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get startTitle => 'Choisis ton joker de départ';
	@override String get startSubtitle => 'Les jokers vont par paires. Tu en choisis un de plus après chaque manche : prépare ta combinaison.';
	@override String get roundTitle => 'Manche gagnée !';
	@override String saverBonus({required Object points}) => 'Épargnant +${points}';
	@override String nextRound({required Object index, required Object target}) => 'Choisis un joker. Ensuite : manche ${index} · ${target} pts.';
	@override String nextBoss({required Object target}) => 'Choisis un joker. Ensuite : Boss · ${target} pts avec des pierres.';
	@override String build({required Object jokers}) => 'Ta combinaison : ${jokers}';
	@override String completesPair({required Object joker}) => '★ Complète une paire avec ton ${joker}';
	@override String pairsWith({required Object joker}) => 'Va avec : ${joker}';
	@override String get take => 'Prendre';
}

// Path: game.lost
class _Translations$game$lost$fr extends Translations$game$lost$en {
	_Translations$game$lost$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get outOfPieces => 'Plus de pièces';
	@override String get noRoom => 'Plus de place';
	@override String progress({required Object score, required Object target}) => '${score} sur ${target} points cette manche.';
	@override String revive({required Object rows, required Object pieces}) => 'Relancer · ${rows} lignes vidées + ${pieces} pièces';
	@override String get endRun => 'Terminer la partie';
}

// Path: game.end
class _Translations$game$end$fr extends Translations$game$end$en {
	_Translations$game$end$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get won => 'Boss vaincu · partie terminée';
	@override String overRound({required Object index}) => 'Partie finie · manche ${index} atteinte';
	@override String get overBoss => 'Partie finie · boss atteint';
	@override String total({required Object total}) => '${total} points';
	@override String build({required Object jokers}) => 'Combinaison : ${jokers}';
	@override String get noJokers => 'aucune';
	@override String best({required Object points}) => 'Record : ${points}';
	@override String get newBest => 'Nouveau record !';
	@override String get retry => 'Rejouer';
}

// Path: game.jokers
class _Translations$game$jokers$fr extends Translations$game$jokers$en {
	_Translations$game$jokers$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override late final _Translations$game$jokers$stonemason$fr stonemason = _Translations$game$jokers$stonemason$fr._(_root);
	@override late final _Translations$game$jokers$combo$fr combo = _Translations$game$jokers$combo$fr._(_root);
	@override late final _Translations$game$jokers$patience$fr patience = _Translations$game$jokers$patience$fr._(_root);
	@override late final _Translations$game$jokers$precision$fr precision = _Translations$game$jokers$precision$fr._(_root);
	@override late final _Translations$game$jokers$collector$fr collector = _Translations$game$jokers$collector$fr._(_root);
	@override late final _Translations$game$jokers$twin$fr twin = _Translations$game$jokers$twin$fr._(_root);
	@override late final _Translations$game$jokers$column$fr column = _Translations$game$jokers$column$fr._(_root);
	@override late final _Translations$game$jokers$heavy$fr heavy = _Translations$game$jokers$heavy$fr._(_root);
	@override late final _Translations$game$jokers$sweep$fr sweep = _Translations$game$jokers$sweep$fr._(_root);
	@override late final _Translations$game$jokers$quarry$fr quarry = _Translations$game$jokers$quarry$fr._(_root);
	@override late final _Translations$game$jokers$bigbox$fr bigbox = _Translations$game$jokers$bigbox$fr._(_root);
	@override late final _Translations$game$jokers$tiny$fr tiny = _Translations$game$jokers$tiny$fr._(_root);
	@override late final _Translations$game$jokers$pockets$fr pockets = _Translations$game$jokers$pockets$fr._(_root);
	@override late final _Translations$game$jokers$saver$fr saver = _Translations$game$jokers$saver$fr._(_root);
}

// Path: home.daily
class _Translations$home$daily$fr extends Translations$home$daily$en {
	_Translations$home$daily$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Partie du jour';
	@override String get subtitle => 'Les mêmes pièces pour tous aujourd\'hui';
}

// Path: home.practice
class _Translations$home$practice$fr extends Translations$home$practice$en {
	_Translations$home$practice$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Entraînement';
	@override String get subtitle => 'Une partie neuve à chaque fois';
}

// Path: game.jokers.stonemason
class _Translations$game$jokers$stonemason$fr extends Translations$game$jokers$stonemason$en {
	_Translations$game$jokers$stonemason$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get name => 'Tailleur de pierre';
	@override String get description => '+50 jetons par pierre effacée. 2 pierres de plus à chaque manche.';
}

// Path: game.jokers.combo
class _Translations$game$jokers$combo$fr extends Translations$game$jokers$combo$en {
	_Translations$game$jokers$combo$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get name => 'Roi du combo';
	@override String get description => '+1 mult pour chaque coup gagnant d\'affilée.';
}

// Path: game.jokers.patience
class _Translations$game$jokers$patience$fr extends Translations$game$jokers$patience$en {
	_Translations$game$jokers$patience$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get name => 'Patience';
	@override String get description => 'Chaque coup sans ligne met +2 mult en réserve pour la prochaine.';
}

// Path: game.jokers.precision
class _Translations$game$jokers$precision$fr extends Translations$game$jokers$precision$en {
	_Translations$game$jokers$precision$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get name => 'Précision';
	@override String get description => '+6 mult quand une pièce de 1 ou 2 cases complète une ligne.';
}

// Path: game.jokers.collector
class _Translations$game$jokers$collector$fr extends Translations$game$jokers$collector$en {
	_Translations$game$jokers$collector$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get name => 'Collectionneur';
	@override String get description => '+1 mult à chaque ligne pour chaque joker possédé.';
}

// Path: game.jokers.twin
class _Translations$game$jokers$twin$fr extends Translations$game$jokers$twin$en {
	_Translations$game$jokers$twin$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get name => 'Lignes jumelles';
	@override String get description => '×3 mult quand tu effaces 2 lignes ou plus d\'un coup.';
}

// Path: game.jokers.column
class _Translations$game$jokers$column$fr extends Translations$game$jokers$column$en {
	_Translations$game$jokers$column$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get name => 'Chasseur de colonnes';
	@override String get description => '×2 mult quand ton coup efface une colonne.';
}

// Path: game.jokers.heavy
class _Translations$game$jokers$heavy$fr extends Translations$game$jokers$heavy$en {
	_Translations$game$jokers$heavy$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get name => 'Poids lourd';
	@override String get description => '×2 mult quand une pièce de 4 cases ou plus complète une ligne.';
}

// Path: game.jokers.sweep
class _Translations$game$jokers$sweep$fr extends Translations$game$jokers$sweep$en {
	_Translations$game$jokers$sweep$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get name => 'Grand ménage';
	@override String get description => '+500 points quand le plateau se vide entièrement.';
}

// Path: game.jokers.quarry
class _Translations$game$jokers$quarry$fr extends Translations$game$jokers$quarry$en {
	_Translations$game$jokers$quarry$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get name => 'Carrière';
	@override String get description => 'Chaque ligne effacée fait tomber une pierre sur une case vide au hasard.';
}

// Path: game.jokers.bigbox
class _Translations$game$jokers$bigbox$fr extends Translations$game$jokers$bigbox$en {
	_Translations$game$jokers$bigbox$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get name => 'Grande boîte';
	@override String get description => 'Les pièces de 5 cases ou plus arrivent 3× plus souvent.';
}

// Path: game.jokers.tiny
class _Translations$game$jokers$tiny$fr extends Translations$game$jokers$tiny$en {
	_Translations$game$jokers$tiny$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get name => 'Petits outils';
	@override String get description => 'Les pièces de 1 ou 2 cases arrivent 3× plus souvent.';
}

// Path: game.jokers.pockets
class _Translations$game$jokers$pockets$fr extends Translations$game$jokers$pockets$en {
	_Translations$game$jokers$pockets$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get name => 'Poches profondes';
	@override String get description => '+4 pièces à chaque manche.';
}

// Path: game.jokers.saver
class _Translations$game$jokers$saver$fr extends Translations$game$jokers$saver$en {
	_Translations$game$jokers$saver$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get name => 'Épargnant';
	@override String get description => 'Chaque pièce inutilisée quand tu gagnes une manche rapporte +40 points de partie.';
}

/// The flat map containing all translations for locale <fr>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsFr {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'game.title' => 'Blockmancer',
			'game.subtitle' => 'Partie du jour · les mêmes pièces pour tous',
			'game.practiceSubtitle' => 'Entraînement · une partie neuve à chaque fois',
			'game.leave' => 'Retour au menu',
			'game.runTotal' => ({required Object total}) => 'Partie ${total}',
			'game.round.regular' => ({required Object index, required Object count}) => 'Manche · ${index} / ${count}',
			'game.round.boss' => 'Boss · Gravats',
			'game.round.target' => ({required Object target}) => '/ ${target}',
			'game.round.piecesLeft' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('fr'))(count, one: '${count} pièce restante', other: '${count} pièces restantes', ), 
			'game.round.combo' => ({required Object streak}) => 'Combo ×${streak}',
			'game.round.storedMult' => ({required Object mult}) => '+${mult} mult en réserve',
			'game.banner.clear' => ({required Object chips, required Object mult, required Object total}) => '${chips} jetons × ${mult} mult = ${total}',
			'game.banner.placed' => ({required Object points}) => '+${points}',
			'game.banner.bonus' => ({required Object points}) => '+${points} bonus',
			'game.banner.fired' => ({required Object joker, required Object effect}) => '${joker} ${effect}',
			'game.banner.chipsAdded' => ({required Object amount}) => '+${amount} jetons',
			'game.banner.multAdded' => ({required Object amount}) => '+${amount} mult',
			'game.banner.multMultiplied' => ({required Object factor}) => '×${factor} mult',
			'game.banner.multStored' => ({required Object total}) => 'mult en réserve · ${total} prêts',
			'game.banner.pointsAdded' => ({required Object amount}) => '+${amount}',
			'game.banner.runPointsAdded' => ({required Object amount}) => '+${amount} points de partie',
			'game.banner.stoneDropped' => 'nouvelle pierre',
			'game.banner.piecesAdded' => ({required Object amount}) => '+${amount} pièces',
			'game.banner.stonesAdded' => ({required Object amount}) => '+${amount} pierres',
			'game.offers.startTitle' => 'Choisis ton joker de départ',
			'game.offers.startSubtitle' => 'Les jokers vont par paires. Tu en choisis un de plus après chaque manche : prépare ta combinaison.',
			'game.offers.roundTitle' => 'Manche gagnée !',
			'game.offers.saverBonus' => ({required Object points}) => 'Épargnant +${points}',
			'game.offers.nextRound' => ({required Object index, required Object target}) => 'Choisis un joker. Ensuite : manche ${index} · ${target} pts.',
			'game.offers.nextBoss' => ({required Object target}) => 'Choisis un joker. Ensuite : Boss · ${target} pts avec des pierres.',
			'game.offers.build' => ({required Object jokers}) => 'Ta combinaison : ${jokers}',
			'game.offers.completesPair' => ({required Object joker}) => '★ Complète une paire avec ton ${joker}',
			'game.offers.pairsWith' => ({required Object joker}) => 'Va avec : ${joker}',
			'game.offers.take' => 'Prendre',
			'game.lost.outOfPieces' => 'Plus de pièces',
			'game.lost.noRoom' => 'Plus de place',
			'game.lost.progress' => ({required Object score, required Object target}) => '${score} sur ${target} points cette manche.',
			'game.lost.revive' => ({required Object rows, required Object pieces}) => 'Relancer · ${rows} lignes vidées + ${pieces} pièces',
			'game.lost.endRun' => 'Terminer la partie',
			'game.end.won' => 'Boss vaincu · partie terminée',
			'game.end.overRound' => ({required Object index}) => 'Partie finie · manche ${index} atteinte',
			'game.end.overBoss' => 'Partie finie · boss atteint',
			'game.end.total' => ({required Object total}) => '${total} points',
			'game.end.build' => ({required Object jokers}) => 'Combinaison : ${jokers}',
			'game.end.noJokers' => 'aucune',
			'game.end.best' => ({required Object points}) => 'Record : ${points}',
			'game.end.newBest' => 'Nouveau record !',
			'game.end.retry' => 'Rejouer',
			'game.jokers.stonemason.name' => 'Tailleur de pierre',
			'game.jokers.stonemason.description' => '+50 jetons par pierre effacée. 2 pierres de plus à chaque manche.',
			'game.jokers.combo.name' => 'Roi du combo',
			'game.jokers.combo.description' => '+1 mult pour chaque coup gagnant d\'affilée.',
			'game.jokers.patience.name' => 'Patience',
			'game.jokers.patience.description' => 'Chaque coup sans ligne met +2 mult en réserve pour la prochaine.',
			'game.jokers.precision.name' => 'Précision',
			'game.jokers.precision.description' => '+6 mult quand une pièce de 1 ou 2 cases complète une ligne.',
			'game.jokers.collector.name' => 'Collectionneur',
			'game.jokers.collector.description' => '+1 mult à chaque ligne pour chaque joker possédé.',
			'game.jokers.twin.name' => 'Lignes jumelles',
			'game.jokers.twin.description' => '×3 mult quand tu effaces 2 lignes ou plus d\'un coup.',
			'game.jokers.column.name' => 'Chasseur de colonnes',
			'game.jokers.column.description' => '×2 mult quand ton coup efface une colonne.',
			'game.jokers.heavy.name' => 'Poids lourd',
			'game.jokers.heavy.description' => '×2 mult quand une pièce de 4 cases ou plus complète une ligne.',
			'game.jokers.sweep.name' => 'Grand ménage',
			'game.jokers.sweep.description' => '+500 points quand le plateau se vide entièrement.',
			'game.jokers.quarry.name' => 'Carrière',
			'game.jokers.quarry.description' => 'Chaque ligne effacée fait tomber une pierre sur une case vide au hasard.',
			'game.jokers.bigbox.name' => 'Grande boîte',
			'game.jokers.bigbox.description' => 'Les pièces de 5 cases ou plus arrivent 3× plus souvent.',
			'game.jokers.tiny.name' => 'Petits outils',
			'game.jokers.tiny.description' => 'Les pièces de 1 ou 2 cases arrivent 3× plus souvent.',
			'game.jokers.pockets.name' => 'Poches profondes',
			'game.jokers.pockets.description' => '+4 pièces à chaque manche.',
			'game.jokers.saver.name' => 'Épargnant',
			'game.jokers.saver.description' => 'Chaque pièce inutilisée quand tu gagnes une manche rapporte +40 points de partie.',
			'push.channelName' => 'Annonces',
			'push.channelDescription' => 'Nouvelles et messages de l\'application.',
			'home.tabLabel' => 'Jouer',
			'home.title' => 'Blockmancer',
			'home.tagline' => 'Posez des pièces, effacez des lignes, combinez vos jokers.',
			'home.daily.title' => 'Partie du jour',
			'home.daily.subtitle' => 'Les mêmes pièces pour tous aujourd\'hui',
			'home.practice.title' => 'Entraînement',
			'home.practice.subtitle' => 'Une partie neuve à chaque fois',
			'home.best' => ({required Object points}) => 'Record : ${points}',
			'home.noBest' => 'Pas encore de partie',
			_ => null,
		};
	}
}
