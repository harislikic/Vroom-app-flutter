import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vroom_app/components/ConfirmationDialog.dart';
import 'package:vroom_app/services/CommentService.dart';
import 'package:vroom_app/models/comment.dart';
import 'package:vroom_app/services/AuthService.dart';

class CommentsSection extends StatelessWidget {
  final int automobileAdId;

  const CommentsSection(this.automobileAdId, {Key? key}) : super(key: key);

  Future<List<Comment>> _fetchComments() async {
    final CommentService commentService = CommentService();
    return await commentService.fetchCommentsByAutomobileId(automobileAdId);
  }

  void _showEditDialog(
      BuildContext context, Comment comment, Function onUpdate) {
    final TextEditingController _controller =
        TextEditingController(text: comment.content);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Uredi komentar'),
          content: TextField(
            controller: _controller,
            decoration: const InputDecoration(hintText: 'Uredite komentar'),
            maxLines: 1,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (_controller.text.isNotEmpty) {
                  final CommentService commentService = CommentService();
                  try {
                    await commentService.editComment(
                      commentId: comment.commentId,
                      userId: comment.user.id,
                      content: _controller.text,
                    );
                    Fluttertoast.showToast(
                      msg: "Komentar editovan",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                    );
                    onUpdate();
                  } catch (e) {
                    Fluttertoast.showToast(
                      msg: "Greška prilikom editovanja",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                    );
                  } finally {
                    Navigator.pop(context);
                  }
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteDialog(
      BuildContext context, Comment comment, Function onUpdate) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmationDialog(
          title: "Potvrda brisanja",
          content: "Da li ste sigurni da želite obrisati komentar?",
          successMessage: "Komentar je uspešno obrisan.",
          onConfirm: () async {
            final CommentService commentService = CommentService();
            try {
              await commentService.deleteComment(commentId: comment.commentId);
              onUpdate();
            } catch (e) {
              Fluttertoast.showToast(
                msg: "Greška prilikom brisanja",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.red,
                textColor: Colors.white,
              );
              throw e; // Ponovno bacanje greške kako bi `ConfirmationDialog` mogao da je obradi.
            }
          },
          onCancel: () {
            // Ovde možete dodati dodatne akcije ako je potrebno pri otkazivanju
          },
        );
      },
    );
  }

  void _showCommentsModal(BuildContext context, List<Comment> comments) async {
    final loggedInUserId = await AuthService.getUserId();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 50,
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              final TextEditingController _commentController =
                  TextEditingController();

              Future<void> _refreshComments() async {
                final CommentService commentService = CommentService();
                final updatedComments = await commentService
                    .fetchCommentsByAutomobileId(automobileAdId);
                setState(() {
                  comments.clear();
                  comments.addAll(updatedComments);
                });
              }

              Future<void> _addComment() async {
                if (_commentController.text.isEmpty) {
                  Fluttertoast.showToast(
                    msg: "Unesite komentar prije slanja.",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                  );
                  return;
                }

                try {
                  final userId = await AuthService.getUserId();
                  if (userId == null) {
                    Fluttertoast.showToast(
                      msg: "Morate biti prijavljeni da biste dodali komentar.",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                    );
                    return;
                  }

                  final CommentService commentService = CommentService();
                  await commentService.addComment(
                    content: _commentController.text,
                    userId: userId,
                    automobileAdId: automobileAdId,
                  );

                  _commentController.clear();
                  Fluttertoast.showToast(
                    msg: "Komentar uspješno dodan.",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                  );

                  // Refresh comments
                  await _refreshComments();
                } catch (e) {
                  Fluttertoast.showToast(
                    msg: "Greška pri dodavanju komentara.",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                  );
                }
              }

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Komentari',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.black),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: comments.isEmpty
                        ? const Text('Nema dostupnih komentara.')
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: comments.length,
                            itemBuilder: (context, index) {
                              final comment = comments[index];
                              final isOwner = comment.user.id == loggedInUserId;
                              return Container(
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: isOwner
                                      ? Colors.blue.shade50
                                      : Colors.white,
                                  border: Border.all(
                                    color: isOwner
                                        ? Colors.blue
                                        : Colors.grey.shade300,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      radius: 20,
                                      backgroundImage: comment
                                                  .user.profilePicture !=
                                              null
                                          ? NetworkImage(
                                              'http://localhost:5194${comment.user.profilePicture}')
                                          : const AssetImage(
                                                  'assets/default_profile.png')
                                              as ImageProvider,
                                      backgroundColor: Colors.grey.shade200,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                comment.user.userName ??
                                                    "Unknown",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: isOwner
                                                      ? Colors.blue
                                                      : Colors.black,
                                                ),
                                              ),
                                              if (isOwner)
                                                Row(
                                                  children: [
                                                    IconButton(
                                                      icon: const Icon(
                                                        Icons.edit,
                                                        color: Colors.grey,
                                                        size: 16,
                                                      ),
                                                      onPressed: () {
                                                        _showEditDialog(
                                                          context,
                                                          comment,
                                                          _refreshComments,
                                                        );
                                                      },
                                                    ),
                                                    IconButton(
                                                      icon: const Icon(
                                                        Icons.delete,
                                                        color: Colors.red,
                                                        size: 16,
                                                      ),
                                                      onPressed: () {
                                                        _showDeleteDialog(
                                                          context,
                                                          comment,
                                                          _refreshComments,
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Text(comment.content),
                                          const SizedBox(height: 4),
                                          Text(
                                            "${comment.createdAt.toLocal()}"
                                                .split(' ')[0],
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
                  const Divider(height: 1, color: Colors.grey),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 50.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _commentController,
                            decoration: const InputDecoration(
                              hintText: "Dodajte komentar...",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: _addComment,
                          child: const Text("Pošalji"),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Comment>>(
      future: _fetchComments(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          final comments = snapshot.data!;
          return GestureDetector(
            onTap: () {
              _showCommentsModal(context, comments);
            },
            child: Padding(
              padding: const EdgeInsets.all(0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade900),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.question_answer_outlined,
                      color: Colors.grey,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'PITANJA I ODGOVORI (${comments.length})',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.all(0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade900),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.question_answer_outlined,
                    color: Colors.grey,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'PITANJA I ODGOVORI (0)',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
