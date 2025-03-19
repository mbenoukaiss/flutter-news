import "package:flutter/material.dart";

class SearchInput extends StatefulWidget {
  final ValueChanged<String?> onChanged;

  const SearchInput({super.key, required this.onChanged});

  @override
  State<SearchInput> createState() => _SearchInputState();
}

class _SearchInputState extends State<SearchInput> {
  final TextEditingController _controller = TextEditingController();

  bool hasText = false;

  void _onChanged(String? value) {
    final bool hasText = value?.isNotEmpty ?? false;

    setState(() {
      this.hasText = hasText;
    });

    widget.onChanged(hasText ? value : null);
  }

  @override
  Widget build(BuildContext context) {
    Widget? eraseButton;
    if (hasText) {
      eraseButton = IconButton(
        onPressed: () {
          _controller.clear();
          _onChanged(null);
        },
        icon: const Icon(Icons.clear),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: _controller,
        onChanged: _onChanged,
        decoration: InputDecoration(
          hintText: "Search",
          prefixIcon: const Icon(Icons.search),
          suffixIcon: eraseButton,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
