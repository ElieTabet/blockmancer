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
	late final Translations$game$en game = Translations$game$en.internal(_root);
	late final Translations$push$en push = Translations$push$en.internal(_root);
	late final Translations$home$en home = Translations$home$en.internal(_root);
	late final Translations$settings$en settings = Translations$settings$en.internal(_root);
}

// Path: game
class Translations$game$en {
	Translations$game$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Blockmancer'
	String get title => 'Blockmancer';

	/// en: 'Daily run · same pieces for everyone'
	String get subtitle => 'Daily run · same pieces for everyone';

	/// en: 'Practice · a new run every time'
	String get practiceSubtitle => 'Practice · a new run every time';

	/// en: 'Back to the menu'
	String get leave => 'Back to the menu';

	late final Translations$game$tutorial$en tutorial = Translations$game$tutorial$en.internal(_root);

	/// en: 'Run $total'
	String runTotal({required Object total}) => 'Run ${total}';

	late final Translations$game$round$en round = Translations$game$round$en.internal(_root);
	late final Translations$game$banner$en banner = Translations$game$banner$en.internal(_root);
	late final Translations$game$offers$en offers = Translations$game$offers$en.internal(_root);
	late final Translations$game$lost$en lost = Translations$game$lost$en.internal(_root);
	late final Translations$game$end$en end = Translations$game$end$en.internal(_root);
	late final Translations$game$jokers$en jokers = Translations$game$jokers$en.internal(_root);
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

// Path: home
class Translations$home$en {
	Translations$home$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Play'
	String get tabLabel => 'Play';

	/// en: 'Blockmancer'
	String get title => 'Blockmancer';

	/// en: 'Place pieces, clear lines, build joker combos.'
	String get tagline => 'Place pieces, clear lines, build joker combos.';

	late final Translations$home$daily$en daily = Translations$home$daily$en.internal(_root);
	late final Translations$home$resume$en resume = Translations$home$resume$en.internal(_root);
	late final Translations$home$practice$en practice = Translations$home$practice$en.internal(_root);

	/// en: 'Best: $points'
	String best({required Object points}) => 'Best: ${points}';

	/// en: 'No run yet'
	String get noBest => 'No run yet';

	/// en: 'Settings'
	String get settings => 'Settings';
}

// Path: settings
class Translations$settings$en {
	Translations$settings$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Settings'
	String get title => 'Settings';

	/// en: 'Close'
	String get close => 'Close';

	/// en: 'Sound'
	String get sound => 'Sound';

	/// en: 'Haptics'
	String get haptics => 'Haptics';

	late final Translations$settings$reduceMotion$en reduceMotion = Translations$settings$reduceMotion$en.internal(_root);
	late final Translations$settings$language$en language = Translations$settings$language$en.internal(_root);
	late final Translations$settings$tutorial$en tutorial = Translations$settings$tutorial$en.internal(_root);
	late final Translations$settings$reset$en reset = Translations$settings$reset$en.internal(_root);
}

// Path: game.tutorial
class Translations$game$tutorial$en {
	Translations$game$tutorial$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Drag a piece onto the board'
	String get drag => 'Drag a piece onto the board';

	/// en: 'Fill a row to clear it'
	String get clear => 'Fill a row to clear it';

	/// en: 'Chips × mult = score'
	String get score => 'Chips × mult = score';

	/// en: 'Tap to continue'
	String get scoreHint => 'Tap to continue';

	/// en: 'Pick your first joker — they work in pairs'
	String get pick => 'Pick your first joker — they work in pairs';

	/// en: 'Skip'
	String get skip => 'Skip';
}

// Path: game.round
class Translations$game$round$en {
	Translations$game$round$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Round · $index / $count'
	String regular({required Object index, required Object count}) => 'Round · ${index} / ${count}';

	/// en: 'Boss · Rubble'
	String get boss => 'Boss · Rubble';

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

	/// en: '$chips chips'
	String chips({required Object chips}) => '${chips} chips';

	/// en: '× $mult mult'
	String mult({required Object mult}) => '× ${mult} mult';

	/// en: '= $total'
	String product({required Object total}) => '= ${total}';

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

	/// en: 'Best: $points'
	String best({required Object points}) => 'Best: ${points}';

	/// en: 'New best!'
	String get newBest => 'New best!';

	/// en: 'Play again'
	String get retry => 'Play again';
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
	late final Translations$game$jokers$anchor$en anchor = Translations$game$jokers$anchor$en.internal(_root);
	late final Translations$game$jokers$avalanche$en avalanche = Translations$game$jokers$avalanche$en.internal(_root);
}

// Path: home.daily
class Translations$home$daily$en {
	Translations$home$daily$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Daily run'
	String get title => 'Daily run';

	/// en: 'Same pieces for everyone today'
	String get subtitle => 'Same pieces for everyone today';
}

// Path: home.resume
class Translations$home$resume$en {
	Translations$home$resume$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Continue run'
	String get title => 'Continue run';

	/// en: 'Pick up where you left off'
	String get subtitle => 'Pick up where you left off';
}

// Path: home.practice
class Translations$home$practice$en {
	Translations$home$practice$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Practice'
	String get title => 'Practice';

	/// en: 'A new run every time'
	String get subtitle => 'A new run every time';
}

// Path: settings.reduceMotion
class Translations$settings$reduceMotion$en {
	Translations$settings$reduceMotion$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Reduce motion'
	String get title => 'Reduce motion';

	/// en: 'Calmer animations, no screen shake'
	String get subtitle => 'Calmer animations, no screen shake';
}

// Path: settings.language
class Translations$settings$language$en {
	Translations$settings$language$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Language'
	String get title => 'Language';

	/// en: 'System'
	String get system => 'System';

	/// en: 'English'
	String get en => 'English';

	/// en: 'Français'
	String get fr => 'Français';
}

// Path: settings.tutorial
class Translations$settings$tutorial$en {
	Translations$settings$tutorial$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Replay tutorial'
	String get title => 'Replay tutorial';

	/// en: 'How to play, step by step'
	String get subtitle => 'How to play, step by step';
}

// Path: settings.reset
class Translations$settings$reset$en {
	Translations$settings$reset$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Reset progress'
	String get title => 'Reset progress';

	/// en: 'Your best scores and the run in progress'
	String get subtitle => 'Your best scores and the run in progress';

	/// en: 'Reset progress?'
	String get confirmTitle => 'Reset progress?';

	/// en: 'Your best scores and the run in progress will be deleted. This can't be undone.'
	String get confirmMessage => 'Your best scores and the run in progress will be deleted. This can\'t be undone.';

	/// en: 'Reset'
	String get confirm => 'Reset';

	/// en: 'Cancel'
	String get cancel => 'Cancel';
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

// Path: game.jokers.anchor
class Translations$game$jokers$anchor$en {
	Translations$game$jokers$anchor$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Anchor'
	String get name => 'Anchor';

	/// en: '+4 mult when your move clears the bottom row.'
	String get description => '+4 mult when your move clears the bottom row.';
}

// Path: game.jokers.avalanche
class Translations$game$jokers$avalanche$en {
	Translations$game$jokers$avalanche$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Avalanche'
	String get name => 'Avalanche';

	/// en: '+25 chips for each filled cell left in the bottom 2 rows after a clear.'
	String get description => '+25 chips for each filled cell left in the bottom 2 rows after a clear.';
}

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'game.title' => 'Blockmancer',
			'game.subtitle' => 'Daily run · same pieces for everyone',
			'game.practiceSubtitle' => 'Practice · a new run every time',
			'game.leave' => 'Back to the menu',
			'game.tutorial.drag' => 'Drag a piece onto the board',
			'game.tutorial.clear' => 'Fill a row to clear it',
			'game.tutorial.score' => 'Chips × mult = score',
			'game.tutorial.scoreHint' => 'Tap to continue',
			'game.tutorial.pick' => 'Pick your first joker — they work in pairs',
			'game.tutorial.skip' => 'Skip',
			'game.runTotal' => ({required Object total}) => 'Run ${total}',
			'game.round.regular' => ({required Object index, required Object count}) => 'Round · ${index} / ${count}',
			'game.round.boss' => 'Boss · Rubble',
			'game.round.target' => ({required Object target}) => '/ ${target}',
			'game.round.piecesLeft' => ({required num count}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(count, one: '${count} piece left', other: '${count} pieces left', ), 
			'game.round.combo' => ({required Object streak}) => 'Combo ×${streak}',
			'game.round.storedMult' => ({required Object mult}) => '+${mult} mult stored',
			'game.banner.chips' => ({required Object chips}) => '${chips} chips',
			'game.banner.mult' => ({required Object mult}) => '× ${mult} mult',
			'game.banner.product' => ({required Object total}) => '= ${total}',
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
			'game.end.best' => ({required Object points}) => 'Best: ${points}',
			'game.end.newBest' => 'New best!',
			'game.end.retry' => 'Play again',
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
			'game.jokers.anchor.name' => 'Anchor',
			'game.jokers.anchor.description' => '+4 mult when your move clears the bottom row.',
			'game.jokers.avalanche.name' => 'Avalanche',
			'game.jokers.avalanche.description' => '+25 chips for each filled cell left in the bottom 2 rows after a clear.',
			'push.channelName' => 'Announcements',
			'push.channelDescription' => 'News and messages from the app.',
			'home.tabLabel' => 'Play',
			'home.title' => 'Blockmancer',
			'home.tagline' => 'Place pieces, clear lines, build joker combos.',
			'home.daily.title' => 'Daily run',
			'home.daily.subtitle' => 'Same pieces for everyone today',
			'home.resume.title' => 'Continue run',
			'home.resume.subtitle' => 'Pick up where you left off',
			'home.practice.title' => 'Practice',
			'home.practice.subtitle' => 'A new run every time',
			'home.best' => ({required Object points}) => 'Best: ${points}',
			'home.noBest' => 'No run yet',
			'home.settings' => 'Settings',
			'settings.title' => 'Settings',
			'settings.close' => 'Close',
			'settings.sound' => 'Sound',
			'settings.haptics' => 'Haptics',
			'settings.reduceMotion.title' => 'Reduce motion',
			'settings.reduceMotion.subtitle' => 'Calmer animations, no screen shake',
			'settings.language.title' => 'Language',
			'settings.language.system' => 'System',
			'settings.language.en' => 'English',
			'settings.language.fr' => 'Français',
			'settings.tutorial.title' => 'Replay tutorial',
			'settings.tutorial.subtitle' => 'How to play, step by step',
			'settings.reset.title' => 'Reset progress',
			'settings.reset.subtitle' => 'Your best scores and the run in progress',
			'settings.reset.confirmTitle' => 'Reset progress?',
			'settings.reset.confirmMessage' => 'Your best scores and the run in progress will be deleted. This can\'t be undone.',
			'settings.reset.confirm' => 'Reset',
			'settings.reset.cancel' => 'Cancel',
			_ => null,
		};
	}
}
