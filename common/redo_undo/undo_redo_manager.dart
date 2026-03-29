import 'package:fluent_ui/fluent_ui.dart';

class GlobalUndoRedoManager extends ChangeNotifier {
  final int maxStates;
  final List<ActionState> undoStack = [];
  final List<ActionState> redoStack = [];
  bool get canUndo => undoStack.isNotEmpty;
  bool get canRedo => redoStack.isNotEmpty;

  GlobalUndoRedoManager({this.maxStates = 120});

  void addAction(ActionState action) {
    undoStack.add(action);
    redoStack.clear();

    // Enforce capacity
    if (undoStack.length > maxStates) {
      undoStack.removeAt(0);
    }

    //debugPrint("call add action: ${undoStack.length}");
    notifyListeners();
  }

  void undo() {
    //debugPrint("call undo manager");
    if (undoStack.isNotEmpty) {
      final lastAction = undoStack.removeLast();
      redoStack.add(lastAction);

      lastAction.restore(lastAction.state);
      //debugPrint("undo done. stack=${undoStack.length}, redo=${redoStack.length}");

      notifyListeners();
    }
  }

  void redo() {
    //debugPrint("call redo manager");
    if (redoStack.isNotEmpty) {
      final nextAction = redoStack.removeLast();
      undoStack.add(nextAction);

      nextAction.restore(nextAction.state);
      //debugPrint("redo done. stack=${undoStack.length}, redo=${redoStack.length}");

      notifyListeners();
    }
  }

  void clearHistory() {
    undoStack.clear();
    redoStack.clear();
    debugPrint("undo/redo history cleared");
    notifyListeners();
  }
}

class ActionState {
  final String type;
  final dynamic state;
  final Function(dynamic) restore;

  ActionState({required this.type, required this.state, required this.restore});
}
