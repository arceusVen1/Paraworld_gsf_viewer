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

class GsfDataTile extends StatefulWidget {
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
  State<GsfDataTile> createState() => _GsfDataTileState();
}

class _GsfDataTileState extends State<GsfDataTile> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    String label = '${widget.label}: ';
    if (widget.relatedPart != null) {
      label += '${widget.relatedPart!.name} (${widget.data})';
    } else {
      label += widget.data.toString();
    }
    String toolTip =
        "position: 0x${widget.data.offsettedPos.toRadixString(16)}, length: ${widget.data.length}";
    if (widget.data.value is int) {
      toolTip =
          'value: 0x${(widget.data.value as int).toRadixString(16)}, $toolTip';
    }
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
        onTap: () {
          if (widget.onSelected != null) {
            widget.onSelected!(widget.relatedPart);
          }
        },
        child: Container(
          color: _isHovering ? Colors.grey.shade300 : null,
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          child: Tooltip(
            message: toolTip,
            child: Label.regular(label,
                fontWeight: widget.bold ? FontWeight.bold : null),
          ),
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
          return ListTile(
            dense: true,
            visualDensity: const VisualDensity(
              horizontal: 0,
              vertical: VisualDensity.minimumDensity,
            ),
            contentPadding: const EdgeInsets.only(left: 5, right: 5),
            selected: part == value,
            selectedTileColor: Colors.grey.shade400,
            title: Label.regular(
                "$index. ${part.name} (0x${part.offset.toRadixString(16)})"),
            onTap: () {
              onSelected(part);
            },
          );
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
