import 'package:flutter/material.dart';

void main() {
  runApp(const SentoDaysApp());
}

class SentoDaysApp extends StatelessWidget {
  const SentoDaysApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SENTO days',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0B7285)),
      ),
      home: const LaunchPage(),
    );
  }
}

class LaunchPage extends StatelessWidget {
  const LaunchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const MainPage()));
            },
            child: const Text('入ろう！'),
          ),
        ),
      ),
    );
  }
}

class SentoInfo {
  const SentoInfo({required this.name, required this.specialPoint});

  final String name;
  final String specialPoint;
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final List<SentoInfo> _sentoList = <SentoInfo>[];

  Future<void> _openAddDialog() async {
    int step = 0;
    String name = '';
    String specialPoint = '';

    final SentoInfo? result = await showDialog<SentoInfo>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setDialogState) {
            final bool isNameStep = step == 0;
            return AlertDialog(
              title: const Text('あなたの大好きな銭湯を教えてください。'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(isNameStep ? '名前を教えてください。' : '特別な点を教えて下さい。'),
                  const SizedBox(height: 12),
                  TextField(
                    key: ValueKey<int>(step),
                    autofocus: true,
                    onChanged: (String value) {
                      if (isNameStep) {
                        name = value;
                        return;
                      }
                      specialPoint = value;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('キャンセル'),
                ),
                FilledButton(
                  onPressed: () {
                    if (isNameStep) {
                      if (name.trim().isEmpty) {
                        return;
                      }
                      setDialogState(() {
                        step = 1;
                      });
                      return;
                    }

                    if (specialPoint.trim().isEmpty) {
                      return;
                    }

                    Navigator.of(context).pop(
                      SentoInfo(
                        name: name.trim(),
                        specialPoint: specialPoint.trim(),
                      ),
                    );
                  },
                  child: Text(isNameStep ? '次' : '登録'),
                ),
              ],
            );
          },
        );
      },
    );

    if (result == null) {
      return;
    }

    setState(() {
      _sentoList.insert(0, result);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SENTO')),
      body:
          _sentoList.isEmpty
              ? const Center(child: Text('＋ 버튼으로 銭湯 정보를 추가해 주세요.'))
              : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: _sentoList.length,
                itemBuilder: (BuildContext context, int index) {
                  final SentoInfo sento = _sentoList[index];
                  return Card(
                    child: ListTile(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => SentoDetailPage(sento: sento),
                          ),
                        );
                      },
                      title: Text(sento.name),
                      subtitle: Text(sento.specialPoint),
                    ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class SentoDetailPage extends StatelessWidget {
  const SentoDetailPage({super.key, required this.sento});

  final SentoInfo sento;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('銭湯詳細')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              sento.name,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            Text(
              sento.specialPoint,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
