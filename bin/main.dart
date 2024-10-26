// import 'package:dash_shield/src/features/print_removal/print_modification_service.dart';
//
// void main(List<String> args) async {
//   if (args.isEmpty || args.length > 1) {
//     print('Usage: dart run dash_shield:main <subcommand> <project_directory>');
//     print('Example:');
//     print(
//         '  flutter pub run dash_shield:main -remove /path/to/project   # To remove all print statements');
//     print(
//         '  flutter pub run dash_shield:main -replace /path/to/project  # To wrap print statements with kDebugMode');
//     return;
//   }
//   final subcommand = args[
//       0]; // First argument specifies the subcommand (e.g., -remove or -replace)
//
//   switch (subcommand) {
//     case '--remove':
//       print('Removing all print statements from the project...');
//       await PrintModificationService.removePrints();
//       break;
//
//     case '--replace':
//       print('Wrapping all print statements with kDebugMode...');
//       await PrintModificationService.wrapPrintsWithDebugModeChecker();
//       break;
//
//     default:
//       print('Unknown subcommand: $subcommand');
//       print('Available subcommands: -remove, -replace');
//   }
// }
/// TODO ###########
import 'package:dash_shield/src/features/print_removal/print_modification_service.dart';
import 'package:interact/interact.dart';

void main() async {
  showMainMenu();
}

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

Future<void> showPrintsMenu() async {
  final options = ['Remove All Prints', 'Wrap All Prints with kDebugMode'];
  final selectedAction = Select(
    prompt: 'Choose an action:',
    options: options,
  ).interact();

  if (selectedAction == 0) {
    final gift = Spinner(
      icon: '🏆',
      leftPrompt: (done) => '', // prompts are optional
      rightPrompt: (done) => done
          ? 'All prints have been removed for you.'
          : 'searching for prints in your project..',
    ).interact();

    await PrintModificationService.removePrints();
    await Future.delayed(const Duration(seconds: 3));
    gift.done();
  } else if (selectedAction == 1) {
    final gift = Spinner(
      icon: '🏆',
      leftPrompt: (done) => '', // prompts are optional
      rightPrompt: (done) => done
          ? 'All prints have been wrapped inside kDebugMode Checker.'
          : 'searching for prints in your project..',
    ).interact();

    await PrintModificationService.wrapPrintsWithDebugModeChecker();
    await Future.delayed(const Duration(seconds: 3));
    gift.done();
  }
}
