import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class SectionWrapper extends StatelessWidget {
  const SectionWrapper({
    super.key,
    required this.label,
    required this.children,
  });

  final String label;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (children.isEmpty) {
      return const SizedBox.shrink();
    }
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Container(
            padding: const EdgeInsets.all(10.0),
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: theme.colorScheme.primary, width: 1),
              borderRadius: BorderRadius.circular(5),
              shape: BoxShape.rectangle,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...children,
              ],
            ),
          ),
        ),
        Positioned(
          left: 20,
          top: 0,
          child: Container(
            padding: const EdgeInsets.only(bottom: 1, left: 5, right: 5),
            color: theme.colorScheme.background,
            child: Label.small(
              label,
            ),
          ),
        ),
      ],
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
          border: Border.all(color: Theme.of(context).colorScheme.primary),
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
    final position = data.offsettedPos.toRadixString(16);
    final String? bytes = data.bytesData
        ?.map((element) => element.toRadixString(16).length > 1
            ? element.toRadixString(16)
            : '0${element.toRadixString(16)}')
        .join(' ');

    String toolTip = "position: 0x$position, length: ${data.length}";
    if (bytes != null) {
      toolTip += ', bytes: $bytes';
    }
    if (data.value is int) {
      toolTip = 'value: 0x${(data.value as int).toRadixString(16)}, $toolTip';
    } else {
      toolTip = 'value: ${data.value}, $toolTip';
    }
    return Tooltip(
      message: toolTip,
      waitDuration: const Duration(milliseconds: 200),
      child: _SelectableTile(
        title: title,
        position: position,
        bytes: bytes,
        value: data.value.toString(),
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
    required this.position,
    required this.value,
    this.bytes,
    this.bold = false,
  });

  final String title;
  final bool bold;
  final String position;
  final String? bytes;
  final String value;
  final void Function() onSelected;

  @override
  State<_SelectableTile> createState() => __SelectableTileState();
}

class __SelectableTileState extends State<_SelectableTile> {
  bool _isHovering = false;
  final ContextMenuController _contextMenuController = ContextMenuController();

  void _onCopy(BuildContext context, String value) {
    final messenger = ScaffoldMessenger.of(context);
    ContextMenuController.removeAny();
    Clipboard.setData(ClipboardData(text: value));
    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          "Copied to clipboard: $value",
        ),
      ),
    );
  }

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
        onTap: () {
          ContextMenuController.removeAny();
          widget.onSelected;
        },
        onSecondaryTapUp: (details) {
          _contextMenuController.show(
            context: context,
            contextMenuBuilder: (BuildContext context) {
              return AdaptiveTextSelectionToolbar.buttonItems(
                anchors: TextSelectionToolbarAnchors(
                  primaryAnchor: details.globalPosition,
                ),
                buttonItems: <ContextMenuButtonItem>[
                  ContextMenuButtonItem(
                    onPressed: () => _onCopy(context, widget.position),
                    label: 'Copy position',
                  ),
                  if (widget.bytes != null)
                    ContextMenuButtonItem(
                      onPressed: () => _onCopy(context, widget.bytes!),
                      label: 'Copy bytes',
                    ),
                  ContextMenuButtonItem(
                    onPressed: () => _onCopy(context, widget.value),
                    label: 'Copy value',
                  ),
                ],
              );
            },
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          decoration: BoxDecoration(
            border: Border.all(
                width: 1,
                color: _isHovering
                    ? Theme.of(context).colorScheme.primary
                    : Colors.black.withOpacity(0)),
            borderRadius: BorderRadius.circular(4.0),
          ),
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
                ContextMenuController.removeAny();
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
                ContextMenuController.removeAny();
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
          border: Border.all(color: Theme.of(context).colorScheme.primary),
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
      selectedTileColor: Theme.of(context).colorScheme.primaryContainer,
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
        const Divider(
          height: 1,
        ),
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
        const Divider(
          height: 1,
        ),
      ],
    );
  }
}
