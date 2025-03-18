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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: _controller,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          hintText: "Search",
          prefixIcon: const Icon(Icons.search),
          suffixIcon: IconButton(
            onPressed: () {
              _controller.clear();
              widget.onChanged(null);
            },
            icon: const Icon(Icons.clear),
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
