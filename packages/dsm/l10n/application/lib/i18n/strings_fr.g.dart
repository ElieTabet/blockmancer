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
	@override late final _Translations$login$fr login = _Translations$login$fr._(_root);
	@override late final _Translations$game$fr game = _Translations$game$fr._(_root);
	@override late final _Translations$session$fr session = _Translations$session$fr._(_root);
	@override late final _Translations$push$fr push = _Translations$push$fr._(_root);
	@override late final _Translations$appStatus$fr appStatus = _Translations$appStatus$fr._(_root);
}

// Path: login
class _Translations$login$fr extends Translations$login$en {
	_Translations$login$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get emailHint => 'Courriel';
	@override String get passwordHint => 'Mot de passe';
	@override String get submit => 'Se connecter';
	@override String get continueAsGuest => 'Continuer en tant qu\'invité';
	@override String get emailRequired => 'Veuillez saisir votre courriel';
	@override String get emailInvalid => 'Veuillez saisir une adresse courriel valide';
	@override String get emailTooLong => 'L\'adresse courriel est trop longue';
	@override String get passwordRequired => 'Veuillez saisir votre mot de passe';
	@override String get passwordTooShort => 'Le mot de passe doit contenir au moins 8 caractères';
	@override String get passwordTooLong => 'Le mot de passe est trop long';
	@override String get errorTitle => 'Échec de la connexion';
	@override String get errorButtonLabel => 'OK';
	@override String get invalidCredentials => 'Courriel ou mot de passe incorrect';
	@override String get deviceConflict => 'Cet appareil est connecté avec un autre compte. Déconnectez-vous d\'abord.';
	@override String get noInternet => 'Vérifiez votre connexion Internet et réessayez.';
	@override String get genericError => 'Une erreur est survenue. Veuillez réessayer.';
}

// Path: game
class _Translations$game$fr extends Translations$game$en {
	_Translations$game$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get tabLabel => 'Jouer';
	@override String get title => 'Blockmancer';
	@override String get subtitle => 'Partie du jour · les mêmes pièces pour tous';
	@override String runTotal({required Object total}) => 'Partie ${total}';
	@override late final _Translations$game$round$fr round = _Translations$game$round$fr._(_root);
	@override late final _Translations$game$banner$fr banner = _Translations$game$banner$fr._(_root);
	@override late final _Translations$game$offers$fr offers = _Translations$game$offers$fr._(_root);
	@override late final _Translations$game$lost$fr lost = _Translations$game$lost$fr._(_root);
	@override late final _Translations$game$end$fr end = _Translations$game$end$fr._(_root);
	@override late final _Translations$game$jokers$fr jokers = _Translations$game$jokers$fr._(_root);
}

// Path: session
class _Translations$session$fr extends Translations$session$en {
	_Translations$session$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get signIn => 'Se connecter';
	@override String get signOut => 'Se déconnecter';
	@override String get signOutConfirmTitle => 'Se déconnecter ?';
	@override String get signOutConfirmMessage => 'Vous devrez vous reconnecter pour accéder à votre contenu.';
	@override String get signOutConfirmAction => 'Se déconnecter';
	@override String get signOutCancel => 'Rester connecté';
	@override String get signOutFailedTitle => 'Déconnexion impossible';
	@override String get signOutFailed => 'Un problème est survenu lors de la déconnexion. Veuillez réessayer.';
	@override String get signOutNoConnection => 'Aucune connexion Internet. Vérifiez votre connexion et réessayez.';
	@override String get signOutFailedButtonLabel => 'OK';
}

// Path: push
class _Translations$push$fr extends Translations$push$en {
	_Translations$push$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get channelName => 'Annonces';
	@override String get channelDescription => 'Nouvelles et messages de l\'application.';
}

// Path: appStatus
class _Translations$appStatus$fr extends Translations$appStatus$en {
	_Translations$appStatus$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get maintenanceTitle => 'Nous revenons vite';
	@override String get maintenanceFallback => 'L\'application est en maintenance. Réessayez dans quelques instants.';
	@override String get retry => 'Réessayer';
	@override String get forceUpdateTitle => 'Mise à jour requise';
	@override String get forceUpdateBody => 'Cette version de l\'application n\'est plus prise en charge. Mettez-la à jour pour continuer à l\'utiliser.';
	@override String get updateAvailableTitle => 'Mise à jour disponible';
	@override String updateAvailableBody({required Object version}) => 'La version ${version} est disponible.';
	@override String get update => 'Mettre à jour';
	@override String get later => 'Plus tard';
}

// Path: game.round
class _Translations$game$round$fr extends Translations$game$round$en {
	_Translations$game$round$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String regular({required Object index, required Object count}) => 'Manche · ${index} / ${count}';
	@override String boss({required Object index, required Object count}) => 'Boss · Gravats · ${index} / ${count}';
	@override String target({required Object target}) => '/ ${target}';
	@override String piecesLeft({required Object count}) => '${count} pièces restantes';
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
	@override String get revive => 'Relancer · 2 lignes vidées + 3 pièces';
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
	@override String get retry => 'Rejouer la partie du jour';
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
			'login.emailHint' => 'Courriel',
			'login.passwordHint' => 'Mot de passe',
			'login.submit' => 'Se connecter',
			'login.continueAsGuest' => 'Continuer en tant qu\'invité',
			'login.emailRequired' => 'Veuillez saisir votre courriel',
			'login.emailInvalid' => 'Veuillez saisir une adresse courriel valide',
			'login.emailTooLong' => 'L\'adresse courriel est trop longue',
			'login.passwordRequired' => 'Veuillez saisir votre mot de passe',
			'login.passwordTooShort' => 'Le mot de passe doit contenir au moins 8 caractères',
			'login.passwordTooLong' => 'Le mot de passe est trop long',
			'login.errorTitle' => 'Échec de la connexion',
			'login.errorButtonLabel' => 'OK',
			'login.invalidCredentials' => 'Courriel ou mot de passe incorrect',
			'login.deviceConflict' => 'Cet appareil est connecté avec un autre compte. Déconnectez-vous d\'abord.',
			'login.noInternet' => 'Vérifiez votre connexion Internet et réessayez.',
			'login.genericError' => 'Une erreur est survenue. Veuillez réessayer.',
			'game.tabLabel' => 'Jouer',
			'game.title' => 'Blockmancer',
			'game.subtitle' => 'Partie du jour · les mêmes pièces pour tous',
			'game.runTotal' => ({required Object total}) => 'Partie ${total}',
			'game.round.regular' => ({required Object index, required Object count}) => 'Manche · ${index} / ${count}',
			'game.round.boss' => ({required Object index, required Object count}) => 'Boss · Gravats · ${index} / ${count}',
			'game.round.target' => ({required Object target}) => '/ ${target}',
			'game.round.piecesLeft' => ({required Object count}) => '${count} pièces restantes',
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
			'game.lost.revive' => 'Relancer · 2 lignes vidées + 3 pièces',
			'game.lost.endRun' => 'Terminer la partie',
			'game.end.won' => 'Boss vaincu · partie terminée',
			'game.end.overRound' => ({required Object index}) => 'Partie finie · manche ${index} atteinte',
			'game.end.overBoss' => 'Partie finie · boss atteint',
			'game.end.total' => ({required Object total}) => '${total} points',
			'game.end.build' => ({required Object jokers}) => 'Combinaison : ${jokers}',
			'game.end.noJokers' => 'aucune',
			'game.end.retry' => 'Rejouer la partie du jour',
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
			'session.signIn' => 'Se connecter',
			'session.signOut' => 'Se déconnecter',
			'session.signOutConfirmTitle' => 'Se déconnecter ?',
			'session.signOutConfirmMessage' => 'Vous devrez vous reconnecter pour accéder à votre contenu.',
			'session.signOutConfirmAction' => 'Se déconnecter',
			'session.signOutCancel' => 'Rester connecté',
			'session.signOutFailedTitle' => 'Déconnexion impossible',
			'session.signOutFailed' => 'Un problème est survenu lors de la déconnexion. Veuillez réessayer.',
			'session.signOutNoConnection' => 'Aucune connexion Internet. Vérifiez votre connexion et réessayez.',
			'session.signOutFailedButtonLabel' => 'OK',
			'push.channelName' => 'Annonces',
			'push.channelDescription' => 'Nouvelles et messages de l\'application.',
			'appStatus.maintenanceTitle' => 'Nous revenons vite',
			'appStatus.maintenanceFallback' => 'L\'application est en maintenance. Réessayez dans quelques instants.',
			'appStatus.retry' => 'Réessayer',
			'appStatus.forceUpdateTitle' => 'Mise à jour requise',
			'appStatus.forceUpdateBody' => 'Cette version de l\'application n\'est plus prise en charge. Mettez-la à jour pour continuer à l\'utiliser.',
			'appStatus.updateAvailableTitle' => 'Mise à jour disponible',
			'appStatus.updateAvailableBody' => ({required Object version}) => 'La version ${version} est disponible.',
			'appStatus.update' => 'Mettre à jour',
			'appStatus.later' => 'Plus tard',
			_ => null,
		};
	}
}
