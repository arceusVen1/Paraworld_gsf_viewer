import 'package:equatable/equatable.dart';
import 'package:paraworld_gsf_viewer/classes/vertex.dart';

class Triangle extends Equatable {
  const Triangle({
    required this.points,
  });

  final List<Vertex> points;

  drawTriangle() {
    
  }

  @override
  // TODO: implement props
  List<Object?> get props => points;
}
