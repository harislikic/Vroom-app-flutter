import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vroom_app/components/shared/CloseModalButton.dart';
import 'package:vroom_app/components/shared/ToastUtils.dart';

class ReservationModal extends StatefulWidget {
  final DateTime selectedDay;
  final void Function(DateTime reservationDateTime) onConfirm;

  const ReservationModal({
    Key? key,
    required this.selectedDay,
    required this.onConfirm,
  }) : super(key: key);

  @override
  _ReservationModalState createState() => _ReservationModalState();
}

class _ReservationModalState extends State<ReservationModal> {
  TimeOfDay? _selectedTime;

  void _selectTime(BuildContext context) async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  void _confirmReservation() {
    if (_selectedTime == null) {
      ToastUtils.showErrorToast(message: 'Morate odabrati vrijeme.');
      return;
    }

    final reservationDateTime = DateTime(
      widget.selectedDay.year,
      widget.selectedDay.month,
      widget.selectedDay.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );

    widget.onConfirm(reservationDateTime);
    Navigator.pop(context); // Zatvara modal
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment:
                CrossAxisAlignment.start, // Poravnanje prema vrhu
            children: [
              const SizedBox(), // Ostavlja prostor sa leve strane
              Column(
                crossAxisAlignment: CrossAxisAlignment.end, // Tekst ispod X-a
                children: [
                  CloseModalButton(
                    onPressed: () =>
                        Navigator.of(context).pop(), // Zatvaranje modala
                  ),
                  const SizedBox(height: 8), // Razmak između ikone i teksta
                  Text(
                    'Odaberite vrijeme za datum: ${DateFormat('yyyy-MM-dd').format(widget.selectedDay)}',
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () => _selectTime(context),
            icon: const Icon(Icons.access_time),
            label: Text(
              _selectedTime == null
                  ? 'Odaberite vrijeme'
                  : 'Odabrano: ${_selectedTime!.format(context)}',
            ),
            style: OutlinedButton.styleFrom(
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
              side: const BorderSide(color: Colors.blueGrey),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _confirmReservation,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              backgroundColor: Colors.white, // Pozadina dugmeta
              foregroundColor: Colors.blueAccent, // Boja teksta i ikona
              side:
                  const BorderSide(color: Colors.blueGrey, width: 2), // Border
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12), // Zaobljeni uglovi
              ),
              elevation: 2, // Efekat senke
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, color: Colors.blueAccent),
                SizedBox(width: 8), // Razmak između ikone i teksta
                Text(
                  'Potvrdi',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 46),
        ],
      ),
    );
  }
}
