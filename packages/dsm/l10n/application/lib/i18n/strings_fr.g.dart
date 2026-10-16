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
	@override late final _Translations$home$fr home = _Translations$home$fr._(_root);
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

// Path: home
class _Translations$home$fr extends Translations$home$en {
	_Translations$home$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get tabLabel => 'Accueil';
	@override String get title => 'Accueil';
	@override String get placeholder => 'Votre application commence ici. Remplacez cet onglet par l\'écran principal de l\'application.';
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
			'home.tabLabel' => 'Accueil',
			'home.title' => 'Accueil',
			'home.placeholder' => 'Votre application commence ici. Remplacez cet onglet par l\'écran principal de l\'application.',
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
