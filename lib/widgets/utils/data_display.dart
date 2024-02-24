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

  Future<void> _showSelector(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Label.regular(
            value != null
                ? "selected: ${value!.name} (0x${value!.offset.toRadixString(16)})"
                : label,
            fontWeight: FontWeight.bold,
          ),
          children: [
            ...parts.map((part) => ListTile(
                  selected: part == value,
                  selectedTileColor: Colors.grey.shade400,
                  title: Label.regular(
                      "${part.name} (offset 0x${part.offset.toRadixString(16)})"),
                  onTap: () {
                    onSelected(part);
                    Navigator.pop(context);
                  },
                ))
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Button.secondary(
        onPressed: () => _showSelector(context),
        child: Label.small(value != null
            ? "${value!.name} (0x${value!.offset.toRadixString(16)})"
            : label),
      ),
    );
  }
}
