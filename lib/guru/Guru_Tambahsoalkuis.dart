import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: QuizCreator(),
    debugShowCheckedModeBanner: false,
  ));
}

class QuizCreator extends StatefulWidget {
  @override
  _QuizCreatorState createState() => _QuizCreatorState();
}

class _QuizCreatorState extends State<QuizCreator> {
  List<Question> questions = [Question()];
  String quizTitle = '';
  String quizDescription = '';

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  List<TextEditingController> questionControllers = [];

  bool isTitleEmpty = false;
  bool isDescriptionEmpty = false;
  List<bool> areQuestionsEmpty = [];

  @override
  void initState() {
    super.initState();
    questionControllers = List.generate(questions.length, (_) => TextEditingController());
    areQuestionsEmpty = List.generate(questions.length, (_) => false);
  }

  Future<bool> _onWillPop() async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Peringatan'),
        content: Text('Kuis tidak akan tersimpan jika Anda keluar. Apakah Anda yakin ingin keluar?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Keluar'),
          ),
        ],
      ),
    ) ?? false;
  }

  bool _isQuizValid() {
    setState(() {
      isTitleEmpty = titleController.text.isEmpty;
      isDescriptionEmpty = descriptionController.text.isEmpty;
      areQuestionsEmpty = List.generate(questions.length, (index) => questionControllers[index].text.isEmpty);
    });

    return !(isTitleEmpty || isDescriptionEmpty || areQuestionsEmpty.contains(true));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF51CC0F),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () async {
              if (await _onWillPop()) {
                Navigator.pop(context);
              }
            },
          ),
          title: Text('Kembali'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Judul Kuis',
                  errorText: isTitleEmpty ? 'Judul Kuis harus diisi' : null,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: isTitleEmpty ? Colors.red : Colors.green, width: 2.0),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    isTitleEmpty = value.isEmpty;
                  });
                },
              ),
              SizedBox(height: 8),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: 'Deskripsi Kuis (optional)',
                  errorText: isDescriptionEmpty ? 'Deskripsi Kuis harus diisi' : null,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: isDescriptionEmpty ? Colors.red : Colors.green, width: 2.0),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    isDescriptionEmpty = value.isEmpty;
                  });
                },
              ),
              SizedBox(height: 16),
              ...questions.asMap().entries.map((entry) {
                int index = entry.key;
                Question question = entry.value;

                return QuestionWidget(
                  question: question,
                  controller: questionControllers[index],
                  isEmpty: areQuestionsEmpty[index],
                  onRemove: () async {
                    bool? confirmDelete = await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Hapus Pertanyaan'),
                        content: Text('Apakah Anda yakin ingin menghapus pertanyaan ini?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: Text('Batal'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: Text('Hapus'),
                          ),
                        ],
                      ),
                    );
                    if (confirmDelete == true) {
                      setState(() {
                        questions.removeAt(index);
                        questionControllers.removeAt(index);
                        areQuestionsEmpty.removeAt(index);
                      });
                    }
                  },
                );
              }),
              SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    questions.add(Question());
                    questionControllers.add(TextEditingController());
                    areQuestionsEmpty.add(false);
                  });
                },
                icon: Icon(Icons.add),
                label: Text("Tambah Pertanyaan"),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_isQuizValid()) {
                    _finishQuiz();
                  } else {
                    // Just update the state to show errors without a dialog
                    setState(() {});
                  }
                },
                child: Text('Selesai'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _finishQuiz() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Kuis Selesai'),
          content: Text('Kuis Anda telah selesai dibuat!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

class Question {
  String text = '';
  List<String> options = [''];
  int? answerKey;
}

// ignore: must_be_immutable
class QuestionWidget extends StatefulWidget {
  final Question question;
  final TextEditingController controller;
  bool isEmpty;
  final VoidCallback onRemove;

  QuestionWidget({
    super.key,
    required this.question,
    required this.controller,
    required this.isEmpty,
    required this.onRemove,
  });

  @override
  _QuestionWidgetState createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: widget.controller,
                    decoration: InputDecoration(
                      labelText: 'Pertanyaan',
                      errorText: widget.isEmpty ? 'Pertanyaan harus diisi' : null,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: widget.isEmpty ? Colors.red : Colors.green, width: 2.0),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        widget.question.text = value;
                        widget.isEmpty = value.isEmpty; // Update empty state
                      });
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: widget.onRemove,
                ),
              ],
            ),
            Column(
              children: [
                ...widget.question.options.asMap().entries.map((entry) {
                  int index = entry.key;
                  return Row(
                    children: [
                      Radio(
                        value: index,
                        groupValue: widget.question.answerKey,
                        onChanged: (int? value) {
                          setState(() {
                            widget.question.answerKey = value;
                          });
                        },
                      ),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Opsi ${index + 1}',
                          ),
                          onChanged: (value) {
                            setState(() {
                              widget.question.options[index] = value;
                            });
                          },
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          setState(() {
                            widget.question.options.removeAt(index);
                          });
                        },
                      ),
                    ],
                  );
                }).toList(),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          widget.question.options.add('');
                        });
                      },
                    ),
                    Text('Tambahkan opsi'),
                  ],
                ),
              ],
            ),
            SizedBox(height: 8),
            TextButton.icon(
              onPressed: () {},
              icon: Icon(Icons.check_circle_outline),
              label: Text('Kunci Jawaban'),
            ),
          ],
        ),
      ),
    );
  }
}
