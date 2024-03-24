import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:paraworld_gsf_viewer/classes/gsf_data.dart';
import 'package:paraworld_gsf_viewer/widgets/utils/label.dart';

class DisplayWrapper extends StatelessWidget {
  const DisplayWrapper({
    super.key,
    required this.mainArea,
    required this.sideArea,
    required this.flexFactorSideArea,
  });

  final Widget mainArea;
  final List<Widget> sideArea;
  final int flexFactorSideArea;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          mainArea,
          Flexible(
            flex: flexFactorSideArea,
            child: Row(children: sideArea),
          ),
        ],
      ),
    );
  }
}

class Empty extends StatelessWidget {
  const Empty({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Label.large('Please select a .gsf file.'));
  }
}

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

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
      title += '${relatedPart!.label} (${data.value})';
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
          child: Label.regular(
            widget.title,
            isBold: widget.bold,
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
          return ListTileWrapper(
              isSelected: part == value,
              label:
                  "$index. ${part.label} (0x${part.offset.toRadixString(16)})",
              onTap: () {
                onSelected(part);
              });
        },
      ),
    );
  }
}

typedef DataToPartRelationFunction = GsfPart? Function(GsfData, int);

class DataSelector extends StatefulWidget {
  const DataSelector({
    super.key,
    required this.datas,
    this.relatedParts,
    this.onSelected,
    this.partFromDataFnct,
  });

  final List<GsfData> datas;
  final List<GsfPart>? relatedParts;
  final Function(GsfData, GsfPart?)? onSelected;
  final DataToPartRelationFunction? partFromDataFnct;

  @override
  State<DataSelector> createState() => _DataSelectorState();
}

class _DataSelectorState extends State<DataSelector> {
  GsfData? _selected;

  GsfPart? defaultDataToPartRelation(GsfData data, int index) {
    if (widget.relatedParts != null && (index < widget.relatedParts!.length)) {
      return widget.relatedParts![index];
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.datas.isEmpty) {
      return const SizedBox.shrink();
    }
    return ListViewWrapper(
      rightPadding: 10,
      maxHeight: 200,
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: widget.datas.length,
          addAutomaticKeepAlives: false,
          cacheExtent: 50,
          itemBuilder: (context, index) {
            final data = widget.datas[index];

            final relatedPart = widget.partFromDataFnct != null
                ? widget.partFromDataFnct!(data, index)
                : defaultDataToPartRelation(data, index);

            String label = "$index. ";

            if (relatedPart != null) {
              label += '${relatedPart.label} (${data.value})';
            } else {
              label += data.toString();
            }

            return ListTileWrapper(
              isSelected: data == _selected,
              label: label,
              onTap: () {
                setState(() {
                  _selected = data;
                });
                if (widget.onSelected != null) {
                  widget.onSelected!(data, relatedPart);
                }
              },
            );
          }),
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

class DropdownWrapper extends StatefulWidget {
  const DropdownWrapper({
    super.key,
    required this.label,
    required this.child,
  });

  final String label;
  final Widget child;

  @override
  State<DropdownWrapper> createState() => _DropdownWrapperState();
}

class _DropdownWrapperState extends State<DropdownWrapper> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: Row(
            children: [
              Expanded(
                  child: Label.medium(
                widget.label,
                isBold: true,
              )),
              Icon(_isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down),
            ],
          ),
        ),
        AnimatedSize(
          alignment: Alignment.topCenter,
          curve: Curves.easeInOut,
          duration: const Duration(milliseconds: 250),
          child: _isExpanded
              ? widget.child
              : const SizedBox(
                  width: double.infinity,
                ),
        ),
      ],
    );
  }
}
