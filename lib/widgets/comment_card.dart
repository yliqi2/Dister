import 'package:dister/controllers/comment_service/comment_service.dart';
import 'package:dister/generated/l10n.dart';
import 'package:dister/model/comment_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CommentCard extends StatelessWidget {
  final Comment comment;
  final CommentService commentService;
  final Function onDeleted;

  const CommentCard({
    super.key,
    required this.comment,
    required this.commentService,
    required this.onDeleted,
  });

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return S.current.justNow;
        }
        return '${difference.inMinutes}m';
      }
      return '${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d';
    } else {
      return DateFormat('dd/MM/yyyy').format(date);
    }
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final bool confirmDelete = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(S.of(context).deleteCommentConfirmation),
            content: Text(S.of(context).deleteCommentWarning),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(S.of(context).cancel),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(
                  S.of(context).delete,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            ],
          ),
        ) ??
        false;

    if (confirmDelete && context.mounted) {
      final success = await commentService.deleteComment(comment.id);
      if (success && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.of(context).commentDeleted)),
        );
        onDeleted();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final canDelete = commentService.canDeleteComment(comment);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: colorScheme.outline.withAlpha(26),
          width: 1,
        ),
      ),
      color: isDarkMode
          ? colorScheme.surfaceContainerHighest
          : colorScheme.surfaceContainer.withAlpha(179),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: comment.userPhoto != null &&
                                !comment.userPhoto!.startsWith('assets/')
                            ? NetworkImage(comment.userPhoto!)
                            : const AssetImage('assets/images/default.png')
                                as ImageProvider,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '@${comment.username ?? 'Unknown'}',
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                                Text(
                                  _formatDate(comment.createdAt),
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: colorScheme.onSurfaceVariant
                                        .withAlpha(179),
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              comment.text,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (canDelete)
                        Padding(
                          padding: const EdgeInsets.only(left: 4.0),
                          child: IconButton(
                            icon: Icon(
                              Icons.delete_outline_rounded,
                              color: colorScheme.error,
                              size: 20,
                            ),
                            onPressed: () => _confirmDelete(context),
                            visualDensity: VisualDensity.compact,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            tooltip: S.of(context).delete,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
