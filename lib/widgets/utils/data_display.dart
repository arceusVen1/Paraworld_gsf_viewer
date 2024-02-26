import 'package:flutter/material.dart';
import 'package:paraworld_gsf_viewer/classes/gsf_data.dart';
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
    this.relatedPart,
    this.onSelected,
  });

  final String label;
  final GsfData data;
  final bool bold;
  final GsfPart? relatedPart;
  final void Function(GsfPart?)? onSelected;

  @override
  Widget build(BuildContext context) {
    String title = '$label: ';
    if (relatedPart != null) {
      title += '${relatedPart!.name} ($data)';
    } else {
      title += data.toString();
    }
    String toolTip =
        "position: 0x${data.offsettedPos.toRadixString(16)}, length: ${data.length}";
    if (data.value is int) {
      toolTip = 'value: 0x${(data.value as int).toRadixString(16)}, $toolTip';
    }
    return Tooltip(
      message: toolTip,
      waitDuration: const Duration(milliseconds: 200),
      child: _SelectableTile(
        title: title,
        onSelected: () {
          if (onSelected != null) {
            onSelected!(relatedPart);
          }
        },
        bold: bold,
      ),
    );
  }
}

class _SelectableTile extends StatefulWidget {
  const _SelectableTile({
    required this.title,
    required this.onSelected,
    this.bold = false,
  });

  final String title;
  final bool bold;
  final void Function() onSelected;

  @override
  State<_SelectableTile> createState() => __SelectableTileState();
}

class __SelectableTileState extends State<_SelectableTile> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (event) {
        setState(() {
          _isHovering = true;
        });
      },
      onExit: (event) => setState(() {
        _isHovering = false;
      }),
      child: GestureDetector(
        onTap: widget.onSelected,
        child: Container(
          color: _isHovering ? Colors.grey.shade300 : null,
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          child: Label.regular(widget.title,
              fontWeight: widget.bold ? FontWeight.bold : null),
        ),
      ),
    );
  }
}

class PartSelector extends StatelessWidget {
  const PartSelector({
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
    return ListViewWrapper(
      rightPadding: 40,
      maxHeight: 300,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: parts.length,
        addAutomaticKeepAlives: false,
        cacheExtent: 50,
        itemBuilder: (context, index) {
          final part = parts[index];
          return ListTileWrapper(
              isSelected: part == value,
              label:
                  "$index. ${part.name} (0x${part.offset.toRadixString(16)})",
              onTap: () {
                onSelected(part);
              });
        },
      ),
    );
  }
}

class ListViewWrapper extends StatelessWidget {
  const ListViewWrapper({
    super.key,
    required this.child,
    required this.rightPadding,
    required this.maxHeight,
  });

  final Widget child;
  final double rightPadding;
  final double maxHeight;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 3.0, bottom: 3.0, right: rightPadding),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8.0),
        ),
        clipBehavior: Clip.hardEdge,
        constraints: BoxConstraints(maxHeight: maxHeight),
        // necessary to fix list view overflow https://github.com/flutter/flutter/issues/143269
        child: Material(
          type: MaterialType.transparency,
          child: child,
        ),
      ),
    );
  }
}

class ListTileWrapper extends StatelessWidget {
  const ListTileWrapper({
    super.key,
    required this.isSelected,
    required this.label,
    this.onTap,
  });

  final bool isSelected;
  final String label;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      visualDensity: const VisualDensity(
        horizontal: 0,
        vertical: VisualDensity.minimumDensity,
      ),
      contentPadding: const EdgeInsets.only(left: 5, right: 5),
      selected: isSelected,
      selectedTileColor: Colors.grey.shade400,
      title: Label.regular(label),
      onTap: onTap,
    );
  }
}
