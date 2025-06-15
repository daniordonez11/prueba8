import 'dart:async';
import 'package:flutter/material.dart';
import 'package:prueba8/service/service.dart';

class StreamListPage extends StatefulWidget {
  const StreamListPage({super.key});

  @override
  _StreamListPageState createState() => _StreamListPageState();
}

class _StreamListPageState extends State<StreamListPage> {
  final StreamController<List<String>> _streamController = StreamController<List<String>>();
  final List<String> _items = [];
  final Service _service = Service();
  Timer? _timer;

  int _currentId = 1;
  final int _maxId = 30;

  int _teamCount = 0; 

  @override
  void initState() {
    super.initState();
    _loadNextTeam();
    _timer = Timer.periodic(Duration(seconds: 20), (_) => _loadNextTeam());
  }

  Future<void> _loadNextTeam() async {
    if (_currentId > _maxId) {
      _timer?.cancel();
      return;
    }

    try {
      final teamName = await _service.getTeamById(_currentId);
      _items.add(teamName);
      _streamController.sink.add(List.from(_items));

      setState(() {
        _teamCount = _items.length;
      });

      _currentId++;
    } catch (e) {
      print('Error cargando equipo ID $_currentId: $e');
      _currentId++;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Prueba Semana 8, Equipos de Basket: ($_teamCount equipos)'),
      ),
      body: StreamBuilder<List<String>>(
        stream: _streamController.stream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          if (snapshot.connectionState == ConnectionState.waiting && _items.isEmpty) {
            return Center(child: CircularProgressIndicator());
          }

          final teams = snapshot.data ?? _items;

          return ListView.builder(
            itemCount: teams.length,
            itemBuilder: (context, index) => ListTile(
              leading: Icon(Icons.sports_basketball),
              title: Text(teams[index]),
            ),
          );
        },
      ),
    );
  }
}
