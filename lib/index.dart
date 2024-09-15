/// Library directive for centralizing exports.
///
/// This file consolidates the export of essential Dart, Flutter, and third-party packages,
/// along with application-specific modules. It serves as a unified access point for
/// importing these dependencies across the project, promoting consistency
/// and simplifying import statements.
///
/// Usage of this file ensures that you have a single source for managing dependencies,
/// which can help with maintainability and clarity in your codebase.
///
/// This file includes:
/// - Core Dart libraries for fundamental functionalities.
/// - Essential Flutter packages for UI development.
/// - Third-party packages that extend application capabilities.
/// - Application-specific modules organized by feature.
library index;


// DART
// ==========
// Essential Dart libraries for core functionalities and cryptographic operations.

/// Provides JSON encoding and decoding utilities.
export 'dart:convert';

/// Includes tools for asynchronous programming, such as Future and Stream.
export 'dart:async';

/// Offers cryptographic functionalities, including various hashing algorithms.
export 'package:crypto/crypto.dart';

/// File, socket, HTTP, and other I/O support for non-web applications.
export 'dart:io';


// FLUTTER
// ==========
// Core Flutter packages for building and managing the app's user interface and functionality.

/// Contains foundational classes used by the Flutter framework.
export 'package:flutter/foundation.dart';

/// Provides Material Design components and theming for Flutter applications.
export 'package:flutter/material.dart';

/// Platform services exposed to Flutter apps.
export 'package:flutter/services.dart';


// THIRD-PARTY PACKAGES
// ==========
// External libraries that enhance the functionality of the application.

/// A package for state management and routing solutions with GetX.
export 'package:get/get.dart' hide HeaderValue;

/// Provides caching for HTTP requests when using the Dio HTTP client.
export 'package:dio_cache_interceptor/dio_cache_interceptor.dart';

/// Adds detailed logging for HTTP requests and responses with Dio.
export 'package:pretty_dio_logger/pretty_dio_logger.dart';

/// Enables efficient caching of network images.
export 'package:cached_network_image/cached_network_image.dart';

/// Manages environment variables in a Flutter app.
export 'package:flutter_dotenv/flutter_dotenv.dart';

/// Facilitates error logging for Retrofit-generated HTTP clients.
export 'package:retrofit/error_logger.dart';

/// Offers a way to store simple key-value pairs persistently.
export 'package:shared_preferences/shared_preferences.dart';


// APP MODULES
// ==========
// Custom modules specific to the application, organized by feature.

/// Handles core app setup and initialization.
export 'app/app.dart';

/// Contains data handling utilities used across the app.
export 'data/data.dart';

/// Contains common widgets used across the app.
export 'widget/widget.dart';

/// Includes data and functionality related to characters.
export 'character/character.dart';

/// Provides features and data related to comics.
export 'comic/comic.dart';

/// Deals with data and functionality related to creators.
export 'creator/creator.dart';

/// Covers event-related data and features.
export 'event/event.dart';

/// Manages series-related data and functionality.
export 'series/series.dart';

/// Handles data and features specific to stories.
export 'story/story.dart';
