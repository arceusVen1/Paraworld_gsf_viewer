import 'package:flutter/material.dart';
import 'package:paraworld_gsf_viewer/classes/gsf_data.dart';
import 'package:paraworld_gsf_viewer/widgets/utils/buttons.dart';
import 'package:paraworld_gsf_viewer/widgets/utils/label.dart';

class DataDecorator extends StatelessWidget {
  const DataDecorator({
    super.key,
    required this.children,
  });

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: ListView(
          children: children,
        ),
      ),
    );
  }
}

class GsfDataTile extends StatelessWidget {
  const GsfDataTile({
    super.key,
    required this.label,
    required this.data,
    this.bold = false,
  });

  final String label;
  final GsfData data;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Tooltip(
        message:
            "position ${data.offsettedPos} (0x${data.offsettedPos.toRadixString(16)}), length: ${data.length}",
        child: Label.regular('$label:  $data',
            fontWeight: bold ? FontWeight.bold : null),
      ),
    );
  }
}

class ValueSelector extends StatelessWidget {
  const ValueSelector({
    super.key,
    required this.label,
    required this.parts,
    required this.onSelected,
    this.value,
  });

  final String label;
  final List<GsfPart> parts;
  final void Function(GsfPart?) onSelected;
  final GsfPart? value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 3.0, bottom: 3.0, right: 40.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8.0),
        ),
        clipBehavior: Clip.hardEdge,
        constraints: const BoxConstraints(maxHeight: 300),
        // necessary to fix list view overflow https://github.com/flutter/flutter/issues/143269
        child: Material(
          type: MaterialType.transparency,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: parts.length,
            addAutomaticKeepAlives: false,
            cacheExtent: 50,
            itemBuilder: (context, index) {
              final part = parts[index];
              return ListTile(
                contentPadding: const EdgeInsets.only(left: 5, right: 5),
                selected: part == value,
                selectedTileColor: Colors.grey.shade400,
                title: Label.regular(
                    "${part.name} (0x${part.offset.toRadixString(16)})"),
                onTap: () {
                  onSelected(part);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
