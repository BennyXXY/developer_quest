import 'package:dev_rpg/src/shared_state/game/bug.dart';
import 'package:dev_rpg/src/shared_state/game/task.dart';
import 'package:dev_rpg/src/shared_state/game/task_pool.dart';
import 'package:dev_rpg/src/shared_state/game/work_item.dart';
import 'package:dev_rpg/src/widgets/work_items/bug_list_item.dart';
import 'package:dev_rpg/src/widgets/work_items/task_list_item.dart';
import 'package:dev_rpg/src/widgets/work_items/tasks_button_header.dart';
import 'package:dev_rpg/src/widgets/work_items/tasks_section_header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Displays a list of the [Task]s the player has interacted with.
/// These are [Task]s that have been added into the game, are being
/// actively worked on, or have been completed and/or archived.
class TaskPoolPage extends StatelessWidget {
  /// Builds a section of the task list with [title] and a list of [workItems].
  /// This returns slivers to be used in a [SliverList].
  void _buildSection(
      List<Widget> children, String title, List<WorkItem> workItems) {
    if (workItems.isNotEmpty) {
      children.add(TasksSectionHeader(title));
      children.addAll(
        workItems.map(
          (WorkItem item) => ChangeNotifierProvider<WorkItem>.value(
                notifier: item,
                key: ValueKey(item),
                child: item is Bug ? BugListItem() : TaskListItem(),
              ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromRGBO(241, 241, 241, 1.0),
      child: Consumer<TaskPool>(
        builder: (context, taskPool) {
          List<Widget> children = <Widget>[
            TasksButtonHeader(taskPool: taskPool),
            const SizedBox(height: 12.0),
          ];
          _buildSection(
            children,
            "IN PROGRESS",
            taskPool.workItems,
          );
          _buildSection(
            children,
            "COMPLETED",
            taskPool.completedTasks
                .followedBy(taskPool.archivedTasks)
                .toList(growable: false),
          );

          return ListView(children: children);
        },
      ),
    );
  }
}
