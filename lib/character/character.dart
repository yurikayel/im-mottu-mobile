/// This file consolidates exports related to the character feature of the application.
///
/// It includes model classes, view models, screens, and repository interfaces specific to
/// characters. This centralization helps to manage imports related to character functionality
/// more efficiently and ensures consistency across the codebase.
///
/// The following modules are included:
/// - **Models**: Define the structure and data of character entities.
/// - **ViewModels**: Manage the state and business logic associated with characters.
/// - **Screens**: Present character-related user interfaces.
/// - **Repositories**: Handle data access and interaction for character-related data.
library character;

/// Exports the character model which represents the data structure of a character entity.
export 'character_model.dart';

/// Exports the character view model that handles the business logic and state management
/// for character-related views.
export 'character_viewmodel.dart';

/// Exports the character list screen that displays a list of characters in a user interface.
export 'character_list_screen.dart';

/// Exports the character detail screen that shows detailed information about a specific character.
export 'character_detail_screen.dart';

/// Exports the character repository that provides methods to interact with the data source
/// for character-related data.
export 'character_repository.dart';

/// Exports the interface for the character repository, defining the contract for data
/// interactions related to characters.
export 'i_character_repository.dart';

/// Exports the interface for character remote data sources, defining methods for fetching
/// character data from remote services.
export 'i_character_remote.dart';
