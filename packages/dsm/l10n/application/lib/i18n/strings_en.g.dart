///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

part of 'strings.g.dart';

// Path: <root>
typedef TranslationsEn = Translations; // ignore: unused_element
class Translations with BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final t = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	dynamic operator[](String key) => $meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	Translations $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => Translations(meta: meta ?? this.$meta);

	// Translations
	late final Translations$login$en login = Translations$login$en.internal(_root);
	late final Translations$game$en game = Translations$game$en.internal(_root);
	late final Translations$session$en session = Translations$session$en.internal(_root);
	late final Translations$push$en push = Translations$push$en.internal(_root);
	late final Translations$appStatus$en appStatus = Translations$appStatus$en.internal(_root);
}

// Path: login
class Translations$login$en {
	Translations$login$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Email'
	String get emailHint => 'Email';

	/// en: 'Password'
	String get passwordHint => 'Password';

	/// en: 'Sign in'
	String get submit => 'Sign in';

	/// en: 'Continue as a guest'
	String get continueAsGuest => 'Continue as a guest';

	/// en: 'Please enter your email'
	String get emailRequired => 'Please enter your email';

	/// en: 'Please enter a valid email address'
	String get emailInvalid => 'Please enter a valid email address';

	/// en: 'Email address is too long'
	String get emailTooLong => 'Email address is too long';

	/// en: 'Please enter your password'
	String get passwordRequired => 'Please enter your password';

	/// en: 'Password must be at least 8 characters long'
	String get passwordTooShort => 'Password must be at least 8 characters long';

	/// en: 'Password is too long'
	String get passwordTooLong => 'Password is too long';

	/// en: 'Sign-in failed'
	String get errorTitle => 'Sign-in failed';

	/// en: 'OK'
	String get errorButtonLabel => 'OK';

	/// en: 'Incorrect email or password'
	String get invalidCredentials => 'Incorrect email or password';

	/// en: 'This device is signed in as another member. Sign out first.'
	String get deviceConflict => 'This device is signed in as another member. Sign out first.';

	/// en: 'Check your internet connection and try again.'
	String get noInternet => 'Check your internet connection and try again.';

	/// en: 'Something went wrong. Please try again.'
	String get genericError => 'Something went wrong. Please try again.';
}

// Path: game
class Translations$game$en {
	Translations$game$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Play'
	String get tabLabel => 'Play';

	/// en: 'Blockmancer'
	String get title => 'Blockmancer';

	/// en: 'Daily run · same pieces for everyone'
	String get subtitle => 'Daily run · same pieces for everyone';

	/// en: 'Run $total'
	String runTotal({required Object total}) => 'Run ${total}';

	late final Translations$game$round$en round = Translations$game$round$en.internal(_root);
	late final Translations$game$banner$en banner = Translations$game$banner$en.internal(_root);
	late final Translations$game$offers$en offers = Translations$game$offers$en.internal(_root);
	late final Translations$game$lost$en lost = Translations$game$lost$en.internal(_root);
	late final Translations$game$end$en end = Translations$game$end$en.internal(_root);
	late final Translations$game$jokers$en jokers = Translations$game$jokers$en.internal(_root);
}

// Path: session
class Translations$session$en {
	Translations$session$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Sign in'
	String get signIn => 'Sign in';

	/// en: 'Sign out'
	String get signOut => 'Sign out';

	/// en: 'Sign out?'
	String get signOutConfirmTitle => 'Sign out?';

	/// en: 'You'll need to sign in again to see your content.'
	String get signOutConfirmMessage => 'You\'ll need to sign in again to see your content.';

	/// en: 'Sign out'
	String get signOutConfirmAction => 'Sign out';

	/// en: 'Stay signed in'
	String get signOutCancel => 'Stay signed in';

	/// en: 'Couldn't sign out'
	String get signOutFailedTitle => 'Couldn\'t sign out';

	/// en: 'Something went wrong signing you out. Please try again.'
	String get signOutFailed => 'Something went wrong signing you out. Please try again.';

	/// en: 'No internet connection. Check your connection and try again.'
	String get signOutNoConnection => 'No internet connection. Check your connection and try again.';

	/// en: 'OK'
	String get signOutFailedButtonLabel => 'OK';
}

// Path: push
class Translations$push$en {
	Translations$push$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Announcements'
	String get channelName => 'Announcements';

	/// en: 'News and messages from the app.'
	String get channelDescription => 'News and messages from the app.';
}

// Path: appStatus
class Translations$appStatus$en {
	Translations$appStatus$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'We'll be right back'
	String get maintenanceTitle => 'We\'ll be right back';

	/// en: 'The app is undergoing maintenance. Please try again in a little while.'
	String get maintenanceFallback => 'The app is undergoing maintenance. Please try again in a little while.';

	/// en: 'Try again'
	String get retry => 'Try again';

	/// en: 'Update required'
	String get forceUpdateTitle => 'Update required';

	/// en: 'This version of the app is no longer supported. Update it to keep using it.'
	String get forceUpdateBody => 'This version of the app is no longer supported. Update it to keep using it.';

	/// en: 'Update available'
	String get updateAvailableTitle => 'Update available';

	/// en: 'Version $version is available.'
	String updateAvailableBody({required Object version}) => 'Version ${version} is available.';

	/// en: 'Update'
	String get update => 'Update';

	/// en: 'Later'
	String get later => 'Later';
}

// Path: game.round
class Translations$game$round$en {
	Translations$game$round$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Round · $index / $count'
	String regular({required Object index, required Object count}) => 'Round · ${index} / ${count}';

	/// en: 'Boss · Rubble · $index / $count'
	String boss({required Object index, required Object count}) => 'Boss · Rubble · ${index} / ${count}';

	/// en: '/ $target'
	String target({required Object target}) => '/ ${target}';

	/// en: '(one) {$count piece left} (other) {$count pieces left}'
	String piecesLeft({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(count,
		one: '${count} piece left',
		other: '${count} pieces left',
	);

	/// en: 'Combo ×$streak'
	String combo({required Object streak}) => 'Combo ×${streak}';

	/// en: '+$mult mult stored'
	String storedMult({required Object mult}) => '+${mult} mult stored';
}

// Path: game.banner
class Translations$game$banner$en {
	Translations$game$banner$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: '$chips chips × $mult mult = $total'
	String clear({required Object chips, required Object mult, required Object total}) => '${chips} chips × ${mult} mult = ${total}';

	/// en: '+$points'
	String placed({required Object points}) => '+${points}';

	/// en: '+$points bonus'
	String bonus({required Object points}) => '+${points} bonus';

	/// en: '$joker $effect'
	String fired({required Object joker, required Object effect}) => '${joker} ${effect}';

	/// en: '+$amount chips'
	String chipsAdded({required Object amount}) => '+${amount} chips';

	/// en: '+$amount mult'
	String multAdded({required Object amount}) => '+${amount} mult';

	/// en: '×$factor mult'
	String multMultiplied({required Object factor}) => '×${factor} mult';

	/// en: 'mult stored · $total ready'
	String multStored({required Object total}) => 'mult stored · ${total} ready';

	/// en: '+$amount'
	String pointsAdded({required Object amount}) => '+${amount}';

	/// en: '+$amount run points'
	String runPointsAdded({required Object amount}) => '+${amount} run points';

	/// en: 'new stone'
	String get stoneDropped => 'new stone';

	/// en: '+$amount pieces'
	String piecesAdded({required Object amount}) => '+${amount} pieces';

	/// en: '+$amount stones'
	String stonesAdded({required Object amount}) => '+${amount} stones';
}

// Path: game.offers
class Translations$game$offers$en {
	Translations$game$offers$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Pick your starting joker'
	String get startTitle => 'Pick your starting joker';

	/// en: 'Jokers work in pairs. You pick one more after every round, so plan your build.'
	String get startSubtitle => 'Jokers work in pairs. You pick one more after every round, so plan your build.';

	/// en: 'Round cleared!'
	String get roundTitle => 'Round cleared!';

	/// en: 'Saver +$points'
	String saverBonus({required Object points}) => 'Saver +${points}';

	/// en: 'Pick a joker. Next: round $index · $target pts.'
	String nextRound({required Object index, required Object target}) => 'Pick a joker. Next: round ${index} · ${target} pts.';

	/// en: 'Pick a joker. Next: Boss · $target pts with stones.'
	String nextBoss({required Object target}) => 'Pick a joker. Next: Boss · ${target} pts with stones.';

	/// en: 'Your build: $jokers'
	String build({required Object jokers}) => 'Your build: ${jokers}';

	/// en: '★ Completes a pair with your $joker'
	String completesPair({required Object joker}) => '★ Completes a pair with your ${joker}';

	/// en: 'Pairs with: $joker'
	String pairsWith({required Object joker}) => 'Pairs with: ${joker}';

	/// en: 'Take'
	String get take => 'Take';
}

// Path: game.lost
class Translations$game$lost$en {
	Translations$game$lost$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Out of pieces'
	String get outOfPieces => 'Out of pieces';

	/// en: 'No room left'
	String get noRoom => 'No room left';

	/// en: '$score of $target points this round.'
	String progress({required Object score, required Object target}) => '${score} of ${target} points this round.';

	/// en: 'Revive · clear $rows rows + $pieces pieces'
	String revive({required Object rows, required Object pieces}) => 'Revive · clear ${rows} rows + ${pieces} pieces';

	/// en: 'End run'
	String get endRun => 'End run';
}

// Path: game.end
class Translations$game$end$en {
	Translations$game$end$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Boss beaten · run complete'
	String get won => 'Boss beaten · run complete';

	/// en: 'Run over · reached round $index'
	String overRound({required Object index}) => 'Run over · reached round ${index}';

	/// en: 'Run over · reached the boss'
	String get overBoss => 'Run over · reached the boss';

	/// en: '$total points'
	String total({required Object total}) => '${total} points';

	/// en: 'Build: $jokers'
	String build({required Object jokers}) => 'Build: ${jokers}';

	/// en: 'none'
	String get noJokers => 'none';

	/// en: 'Retry today's run'
	String get retry => 'Retry today\'s run';
}

// Path: game.jokers
class Translations$game$jokers$en {
	Translations$game$jokers$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final Translations$game$jokers$stonemason$en stonemason = Translations$game$jokers$stonemason$en.internal(_root);
	late final Translations$game$jokers$combo$en combo = Translations$game$jokers$combo$en.internal(_root);
	late final Translations$game$jokers$patience$en patience = Translations$game$jokers$patience$en.internal(_root);
	late final Translations$game$jokers$precision$en precision = Translations$game$jokers$precision$en.internal(_root);
	late final Translations$game$jokers$collector$en collector = Translations$game$jokers$collector$en.internal(_root);
	late final Translations$game$jokers$twin$en twin = Translations$game$jokers$twin$en.internal(_root);
	late final Translations$game$jokers$column$en column = Translations$game$jokers$column$en.internal(_root);
	late final Translations$game$jokers$heavy$en heavy = Translations$game$jokers$heavy$en.internal(_root);
	late final Translations$game$jokers$sweep$en sweep = Translations$game$jokers$sweep$en.internal(_root);
	late final Translations$game$jokers$quarry$en quarry = Translations$game$jokers$quarry$en.internal(_root);
	late final Translations$game$jokers$bigbox$en bigbox = Translations$game$jokers$bigbox$en.internal(_root);
	late final Translations$game$jokers$tiny$en tiny = Translations$game$jokers$tiny$en.internal(_root);
	late final Translations$game$jokers$pockets$en pockets = Translations$game$jokers$pockets$en.internal(_root);
	late final Translations$game$jokers$saver$en saver = Translations$game$jokers$saver$en.internal(_root);
}

// Path: game.jokers.stonemason
class Translations$game$jokers$stonemason$en {
	Translations$game$jokers$stonemason$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Stonemason'
	String get name => 'Stonemason';

	/// en: '+50 chips for each stone cleared. 2 extra stones every round.'
	String get description => '+50 chips for each stone cleared. 2 extra stones every round.';
}

// Path: game.jokers.combo
class Translations$game$jokers$combo$en {
	Translations$game$jokers$combo$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Combo King'
	String get name => 'Combo King';

	/// en: '+1 mult for every clearing move in a row.'
	String get description => '+1 mult for every clearing move in a row.';
}

// Path: game.jokers.patience
class Translations$game$jokers$patience$en {
	Translations$game$jokers$patience$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Patience'
	String get name => 'Patience';

	/// en: 'Each move without a clear stores +2 mult for your next clear.'
	String get description => 'Each move without a clear stores +2 mult for your next clear.';
}

// Path: game.jokers.precision
class Translations$game$jokers$precision$en {
	Translations$game$jokers$precision$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Precision'
	String get name => 'Precision';

	/// en: '+6 mult when a 1–2 cell piece completes a line.'
	String get description => '+6 mult when a 1–2 cell piece completes a line.';
}

// Path: game.jokers.collector
class Translations$game$jokers$collector$en {
	Translations$game$jokers$collector$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Collector'
	String get name => 'Collector';

	/// en: '+1 mult on every clear for each joker you own.'
	String get description => '+1 mult on every clear for each joker you own.';
}

// Path: game.jokers.twin
class Translations$game$jokers$twin$en {
	Translations$game$jokers$twin$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Twin Lines'
	String get name => 'Twin Lines';

	/// en: '×3 mult when you clear 2 or more lines at once.'
	String get description => '×3 mult when you clear 2 or more lines at once.';
}

// Path: game.jokers.column
class Translations$game$jokers$column$en {
	Translations$game$jokers$column$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Column Hunter'
	String get name => 'Column Hunter';

	/// en: '×2 mult when your move clears a column.'
	String get description => '×2 mult when your move clears a column.';
}

// Path: game.jokers.heavy
class Translations$game$jokers$heavy$en {
	Translations$game$jokers$heavy$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Heavyweight'
	String get name => 'Heavyweight';

	/// en: '×2 mult when a piece of 4+ cells completes a line.'
	String get description => '×2 mult when a piece of 4+ cells completes a line.';
}

// Path: game.jokers.sweep
class Translations$game$jokers$sweep$en {
	Translations$game$jokers$sweep$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Clean Sweep'
	String get name => 'Clean Sweep';

	/// en: '+500 points when the board becomes completely empty.'
	String get description => '+500 points when the board becomes completely empty.';
}

// Path: game.jokers.quarry
class Translations$game$jokers$quarry$en {
	Translations$game$jokers$quarry$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Quarry'
	String get name => 'Quarry';

	/// en: 'Every clear drops a new stone on a random empty cell.'
	String get description => 'Every clear drops a new stone on a random empty cell.';
}

// Path: game.jokers.bigbox
class Translations$game$jokers$bigbox$en {
	Translations$game$jokers$bigbox$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Big Box'
	String get name => 'Big Box';

	/// en: 'Pieces of 5+ cells show up 3× more often.'
	String get description => 'Pieces of 5+ cells show up 3× more often.';
}

// Path: game.jokers.tiny
class Translations$game$jokers$tiny$en {
	Translations$game$jokers$tiny$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Tiny Tools'
	String get name => 'Tiny Tools';

	/// en: 'Pieces of 1–2 cells show up 3× more often.'
	String get description => 'Pieces of 1–2 cells show up 3× more often.';
}

// Path: game.jokers.pockets
class Translations$game$jokers$pockets$en {
	Translations$game$jokers$pockets$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Deep Pockets'
	String get name => 'Deep Pockets';

	/// en: '+4 pieces every round.'
	String get description => '+4 pieces every round.';
}

// Path: game.jokers.saver
class Translations$game$jokers$saver$en {
	Translations$game$jokers$saver$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Saver'
	String get name => 'Saver';

	/// en: 'Each unused piece when you beat a round gives +40 run points.'
	String get description => 'Each unused piece when you beat a round gives +40 run points.';
}

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'login.emailHint' => 'Email',
			'login.passwordHint' => 'Password',
			'login.submit' => 'Sign in',
			'login.continueAsGuest' => 'Continue as a guest',
			'login.emailRequired' => 'Please enter your email',
			'login.emailInvalid' => 'Please enter a valid email address',
			'login.emailTooLong' => 'Email address is too long',
			'login.passwordRequired' => 'Please enter your password',
			'login.passwordTooShort' => 'Password must be at least 8 characters long',
			'login.passwordTooLong' => 'Password is too long',
			'login.errorTitle' => 'Sign-in failed',
			'login.errorButtonLabel' => 'OK',
			'login.invalidCredentials' => 'Incorrect email or password',
			'login.deviceConflict' => 'This device is signed in as another member. Sign out first.',
			'login.noInternet' => 'Check your internet connection and try again.',
			'login.genericError' => 'Something went wrong. Please try again.',
			'game.tabLabel' => 'Play',
			'game.title' => 'Blockmancer',
			'game.subtitle' => 'Daily run · same pieces for everyone',
			'game.runTotal' => ({required Object total}) => 'Run ${total}',
			'game.round.regular' => ({required Object index, required Object count}) => 'Round · ${index} / ${count}',
			'game.round.boss' => ({required Object index, required Object count}) => 'Boss · Rubble · ${index} / ${count}',
			'game.round.target' => ({required Object target}) => '/ ${target}',
			'game.round.piecesLeft' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(count, one: '${count} piece left', other: '${count} pieces left', ), 
			'game.round.combo' => ({required Object streak}) => 'Combo ×${streak}',
			'game.round.storedMult' => ({required Object mult}) => '+${mult} mult stored',
			'game.banner.clear' => ({required Object chips, required Object mult, required Object total}) => '${chips} chips × ${mult} mult = ${total}',
			'game.banner.placed' => ({required Object points}) => '+${points}',
			'game.banner.bonus' => ({required Object points}) => '+${points} bonus',
			'game.banner.fired' => ({required Object joker, required Object effect}) => '${joker} ${effect}',
			'game.banner.chipsAdded' => ({required Object amount}) => '+${amount} chips',
			'game.banner.multAdded' => ({required Object amount}) => '+${amount} mult',
			'game.banner.multMultiplied' => ({required Object factor}) => '×${factor} mult',
			'game.banner.multStored' => ({required Object total}) => 'mult stored · ${total} ready',
			'game.banner.pointsAdded' => ({required Object amount}) => '+${amount}',
			'game.banner.runPointsAdded' => ({required Object amount}) => '+${amount} run points',
			'game.banner.stoneDropped' => 'new stone',
			'game.banner.piecesAdded' => ({required Object amount}) => '+${amount} pieces',
			'game.banner.stonesAdded' => ({required Object amount}) => '+${amount} stones',
			'game.offers.startTitle' => 'Pick your starting joker',
			'game.offers.startSubtitle' => 'Jokers work in pairs. You pick one more after every round, so plan your build.',
			'game.offers.roundTitle' => 'Round cleared!',
			'game.offers.saverBonus' => ({required Object points}) => 'Saver +${points}',
			'game.offers.nextRound' => ({required Object index, required Object target}) => 'Pick a joker. Next: round ${index} · ${target} pts.',
			'game.offers.nextBoss' => ({required Object target}) => 'Pick a joker. Next: Boss · ${target} pts with stones.',
			'game.offers.build' => ({required Object jokers}) => 'Your build: ${jokers}',
			'game.offers.completesPair' => ({required Object joker}) => '★ Completes a pair with your ${joker}',
			'game.offers.pairsWith' => ({required Object joker}) => 'Pairs with: ${joker}',
			'game.offers.take' => 'Take',
			'game.lost.outOfPieces' => 'Out of pieces',
			'game.lost.noRoom' => 'No room left',
			'game.lost.progress' => ({required Object score, required Object target}) => '${score} of ${target} points this round.',
			'game.lost.revive' => ({required Object rows, required Object pieces}) => 'Revive · clear ${rows} rows + ${pieces} pieces',
			'game.lost.endRun' => 'End run',
			'game.end.won' => 'Boss beaten · run complete',
			'game.end.overRound' => ({required Object index}) => 'Run over · reached round ${index}',
			'game.end.overBoss' => 'Run over · reached the boss',
			'game.end.total' => ({required Object total}) => '${total} points',
			'game.end.build' => ({required Object jokers}) => 'Build: ${jokers}',
			'game.end.noJokers' => 'none',
			'game.end.retry' => 'Retry today\'s run',
			'game.jokers.stonemason.name' => 'Stonemason',
			'game.jokers.stonemason.description' => '+50 chips for each stone cleared. 2 extra stones every round.',
			'game.jokers.combo.name' => 'Combo King',
			'game.jokers.combo.description' => '+1 mult for every clearing move in a row.',
			'game.jokers.patience.name' => 'Patience',
			'game.jokers.patience.description' => 'Each move without a clear stores +2 mult for your next clear.',
			'game.jokers.precision.name' => 'Precision',
			'game.jokers.precision.description' => '+6 mult when a 1–2 cell piece completes a line.',
			'game.jokers.collector.name' => 'Collector',
			'game.jokers.collector.description' => '+1 mult on every clear for each joker you own.',
			'game.jokers.twin.name' => 'Twin Lines',
			'game.jokers.twin.description' => '×3 mult when you clear 2 or more lines at once.',
			'game.jokers.column.name' => 'Column Hunter',
			'game.jokers.column.description' => '×2 mult when your move clears a column.',
			'game.jokers.heavy.name' => 'Heavyweight',
			'game.jokers.heavy.description' => '×2 mult when a piece of 4+ cells completes a line.',
			'game.jokers.sweep.name' => 'Clean Sweep',
			'game.jokers.sweep.description' => '+500 points when the board becomes completely empty.',
			'game.jokers.quarry.name' => 'Quarry',
			'game.jokers.quarry.description' => 'Every clear drops a new stone on a random empty cell.',
			'game.jokers.bigbox.name' => 'Big Box',
			'game.jokers.bigbox.description' => 'Pieces of 5+ cells show up 3× more often.',
			'game.jokers.tiny.name' => 'Tiny Tools',
			'game.jokers.tiny.description' => 'Pieces of 1–2 cells show up 3× more often.',
			'game.jokers.pockets.name' => 'Deep Pockets',
			'game.jokers.pockets.description' => '+4 pieces every round.',
			'game.jokers.saver.name' => 'Saver',
			'game.jokers.saver.description' => 'Each unused piece when you beat a round gives +40 run points.',
			'session.signIn' => 'Sign in',
			'session.signOut' => 'Sign out',
			'session.signOutConfirmTitle' => 'Sign out?',
			'session.signOutConfirmMessage' => 'You\'ll need to sign in again to see your content.',
			'session.signOutConfirmAction' => 'Sign out',
			'session.signOutCancel' => 'Stay signed in',
			'session.signOutFailedTitle' => 'Couldn\'t sign out',
			'session.signOutFailed' => 'Something went wrong signing you out. Please try again.',
			'session.signOutNoConnection' => 'No internet connection. Check your connection and try again.',
			'session.signOutFailedButtonLabel' => 'OK',
			'push.channelName' => 'Announcements',
			'push.channelDescription' => 'News and messages from the app.',
			'appStatus.maintenanceTitle' => 'We\'ll be right back',
			'appStatus.maintenanceFallback' => 'The app is undergoing maintenance. Please try again in a little while.',
			'appStatus.retry' => 'Try again',
			'appStatus.forceUpdateTitle' => 'Update required',
			'appStatus.forceUpdateBody' => 'This version of the app is no longer supported. Update it to keep using it.',
			'appStatus.updateAvailableTitle' => 'Update available',
			'appStatus.updateAvailableBody' => ({required Object version}) => 'Version ${version} is available.',
			'appStatus.update' => 'Update',
			'appStatus.later' => 'Later',
			_ => null,
		};
	}
}
