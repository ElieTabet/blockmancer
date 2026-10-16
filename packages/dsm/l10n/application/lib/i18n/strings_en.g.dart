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
	late final Translations$home$en home = Translations$home$en.internal(_root);
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

// Path: home
class Translations$home$en {
	Translations$home$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Home'
	String get tabLabel => 'Home';

	/// en: 'Home'
	String get title => 'Home';

	/// en: 'Your app starts here. Replace this tab with the app's own main screen.'
	String get placeholder => 'Your app starts here. Replace this tab with the app\'s own main screen.';
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
			'home.tabLabel' => 'Home',
			'home.title' => 'Home',
			'home.placeholder' => 'Your app starts here. Replace this tab with the app\'s own main screen.',
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
