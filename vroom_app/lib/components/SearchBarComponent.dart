import 'dart:async';
import 'package:flutter/material.dart';

class SearchBarComponent extends StatefulWidget {
  final Function(String) onSearch;

  const SearchBarComponent({Key? key, required this.onSearch})
      : super(key: key);

  @override
  _SearchBarComponentState createState() => _SearchBarComponentState();
}

class _SearchBarComponentState extends State<SearchBarComponent> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    // Kada se UI izgradi, postavi fokus
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // "Vroom" tekst kao logo
        const Padding(
          padding: EdgeInsets.only(right: 4.0),
          child: Text(
            "Vroom",
            style: TextStyle(
              fontSize: 20, // Lagano veći font za bolji izgled
              fontWeight: FontWeight.w700, // Polu-bold za isticanje
              color: Colors.blueGrey, // BlueGray boja
              fontFamily: 'Montserrat', // Stilizovan i moderan font
            ),
          ),
        ),
        // Search bar
        Expanded(
          child: AnimatedOpacity(
            opacity: 1.0, // Pretraga je uvek vidljiva dok je SearchBar aktivan
            duration: const Duration(milliseconds: 300), // Trajanje animacije
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0), // Pomeranje
              child: TextField(
                controller: _controller,
                focusNode: _focusNode, // Fokus je povezan sa TextField
                onChanged: (value) {
                  if (_debounce?.isActive ?? false) _debounce?.cancel();
                  _debounce = Timer(const Duration(milliseconds: 500), () {
                    widget.onSearch(value);
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Pretraži automobile',
                  labelStyle: const TextStyle(
                      fontSize: 16), // Povećanje veličine labela
                  prefixIcon: const Icon(
                    Icons.search,
                    // Plava ikona za pretragu
                    size: 20, // Manja ikona za pretragu
                  ),
                  suffixIcon: _controller.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(
                            Icons.clear_sharp,
                            // Plava ikona za brisanje
                            size: 20, // Manja ikona za brisanje
                          ),
                          onPressed: () {
                            _controller.clear();
                            widget.onSearch(''); // Čisti pretragu
                          },
                        )
                      : null,
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 12.0), // Manji razmak
                  border: const OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.blue), // Plava boja za border
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    _focusNode.dispose();
    super.dispose();
  }
}
