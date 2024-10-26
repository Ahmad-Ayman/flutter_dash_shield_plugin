import 'package:dash_shield/src/features/print_removal/print_modification_service.dart';
import 'package:interact/interact.dart';

/// The main entry point for the Dash Shield console application.
///
/// This script provides a console interface for managing `print` statements
/// within a Flutter project. Currently, it allows users to either remove
/// all `print` statements or wrap them with `kDebugMode` to ensure they
/// only run in debug mode. More options will be added in future updates.
void main() async {
  showMainMenu();
}

/// Displays the main menu for Dash Shield console options.
///
/// This function presents a prompt with options related to `print` management
/// in the project. Future updates will add more options to the menu.
Future<void> showMainMenu() async {
  final options = ['Prints Removal & Replace'];
  final selectedOption = Select(
    prompt: 'What do you want to do? (a lot of addons will be added soon)',
    options: options,
  ).interact();

  if (selectedOption == 0) {
    await showPrintsMenu();
  }
}

/// Displays the `print` management submenu with available actions.
///
/// This function allows the user to choose between removing all `print`
/// statements or wrapping them with `kDebugMode`. Each action is accompanied
/// by a progress indicator to inform the user of task completion.
Future<void> showPrintsMenu() async {
  final options = ['Remove All Prints', 'Wrap All Prints with kDebugMode'];
  final selectedAction = Select(
    prompt: 'Choose an action:',
    options: options,
  ).interact();

  if (selectedAction == 0) {
    // Show a spinner while removing all `print` statements
    final gift = Spinner(
      icon: '🏆',
      leftPrompt: (done) => '', // optional left prompt
      rightPrompt: (done) => done
          ? 'All prints have been removed for you.'
          : 'searching for prints in your project..',
    ).interact();

    await PrintModificationService.removePrints();
    await Future.delayed(const Duration(seconds: 3));
    gift.done();
  } else if (selectedAction == 1) {
    // Show a spinner while wrapping `print` statements with `kDebugMode`
    final gift = Spinner(
      icon: '🏆',
      leftPrompt: (done) => '', // optional left prompt
      rightPrompt: (done) => done
          ? 'All prints have been wrapped inside kDebugMode Checker.'
          : 'searching for prints in your project..',
    ).interact();

    await PrintModificationService.wrapPrintsWithDebugModeChecker();
    await Future.delayed(const Duration(seconds: 3));
    gift.done();
  }
}
