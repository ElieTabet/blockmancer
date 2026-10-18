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
	@override late final _Translations$settings$fr settings = _Translations$settings$fr._(_root);
}

// Path: game
class _Translations$game$fr extends Translations$game$en {
	_Translations$game$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Blockmancer';
	@override String get subtitle => 'Partie du jour · les mêmes pièces pour tout le monde';
	@override String get practiceSubtitle => 'Entraînement · une nouvelle partie à chaque fois';
	@override String worldSubtitle({required Object world}) => '${world} · gagne ses trois étoiles';
	@override String get leave => 'Retour au menu';
	@override late final _Translations$game$tutorial$fr tutorial = _Translations$game$tutorial$fr._(_root);
	@override String runTotal({required Object total}) => 'Partie : ${total}';
	@override late final _Translations$game$round$fr round = _Translations$game$round$fr._(_root);
	@override late final _Translations$game$banner$fr banner = _Translations$game$banner$fr._(_root);
	@override late final _Translations$game$offers$fr offers = _Translations$game$offers$fr._(_root);
	@override late final _Translations$game$bossCard$fr bossCard = _Translations$game$bossCard$fr._(_root);
	@override late final _Translations$game$lost$fr lost = _Translations$game$lost$fr._(_root);
	@override late final _Translations$game$end$fr end = _Translations$game$end$fr._(_root);
	@override late final _Translations$game$unlocks$fr unlocks = _Translations$game$unlocks$fr._(_root);
	@override late final _Translations$game$worlds$fr worlds = _Translations$game$worlds$fr._(_root);
	@override late final _Translations$game$jokers$fr jokers = _Translations$game$jokers$fr._(_root);
}

// Path: push
class _Translations$push$fr extends Translations$push$en {
	_Translations$push$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get channelName => 'Annonces';
	@override String get channelDescription => 'Les nouveautés et messages de l\'application.';
}

// Path: home
class _Translations$home$fr extends Translations$home$en {
	_Translations$home$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override late final _Translations$home$complete$fr complete = _Translations$home$complete$fr._(_root);
	@override String get tabLabel => 'Jouer';
	@override String get title => 'Blockmancer';
	@override late final _Translations$home$daily$fr daily = _Translations$home$daily$fr._(_root);
	@override late final _Translations$home$resume$fr resume = _Translations$home$resume$fr._(_root);
	@override late final _Translations$home$practice$fr practice = _Translations$home$practice$fr._(_root);
	@override late final _Translations$home$map$fr map = _Translations$home$map$fr._(_root);
	@override late final _Translations$home$sheet$fr sheet = _Translations$home$sheet$fr._(_root);
	@override String best({required Object points}) => 'Record : ${points}';
	@override String get noBest => 'Pas encore de partie';
	@override String get settings => 'Réglages';
	@override late final _Translations$home$spellbook$fr spellbook = _Translations$home$spellbook$fr._(_root);
}

// Path: settings
class _Translations$settings$fr extends Translations$settings$en {
	_Translations$settings$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Réglages';
	@override String get close => 'Fermer';
	@override String get sound => 'Son';
	@override String get haptics => 'Vibrations';
	@override late final _Translations$settings$reduceMotion$fr reduceMotion = _Translations$settings$reduceMotion$fr._(_root);
	@override late final _Translations$settings$language$fr language = _Translations$settings$language$fr._(_root);
	@override late final _Translations$settings$tutorial$fr tutorial = _Translations$settings$tutorial$fr._(_root);
	@override late final _Translations$settings$feedback$fr feedback = _Translations$settings$feedback$fr._(_root);
	@override late final _Translations$settings$testStats$fr testStats = _Translations$settings$testStats$fr._(_root);
	@override String get version => 'Version';
	@override late final _Translations$settings$reset$fr reset = _Translations$settings$reset$fr._(_root);
}

// Path: game.tutorial
class _Translations$game$tutorial$fr extends Translations$game$tutorial$en {
	_Translations$game$tutorial$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get drag => 'Fais glisser une pièce sur le plateau';
	@override String get clear => 'Remplis une ligne pour l\'effacer';
	@override String get score => 'Jetons × mult = score';
	@override String get scoreHint => 'Touche pour continuer';
	@override String get pick => 'Choisis ton premier joker — ils vont par paires';
	@override String get skip => 'Passer';
}

// Path: game.round
class _Translations$game$round$fr extends Translations$game$round$en {
	_Translations$game$round$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String regular({required Object index, required Object count}) => 'Manche · ${index} / ${count}';
	@override String boss({required Object world}) => 'Boss · ${world}';
	@override String target({required Object target}) => '/ ${target}';
	@override String piecesLeft({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('fr'))(count,
		one: '${count} pièce restante',
		other: '${count} pièces restantes',
	);
	@override String combo({required Object streak}) => 'Combo ×${streak}';
	@override String storedMult({required Object mult}) => '+${mult} mult en réserve';
	@override String tideIn({required Object count}) => 'Marée dans ${count}';
}

// Path: game.banner
class _Translations$game$banner$fr extends Translations$game$banner$en {
	_Translations$game$banner$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String chips({required Object chips}) => '${chips} jetons';
	@override String mult({required Object mult}) => '× ${mult} mult';
	@override String product({required Object total}) => '= ${total}';
	@override String placed({required Object points}) => '+${points}';
	@override String bonus({required Object points}) => '+${points} de bonus';
	@override String fired({required Object joker, required Object effect}) => '${joker} ${effect}';
	@override String chipsAdded({required Object amount}) => '+${amount} jetons';
	@override String multAdded({required Object amount}) => '+${amount} mult';
	@override String multMultiplied({required Object factor}) => '×${factor} mult';
	@override String multStored({required Object total}) => 'mult en réserve : ${total}';
	@override String obstaclesRemoved({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('fr'))(count,
		one: '${count} effacée à côté',
		other: '${count} effacées à côté',
	);
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
	@override String get startSubtitle => 'Les jokers fonctionnent par paires. Tu en choisis un de plus après chaque manche, alors pense à la suite.';
	@override String get roundTitle => 'Manche gagnée !';
	@override String saverBonus({required Object points}) => 'Épargnant +${points}';
	@override String nextRound({required Object index, required Object target}) => 'Choisis un joker. À suivre : manche ${index} · ${target} pts.';
	@override late final _Translations$game$offers$nextBoss$fr nextBoss = _Translations$game$offers$nextBoss$fr._(_root);
	@override String build({required Object jokers}) => 'Tes jokers : ${jokers}';
	@override String completesPair({required Object joker}) => '★ Forme une paire avec ${joker}';
	@override String pairsWith({required Object joker}) => 'En paire avec : ${joker}';
	@override String get take => 'Prendre';
}

// Path: game.bossCard
class _Translations$game$bossCard$fr extends Translations$game$bossCard$en {
	_Translations$game$bossCard$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String title({required Object world}) => 'Le boss de ${world}';
	@override String get rubble => 'Le boss commence avec des pierres déjà posées.';
	@override String get gravity => 'Pendant ce boss, chaque pièce tombe aussi bas que possible.';
	@override String get fog => 'Le brouillard cache le plateau. Pose à côté pour voir ce qu\'il y a dessous.';
	@override String get tide => 'À chaque nouvelle main, la marée monte d\'une ligne. Ne la laisse pas pousser tes blocs hors du plateau.';
	@override String get mirror => 'Tout ce que tu poses atterrit en miroir.';
	@override String get ok => 'Compris';
}

// Path: game.lost
class _Translations$game$lost$fr extends Translations$game$lost$en {
	_Translations$game$lost$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get outOfPieces => 'Plus de pièces';
	@override String get noRoom => 'Plus de place';
	@override String get flooded => 'Submergé';
	@override String progress({required Object score, required Object target}) => '${score} points sur ${target} pour cette manche.';
	@override String revive({required Object rows, required Object pieces}) => 'Continuer · ${rows} lignes effacées + ${pieces} pièces';
	@override String get endRun => 'Terminer la partie';
}

// Path: game.end
class _Translations$game$end$fr extends Translations$game$end$en {
	_Translations$game$end$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get won => 'Boss vaincu · partie réussie';
	@override String overRound({required Object index}) => 'Fin de partie · manche ${index} atteinte';
	@override String get overBoss => 'Fin de partie · boss atteint';
	@override String total({required Object total}) => '${total} points';
	@override String build({required Object jokers}) => 'Jokers : ${jokers}';
	@override String get noJokers => 'aucun';
	@override String best({required Object points}) => 'Record : ${points}';
	@override String get newBest => 'Nouveau record !';
	@override String get retry => 'Rejouer';
	@override late final _Translations$game$end$stars$fr stars = _Translations$game$end$stars$fr._(_root);
}

// Path: game.unlocks
class _Translations$game$unlocks$fr extends Translations$game$unlocks$en {
	_Translations$game$unlocks$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get label => 'Débloqué';
	@override String newWorld({required Object world}) => 'Nouveau monde : ${world}';
	@override String get newJokers => 'Nouveaux jokers';
	@override String get jokersNote => 'Ces jokers peuvent maintenant apparaître dans tes parties.';
	@override String get next => 'Continuer';
}

// Path: game.worlds
class _Translations$game$worlds$fr extends Translations$game$worlds$en {
	_Translations$game$worlds$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get rubble => 'Gravats';
	@override String get gravity => 'Gravité';
	@override String get fog => 'Brouillard';
	@override String get tide => 'Marée';
	@override String get mirror => 'Miroir';
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
	@override late final _Translations$game$jokers$anchor$fr anchor = _Translations$game$jokers$anchor$fr._(_root);
	@override late final _Translations$game$jokers$avalanche$fr avalanche = _Translations$game$jokers$avalanche$fr._(_root);
	@override late final _Translations$game$jokers$fullhouse$fr fullhouse = _Translations$game$jokers$fullhouse$fr._(_root);
	@override late final _Translations$game$jokers$brink$fr brink = _Translations$game$jokers$brink$fr._(_root);
	@override late final _Translations$game$jokers$finisher$fr finisher = _Translations$game$jokers$finisher$fr._(_root);
	@override late final _Translations$game$jokers$hattrick$fr hattrick = _Translations$game$jokers$hattrick$fr._(_root);
	@override late final _Translations$game$jokers$lantern$fr lantern = _Translations$game$jokers$lantern$fr._(_root);
	@override late final _Translations$game$jokers$ember$fr ember = _Translations$game$jokers$ember$fr._(_root);
	@override late final _Translations$game$jokers$sprinter$fr sprinter = _Translations$game$jokers$sprinter$fr._(_root);
	@override late final _Translations$game$jokers$momentum$fr momentum = _Translations$game$jokers$momentum$fr._(_root);
	@override late final _Translations$game$jokers$symmetry$fr symmetry = _Translations$game$jokers$symmetry$fr._(_root);
	@override late final _Translations$game$jokers$prism$fr prism = _Translations$game$jokers$prism$fr._(_root);
}

// Path: home.complete
class _Translations$home$complete$fr extends Translations$home$complete$en {
	_Translations$home$complete$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Tous les mondes terminés';
	@override String body({required Object count}) => 'Tous les boss sont battus : les ${count} mondes sont à toi.';
	@override String stars({required Object stars, required Object max}) => '${stars} étoiles sur ${max}';
	@override String get ok => 'Continuer';
}

// Path: home.daily
class _Translations$home$daily$fr extends Translations$home$daily$en {
	_Translations$home$daily$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Partie du jour';
	@override String get subtitle => 'Aujourd\'hui, les mêmes pièces pour tout le monde';
	@override String get play => 'Jouer';
}

// Path: home.resume
class _Translations$home$resume$fr extends Translations$home$resume$en {
	_Translations$home$resume$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Reprendre la partie';
	@override String get subtitle => 'Reprends là où tu en étais';
}

// Path: home.practice
class _Translations$home$practice$fr extends Translations$home$practice$en {
	_Translations$home$practice$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Entraînement';
}

// Path: home.map
class _Translations$home$map$fr extends Translations$home$map$en {
	_Translations$home$map$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Les mondes';
	@override String get here => 'Tu es ici';
	@override String get done => 'Boss vaincu';
	@override String get locked => 'Verrouillé';
	@override String get comingSoon => 'Bientôt';
	@override String stars({required Object count}) => 'Étoiles : ${count} sur 3';
}

// Path: home.sheet
class _Translations$home$sheet$fr extends Translations$home$sheet$en {
	_Translations$home$sheet$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get done => 'Terminé';
	@override String get current => 'En cours';
	@override String get bossCard => 'Comment se joue le boss';
	@override late final _Translations$home$sheet$bossRule$fr bossRule = _Translations$home$sheet$bossRule$fr._(_root);
	@override String bossTarget({required Object points}) => 'Bats le boss : ${points} points';
	@override String get stars => 'Étoiles';
	@override String threshold({required Object points}) => 'Atteins ${points} points en une partie';
	@override String get unlocks => 'Battre son boss débloque';
	@override String get start => 'Lancer la partie';
	@override String get replay => 'Rejouer pour l\'étoile manquante';
	@override String get lockedHint => 'Bats le boss précédent pour le débloquer';
}

// Path: home.spellbook
class _Translations$home$spellbook$fr extends Translations$home$spellbook$en {
	_Translations$home$spellbook$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Grimoire';
	@override String get open => 'Grimoire';
	@override String get close => 'Fermer';
	@override String progress({required Object unlocked, required Object total}) => '${unlocked} jokers débloqués sur ${total}';
	@override String partner({required Object name}) => 'Fait la paire avec ${name}';
	@override String get picked => 'Choisi';
	@override String get wins => 'Victoires';
	@override String get best => 'Record';
	@override String get locked => 'Verrouillé';
	@override String unlockBoss({required Object world}) => 'Bats le boss de ${world}';
	@override String unlockStars({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('fr'))(count,
		one: 'Récolte 1 étoile',
		other: 'Récolte ${count} étoiles',
	);
}

// Path: settings.reduceMotion
class _Translations$settings$reduceMotion$fr extends Translations$settings$reduceMotion$en {
	_Translations$settings$reduceMotion$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Réduire les animations';
	@override String get subtitle => 'Des animations plus douces, sans tremblement de l\'écran';
}

// Path: settings.language
class _Translations$settings$language$fr extends Translations$settings$language$en {
	_Translations$settings$language$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Langue';
	@override String get system => 'Système';
	@override String get en => 'English';
	@override String get fr => 'Français';
}

// Path: settings.tutorial
class _Translations$settings$tutorial$fr extends Translations$settings$tutorial$en {
	_Translations$settings$tutorial$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Revoir le tutoriel';
	@override String get subtitle => 'Comment jouer, pas à pas';
}

// Path: settings.feedback
class _Translations$settings$feedback$fr extends Translations$settings$feedback$en {
	_Translations$settings$feedback$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Envoyer un avis';
	@override String get subtitle => 'Ouvre un e-mail à l\'équipe';
	@override String get unavailableTitle => 'Pas d\'app de mail';
	@override String unavailableMessage({required Object address}) => 'Impossible d\'ouvrir une app de mail. Écris-nous à ${address}.';
	@override String get ok => 'OK';
}

// Path: settings.testStats
class _Translations$settings$testStats$fr extends Translations$settings$testStats$en {
	_Translations$settings$testStats$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Partager les stats de test';
	@override String get subtitle => 'Envoie à l\'équipe comment tu joues';
	@override String get unavailableTitle => 'Partage impossible';
	@override String get unavailableMessage => 'La feuille de partage ne s\'est pas ouverte. Réessaie dans un instant.';
	@override String get ok => 'OK';
}

// Path: settings.reset
class _Translations$settings$reset$fr extends Translations$settings$reset$en {
	_Translations$settings$reset$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Réinitialiser la progression';
	@override String get subtitle => 'Tes records et la partie en cours';
	@override String get confirmTitle => 'Réinitialiser la progression ?';
	@override String get confirmMessage => 'Tes records et la partie en cours seront effacés. Impossible de revenir en arrière.';
	@override String get confirm => 'Réinitialiser';
	@override String get cancel => 'Annuler';
}

// Path: game.offers.nextBoss
class _Translations$game$offers$nextBoss$fr extends Translations$game$offers$nextBoss$en {
	_Translations$game$offers$nextBoss$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String rubble({required Object target}) => 'Choisis un joker. À suivre : le boss · ${target} pts, avec des pierres.';
	@override String gravity({required Object target}) => 'Choisis un joker. À suivre : le boss · ${target} pts, et les pièces tombent.';
	@override String fog({required Object target}) => 'Choisis un joker. À suivre : le boss · ${target} pts, dans le brouillard.';
	@override String tide({required Object target}) => 'Choisis un joker. À suivre : le boss · ${target} pts, quand la marée monte.';
	@override String mirror({required Object target}) => 'Choisis un joker. À suivre : le boss · ${target} pts, dans le miroir.';
}

// Path: game.end.stars
class _Translations$game$end$stars$fr extends Translations$game$end$stars$en {
	_Translations$game$end$stars$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get bossBeaten => 'Bats le boss';
	@override String get noRevive => 'Bats le boss sans seconde chance';
	@override String threshold({required Object points}) => 'Atteins ${points}';
	@override String get earned => 'Étoile gagnée';
	@override String get newStar => 'Nouvelle étoile';
	@override String get missing => 'Étoile pas encore gagnée';
}

// Path: game.jokers.stonemason
class _Translations$game$jokers$stonemason$fr extends Translations$game$jokers$stonemason$en {
	_Translations$game$jokers$stonemason$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get name => 'Tailleur de pierre';
	@override String description({required num stones, required Object chips}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('fr'))(stones,
		one: '+${chips} jetons par pierre effacée. ${stones} pierre de plus à chaque manche.',
		other: '+${chips} jetons par pierre effacée. ${stones} pierres de plus à chaque manche.',
	);
}

// Path: game.jokers.combo
class _Translations$game$jokers$combo$fr extends Translations$game$jokers$combo$en {
	_Translations$game$jokers$combo$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get name => 'Roi du combo';
	@override String description({required Object mult}) => '+${mult} mult par coup d\'affilée qui efface une ligne.';
}

// Path: game.jokers.patience
class _Translations$game$jokers$patience$fr extends Translations$game$jokers$patience$en {
	_Translations$game$jokers$patience$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get name => 'Patience';
	@override String description({required Object mult}) => 'Chaque coup qui n\'efface rien met +${mult} mult de côté pour ta prochaine ligne.';
}

// Path: game.jokers.precision
class _Translations$game$jokers$precision$fr extends Translations$game$jokers$precision$en {
	_Translations$game$jokers$precision$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get name => 'Précision';
	@override String description({required Object mult, required Object size}) => '+${mult} mult quand une pièce de ${size} cases au plus complète une ligne.';
}

// Path: game.jokers.collector
class _Translations$game$jokers$collector$fr extends Translations$game$jokers$collector$en {
	_Translations$game$jokers$collector$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get name => 'Collectionneur';
	@override String description({required Object mult}) => 'À chaque ligne effacée, +${mult} mult pour chaque paire de jokers que tu as.';
}

// Path: game.jokers.twin
class _Translations$game$jokers$twin$fr extends Translations$game$jokers$twin$en {
	_Translations$game$jokers$twin$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get name => 'Lignes jumelles';
	@override String description({required Object factor, required Object lines}) => '×${factor} mult quand tu effaces ${lines} lignes ou plus d\'un coup.';
}

// Path: game.jokers.column
class _Translations$game$jokers$column$fr extends Translations$game$jokers$column$en {
	_Translations$game$jokers$column$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get name => 'Chasseur de colonnes';
	@override String description({required Object factor}) => '×${factor} mult quand ton coup efface une colonne.';
}

// Path: game.jokers.heavy
class _Translations$game$jokers$heavy$fr extends Translations$game$jokers$heavy$en {
	_Translations$game$jokers$heavy$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get name => 'Poids lourd';
	@override String description({required Object factor, required Object size}) => '×${factor} mult quand une pièce de ${size} cases ou plus complète une ligne.';
}

// Path: game.jokers.sweep
class _Translations$game$jokers$sweep$fr extends Translations$game$jokers$sweep$en {
	_Translations$game$jokers$sweep$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get name => 'Grand ménage';
	@override String description({required Object points}) => '+${points} points quand tu vides entièrement le plateau.';
}

// Path: game.jokers.quarry
class _Translations$game$jokers$quarry$fr extends Translations$game$jokers$quarry$en {
	_Translations$game$jokers$quarry$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get name => 'Carrière';
	@override String description({required num stones}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('fr'))(stones,
		one: 'Chaque ligne effacée fait tomber une pierre sur une case vide au hasard.',
		other: 'Chaque ligne effacée fait tomber ${stones} pierres sur des cases vides au hasard.',
	);
}

// Path: game.jokers.bigbox
class _Translations$game$jokers$bigbox$fr extends Translations$game$jokers$bigbox$en {
	_Translations$game$jokers$bigbox$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get name => 'Grand format';
	@override String description({required Object size, required Object factor}) => 'Les pièces de ${size} cases ou plus arrivent ${factor}× plus souvent.';
}

// Path: game.jokers.tiny
class _Translations$game$jokers$tiny$fr extends Translations$game$jokers$tiny$en {
	_Translations$game$jokers$tiny$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get name => 'Petits outils';
	@override String description({required Object size, required Object factor}) => 'Les pièces de ${size} cases au plus arrivent ${factor}× plus souvent.';
}

// Path: game.jokers.pockets
class _Translations$game$jokers$pockets$fr extends Translations$game$jokers$pockets$en {
	_Translations$game$jokers$pockets$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get name => 'Poches pleines';
	@override String description({required num pieces}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('fr'))(pieces,
		one: '+${pieces} pièce à chaque manche.',
		other: '+${pieces} pièces à chaque manche.',
	);
}

// Path: game.jokers.saver
class _Translations$game$jokers$saver$fr extends Translations$game$jokers$saver$en {
	_Translations$game$jokers$saver$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get name => 'Épargnant';
	@override String description({required Object points}) => 'Chaque pièce non jouée à la fin d\'une manche gagnée rapporte +${points} points de partie.';
}

// Path: game.jokers.anchor
class _Translations$game$jokers$anchor$fr extends Translations$game$jokers$anchor$en {
	_Translations$game$jokers$anchor$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get name => 'Ancre';
	@override String description({required Object mult}) => '+${mult} mult quand ton coup efface la ligne du bas.';
}

// Path: game.jokers.avalanche
class _Translations$game$jokers$avalanche$fr extends Translations$game$jokers$avalanche$en {
	_Translations$game$jokers$avalanche$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get name => 'Avalanche';
	@override String description({required num rows, required Object chips}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('fr'))(rows,
		one: 'Après chaque ligne effacée, +${chips} jetons par case pleine restée dans la ligne du bas.',
		other: 'Après chaque ligne effacée, +${chips} jetons par case pleine restée dans les ${rows} lignes du bas.',
	);
}

// Path: game.jokers.fullhouse
class _Translations$game$jokers$fullhouse$fr extends Translations$game$jokers$fullhouse$en {
	_Translations$game$jokers$fullhouse$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get name => 'Salle comble';
	@override String description({required Object mult, required Object cells}) => '+${mult} mult toutes les ${cells} cases occupées, pierres comprises, quand ta pièce se pose.';
}

// Path: game.jokers.brink
class _Translations$game$jokers$brink$fr extends Translations$game$jokers$brink$en {
	_Translations$game$jokers$brink$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get name => 'Sur le fil';
	@override String description({required Object factor, required Object cells}) => '×${factor} mult si ${cells} cases ou plus sont occupées, pierres comprises, quand ta pièce se pose.';
}

// Path: game.jokers.finisher
class _Translations$game$jokers$finisher$fr extends Translations$game$jokers$finisher$en {
	_Translations$game$jokers$finisher$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get name => 'Finisseur';
	@override String description({required Object factor}) => '×${factor} mult quand tu joues la dernière pièce de ta main.';
}

// Path: game.jokers.hattrick
class _Translations$game$jokers$hattrick$fr extends Translations$game$jokers$hattrick$en {
	_Translations$game$jokers$hattrick$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get name => 'Coup du chapeau';
	@override String description({required Object points, required Object pieces}) => '+${points} points quand chacune des ${pieces} pièces d\'une main complète efface une ligne.';
}

// Path: game.jokers.lantern
class _Translations$game$jokers$lantern$fr extends Translations$game$jokers$lantern$en {
	_Translations$game$jokers$lantern$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get name => 'Lanterne';
	@override String get description => 'Les pierres et le brouillard à côté d\'une ligne effacée partent avec elle.';
}

// Path: game.jokers.ember
class _Translations$game$jokers$ember$fr extends Translations$game$jokers$ember$en {
	_Translations$game$jokers$ember$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get name => 'Braise';
	@override String description({required Object mult, required Object factor}) => '+${mult} mult à chaque ligne effacée, et ×${factor} quand ton coup retire une pierre ou une case de brouillard.';
}

// Path: game.jokers.sprinter
class _Translations$game$jokers$sprinter$fr extends Translations$game$jokers$sprinter$en {
	_Translations$game$jokers$sprinter$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get name => 'Sprinteur';
	@override String description({required Object mult}) => '+${mult} mult quand la première pièce d\'une nouvelle main efface une ligne.';
}

// Path: game.jokers.momentum
class _Translations$game$jokers$momentum$fr extends Translations$game$jokers$momentum$en {
	_Translations$game$jokers$momentum$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get name => 'Élan';
	@override String description({required Object mult}) => 'À chaque ligne effacée, +${mult} mult par main d\'affilée dont la première pièce a effacé une ligne.';
}

// Path: game.jokers.symmetry
class _Translations$game$jokers$symmetry$fr extends Translations$game$jokers$symmetry$en {
	_Translations$game$jokers$symmetry$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get name => 'Symétrie';
	@override String description({required Object mult}) => '+${mult} mult quand ta ligne laisse le plateau symétrique, et pas vide.';
}

// Path: game.jokers.prism
class _Translations$game$jokers$prism$fr extends Translations$game$jokers$prism$en {
	_Translations$game$jokers$prism$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get name => 'Prisme';
	@override String description({required Object chips}) => '+${chips} jetons par case pleine ou pierre dont la case miroir l\'est aussi, après une ligne effacée.';
}

// Path: home.sheet.bossRule
class _Translations$home$sheet$bossRule$fr extends Translations$home$sheet$bossRule$en {
	_Translations$home$sheet$bossRule$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get rubble => 'Le boss commence avec des pierres sur le plateau.';
	@override String get fog => 'Le brouillard cache des cases. Pose à côté pour voir ce qu\'il y a dessous.';
	@override String get tide => 'À chaque nouvelle main, la marée monte d\'une ligne. Ne la laisse pas pousser tes blocs hors du plateau.';
	@override String get mirror => 'Tout ce que tu poses atterrit en miroir.';
	@override String get gravity => 'Pendant la manche du boss, chaque pièce tombe tout en bas.';
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
			'game.subtitle' => 'Partie du jour · les mêmes pièces pour tout le monde',
			'game.practiceSubtitle' => 'Entraînement · une nouvelle partie à chaque fois',
			'game.worldSubtitle' => ({required Object world}) => '${world} · gagne ses trois étoiles',
			'game.leave' => 'Retour au menu',
			'game.tutorial.drag' => 'Fais glisser une pièce sur le plateau',
			'game.tutorial.clear' => 'Remplis une ligne pour l\'effacer',
			'game.tutorial.score' => 'Jetons × mult = score',
			'game.tutorial.scoreHint' => 'Touche pour continuer',
			'game.tutorial.pick' => 'Choisis ton premier joker — ils vont par paires',
			'game.tutorial.skip' => 'Passer',
			'game.runTotal' => ({required Object total}) => 'Partie : ${total}',
			'game.round.regular' => ({required Object index, required Object count}) => 'Manche · ${index} / ${count}',
			'game.round.boss' => ({required Object world}) => 'Boss · ${world}',
			'game.round.target' => ({required Object target}) => '/ ${target}',
			'game.round.piecesLeft' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('fr'))(count, one: '${count} pièce restante', other: '${count} pièces restantes', ), 
			'game.round.combo' => ({required Object streak}) => 'Combo ×${streak}',
			'game.round.storedMult' => ({required Object mult}) => '+${mult} mult en réserve',
			'game.round.tideIn' => ({required Object count}) => 'Marée dans ${count}',
			'game.banner.chips' => ({required Object chips}) => '${chips} jetons',
			'game.banner.mult' => ({required Object mult}) => '× ${mult} mult',
			'game.banner.product' => ({required Object total}) => '= ${total}',
			'game.banner.placed' => ({required Object points}) => '+${points}',
			'game.banner.bonus' => ({required Object points}) => '+${points} de bonus',
			'game.banner.fired' => ({required Object joker, required Object effect}) => '${joker} ${effect}',
			'game.banner.chipsAdded' => ({required Object amount}) => '+${amount} jetons',
			'game.banner.multAdded' => ({required Object amount}) => '+${amount} mult',
			'game.banner.multMultiplied' => ({required Object factor}) => '×${factor} mult',
			'game.banner.multStored' => ({required Object total}) => 'mult en réserve : ${total}',
			'game.banner.obstaclesRemoved' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('fr'))(count, one: '${count} effacée à côté', other: '${count} effacées à côté', ), 
			'game.banner.pointsAdded' => ({required Object amount}) => '+${amount}',
			'game.banner.runPointsAdded' => ({required Object amount}) => '+${amount} points de partie',
			'game.banner.stoneDropped' => 'nouvelle pierre',
			'game.banner.piecesAdded' => ({required Object amount}) => '+${amount} pièces',
			'game.banner.stonesAdded' => ({required Object amount}) => '+${amount} pierres',
			'game.offers.startTitle' => 'Choisis ton joker de départ',
			'game.offers.startSubtitle' => 'Les jokers fonctionnent par paires. Tu en choisis un de plus après chaque manche, alors pense à la suite.',
			'game.offers.roundTitle' => 'Manche gagnée !',
			'game.offers.saverBonus' => ({required Object points}) => 'Épargnant +${points}',
			'game.offers.nextRound' => ({required Object index, required Object target}) => 'Choisis un joker. À suivre : manche ${index} · ${target} pts.',
			'game.offers.nextBoss.rubble' => ({required Object target}) => 'Choisis un joker. À suivre : le boss · ${target} pts, avec des pierres.',
			'game.offers.nextBoss.gravity' => ({required Object target}) => 'Choisis un joker. À suivre : le boss · ${target} pts, et les pièces tombent.',
			'game.offers.nextBoss.fog' => ({required Object target}) => 'Choisis un joker. À suivre : le boss · ${target} pts, dans le brouillard.',
			'game.offers.nextBoss.tide' => ({required Object target}) => 'Choisis un joker. À suivre : le boss · ${target} pts, quand la marée monte.',
			'game.offers.nextBoss.mirror' => ({required Object target}) => 'Choisis un joker. À suivre : le boss · ${target} pts, dans le miroir.',
			'game.offers.build' => ({required Object jokers}) => 'Tes jokers : ${jokers}',
			'game.offers.completesPair' => ({required Object joker}) => '★ Forme une paire avec ${joker}',
			'game.offers.pairsWith' => ({required Object joker}) => 'En paire avec : ${joker}',
			'game.offers.take' => 'Prendre',
			'game.bossCard.title' => ({required Object world}) => 'Le boss de ${world}',
			'game.bossCard.rubble' => 'Le boss commence avec des pierres déjà posées.',
			'game.bossCard.gravity' => 'Pendant ce boss, chaque pièce tombe aussi bas que possible.',
			'game.bossCard.fog' => 'Le brouillard cache le plateau. Pose à côté pour voir ce qu\'il y a dessous.',
			'game.bossCard.tide' => 'À chaque nouvelle main, la marée monte d\'une ligne. Ne la laisse pas pousser tes blocs hors du plateau.',
			'game.bossCard.mirror' => 'Tout ce que tu poses atterrit en miroir.',
			'game.bossCard.ok' => 'Compris',
			'game.lost.outOfPieces' => 'Plus de pièces',
			'game.lost.noRoom' => 'Plus de place',
			'game.lost.flooded' => 'Submergé',
			'game.lost.progress' => ({required Object score, required Object target}) => '${score} points sur ${target} pour cette manche.',
			'game.lost.revive' => ({required Object rows, required Object pieces}) => 'Continuer · ${rows} lignes effacées + ${pieces} pièces',
			'game.lost.endRun' => 'Terminer la partie',
			'game.end.won' => 'Boss vaincu · partie réussie',
			'game.end.overRound' => ({required Object index}) => 'Fin de partie · manche ${index} atteinte',
			'game.end.overBoss' => 'Fin de partie · boss atteint',
			'game.end.total' => ({required Object total}) => '${total} points',
			'game.end.build' => ({required Object jokers}) => 'Jokers : ${jokers}',
			'game.end.noJokers' => 'aucun',
			'game.end.best' => ({required Object points}) => 'Record : ${points}',
			'game.end.newBest' => 'Nouveau record !',
			'game.end.retry' => 'Rejouer',
			'game.end.stars.bossBeaten' => 'Bats le boss',
			'game.end.stars.noRevive' => 'Bats le boss sans seconde chance',
			'game.end.stars.threshold' => ({required Object points}) => 'Atteins ${points}',
			'game.end.stars.earned' => 'Étoile gagnée',
			'game.end.stars.newStar' => 'Nouvelle étoile',
			'game.end.stars.missing' => 'Étoile pas encore gagnée',
			'game.unlocks.label' => 'Débloqué',
			'game.unlocks.newWorld' => ({required Object world}) => 'Nouveau monde : ${world}',
			'game.unlocks.newJokers' => 'Nouveaux jokers',
			'game.unlocks.jokersNote' => 'Ces jokers peuvent maintenant apparaître dans tes parties.',
			'game.unlocks.next' => 'Continuer',
			'game.worlds.rubble' => 'Gravats',
			'game.worlds.gravity' => 'Gravité',
			'game.worlds.fog' => 'Brouillard',
			'game.worlds.tide' => 'Marée',
			'game.worlds.mirror' => 'Miroir',
			'game.jokers.stonemason.name' => 'Tailleur de pierre',
			'game.jokers.stonemason.description' => ({required num stones, required Object chips}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('fr'))(stones, one: '+${chips} jetons par pierre effacée. ${stones} pierre de plus à chaque manche.', other: '+${chips} jetons par pierre effacée. ${stones} pierres de plus à chaque manche.', ), 
			'game.jokers.combo.name' => 'Roi du combo',
			'game.jokers.combo.description' => ({required Object mult}) => '+${mult} mult par coup d\'affilée qui efface une ligne.',
			'game.jokers.patience.name' => 'Patience',
			'game.jokers.patience.description' => ({required Object mult}) => 'Chaque coup qui n\'efface rien met +${mult} mult de côté pour ta prochaine ligne.',
			'game.jokers.precision.name' => 'Précision',
			'game.jokers.precision.description' => ({required Object mult, required Object size}) => '+${mult} mult quand une pièce de ${size} cases au plus complète une ligne.',
			'game.jokers.collector.name' => 'Collectionneur',
			'game.jokers.collector.description' => ({required Object mult}) => 'À chaque ligne effacée, +${mult} mult pour chaque paire de jokers que tu as.',
			'game.jokers.twin.name' => 'Lignes jumelles',
			'game.jokers.twin.description' => ({required Object factor, required Object lines}) => '×${factor} mult quand tu effaces ${lines} lignes ou plus d\'un coup.',
			'game.jokers.column.name' => 'Chasseur de colonnes',
			'game.jokers.column.description' => ({required Object factor}) => '×${factor} mult quand ton coup efface une colonne.',
			'game.jokers.heavy.name' => 'Poids lourd',
			'game.jokers.heavy.description' => ({required Object factor, required Object size}) => '×${factor} mult quand une pièce de ${size} cases ou plus complète une ligne.',
			'game.jokers.sweep.name' => 'Grand ménage',
			'game.jokers.sweep.description' => ({required Object points}) => '+${points} points quand tu vides entièrement le plateau.',
			'game.jokers.quarry.name' => 'Carrière',
			'game.jokers.quarry.description' => ({required num stones}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('fr'))(stones, one: 'Chaque ligne effacée fait tomber une pierre sur une case vide au hasard.', other: 'Chaque ligne effacée fait tomber ${stones} pierres sur des cases vides au hasard.', ), 
			'game.jokers.bigbox.name' => 'Grand format',
			'game.jokers.bigbox.description' => ({required Object size, required Object factor}) => 'Les pièces de ${size} cases ou plus arrivent ${factor}× plus souvent.',
			'game.jokers.tiny.name' => 'Petits outils',
			'game.jokers.tiny.description' => ({required Object size, required Object factor}) => 'Les pièces de ${size} cases au plus arrivent ${factor}× plus souvent.',
			'game.jokers.pockets.name' => 'Poches pleines',
			'game.jokers.pockets.description' => ({required num pieces}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('fr'))(pieces, one: '+${pieces} pièce à chaque manche.', other: '+${pieces} pièces à chaque manche.', ), 
			'game.jokers.saver.name' => 'Épargnant',
			'game.jokers.saver.description' => ({required Object points}) => 'Chaque pièce non jouée à la fin d\'une manche gagnée rapporte +${points} points de partie.',
			'game.jokers.anchor.name' => 'Ancre',
			'game.jokers.anchor.description' => ({required Object mult}) => '+${mult} mult quand ton coup efface la ligne du bas.',
			'game.jokers.avalanche.name' => 'Avalanche',
			'game.jokers.avalanche.description' => ({required num rows, required Object chips}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('fr'))(rows, one: 'Après chaque ligne effacée, +${chips} jetons par case pleine restée dans la ligne du bas.', other: 'Après chaque ligne effacée, +${chips} jetons par case pleine restée dans les ${rows} lignes du bas.', ), 
			'game.jokers.fullhouse.name' => 'Salle comble',
			'game.jokers.fullhouse.description' => ({required Object mult, required Object cells}) => '+${mult} mult toutes les ${cells} cases occupées, pierres comprises, quand ta pièce se pose.',
			'game.jokers.brink.name' => 'Sur le fil',
			'game.jokers.brink.description' => ({required Object factor, required Object cells}) => '×${factor} mult si ${cells} cases ou plus sont occupées, pierres comprises, quand ta pièce se pose.',
			'game.jokers.finisher.name' => 'Finisseur',
			'game.jokers.finisher.description' => ({required Object factor}) => '×${factor} mult quand tu joues la dernière pièce de ta main.',
			'game.jokers.hattrick.name' => 'Coup du chapeau',
			'game.jokers.hattrick.description' => ({required Object points, required Object pieces}) => '+${points} points quand chacune des ${pieces} pièces d\'une main complète efface une ligne.',
			'game.jokers.lantern.name' => 'Lanterne',
			'game.jokers.lantern.description' => 'Les pierres et le brouillard à côté d\'une ligne effacée partent avec elle.',
			'game.jokers.ember.name' => 'Braise',
			'game.jokers.ember.description' => ({required Object mult, required Object factor}) => '+${mult} mult à chaque ligne effacée, et ×${factor} quand ton coup retire une pierre ou une case de brouillard.',
			'game.jokers.sprinter.name' => 'Sprinteur',
			'game.jokers.sprinter.description' => ({required Object mult}) => '+${mult} mult quand la première pièce d\'une nouvelle main efface une ligne.',
			'game.jokers.momentum.name' => 'Élan',
			'game.jokers.momentum.description' => ({required Object mult}) => 'À chaque ligne effacée, +${mult} mult par main d\'affilée dont la première pièce a effacé une ligne.',
			'game.jokers.symmetry.name' => 'Symétrie',
			'game.jokers.symmetry.description' => ({required Object mult}) => '+${mult} mult quand ta ligne laisse le plateau symétrique, et pas vide.',
			'game.jokers.prism.name' => 'Prisme',
			'game.jokers.prism.description' => ({required Object chips}) => '+${chips} jetons par case pleine ou pierre dont la case miroir l\'est aussi, après une ligne effacée.',
			'push.channelName' => 'Annonces',
			'push.channelDescription' => 'Les nouveautés et messages de l\'application.',
			'home.complete.title' => 'Tous les mondes terminés',
			'home.complete.body' => ({required Object count}) => 'Tous les boss sont battus : les ${count} mondes sont à toi.',
			'home.complete.stars' => ({required Object stars, required Object max}) => '${stars} étoiles sur ${max}',
			'home.complete.ok' => 'Continuer',
			'home.tabLabel' => 'Jouer',
			'home.title' => 'Blockmancer',
			'home.daily.title' => 'Partie du jour',
			'home.daily.subtitle' => 'Aujourd\'hui, les mêmes pièces pour tout le monde',
			'home.daily.play' => 'Jouer',
			'home.resume.title' => 'Reprendre la partie',
			'home.resume.subtitle' => 'Reprends là où tu en étais',
			'home.practice.title' => 'Entraînement',
			'home.map.title' => 'Les mondes',
			'home.map.here' => 'Tu es ici',
			'home.map.done' => 'Boss vaincu',
			'home.map.locked' => 'Verrouillé',
			'home.map.comingSoon' => 'Bientôt',
			'home.map.stars' => ({required Object count}) => 'Étoiles : ${count} sur 3',
			'home.sheet.done' => 'Terminé',
			'home.sheet.current' => 'En cours',
			'home.sheet.bossCard' => 'Comment se joue le boss',
			'home.sheet.bossRule.rubble' => 'Le boss commence avec des pierres sur le plateau.',
			'home.sheet.bossRule.fog' => 'Le brouillard cache des cases. Pose à côté pour voir ce qu\'il y a dessous.',
			'home.sheet.bossRule.tide' => 'À chaque nouvelle main, la marée monte d\'une ligne. Ne la laisse pas pousser tes blocs hors du plateau.',
			'home.sheet.bossRule.mirror' => 'Tout ce que tu poses atterrit en miroir.',
			'home.sheet.bossRule.gravity' => 'Pendant la manche du boss, chaque pièce tombe tout en bas.',
			'home.sheet.bossTarget' => ({required Object points}) => 'Bats le boss : ${points} points',
			'home.sheet.stars' => 'Étoiles',
			'home.sheet.threshold' => ({required Object points}) => 'Atteins ${points} points en une partie',
			'home.sheet.unlocks' => 'Battre son boss débloque',
			'home.sheet.start' => 'Lancer la partie',
			'home.sheet.replay' => 'Rejouer pour l\'étoile manquante',
			'home.sheet.lockedHint' => 'Bats le boss précédent pour le débloquer',
			'home.best' => ({required Object points}) => 'Record : ${points}',
			'home.noBest' => 'Pas encore de partie',
			'home.settings' => 'Réglages',
			'home.spellbook.title' => 'Grimoire',
			'home.spellbook.open' => 'Grimoire',
			'home.spellbook.close' => 'Fermer',
			'home.spellbook.progress' => ({required Object unlocked, required Object total}) => '${unlocked} jokers débloqués sur ${total}',
			'home.spellbook.partner' => ({required Object name}) => 'Fait la paire avec ${name}',
			'home.spellbook.picked' => 'Choisi',
			'home.spellbook.wins' => 'Victoires',
			'home.spellbook.best' => 'Record',
			'home.spellbook.locked' => 'Verrouillé',
			'home.spellbook.unlockBoss' => ({required Object world}) => 'Bats le boss de ${world}',
			'home.spellbook.unlockStars' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('fr'))(count, one: 'Récolte 1 étoile', other: 'Récolte ${count} étoiles', ), 
			'settings.title' => 'Réglages',
			'settings.close' => 'Fermer',
			'settings.sound' => 'Son',
			'settings.haptics' => 'Vibrations',
			'settings.reduceMotion.title' => 'Réduire les animations',
			'settings.reduceMotion.subtitle' => 'Des animations plus douces, sans tremblement de l\'écran',
			'settings.language.title' => 'Langue',
			'settings.language.system' => 'Système',
			'settings.language.en' => 'English',
			'settings.language.fr' => 'Français',
			'settings.tutorial.title' => 'Revoir le tutoriel',
			'settings.tutorial.subtitle' => 'Comment jouer, pas à pas',
			'settings.feedback.title' => 'Envoyer un avis',
			'settings.feedback.subtitle' => 'Ouvre un e-mail à l\'équipe',
			'settings.feedback.unavailableTitle' => 'Pas d\'app de mail',
			'settings.feedback.unavailableMessage' => ({required Object address}) => 'Impossible d\'ouvrir une app de mail. Écris-nous à ${address}.',
			'settings.feedback.ok' => 'OK',
			'settings.testStats.title' => 'Partager les stats de test',
			'settings.testStats.subtitle' => 'Envoie à l\'équipe comment tu joues',
			'settings.testStats.unavailableTitle' => 'Partage impossible',
			'settings.testStats.unavailableMessage' => 'La feuille de partage ne s\'est pas ouverte. Réessaie dans un instant.',
			'settings.testStats.ok' => 'OK',
			'settings.version' => 'Version',
			'settings.reset.title' => 'Réinitialiser la progression',
			'settings.reset.subtitle' => 'Tes records et la partie en cours',
			'settings.reset.confirmTitle' => 'Réinitialiser la progression ?',
			'settings.reset.confirmMessage' => 'Tes records et la partie en cours seront effacés. Impossible de revenir en arrière.',
			'settings.reset.confirm' => 'Réinitialiser',
			'settings.reset.cancel' => 'Annuler',
			_ => null,
		};
	}
}
